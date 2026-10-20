// --- ENROLLED_IN (8) ---
MATCH (s:Student {studentId: 1001}), (c:Course {code: 'NOSQL301'})
MERGE (s)-[:ENROLLED_IN {semester: '2026-Fall'}]->(c);

MATCH (s:Student {studentId: 1001}), (c:Course {code: 'DB201'})
MERGE (s)-[:ENROLLED_IN {semester: '2026-Spring'}]->(c);

MATCH (s:Student {studentId: 1002}), (c:Course {code: 'NOSQL301'})
MERGE (s)-[:ENROLLED_IN {semester: '2026-Fall'}]->(c);

MATCH (s:Student {studentId: 1002}), (c:Course {code: 'ALG101'})
MERGE (s)-[:ENROLLED_IN {semester: '2026-Fall'}]->(c);

MATCH (s:Student {studentId: 1003}), (c:Course {code: 'ADV401'})
MERGE (s)-[:ENROLLED_IN {semester: '2026-Fall'}]->(c);

MATCH (s:Student {studentId: 1003}), (c:Course {code: 'NOSQL301'})
MERGE (s)-[:ENROLLED_IN {semester: '2026-Spring'}]->(c);

MATCH (s:Student {studentId: 1004}), (c:Course {code: 'ML301'})
MERGE (s)-[:ENROLLED_IN {semester: '2026-Fall'}]->(c);

MATCH (s:Student {studentId: 1005}), (c:Course {code: 'PROG102'})
MERGE (s)-[:ENROLLED_IN {semester: '2026-Fall'}]->(c);

// --- TEACHES (6) ---
MATCH (t:Teacher {teacherId: 501}), (c:Course {code: 'NOSQL301'})
MERGE (t)-[:TEACHES]->(c);

MATCH (t:Teacher {teacherId: 501}), (c:Course {code: 'ADV401'})
MERGE (t)-[:TEACHES]->(c);

MATCH (t:Teacher {teacherId: 502}), (c:Course {code: 'DB201'})
MERGE (t)-[:TEACHES]->(c);

MATCH (t:Teacher {teacherId: 502}), (c:Course {code: 'ALG101'})
MERGE (t)-[:TEACHES]->(c);

MATCH (t:Teacher {teacherId: 503}), (c:Course {code: 'PROG102'})
MERGE (t)-[:TEACHES]->(c);

MATCH (t:Teacher {teacherId: 504}), (c:Course {code: 'ML301'})
MERGE (t)-[:TEACHES]->(c);

// --- REQUIRES (8) ---
MATCH (c:Course {code: 'NOSQL301'}), (p:Course {code: 'DB201'})
MERGE (c)-[:REQUIRES]->(p);

MATCH (c:Course {code: 'ADV401'}), (p:Course {code: 'NOSQL301'})
MERGE (c)-[:REQUIRES]->(p);

MATCH (c:Course {code: 'ADV401'}), (p:Course {code: 'DB201'})
MERGE (c)-[:REQUIRES]->(p);

MATCH (c:Course {code: 'ML301'}), (p:Course {code: 'ALG101'})
MERGE (c)-[:REQUIRES]->(p);

MATCH (c:Course {code: 'ML301'}), (p:Course {code: 'PROG102'})
MERGE (c)-[:REQUIRES]->(p);

MATCH (c:Course {code: 'DB201'}), (p:Course {code: 'PROG102'})
MERGE (c)-[:REQUIRES]->(p);

MATCH (c:Course {code: 'ALG101'}), (p:Course {code: 'PROG102'})
MERGE (c)-[:REQUIRES]->(p);

MATCH (c:Course {code: 'NOSQL301'}), (p:Course {code: 'ALG101'})
MERGE (c)-[:REQUIRES]->(p);

// Проверка
MATCH ()-[r]->()
RETURN type(r) AS relation, count(*) AS qty
ORDER BY relation;
