import java.util.*;
import java.io.*;
import javax.json.*;
import java.sql.*;

public class Service{

    static String path, output_path;

    public static void main(String[] args){
        path = System.getProperty("user.dir");
        output_path = args[2];
        //---------------------------------------------------
        if(args.length < 3){
            generateError("Недостаточно аргументов");
            return;
        }
        //------------------------------------------
        File input = new File(path + "/" + args[1]);
        if(!input.exists()){
            generateError("Входной файл не найден");
            return;
        }
        //---------------------------------------------
        switch(args[0]){
            case "search":
                JsonArray criterias_raw;
                JsonReader reader;
                //-------------
                try{
                    reader = Json.createReader(new BufferedReader(new InputStreamReader(new FileInputStream(input), "UTF-8")));
                }catch(Exception e){
                    generateError("Невозможно открыть файл");
                    return;
                }
                //------------
                try{
                    criterias_raw = reader.readObject().getJsonArray("criterias");
                    reader.close();
                }catch(Exception e){
                    generateError("Входные данные не отформатированы");
                    return;
                }
                //------------
                if(criterias_raw == null){
                    generateError("Входные данные не отформатированы");
                    return;
                }
                //------------
                ArrayList<JsonObject> criterias = new ArrayList<>(criterias_raw.getValuesAs(JsonObject.class));
                if(criterias.size() == 0){
                    generateError("Не указаны критерии поиска");
                    return;
                }
                //------------
                int[] criteria_types_provided = new int[criterias.size()]; // массив, хранит тип каждого критерия
                Arrays.fill(criteria_types_provided, -1);
                for(int a = 0; a < criterias.size(); a++){ // валидация критериев перед началом обработки
                    JsonObject criteria = criterias.get(a);
                    String[] criteria_types = new String[4];
                    criteria_types[0] = criteria.getString("lastName", null);
                    criteria_types[1] = criteria.getString("productName", null);
                    criteria_types[2] = criteria.getString("minExpenses", null);
                    criteria_types[3] = criteria.getString("badCustomers", null);
                    for(int b = 0; b < criteria_types.length; b++){ // выясняем тип критерия (либо его отсутствие)
                        if(criteria_types[b] != null){
                            criteria_types_provided[a] = b;
                            break;
                        }
                    }
                    if(criteria_types_provided[a] == -1){
                        generateError("Неизвестный критерий #" + (a+1) + ", resolve time");
                        return;
                    }
                    switch(criteria_types_provided[a]){ // валидация для каждого критерия в отдельности
                        case 1:
                            String minTimes;
                            try{
                                minTimes = criteria.getString("minTimes");
                            }catch(NullPointerException e){
                                generateError("Критерий #" + (a+1) + ": не указано число раз (minTimes)");
                                return;
                            }
                            long times;
                            try{
                                times = Long.parseLong(minTimes);
                            }catch(NumberFormatException e){
                                generateError("Критерий #" + (a+1) + ": неправильное значение minTimes");
                                return;
                            }
                            break;
                        case 2:
                            try{
                                long minExp = Long.parseLong(criteria_types[2]);
                            }catch(NumberFormatException e){
                                generateError("Критерий #" + (a+1) + ": неправильное значение minExpenses");
                                return;
                            }
                            String maxExpenses;
                            try{
                                maxExpenses = criteria.getString("maxExpenses");
                            }catch(NullPointerException e){
                                generateError("Критерий #" + (a+1) + ": не указаны максимальные расходы (maxExpenses)");
                                return;
                            }
                            long maxExp;
                            try{
                                maxExp = Long.parseLong(maxExpenses);
                            }catch(NumberFormatException e){
                                generateError("Критерий #" + (a+1) + ": неправильное значение maxExpenses");
                                return;
                            }
                            break;
                        case 3:
                            try{
                                long badCustomers = Long.parseLong(criteria_types[3]);
                            }catch(NumberFormatException e){
                                generateError("Критерий #" + (a+1) + ": неправильное значение badCustomers");
                                return;
                            }
                            break;
                    }
                }
                //------------------
                Properties connection_props = new Properties();
                connection_props.put("user", "postgres");
                connection_props.put("password", "your_password_here");
                Connection con;
                try{
                    con = DriverManager.getConnection("jdbc:postgresql://localhost:5432/postgres", connection_props);
                }catch(Exception e){
                    generateError("Не удалось подключиться к БД");
                    return;
                }
                JsonObjectBuilder result_builder = Json.createObjectBuilder();
                result_builder.add("type", "search");
                JsonArrayBuilder result_set_builder = Json.createArrayBuilder(); // нужно добавить к итоговому JSON ("results")
                for(int a = 0; a < criterias.size(); a++){
                    try{
                        JsonObjectBuilder current_result_builder = Json.createObjectBuilder();
                        current_result_builder.add("criteria", criterias.get(a));
                        JsonArrayBuilder fetched_results_list = Json.createArrayBuilder();
                        Statement st = con.createStatement();
                        ResultSet rs = null;
                        JsonObject current_criteria;
                        switch(criteria_types_provided[a]){
                            case 0:
                                rs = st.executeQuery("SELECT * FROM Customers WHERE lastName='" + criterias.get(a).getString("lastName") + "'");
                                break;
                            //--------
                            case 1:
                                current_criteria = criterias.get(a);
                                rs = st.executeQuery("SELECT DISTINCT firstName, lastName FROM Customers WHERE ("
                                    + "SELECT COUNT(*) FROM Purchases WHERE Purchases.CustomerID=Customers.CustomerID AND thingType='" + current_criteria.getString("productName") + "'"
                                + ") >= " + current_criteria.getString("minTimes"));
                                break;
                            //--------
                            case 2:
                                current_criteria = criterias.get(a);
                                rs = st.executeQuery("SELECT DISTINCT firstName, lastName FROM Customers WHERE ("
                                    + "SELECT SUM(price) FROM Purchases INNER JOIN Goods ON Purchases.thingType=Goods.thingType WHERE Purchases.CustomerID=Customers.CustomerID"
                                + ") BETWEEN " + current_criteria.getString("minExpenses") + " AND " + current_criteria.getString("maxExpenses"));

                                break;
                            //--------
                            case 3:
                                current_criteria = criterias.get(a);
                                rs = st.executeQuery("SELECT firstName, lastName FROM ("
                                    + "SELECT firstName, lastName, ("
                                    + "SELECT SUM(price) FROM Purchases INNER JOIN Goods ON Goods.thingType=Purchases.thingType WHERE Purchases.CustomerID=Customers.CustomerID"
                                    + ") AS spent FROM Customers ORDER BY spent"
                                    + ") AS Subquery FETCH FIRST " + current_criteria.getString("badCustomers") + " ROWS ONLY");
                                break;
                            //--------
                            default:
                                generateError("Неизвестный критерий #" + (a+1));
                                return;
                        }
                        while(rs.next()){
                            fetched_results_list.add(Json.createObjectBuilder()
                                .add("firstName", rs.getString("firstName"))
                                .add("lastName", rs.getString("lastName"))
                                .build());
                        }
                        current_result_builder.add("results", fetched_results_list.build());
                        result_set_builder.add(current_result_builder.build());
                    }catch(Exception e){
                        generateError("Ошибка во время транзакции");
                        try{
                            con.close();
                        }catch(Exception ee){
                            ee.printStackTrace();
                            return;
                        }
                        return;
                    }
                }
                //--------------------------------
                result_builder.add("results", result_set_builder.build());
                try{
                    con.close();
                }catch(Exception e){
                    generateError("Не удалось закрыть соединение с БД");
                    return;
                }
                File output = new File(path + "/" + output_path);
                JsonWriter writer;
                try{
                    output.createNewFile();
                    writer = Json.createWriter(new BufferedWriter(new OutputStreamWriter(new FileOutputStream(output), "UTF-8")));
                }catch(IOException e){
                    generateError("Не удалось создать выходной файл с готовыми данными");
                    return;
                }
                writer.write(result_builder.build());
                writer.close();
                break;
            case "stat":

        }
    }

    private static void writeOutputJSON(JsonObject object){
        File output = new File(path + "/" + output_path);
    }

    private static void generateError(String error){
        File output = new File(path + "/" + output_path);
        JsonObjectBuilder builder = Json.createObjectBuilder();
        builder.add("type", "error")
        .add("message", error);
        JsonWriter writer;
        try{
            output.createNewFile();
            writer = Json.createWriter(new BufferedWriter(new OutputStreamWriter(new FileOutputStream(output), "UTF-8")));
        }catch(IOException e){
            System.err.println(error + ". Не удалось создать выходной файл.");
            e.printStackTrace();
            return;
        }
        writer.write(builder.build());
        writer.close();
        return;
    }

} 