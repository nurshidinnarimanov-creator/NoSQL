// Количество узлов по меткам
MATCH (n)
RETURN labels(n) AS labels, count(*) AS qty
ORDER BY labels;

// Количество отношений по типам
MATCH ()-[r]->()
RETURN type(r) AS relation, count(*) AS qty
ORDER BY relation;

// Пример пути (для визуализации в Browser)
MATCH path = (s:Student)-[:ENROLLED_IN]->(c:Course)<-[:TEACHES]-(t:Teacher)
RETURN path
LIMIT 10;
