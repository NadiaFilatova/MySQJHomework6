DROP
DATABASE IF EXISTS MyJoinsDB;
CREATE
DATABASE IF NOT EXISTS MyJoinsDB;
USE
MyJoinsDB;
-- У всіх створених таблицях використовуються кластеризовані індекси -
-- Додавання індексів дозволяє прискорити процес вибірки, проте варто створювати індекси на тих стовпцях таблиці, які використовуються найчастіше. -
-- Як приклад для таблиці person був створений індекс name, що значно прискорило вибірку значень.
CREATE TABLE IF NOT EXISTS staff
(
    id
    INT
    AUTO_INCREMENT
    PRIMARY
    KEY,
    name_staff
    VARCHAR(20) NOT NULL,
    phone VARCHAR(15) NOT NULL
    );
CREATE INDEX name_staff ON staff (name_staff);

INSERT INTO staff
(name_staff, phone)
VALUES ('Андрiй', '+380974222231'),
       ('Коля', '+380974222272'),
       ('Саша', '+380964552241'),
       ('Маша', '+380673992261'),
       ('Оля', '+380973361221');

CREATE TABLE IF NOT EXISTS serviceInfo
(
    id
    INT
    PRIMARY
    KEY,
    position_staff
    VARCHAR(20) NOT NULL,
    salary   INT         NOT NULL,
    staff_id INT         NOT NULL,
    FOREIGN KEY
(
    staff_id
) REFERENCES staff
(
    id
)
    );
CREATE INDEX position_staff ON serviceInfo (position_staff);

INSERT INTO serviceInfo (id, position_staff, salary, staff_id)
VALUES (1, 'Главный директор', 2000, 1),
       (2, 'Менеджер', 1000, 2),
       (3, 'Менеджер', 25000, 3),
       (4, 'Рабочий', 15000, 4),
       (5, 'Менеджер', 40000, 5);

CREATE TABLE IF NOT EXISTS personalInfo
(
    id
    INT
    PRIMARY
    KEY,
    maritalStatus
    VARCHAR(100) NOT NULL,
    birth_day DATE         NOT NULL,
    address   VARCHAR(100) NOT NULL,
    staff_id  INT          NOT NULL,
    FOREIGN KEY
(
    staff_id
) REFERENCES staff
(
    id
)
    );
CREATE INDEX malitalStatus ON personalInfo (maritalStatus);

INSERT INTO personalInfo(id, maritalStatus, birth_day, address, staff_id)
VALUES (1, 'Одружений', '1999-11-12', 'м. Луцьк, ул. Набережна, 33', 1),
       (2, 'Заручений', '2002-11-22', 'м. Харків, ул. Незалежності, 35', 2),
       (3, 'неодружений', '1998-02-11', 'м. Одеса, ул. Небесної Сотні, 54', 3),
       (4, 'розведена', '1996-03-13', 'м. Київ, ул. Шевченка, 16, кв. 52', 4),
       (5, 'неодружена', '1997-02-24', 'м. Львів, ул. Бандери, 21', 5);

-- Без використання індексів Швидкість роботи мінімальна --

EXPLAIN
SELECT name_staff
FROM staff
WHERE staff.name_staff = 'Андрiй';

-- З використанням индексів. Швидкість роботи збільшується --
CREATE INDEX name ON staff (name_staff);
EXPLAIN
SELECT name_staff
FROM staff
WHERE staff.name_staff = 'Андрiй';
-- task 4
/* Получите контактные данные сотрудников (номера телефонов, место жительства)  5 чел*/
-- при помощи JOIN’s
DROP VIEW IF EXISTS contactDetails;
CREATE VIEW contactDetails
AS
SELECT name_staff, phone, address
FROM staff
         JOIN personalInfo
              ON staff.id = personalInfo.id;

SELECT *
FROM contactDetails;

-- при помощи вложенных запросов
DROP VIEW IF EXISTS contactDetails;
CREATE VIEW contactDetails AS
SELECT name_staff, phone, (SELECT address FROM personalInfo WHERE staff.id = personalInfo.id) AS adress
FROM staff;
SELECT *
FROM contactDetails;

/* Получите информацию о дате рождения всех холостых сотрудников и их номера 3 чел */
-- при помощи JOIN’s
DROP VIEW IF EXISTS divorcedPerson;
CREATE VIEW divorcedPerson AS
SELECT staff.name_staff, personalInfo.maritalStatus, personalInfo.birth_day, staff.phone
FROM staff
         JOIN personalInfo
              ON staff.id = personalInfo.staff_id
WHERE personalInfo.maritalStatus IN ('розведена', 'неодружений', 'неодружена');
SELECT *
FROM divorcedPerson;

-- при помощи вложенных запросов
DROP VIEW IF EXISTS divorcedPerson;
CREATE VIEW divorcedPerson AS
SELECT maritalStatus,
       birth_day,
       (SELECT phone FROM staff WHERE staff.id = personalInfo.id)      AS phone,
       (SELECT name_staff FROM staff WHERE staff.id = personalInfo.id) AS name
FROM personalInfo
WHERE personalInfo.maritalStatus IN ('розведена', 'неодружений', 'неодружена');
SELECT *
FROM divorcedPerson;

/* Получите информацию обо всех менеджерах компании: дату рождения и номер телефона 3 чел */
-- при помощи JOIN’s
DROP VIEW IF EXISTS managers;
CREATE VIEW managers AS
SELECT staff.name_staff, position_staff, personalInfo.birth_day, staff.phone
FROM staff
         JOIN personalInfo
              ON staff.id = personalInfo.staff_id
         JOIN serviceInfo
              ON staff.id = serviceInfo.staff_id
WHERE serviceInfo.position_staff = 'Менеджер';
SELECT *
FROM managers;

-- при помощи вложенных запросов
DROP VIEW IF EXISTS managers;
CREATE VIEW managers AS
SELECT position_staff                                                              AS position_staff,
       (SELECT name_staff FROM staff WHERE staff.id = serviceInfo.id)              AS name,
       (SELECT phone FROM staff WHERE staff.id = serviceInfo.id)                   as phone,
       (SELECT birth_day FROM personalInfo WHERE personalInfo.id = serviceInfo.id) as birthday
FROM serviceInfo
WHERE serviceInfo.position_staff = 'Менеджер';
SELECT *
FROM managers

