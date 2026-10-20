// Шаг 1. Сначала ПОКАЗЫВАЕМ выбранную связь
MATCH (s:Student {studentId: 1005})-[r:ENROLLED_IN]->(c:Course {code: 'PROG102'})
RETURN s.name AS student, type(r) AS relation, c.code AS course, r.semester AS semester;

// Шаг 2. Удаляем ТОЛЬКО эту связь
MATCH (s:Student {studentId: 1005})-[r:ENROLLED_IN]->(c:Course {code: 'PROG102'})
DELETE r;

// Шаг 3. Проверяем, что связь исчезла (должен быть пустой результат)
MATCH (s:Student {studentId: 1005})-[r:ENROLLED_IN]->(c:Course {code: 'PROG102'})
RETURN r;
