CREATE TABLE SalesRepresentatives (
                                         id SERIAL PRIMARY KEY,
                                         last_name VARCHAR(50),
                                         first_name VARCHAR(50),
                                         middle_name VARCHAR(50),
                                         address VARCHAR(100),
                                         phone VARCHAR(20)
);

CREATE TABLE Products (
                          id SERIAL PRIMARY KEY,
                          name VARCHAR(100),
                          price DECIMAL(10, 2),
                          unit_of_measurement VARCHAR(20)
);

CREATE TABLE BusinessTrips (
                               id SERIAL PRIMARY KEY,
                               sales_rep_id INT REFERENCES SalesRepresentatives(id),
                               start_date DATE,
                               end_date DATE
);

CREATE TABLE Taken (
                       business_trip_id INT REFERENCES BusinessTrips(id),
                       product_id INT REFERENCES Products(id),
                       quantity INT,
                       PRIMARY KEY (business_trip_id, product_id)
);

CREATE TABLE Returns (
                         business_trip_id INT REFERENCES BusinessTrips(id),
                         product_id INT REFERENCES Products(id),
                         quantity INT,
                         PRIMARY KEY (business_trip_id, product_id)
);

INSERT INTO SalesRepresentatives (last_name, first_name, middle_name, address, phone) VALUES
                                                                                          ('Иванов', 'Иван', 'Иванович', 'Москва, ул. Ленина, д. 1', '89991111111'),
                                                                                          ('Петров', 'Петр', 'Петрович', 'Санкт-Петербург, пр. Невский, д. 2', '89992222222'),
                                                                                          ('Сидоров', 'Сидор', 'Сидорович', 'Екатеринбург, ул. Малышева, д. 3', '89993333333'),
                                                                                          ('Кузнецов', 'Алексей', 'Алексеевич', 'Новосибирск, ул. Красный проспект, д. 4', '89994444444'),
                                                                                          ('Смирнов', 'Дмитрий', 'Дмитриевич', 'Казань, ул. Баумана, д. 5', '89995555555'),
                                                                                          ('Попов', 'Андрей', 'Андреевич', 'Челябинск, ул. Труда, д. 6', '89996666666'),
                                                                                          ('Зайцев', 'Николай', 'Николаевич', 'Ростов-на-Дону, ул. Пушкинская, д. 7', '89997777777'),
                                                                                          ('Морозов', 'Станислав', 'Станиславович', 'Воронеж, ул. Карла Маркса, д. 8', '89998888888'),
                                                                                          ('Васильев', 'Евгений', 'Евгеньевич', 'Нижний Новгород, ул. Горького, д. 9', '89999999999'),
                                                                                          ('Федоров', 'Роман', 'Романович', 'Самара, ул. Ленинградская, д. 10', '89990000000');

INSERT INTO Products (name, price, unit_of_measurement) VALUES
                                                            ('Хлеб', 25.50, 'штука'),
                                                            ('Молоко', 60.00, 'литр'),
                                                            ('Яйца', 90.00, 'десяток'),
                                                            ('Мясо говядина', 500.00, 'килограмм'),
                                                            ('Курица целая', 300.00, 'килограмм'),
                                                            ('Сыр', 450.00, 'килограмм'),
                                                            ('Рыба', 350.00, 'килограмм'),
                                                            ('Овощи ассорти', 150.00, 'килограмм'),
                                                            ('Фрукты ассорти', 200.00, 'килограмм'),
                                                            ('Конфеты', 150.00, 'штука');



INSERT INTO BusinessTrips (sales_rep_id, start_date, end_date) VALUES
                                                                   (1, '2023-01-10', '2023-01-15'),
                                                                   (2, '2023-02-05', '2023-02-10'),
                                                                   (3, '2023-03-01', '2023-03-05'),
                                                                   (4, '2023-04-15', '2023-04-20'),
                                                                   (5, '2023-05-10', '2023-05-15'),
                                                                   (6, '2023-06-01', '2023-06-05'),
                                                                   (7, '2023-07-20', '2023-07-25'),
                                                                   (8, '2023-08-15', '2023-08-20'),
                                                                   (9, '2023-09-10', '2023-09-15'),
                                                                   (10, '2023-10-05', '2023-10-10');


INSERT INTO Taken (business_trip_id, product_id, quantity) VALUES
                                                               (1, 1, 10),
                                                               (1, 2, 5),
                                                               (2, 3, 20),
                                                               (2, 4, 15),
                                                               (3, 5, 8),
                                                               (4, 6, 12),
                                                               (5, 7, 6),
                                                               (6, 8, 10),
                                                               (7, 9, 4),
                                                               (8, 10, 30);


INSERT INTO Returns (business_trip_id, product_id, quantity) VALUES
                                                                 (1, 1, 2),
                                                                 (1, 2, 1),
                                                                 (2, 3, 5),
                                                                 (2, 4, 3),
                                                                 (3, 5, 2),
                                                                 (4, 6, 4),
                                                                 (5, 7, 1),
                                                                 (6, 8, 2),
                                                                 (7, 9, 1),
                                                                 (8, 10, 15);


INSERT INTO BusinessTrips (sales_rep_id, start_date, end_date) VALUES
                                                                   (1, '2024-01-10', '2024-01-15'),
                                                                   (2, '2024-02-05', '2024-02-10'),
                                                                   (3, '2024-03-01', '2024-03-05'),
                                                                   (4, '2024-04-15', '2024-04-20');


INSERT INTO Taken (business_trip_id, product_id, quantity) VALUES
                                                               (11, 8, 10),
                                                               (11, 7, 5),
                                                               (12, 6, 20),
                                                               (12, 5, 15),
                                                               (13, 5, 8),
                                                               (14, 6, 12);


INSERT INTO Returns (business_trip_id, product_id, quantity) VALUES
                                                                 (11, 8, 1),
                                                                 (11, 7, 2),
                                                                 (12, 6, 3);