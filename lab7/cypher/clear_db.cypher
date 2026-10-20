MATCH (n)
DETACH DELETE n;

// Проверка
MATCH (n)
RETURN count(n) AS remaining_nodes;
