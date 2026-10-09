# Лабораторная работа № 6: Моделирование таблиц Cassandra от запросов (реализация в MongoDB)

**Дисциплина:** Проектирование и применение NoSQL-технологий  
**Предметная область:** Информационные системы / Базы данных  
**Вариант:** № 1 — Университет  

---

## 📌 Цель работы
Сформировать практические навыки query-driven проектирования NoSQL-модели: от анализа пользовательских запросов и нагрузки к выбору аналогов partition key и clustering columns (составных индексов), созданию коллекций и проверке того, что ключевые запросы выполняются без полного сканирования коллекции (Full Collection Scan).

---

## 🛠️ Ход выполнения работы

### Этап 1. Подготовка базы данных и коллекций

В СУБД MongoDB создана база данных `lab6_university` и две денормализованные коллекции под разные паттерны доступа:
* `schedule_by_group` — хранение и выборка расписания академических групп.
* `schedule_by_teacher` — хранение и выборка занятий преподавателей.

<img width="1919" height="1079" alt="image" src="https://github.com/user-attachments/assets/a27c0b91-18a1-421c-887b-47f138c76119" />
<img width="1919" height="1079" alt="image" src="https://github.com/user-attachments/assets/afeb42c0-4635-4793-b411-761c27168450" />
<img width="1919" height="1079" alt="image" src="https://github.com/user-attachments/assets/cc49d245-a3b6-45ac-9293-06553f84127e" />

---
<img width="1421" height="889" alt="image" src="https://github.com/user-attachments/assets/4e08c2c5-74b3-4502-b7f0-e741c4ae6c3b" />
<img width="845" height="898" alt="image" src="https://github.com/user-attachments/assets/58aeb026-73fb-49ff-a0b7-ba0ea9e30d8b" />
<img width="967" height="886" alt="image" src="https://github.com/user-attachments/assets/00d98c7c-32b7-4de1-9eed-bf723a9c37a2" />
<img width="794" height="892" alt="image" src="https://github.com/user-attachments/assets/fcb4c15d-726a-4716-a4b6-68ba9c6a7c5f" />
<img width="504" height="384" alt="image" src="https://github.com/user-attachments/assets/6b4aa38a-c20c-4f1b-bc25-c81cfea1869e" />
<img width="340" height="232" alt="image" src="https://github.com/user-attachments/assets/7719d5f0-581c-4093-9619-a38682fa76fa" />

### Этап 2. Проектирование от запросов (Query-Driven Design)

Для обеспечения высокой производительности чтения модель спроектирована под каждый из 5 обязательных паттернов доступа:

| № | Запрос (Access Pattern) | Известно на входе | Analog Partition Key | Analog Clustering Columns | Коллекция MongoDB |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **Q1** | Расписание группы по датам | `group_id` | `group_id` | `lesson_date`, `lesson_time` | `schedule_by_group` |
| **Q2** | Занятия группы за период | `group_id`, период | `group_id` | `lesson_date`, `lesson_time` | `schedule_by_group` |
| **Q3** | Занятия преподавателя | `teacher_id` | `teacher_id` | `lesson_date`, `lesson_time` | `schedule_by_teacher` |
| **Q4** | Занятия преподавателя за период | `teacher_id`, период | `teacher_id` | `lesson_date`, `lesson_time` | `schedule_by_teacher` |
| **Q5** | Конкретное занятие по дате/времени | `group_id`, дата, время | `group_id` | `lesson_date`, `lesson_time` | `schedule_by_group` |

---

### Этап 3. Настройка составных индексов

Для имитации эффективной адресации Wide-column модели созданы составные индексы (Compound Indexes):
```javascript

// Индекс для быстрых выборок и сортировки по группе
db.schedule_by_group.createIndex({ group_id: 1, lesson_date: 1, lesson_time: 1 });

// Индекс для быстрых выборок и сортировки по преподавателю
db.schedule_by_teacher.createIndex({ teacher_id: 1, lesson_date: 1, lesson_time: 1 });

---

Этап 4. Наполнение тестовыми данными
Выполнена запись 20+ документов с распределением по разным группам и преподавателям для проверки изоляции партиций.
// Вставка в коллекцию schedule_by_group
db.schedule_by_group.insertMany([
  { group_id: "IS-24-1", lesson_date: ISODate("2026-10-12"), lesson_time: "09:00", course_id: "CS-101", course_name: "NoSQL Databases", teacher_id: "T-10", teacher_name: "A. Petrov", room: "301" },
  { group_id: "IS-24-1", lesson_date: ISODate("2026-10-12"), lesson_time: "10:45", course_id: "CS-102", course_name: "Web Programming", teacher_id: "T-11", teacher_name: "B. Ivanov", room: "405" },
  { group_id: "IS-24-1", lesson_date: ISODate("2026-10-13"), lesson_time: "09:00", course_id: "CS-103", course_name: "Software Architecture", teacher_id: "T-10", teacher_name: "A. Petrov", room: "301" },
  { group_id: "IS-24-1", lesson_date: ISODate("2026-10-13"), lesson_time: "12:30", course_id: "CS-104", course_name: "Algorithms", teacher_id: "T-12", teacher_name: "C. Sidorov", room: "210" },
  { group_id: "IS-24-1", lesson_date: ISODate("2026-10-14"), lesson_time: "09:00", course_id: "CS-101", course_name: "NoSQL Databases", teacher_id: "T-10", teacher_name: "A. Petrov", room: "301" },
  { group_id: "CS-24-2", lesson_date: ISODate("2026-10-12"), lesson_time: "09:00", course_id: "CS-104", course_name: "Algorithms", teacher_id: "T-12", teacher_name: "C. Sidorov", room: "210" },
  { group_id: "CS-24-2", lesson_date: ISODate("2026-10-12"), lesson_time: "10:45", course_id: "CS-101", course_name: "NoSQL Databases", teacher_id: "T-10", teacher_name: "A. Petrov", room: "302" },
  { group_id: "CS-24-2", lesson_date: ISODate("2026-10-13"), lesson_time: "09:00", course_id: "CS-102", course_name: "Web Programming", teacher_id: "T-11", teacher_name: "B. Ivanov", room: "405" },
  { group_id: "CS-24-2", lesson_date: ISODate("2026-10-14"), lesson_time: "14:00", course_id: "CS-105", course_name: "Machine Learning", teacher_id: "T-13", teacher_name: "D. Kasenov", room: "101" },
  { group_id: "CS-24-2", lesson_date: ISODate("2026-10-15"), lesson_time: "09:00", course_id: "CS-105", course_name: "Machine Learning", teacher_id: "T-13", teacher_name: "D. Kasenov", room: "101" }
]);

// Денормализованная вставка в коллекцию schedule_by_teacher
db.schedule_by_teacher.insertMany([
  { teacher_id: "T-10", lesson_date: ISODate("2026-10-12"), lesson_time: "09:00", group_id: "IS-24-1", course_id: "CS-101", course_name: "NoSQL Databases", room: "301" },
  { teacher_id: "T-11", lesson_date: ISODate("2026-10-12"), lesson_time: "10:45", group_id: "IS-24-1", course_id: "CS-102", course_name: "Web Programming", room: "405" },
  { teacher_id: "T-10", lesson_date: ISODate("2026-10-13"), lesson_time: "09:00", group_id: "IS-24-1", course_id: "CS-103", course_name: "Software Architecture", room: "301" },
  { teacher_id: "T-12", lesson_date: ISODate("2026-10-13"), lesson_time: "12:30", group_id: "IS-24-1", course_id: "CS-104", course_name: "Algorithms", room: "210" },
  { teacher_id: "T-10", lesson_date: ISODate("2026-10-14"), lesson_time: "09:00", group_id: "IS-24-1", course_id: "CS-101", course_name: "NoSQL Databases", room: "301" },
  { teacher_id: "T-12", lesson_date: ISODate("2026-10-12"), lesson_time: "09:00", group_id: "CS-24-2", course_id: "CS-104", course_name: "Algorithms", room: "210" },
  { teacher_id: "T-10", lesson_date: ISODate("2026-10-12"), lesson_time: "10:45", group_id: "CS-24-2", course_id: "CS-101", course_name: "NoSQL Databases", room: "302" },
  { teacher_id: "T-11", lesson_date: ISODate("2026-10-13"), lesson_time: "09:00", group_id: "CS-24-2", course_id: "CS-102", course_name: "Web Programming", room: "405" },
  { teacher_id: "T-13", lesson_date: ISODate("2026-10-14"), lesson_time: "14:00", group_id: "CS-24-2", course_id: "CS-105", course_name: "Machine Learning", room: "101" },
  { teacher_id: "T-13", lesson_date: ISODate("2026-10-15"), lesson_time: "09:00", group_id: "CS-24-2", course_id: "CS-105", course_name: "Machine Learning", room: "101" }
]);

Этап 5. Выполнение 5 обязательных запросов
Запрос Q1: Все расписание группы IS-24-1
db.schedule_by_group.find({ group_id: "IS-24-1" }).sort({ lesson_date: 1, lesson_time: 1 });

Запрос Q2: Занятия группы IS-24-1 за период с 12 по 13 октября
db.schedule_by_group.find({
  group_id: "IS-24-1",
  lesson_date: { $gte: ISODate("2026-10-12"), $lte: ISODate("2026-10-13") }
}).sort({ lesson_date: 1, lesson_time: 1 });

Запрос Q3: Все занятия преподавателя A. Petrov (T-10)
db.schedule_by_teacher.find({ teacher_id: "T-10" }).sort({ lesson_date: 1, lesson_time: 1 });

Запрос Q4: Занятия преподавателя T-10 за период (12–13 октября)
db.schedule_by_teacher.find({
  teacher_id: "T-10",
  lesson_date: { $gte: ISODate("2026-10-12"), $lte: ISODate("2026-10-13") }
}).sort({ lesson_date: 1, lesson_time: 1 });

Запрос Q5: Выборка конкретного занятия группы IS-24-1 по дате и времени
db.schedule_by_group.find({
  group_id: "IS-24-1",
  lesson_date: ISODate("2026-10-12"),
  lesson_time: "09:00"
});

Этап 6. Обновление (UPDATE) и Удаление (DELETE)
При денормализованной модели изменения вносятся во все связанные коллекции.

Изменение аудитории (UPDATE)
db.schedule_by_group.updateOne(
  { group_id: "IS-24-1", lesson_date: ISODate("2026-10-12"), lesson_time: "09:00", course_id: "CS-101" },
  { $set: { room: "505" } }
);

db.schedule_by_teacher.updateOne(
  { teacher_id: "T-10", lesson_date: ISODate("2026-10-12"), lesson_time: "09:00", group_id: "IS-24-1" },
  { $set: { room: "505" } }
);


📊 Этап 7. Анализ нагрузки и размер партицийРасчет для группы: За 1 семестр (15 недель) группа проводит $4 \text{ пары/день} \times 6 \text{ дней} \times 15 \text{ недель} = 360 \text{ записей}$. За 4 года обучения собирается ~2880 документов. Это оптимальный размер для единого ключа group_id.Риск Large Partition / Hot Partition: Для преподавателей с длительным стажем размер коллекции или индексной выборки может превысить миллион записей.Решение (Time Bucketing): Добавление учебного года в ключ (academic_year: 2026) позволяет логически разбивать крупные коллекции на годовые блоки.

📝 Вывод
В ходе лабораторной работы освоены принципы Query-Driven Design. Продемонстрировано, что для достижения высокой скорости чтения в NoSQL-системах применяется осознанная денормализация данных с созданием отдельных коллекций/таблиц под каждый паттерн доступа.
