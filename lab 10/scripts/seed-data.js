// Переключаемся на базу данных лабораторной работы
use university_lab10;

db.orders.insertMany([
  { item: "cardboard", qty: 25, status: "A" },
  { item: "paper", qty: 100, status: "B" },
  { item: "planner", qty: 75, status: "A" },
  { item: "notebook", qty: 50, status: "A" },
  { item: "pen", qty: 200, status: "C" },
  { item: "pencil", qty: 150, status: "B" },
  { item: "folder", qty: 30, status: "A" },
  { item: "marker", qty: 80, status: "C" },
  { item: "eraser", qty: 120, status: "B" },
  { item: "glue", qty: 45, status: "A" },
  { item: "scissors", qty: 60, status: "B" },
  { item: "stapler", qty: 15, status: "C" },
  { item: "tape", qty: 90, status: "A" },
  { item: "notepad", qty: 110, status: "B" },
  { item: "envelope", qty: 300, status: "A" },
  { item: "calculator", qty: 10, status: "C" },
  { item: "desk pad", qty: 25, status: "B" },
  { item: "highlighter", qty: 85, status: "A" },
  { item: "paperclip", qty: 500, status: "C" },
  { item: "binder", qty: 40, status: "B" },
  { item: "ruler", qty: 70, status: "A" },
  { item: "correction tape", qty: 65, status: "C" },
  { item: "sticky notes", qty: 130, status: "B" },
  { item: "index cards", qty: 95, status: "A" },
  { item: "stamp", qty: 20, status: "C" }
], { 
  writeConcern: { w: "majority", wtimeout: 5000 } 
});
