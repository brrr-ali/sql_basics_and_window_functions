CREATE TABLE Employees
(
    employeeId  SERIAL PRIMARY KEY,
    FirstName   VARCHAR(50) NOT NULL,
    LastName    VARCHAR(50) NOT NULL,
    EMail       VARCHAR(50),
    PhoneNumber VARCHAR(15)
);

CREATE TABLE Specializations
(
    specializationId     SERIAL PRIMARY KEY,
    nameOfSpecialization VARCHAR(50) NOT NULL
);

CREATE TABLE Departments
(
    specializationId INTEGER REFERENCES Specializations (specializationId) UNIQUE,
    maxCapacity      INTEGER
);

CREATE TABLE Positions
(
    id              SERIAL PRIMARY KEY,
    titleOfPosition VARCHAR(100)
);

CREATE TYPE personnelChangesTypes AS ENUM ('принят на работу', 'уволен', 'изменение отдела','изменение заработной платы','изменение должности');

CREATE TABLE PersonnelChanges
(
    id           SERIAL PRIMARY KEY,
    employeeId   INTEGER REFERENCES Employees (employeeid),
    dateOfChange DATE,
    departmentId INTEGER REFERENCES Departments (specializationId),
    positionId   INTEGER REFERENCES Positions (id),
    salary       MONEY,
    typeOfChange personnelChangesTypes
);

CREATE TABLE Doctors
(
    doctorId   SERIAL PRIMARY KEY,
    employeeId INTEGER REFERENCES Employees (employeeId)
);

CREATE TABLE SpecializationsOfDoctors
(
    doctorId         INTEGER REFERENCES Doctors (doctorId),
    specializationId INTEGER REFERENCES Specializations (specializationId)
);

CREATE TABLE Patients
(
    id          SERIAL PRIMARY KEY,
    FirstName   VARCHAR(50) NOT NULL,
    LastName    VARCHAR(50) NOT NULL,
    OMS         VARCHAR(16) NOT NULL,
    dateOfBirth DATE
);

CREATE TYPE resultOfBeingInHospital AS ENUM ('здоров', 'амбулаторное лечение', 'стационар');

CREATE TYPE patientActions AS ENUM ('поступление', 'выписка', 'изменение врача', 'изменение отделения');

CREATE TABLE Diagnoses
(
    id               SERIAL PRIMARY KEY,
    titleOfDiagnosis VARCHAR(100) NOT NULL
);

CREATE TABLE HistoryOfPatients
(
    patientId         INTEGER REFERENCES Patients (id),
    dateStart         DATE NOT NULL,
    dateEnd           DATE,
    typeOfEvent       patientActions,
    result            resultOfBeingInHospital,
    departmentId      INTEGER REFERENCES Departments (specializationId),
    attendingDoctorId INTEGER REFERENCES Doctors (doctorId),
    intendedDiagnosis INTEGER REFERENCES Diagnoses (id)
);


CREATE TABLE Consultations
(
    id                        SERIAL PRIMARY KEY,
    dateAndTimeOfConsultation TIMESTAMP,
    patientId                 INTEGER REFERENCES Patients (id),
    doctorId                  INTEGER REFERENCES Doctors (doctorId),
    report                    JSONB
);

CREATE TABLE HistoryOfDiagnoses
(
    id                SERIAL PRIMARY KEY,
    typeOfDiagnosisId INTEGER REFERENCES Diagnoses (id),
    consultationId    INTEGER REFERENCES Consultations (id),
    moreInformation   JSONB
);

CREATE TABLE Researches
(
    id              SERIAL PRIMARY KEY,
    titleOfResearch VARCHAR(100) NOT NULL
);

CREATE TABLE HistoryOfResearches
(
    id                    SERIAL PRIMARY KEY,
    patientId             INTEGER REFERENCES Patients (id),
    typeOfResearchId      INTEGER REFERENCES Researches (id),
    dateAndTimeOfResearch TIMESTAMP,
    resultOfSearch        JSONB
);

CREATE TABLE ConfirmationOfDiagnosisByResearches
(
    researchId  INTEGER REFERENCES HistoryOfResearches (id),
    diagnosisId INTEGER REFERENCES HistoryOfDiagnoses (id)
);


CREATE TABLE DutySchedule
(
    positionId INTEGER REFERENCES PersonnelChanges (id),
    dateOfDuty DATE,
    startTime  TIME,
    endTime    TIME
);

INSERT INTO Employees (FirstName, LastName, EMail, PhoneNumber)
VALUES ('Иван', 'Иванов', 'ivan.ivanov@example.com', '1234567890'),
       ('Мария', 'Петрова', 'maria.petrovna@example.com', '0987654321'),
       ('Сергей', 'Сидоров', 'sergey.sidorov@example.com', '1122334455'),
       ('Анна', 'Кузнецова', 'anna.kuznetsova@example.com', '2233445566'),
       ('Дмитрий', 'Смирнов', 'dmitry.smirnov@example.com', '3344556677'),
       ('Ольга', 'Федорова', 'olga.fedorova@example.com', '4455667788');


INSERT INTO Specializations (nameOfSpecialization)
VALUES ('Стоматология'),
       ('Хирургия'),
       ('Педиатрия'),
       ('Кардиология'),
       ('Неврология'),
       ('Офтальмология');

INSERT INTO Departments (specializationId, maxCapacity)
VALUES (1, 10),
       (2, 15),
       (3, 25),
       (4, 10),
       (5, 30),
       (6, 12);


INSERT INTO Positions (titleOfPosition)
VALUES ('Врач'),
       ('Медсестра'),
       ('Главный врач'),
       ('Администратор'),
       ('Техник'),
       ('Уборщик'),
       ('Фармацевт');


INSERT INTO PersonnelChanges (employeeId, dateOfChange, departmentId, positionId, salary, typeOfChange)
VALUES (1, '2024-01-15', 1, 1, 120000, 'принят на работу'),
       (1, '2023-01-15', 2, 1, 50000, 'принят на работу'),
       (2, '2023-02-20', 2, 2, 30000, 'принят на работу'),
       (3, '2023-02-20', 2, 2, 30000, 'принят на работу'),
       (4, '2023-02-20', 2, 2, 30000, 'принят на работу'),
       (2, '2023-02-20', 1, 2, 30000, 'принят на работу'),
       (3, '2023-02-20', 1, 2, 30000, 'принят на работу'),
       (3, '2023-03-10', 3, 1, 55000, 'принят на работу'),
       (5, '2023-04-05', 4, 3, 40000, 'принят на работу'),
       (5, '2023-05-12', 5, 4, 60000, 'изменение должности'),
       (6, '2021-06-01', 6, 5, 45000, 'принят на работу'),
       (6, '2023-06-01', 6, 5, 45000, 'уволен');

INSERT INTO Doctors (employeeId)
VALUES (1),
       (2),
       (3);

INSERT INTO SpecializationsOfDoctors (doctorId, specializationId)
VALUES (1, 1),
       (2, 2),
       (3, 3),
       (1, 4),
       (1, 5),
       (2, 6);


INSERT INTO Patients (FirstName, LastName, OMS, dateOfBirth)
VALUES ('Алексей', 'Алексеев', '1234567890123456', '1990-01-01'),
       ('Елена', 'Еленова', '2345678901234567', '1985-02-02'),
       ('Светлана', 'Светлова', '3456789012345678', '2000-03-03'),
       ('Игорь', 'Игорев', '4567890123456789', '1975-04-04'),
       ('Наталья', 'Наталиева', '5678901234567890', '1995-05-05'),
       ('Владимир', 'Владимиров', '6789012345678901', '1980-06-06');


INSERT INTO Diagnoses (titleOfDiagnosis)
VALUES ('Грипп'),
       ('Острый бронхит'),
       ('Пневмония'),
       ('Диабет'),
       ('Гипертония'),
       ('Аллергия');


INSERT INTO Researches (titleOfResearch)
VALUES ('Анализ крови'),
       ('УЗИ органов брюшной полости'),
       ('Рентген грудной клетки'),
       ('ЭКГ'),
       ('МРТ головы'),
       ('КТ грудной клетки');

INSERT INTO Consultations (dateAndTimeOfConsultation, patientId, doctorId, report)
VALUES ('2023-01-11 10:00', 1, 1, '{
  "замечания": "Общее состояние хорошее"
}'),
       ('2023-02-21 11:00', 2, 2, '{
         "замечания": "Необходима повторная консультация"
       }'),
       ('2023-03-16 14:00', 3, 3, '{
         "замечания": "Рекомендован курс лечения"
       }'),
       ('2023-04-11 09:30', 4, 1, '{
         "замечания": "Пациент в удовлетворительном состоянии"
       }'),
       ('2023-05-02 10:45', 5, 2, '{
         "замечания": "Требуется дальнейшее наблюдение"
       }'),
       ('2023-06-12 11:15', 6, 3, '{
         "замечания": "Состояние стабильное"
       }'),
       ('2023-07-07 13:30', 1, 1, '{
         "замечания": "Необходима госпитализация"
       }'),
       ('2023-08-02 14:00', 2, 2, '{
         "замечания": "Следующий прием через месяц"
       }'),
       ('2023-09-11 09:00', 3, 3, '{
         "замечания": "Рекомендован обследование"
       }'),
       ('2023-10-01 10:30', 4, 1, '{
         "замечания": "Необходимо увеличение дозы"
       }');


INSERT INTO HistoryOfPatients (patientId, dateStart, dateEnd, typeOfEvent, result, departmentId, attendingDoctorId,
                               intendedDiagnosis)
VALUES (1, '2023-01-10', '2023-01-15', 'выписка', 'здоров', 1, 1, 1),
       (1, '2023-03-10', '2023-06-05', 'выписка', 'здоров', 1, 1, 1),
       (1, '2023-07-07', '2023-10-20', 'выписка', 'здоров', 2, 3, 2),

       (2, '2023-02-20', '2023-02-25', 'выписка', 'здоров', 2, 2, 1),
       (2, '2024-04-15', '2024-07-15', 'выписка', 'здоров', 2, 2, 1),
       (2, '2023-09-01', '2023-09-05', 'выписка', 'здоров', 3, 1, 2),
       (3, '2024-03-15', '2024-08-15', 'выписка', 'здоров', 3, 3, 1),
       (3, '2024-10-01', NULL, 'поступление', 'амбулаторное лечение', 4, 2, 2),
       (4, '2023-04-10', '2023-04-15', 'выписка', 'здоров', 4, 3, 1),
       (4, '2023-05-05', '2023-05-10', 'выписка', 'здоров', 4, 3, 2),
       (6, '2023-06-12', '2023-06-15', 'выписка', 'здоров', 1, 2, 2),

       (4, '2023-09-10', '2023-09-15', 'выписка', 'здоров', 5, 3, 2);


INSERT INTO HistoryOfDiagnoses (typeOfDiagnosisId, consultationId, moreInformation)
VALUES (1, 1, '{
  "дополнительные сведения": "Легкая форма"
}'),
       (2, 2, '{
         "дополнительные сведения": "Требуется повторное обследование"
       }'),
       (3, 3, '{
         "дополнительные сведения": "Контроль уровня сахара"
       }'),
       (4, 4, '{
         "дополнительные сведения": "Прием таблеток"
       }'),
       (5, 5, '{
         "дополнительные сведения": "Необходимы инъекции"
       }'),
       (6, 6, '{
         "дополнительные сведения": "Прошло 3 месяца"
       }'),
       (1, 7, '{
         "дополнительные сведения": "Требуется операция"
       }'),
       (2, 8, '{
         "дополнительные сведения": "Обострение состояния"
       }'),
       (3, 9, '{
         "дополнительные сведения": "Пациенту требуется повторный прием"
       }'),
       (4, 10, '{
         "дополнительные сведения": "Следующий прием через месяц"
       }');

INSERT INTO Patients (FirstName, LastName, OMS, dateOfBirth)
VALUES ('Влад', 'Васильев', '512886453623612', '1975-01-01');
INSERT INTO HistoryOfPatients (patientId, dateStart, dateEnd, typeOfEvent, result, departmentId, attendingDoctorId,
                               intendedDiagnosis)
VALUES (7, '2022-10-01', NULL, 'поступление', 'амбулаторное лечение', 4, 1, 2);

-- 1) Выбрать весь мед персонал, трудоустроенный в последние 2 года, с ЗП ниже 100т.р.
SELECT doctorid, dateofchange, typeofchange, departmentid, positionid, salary
FROM personnelchanges
         INNER JOIN Doctors ON personnelchanges.employeeid = Doctors.employeeid
WHERE dateOfChange >= CURRENT_DATE - INTERVAL '2 years'
  AND (personnelchanges.typeofchange = 'принят на работу')
  AND (salary < MONEY(100_000));

-- 2) Выбрать всех пациентов с одинаковым диагнозом, поступившие в последние 3 месяца.
SELECT DISTINCT firstname, lastname, intendedDiagnosis
FROM patients
         JOIN HistoryOfPatients ON Patients.id = HistoryOfPatients.patientId
WHERE HistoryOfPatients.dateStart >= CURRENT_DATE - INTERVAL '2 year'
  AND typeofevent = 'поступление'
  AND intendeddiagnosis = 1;

-- 3) Выбрать ТОП-10 врачей, у которых за последние 3 года, был максимальный процент выздоровевших выписанных пациентов с указанием этого процента.

SELECT attendingDoctorId,
       (SUM(CASE WHEN result = 'здоров' AND typeOfEvent = 'выписка' THEN 1 ELSE 0 END) * 100.0 /
        COUNT(CASE WHEN typeOfEvent = 'поступление' THEN 1 ELSE 0 END)) AS recoveryRate
FROM HistoryOfPatients
WHERE HistoryOfPatients.datestart >= CURRENT_DATE - INTERVAL '3 years'
   OR COALESCE(HistoryOfPatients.dateEnd, CURRENT_DATE) >= CURRENT_DATE - INTERVAL '3 years'
GROUP BY attendingDoctorId
ORDER BY recoveryRate DESC
LIMIT 10;

-- 4) Выбрать ТОП-10 пациентов, которые пролежали в больнице (сумма по времени всех попаданий) за последние 3 года дольше всех.
SELECT Patients.id,
       Patients.FirstName,
       Patients.LastName,
       SUM(COALESCE(HistoryOfPatients.dateEnd, CURRENT_DATE) -
           GREATEST(historyofpatients.datestart, CURRENT_DATE - INTERVAL '3 years')) AS total_days
FROM Patients
         JOIN HistoryOfPatients ON Patients.id = HistoryOfPatients.patientId
WHERE HistoryOfPatients.datestart >= CURRENT_DATE - INTERVAL '3 years'
   OR COALESCE(HistoryOfPatients.dateEnd, CURRENT_DATE) >= CURRENT_DATE - INTERVAL '3 years'
GROUP BY Patients.id
ORDER BY total_days DESC
LIMIT 10;

-- 5) Выбрать отделения, где среднее число пациентов (в день? в постоянном лечении?) у врача, больше 10.
SELECT count(patientid) AS countOfPatients, departmentid, count(attendingdoctorid) AS countOfDoctors
FROM HistoryOfPatients
GROUP BY departmentId
HAVING COUNT(patientId) / COUNT(DISTINCT historyofpatients.attendingdoctorid) > 10;

-- 6) Выбрать всех врачей, отсортировав их по нагрузке за последний год (нагрузка за год = сумма по дням: число пациентов (дата)).
SELECT count(DISTINCT HistoryOfPatients.patientId),
       attendingdoctorid,
       SUM(COALESCE(HistoryOfPatients.dateEnd, CURRENT_DATE)
           - GREATEST(historyofpatients.datestart, CURRENT_DATE - INTERVAL '1 years'))
           AS total_days
FROM historyofpatients
WHERE HistoryOfPatients.datestart >= CURRENT_DATE - INTERVAL '1 years'
   OR COALESCE(HistoryOfPatients.dateEnd, CURRENT_DATE) >= CURRENT_DATE - INTERVAL '1 years'
GROUP BY attendingdoctorid
ORDER BY total_days;
