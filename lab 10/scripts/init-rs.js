// Инициализация Replica Set из трех узлов
rs.initiate({
  _id: "rsLab10",
  members: [
    { _id: 0, host: "127.0.0.1:27101" },
    { _id: 1, host: "127.0.0.1:27102" },
    { _id: 2, host: "127.0.0.1:27103" }
  ]
});

// Запуск в терминале после старта узлов: mongosh --port 27101 scripts/init-rs.js
