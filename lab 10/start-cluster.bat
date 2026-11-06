@echo off
echo Запуск узлов MongoDB Replica Set (rsLab10)...

REM Создаем папки для данных
if not exist C:\mongo-lab10\rs1 mkdir C:\mongo-lab10\rs1
if not exist C:\mongo-lab10\rs2 mkdir C:\mongo-lab10\rs2
if not exist C:\mongo-lab10\rs3 mkdir C:\mongo-lab10\rs3

REM Запускаем три узла в отдельных окнах
start "MongoDB Node 1 (27101)" "C:\Program Files\MongoDB\Server\8.2\bin\mongod.exe" --replSet rsLab10 --port 27101 --dbpath C:\mongo-lab10\rs1 --bind_ip 127.0.0.1
start "MongoDB Node 2 (27102)" "C:\Program Files\MongoDB\Server\8.2\bin\mongod.exe" --replSet rsLab10 --port 27102 --dbpath C:\mongo-lab10\rs2 --bind_ip 127.0.0.1
start "MongoDB Node 3 (27103)" "C:\Program Files\MongoDB\Server\8.2\bin\mongod.exe" --replSet rsLab10 --port 27103 --dbpath C:\mongo-lab10\rs3 --bind_ip 127.0.0.1

echo Все три узла запущенны!
pause
