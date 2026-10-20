// --- Студенты (5) ---
MERGE (s1:Student {studentId: 1001})
SET s1.name = 'Аружан Серикова';

MERGE (s2:Student {studentId: 1002})
SET s2.name = 'Диас Нурланов';

MERGE (s3:Student {studentId: 1003})
SET s3.name = 'Айгерим Касымова';

MERGE (s4:Student {studentId: 1004})
SET s4.name = 'Ерлан Бекмурзаев';

MERGE (s5:Student {studentId: 1005})
SET s5.name = 'Сабина Токтарова';

// --- Курсы (6) ---
MERGE (c1:Course {code: 'DB201'})
SET c1.title = 'Database Systems', c1.credits = 3;

MERGE (c2:Course {code: 'NOSQL301'})
SET c2.title = 'NoSQL Technologies', c2.credits = 4;

MERGE (c3:Course {code: 'ALG101'})
SET c3.title = 'Algorithms', c3.credits = 3;

MERGE (c4:Course {code: 'PROG102'})
SET c4.title = 'Programming Fundamentals', c4.credits = 4;

MERGE (c5:Course {code: 'ADV401'})
SET c5.title = 'Advanced Databases', c5.credits = 5;

MERGE (c6:Course {code: 'ML301'})
SET c6.title = 'Machine Learning', c6.credits = 4;

// --- Преподаватели (4) ---
MERGE (t1:Teacher {teacherId: 501})
SET t1.name = 'А. Смагулов';

MERGE (t2:Teacher {teacherId: 502})
SET t2.name = 'Б. Искакова';

MERGE (t3:Teacher {teacherId: 503})
SET t3.name = 'В. Ким';

MERGE (t4:Teacher {teacherId: 504})
SET t4.name = 'Г. Омарова';

// Проверка
MATCH (n)
RETURN labels(n) AS labels, count(*) AS qty
ORDER BY labels;
