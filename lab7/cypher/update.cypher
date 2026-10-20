// Изменяем имя студента 1001
MATCH (s:Student {studentId: 1001})
SET s.name = 'Аружан Серикова (обновлено)'
RETURN s.studentId AS id, s.name AS name;

// Контрольный запрос — убеждаемся, что изменение применилось
MATCH (s:Student {studentId: 1001})
RETURN s.studentId, s.name;
