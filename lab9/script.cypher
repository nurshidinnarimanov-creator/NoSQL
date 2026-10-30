// 1. Создание ограничений уникальности
CREATE CONSTRAINT student_id_unique IF NOT EXISTS FOR (s:Student) REQUIRE s.id IS UNIQUE;
CREATE CONSTRAINT course_id_unique IF NOT EXISTS FOR (c:Course) REQUIRE c.id IS UNIQUE;
CREATE CONSTRAINT teacher_id_unique IF NOT EXISTS FOR (t:Teacher) REQUIRE t.id IS UNIQUE;

// 2. Создание узлов (12+ узлов)
MERGE (s1:Student {id: 1}) SET s1.name = "Aibek", s1.group = "IS-24-1", s1.year = 3;
MERGE (s2:Student {id: 2}) SET s2.name = "Aliya", s2.group = "IS-24-1", s2.year = 3;
MERGE (s3:Student {id: 3}) SET s3.name = "Damir", s3.group = "IS-24-2", s3.year = 2;
MERGE (s4:Student {id: 4}) SET s4.name = "Zhansaya", s4.group = "IS-24-2", s4.year = 2;

MERGE (c1:Course {id: 101}) SET c1.title = "NoSQL", c1.credits = 5;
MERGE (c2:Course {id: 102}) SET c2.title = "Algorithms", c2.credits = 4;
MERGE (c3:Course {id: 103}) SET c3.title = "Web Development", c3.credits = 5;
MERGE (c4:Course {id: 104}) SET c4.title = "Database Systems", c4.credits = 6;

MERGE (t1:Teacher {id: 201}) SET t1.name = "Dr. Smith", t1.department = "Computer Science";
MERGе (t2:Teacher {id: 202}) SET t2.name = "Prof. Johnson", t2.department = "Software Engineering";
MERGE (t3:Teacher {id: 203}) SET t3.name = "Dr. Davis", t3.department = "Information Systems";
MERGE (t4:Teacher {id: 204}) SET t4.name = "Prof. Wilson", t4.department = "Data Science";

// 3. Создание отношений (16 связей)
MATCH (s:Student {id: 1}), (c:Course {id: 101}) MERGE (s)-[:STUDIES]->(c);
MATCH (s:Student {id: 1}), (c:Course {id: 102}) MERGE (s)-[:STUDIES]->(c);
MATCH (s:Student {id: 2}), (c:Course {id: 101}) MERGE (s)-[:STUDIES]->(c);
MATCH (s:Student {id: 2}), (c:Course {id: 103}) MERGE (s)-[:STUDIES]->(c);
MATCH (s:Student {id: 3}), (c:Course {id: 102}) MERGE (s)-[:STUDIES]->(c);
MATCH (s:Student {id: 3}), (c:Course {id: 104}) MERGE (s)-[:STUDIES]->(c);
MATCH (s:Student {id: 4}), (c:Course {id: 103}) MERGE (s)-[:STUDIES]->(c);
MATCH (s:Student {id: 4}), (c:Course {id: 104}) MERGE (s)-[:STUDIES]->(c);

MATCH (t:Teacher {id: 201}), (c:Course {id: 101}) MERGE (t)-[:TEACHES]->(c);
MATCH (t:Teacher {id: 202}), (c:Course {id: 101}) MERGE (t)-[:TEACHES]->(c);
MATCH (t:Teacher {id: 202}), (c:Course {id: 102}) MERGE (t)-[:TEACHES]->(c);
MATCH (t:Teacher {id: 203}), (c:Course {id: 102}) MERGE (t)-[:TEACHES]->(c);
MATCH (t:Teacher {id: 203}), (c:Course {id: 103}) MERGE (t)-[:TEACHES]->(c);
MATCH (t:Teacher {id: 204}), (c:Course {id: 103}) MERGE (t)-[:TEACHES]->(c);
MATCH (t:Teacher {id: 201}), (c:Course {id: 104}) MERGE (t)-CI TEACHES->(c); // (или просто TEACHES)
MATCH (t:Teacher {id: 204}), (c:Course {id: 104}) MERGE (t)-[:TEACHES]->(c);

// 4. Задания 3-4: Выборки и связи
MATCH (s:Student) RETURN s;
MATCH (s:Student) RETURN s.name AS student, s.group AS groupName ORDER BY student LIMIT 10;
MATCH (s:Student)-[:STUDIES]->(c:Course) RETURN s.name AS student, c.title AS course;
MATCH (t:Teacher)-[:TEACHES]->(c:Course)<-[:STUDIES]-(s:Student) RETURN t.name AS teacher, c.title AS course, s.name AS student;

// 5. Задание 5: Фильтрация WHERE
MATCH (s:Student) WHERE s.group = "IS-24-1" RETURN s.name, s.group;
MATCH (c:Course) WHERE c.credits >= 5 RETURN c.title, c.credits;

// 6. Задание 6: Модификация SET
MATCH (s:Student {id: 1}) SET s.year = 4 RETURN s;
MATCH (s:Student {id: 1})-[r:STUDIES]->(c:Course {id: 101}) SET r.semester = 5 RETURN s.name, r.semester, c.title;

// 7. Задание 7: Удаление DETACH DELETE
CREATE (:Temp {id: 999, note: "delete-me"});
MATCH (n:Temp {id: 999}) DETACH DELETE n;
MATCH (n:Temp {id: 999}) RETURN count(n) AS remaining;

// 8. Задание 8: Проверка MERGE
MERGE (s1:Student {id: 1}) SET s1.name = "Aibek", s1.group = "IS-24-1", s1.year = 4;
MATCH (s:Student) RETURN count(s) AS totalStudents;

// 9. Дополнительное задание: Общие соседи
MATCH (a:Student)-[:STUDIES]->(c:Course)<-[:STUDIES]-(b:Student)
WHERE a.id < b.id
RETURN a.name AS firstStudent, b.name AS secondStudent, collect(DISTINCT c.title) AS sharedCourses;
