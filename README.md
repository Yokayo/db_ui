# DB UI
Программа для работы с данными из БД.

## Сборка
В корневой папке проекта выполнить команду:

mvn clean compile assembly:single

После этого в папке target появится jar со скомпилированной программой.

## Использование
Сервис запускается из командной строки и принимает три аргумента: тип операции, имя входного файла и имя выходного файла.

Примечание: имена файлов указываются относительно папки с самой программой.

Доступны два типа операций: search (поиск) и stat (статистика).

## Примеры
*java -jar test-1.0-SNAPSHOT-jar-with-dependencies.jar search input.json search_output.json*

Поиск по критериям из файла input.json с занесением результата в файл search_output.json.

*java -jar test-1.0-SNAPSHOT-jar-with-dependencies.jar stat input.json stats_output.json*

Вывод статистики за период, обозначенный в файле input.json.
