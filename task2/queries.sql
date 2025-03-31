-- 1. Расчет зарплаты коммивояжера за указанный период (20% от вырученной суммы).

SELECT DISTINCT sales_rep_id,
                SUM((Taken.quantity - Returns.quantity) * price * 0.2) OVER (PARTITION BY sales_rep_id) AS salary
FROM Taken
         INNER JOIN RETURNS
                    ON Taken.business_trip_id = Returns.business_trip_id AND Taken.product_id = Returns.product_id
         INNER JOIN Products ON Taken.product_id = Products.id
         INNER JOIN BusinessTrips ON BusinessTrips.id = Taken.business_trip_id
WHERE BusinessTrips.start_date >= CURRENT_DATE - INTERVAL '2 years';

-- 2. Выбрать коммивояжеров, у которых были командировки с одним видом взятого товара (речь про один «Идентификатор товара», не кол-во).

SELECT DISTINCT last_name, first_name, middle_name, business_trip_id
FROM Taken
         INNER JOIN BusinessTrips ON business_trip_id = BusinessTrips.id
         INNER JOIN SalesRepresentatives ON sales_rep_id = SalesRepresentatives.id
GROUP BY business_trip_id, last_name, first_name, middle_name
HAVING COUNT(product_id) = 1;



SELECT last_name, first_name, middle_name
FROM (SELECT COUNT(product_id) OVER (PARTITION BY business_trip_id) AS count_products,
             last_name,
             first_name,
             middle_name
      FROM Taken
               INNER JOIN BusinessTrips ON business_trip_id = BusinessTrips.id
               INNER JOIN SalesRepresentatives ON sales_rep_id = SalesRepresentatives.id)
WHERE count_products = 1;


-- 3. Расчет эффективности работы (отношение забираемого товара к возвращаемому) для коммивояже-ров, зарплата которых больше 1000р..

SELECT DISTINCT sales_rep_id,
                SUM(Taken.quantity) / SUM(Returns.quantity)            AS efficiency,
                SUM((Taken.quantity - Returns.quantity) * price * 0.2) AS salary
FROM Taken
         INNER JOIN RETURNS ON Taken.business_trip_id = Returns.business_trip_id
         INNER JOIN Products ON Taken.product_id = Products.id
         INNER JOIN BusinessTrips ON BusinessTrips.id = Taken.business_trip_id
WHERE BusinessTrips.start_date >= CURRENT_DATE - INTERVAL '2 years'
GROUP BY sales_rep_id
HAVING SUM((Taken.quantity - Returns.quantity) * price * 0.2) > 1000;


-- 4. Выбрать самого эффективного работника с указанием его эффективности и количества командировок.


SELECT sales_rep_id, SUM(Taken.quantity) / SUM(Returns.quantity) AS efficiency, COUNT(BusinessTrips.id)
FROM Taken
         INNER JOIN RETURNS ON Taken.business_trip_id = Returns.business_trip_id
         INNER JOIN Products ON Taken.product_id = Products.id
         INNER JOIN BusinessTrips ON BusinessTrips.id = Taken.business_trip_id
GROUP BY sales_rep_id, BusinessTrips.id
ORDER BY SUM(Taken.quantity) / SUM(Returns.quantity)
        DESC
LIMIT 1;


-- 5. Выбрать для каждого коммивояжера его «любимый» товар: тот, который он чаще всего берёт / отдаёт (обязательно использование аналитических функций).*/

WITH productsInUse AS (SELECT business_trip_id, product_id
                       FROM taken
                       UNION ALL
                       SELECT business_trip_id, product_id
                       FROM returns),
     RankedProducts AS (SELECT DISTINCT sales_rep_id,
                                        product_id,
                                        COUNT(product_id) OVER (PARTITION BY sales_rep_id),
                                        RANK() OVER (PARTITION BY sales_rep_id ORDER BY COUNT(product_id) DESC) AS rank
                        FROM productsInUse
                                 JOIN businesstrips ON business_trip_id = businesstrips.id
                        group by sales_rep_id, product_id)
SELECT *
from RankedProducts
where rank = 1
order by sales_rep_id;
