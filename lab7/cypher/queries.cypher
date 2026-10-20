// ------------------------------------------------------------
// Запрос 1. Простое MATCH — все студенты
// ------------------------------------------------------------
MATCH (s:Student)
RETURN s.studentId AS id, s.name AS name
ORDER BY s.studentId;


// ------------------------------------------------------------
// Запрос 2. Фильтрация — студенты курса NOSQL301
// ------------------------------------------------------------
MATCH (s:Student)-[:ENROLLED_IN]->(c:Course {code: 'NOSQL301'})
RETURN s.studentId AS id, s.name AS name
ORDER BY s.name;


// ------------------------------------------------------------
// Запрос 3. Сортировка и ограничение — топ-3 курса по кредитам
// ------------------------------------------------------------
MATCH (c:Course)
RETURN c.code AS code, c.title AS title, c.credits AS credits
ORDER BY c.credits DESC
LIMIT 3;


// ------------------------------------------------------------
// Запрос 4. Запрос по отношению — кто преподаёт NOSQL301
// ------------------------------------------------------------
MATCH (t:Teacher)-[:TEACHES]->(c:Course {code: 'NOSQL301'})
RETURN t.teacherId AS id, t.name AS teacher, c.title AS course;


// ------------------------------------------------------------
// Запрос 5. Двухшаговый обход —
// студенты курсов, которые ведёт преподаватель 501
// ------------------------------------------------------------
MATCH (t:Teacher {teacherId: 501})-[:TEACHES]->(c:Course)<-[:ENROLLED_IN]-(s:Student)
RETURN DISTINCT s.studentId AS id, s.name AS student, c.code AS course
ORDER BY s.name;


// ------------------------------------------------------------
// Запрос 6. Variable-length path (повышенное задание)
// Цепочка пререквизитов ADV401 до 3 уровней
// ------------------------------------------------------------
MATCH (c:Course {code: 'ADV401'})-[:REQUIRES*1..3]->(p:Course)
RETURN DISTINCT p.code AS code, p.title AS title
ORDER BY p.code;


// ------------------------------------------------------------
// Запрос 7. Агрегирование count() —
// количество студентов на каждом курсе
// ------------------------------------------------------------
MATCH (c:Course)<-[:ENROLLED_IN]-(s:Student)
RETURN c.code AS code, c.title AS title, count(s) AS students_count
ORDER BY students_count DESC;
