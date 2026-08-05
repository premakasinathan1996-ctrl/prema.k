CREATE DATABASE elearning_db;
USE elearning_db 

SHOW DATABASES;

SELECT DATABASE();

CREATE TABLE learners(learner_id INT PRIMARY KEY,
    full_name VARCHAR(100),
    country VARCHAR(50));
    
DESC learners;

CREATE TABLE courses (
    course_id INT PRIMARY KEY,
    course_name VARCHAR(100),
    category VARCHAR(50),
    unit_price DECIMAL(10,2));
    
DESC courses;

CREATE TABLE purchases (
    purchase_id INT PRIMARY KEY,
    learner_id INT,
    course_id INT,
    quantity INT,
    purchase_date DATE,
    FOREIGN KEY (learner_id) REFERENCES learners(learner_id),
    FOREIGN KEY (course_id) REFERENCES courses(course_id));
    
DESC purchases;

SHOW TABLES;

INSERT INTO learners VALUES
(1,'Prema k','India'),
(2,'praveen kumar ','USA'),
(3,'Rahul k','UK'),
(4,'Ravi','India'),
(5,'Nandhika sree','france');

SELECT * FROM learners;

INSERT INTO courses VALUES
(101,'SQL Basics','Beginner',3000),
(102,'Power BI Mastery','Intermediate',5000),
(103,'Python for Data Analysis','Advanced',7000),
(104,'Excel Dashboard','Beginner',2500),
(105,'Tableau Visualization','Intermediate',4500);

SELECT * FROM courses;

INSERT INTO purchases VALUES
(1,1,101,2,'2026-01-10'),
(2,1,102,1,'2026-02-15'),
(3,2,103,1,'2026-03-05'),
(4,3,104,3,'2026-03-18'),
(5,4,105,2,'2026-04-01'),
(6,5,102,2,'2026-04-10'),
(7,2,101,1,'2026-05-12'),
(8,3,103,1,'2026-05-20');

SELECT * FROM purchases;

SELECT COUNT(*) FROM learners;  
SELECT COUNT(*) FROM courses;
SELECT COUNT(*) FROM purchases;

USE elearning_db;

SELECT DATABASE();

SHOW DATABASES;
SHOW TABLES;

SELECT * FROM learners;
SELECT * FROM courses;
SELECT * FROM purchases;

SELECT 
    l.full_name AS Learner_Name,
    c.course_name AS Course_Name,
    c.category AS Category,
    p.quantity AS Quantity,
    FORMAT(p.quantity * c.unit_price, 2) AS Total_Amount,
    p.purchase_date AS Purchase_Date
FROM purchases p
INNER JOIN learners l
    ON p.learner_id = l.learner_id
INNER JOIN courses c
    ON p.course_id = c.course_id
ORDER BY (p.quantity * c.unit_price) DESC;

SELECT 
    l.full_name AS Learner_Name,
    c.course_name AS Course_Name,
    c.category AS Category,
    p.quantity AS Quantity,
    FORMAT(IFNULL(p.quantity * c.unit_price,0), 2) AS Total_Amount,
    p.purchase_date AS Purchase_Date
FROM learners l
LEFT JOIN purchases p
    ON l.learner_id = p.learner_id
LEFT JOIN courses c
    ON p.course_id = c.course_id
ORDER BY (p.quantity * c.unit_price) DESC;

SELECT 
    l.full_name AS Learner_Name,
    c.course_name AS Course_Name,
    c.category AS Category,
    p.quantity AS Quantity,
    FORMAT(IFNULL(p.quantity * c.unit_price,0), 2) AS Total_Amount,
    p.purchase_date AS Purchase_Date
FROM learners l
RIGHT JOIN purchases p
    ON l.learner_id = p.learner_id
RIGHT JOIN courses c
    ON p.course_id = c.course_id
ORDER BY (p.quantity * c.unit_price) DESC;

SELECT 
    l.full_name AS Learner_Name,
    l.country AS Country,
    SUM(p.quantity * c.unit_price) AS Total_Spending
FROM learners l
JOIN purchases p
    ON l.learner_id = p.learner_id
JOIN courses c
    ON p.course_id = c.course_id
GROUP BY l.learner_id, l.full_name, l.country
ORDER BY Total_Spending DESC;

SELECT
    c.course_name AS Course_Name,
    SUM(p.quantity) AS Total_Quantity_Purchased
FROM courses c
JOIN purchases p
    ON c.course_id = p.course_id
GROUP BY c.course_id, c.course_name
ORDER BY Total_Quantity_Purchased DESC
LIMIT 3;

SELECT
    c.category AS Category,
    SUM(p.quantity * c.unit_price) AS Total_Revenue,
    COUNT(DISTINCT p.learner_id) AS Unique_Learners
FROM courses c
JOIN purchases p
    ON c.course_id = p.course_id
GROUP BY c.category
ORDER BY Total_Revenue DESC;

SELECT
    l.full_name AS Learner_Name,
    COUNT(DISTINCT c.category) AS Categories_Purchased
FROM learners l
JOIN purchases p
    ON l.learner_id = p.learner_id
JOIN courses c
    ON p.course_id = c.course_id
GROUP BY l.learner_id, l.full_name
HAVING COUNT(DISTINCT c.category) > 1;

SELECT
    c.course_id,
    c.course_name,
    c.category
FROM courses c
LEFT JOIN purchases p
    ON c.course_id = p.course_id
WHERE p.purchase_id IS NULL;

SELECT
    l.full_name,
    SUM(p.quantity * c.unit_price) AS Total_Spending
FROM learners l
JOIN purchases p ON l.learner_id = p.learner_id
JOIN courses c ON p.course_id = c.course_id
GROUP BY l.learner_id, l.full_name
HAVING SUM(p.quantity * c.unit_price) >
(SELECT AVG(total_spending)
    FROM(SELECT SUM(p2.quantity * c2.unit_price) AS total_spending
        FROM purchases p2
        JOIN courses c2 ON p2.course_id = c2.course_id
        GROUP BY p2.learner_id) avg_table);
        
 SELECT
    course_name,
    category,
    unit_price
FROM courses
WHERE unit_price >
(
    SELECT MAX(unit_price)
    FROM courses
    WHERE category = 'Beginner');       

SELECT
    l.full_name,
    l.country,
    SUM(p.quantity * c.unit_price) AS Total_Spending
FROM learners l
JOIN purchases p
    ON l.learner_id = p.learner_id
JOIN courses c
    ON p.course_id = c.course_id
GROUP BY l.learner_id, l.full_name, l.country
HAVING SUM(p.quantity * c.unit_price) >
(
    SELECT AVG(country_spending)
    FROM
    (
        SELECT
            l2.country,
            l2.learner_id,
            SUM(p2.quantity * c2.unit_price) AS country_spending
        FROM learners l2
        JOIN purchases p2 ON l2.learner_id = p2.learner_id
        JOIN courses c2 ON p2.course_id = c2.course_id
        WHERE l2.country = l.country
        GROUP BY l2.country, l2.learner_id
    ) avg_country
);

WITH learner_spending AS
(
    SELECT
        l.learner_id,
        l.full_name,
        SUM(p.quantity * c.unit_price) AS Total_Spending
    FROM learners l
    JOIN purchases p
        ON l.learner_id = p.learner_id
    JOIN courses c
        ON p.course_id = c.course_id
    GROUP BY l.learner_id, l.full_name
)
SELECT *
FROM learner_spending
WHERE Total_Spending > 10000;

SELECT
    l.full_name,
    SUM(p.quantity * c.unit_price) AS Total_Spending,
    CASE
        WHEN SUM(p.quantity * c.unit_price) > 15000 THEN 'High Value'
        WHEN SUM(p.quantity * c.unit_price) BETWEEN 8000 AND 15000 THEN 'Medium Value'
        ELSE 'Low Value'
    END AS Customer_Category
FROM learners l
JOIN purchases p
    ON l.learner_id = p.learner_id
JOIN courses c
    ON p.course_id = c.course_id
GROUP BY l.learner_id, l.full_name;

SELECT
    c.course_name,
    COALESCE(COUNT(p.purchase_id), 0) AS Purchase_Count
FROM courses c
LEFT JOIN purchases p
    ON c.course_id = p.course_id
GROUP BY c.course_id, c.course_name;

CREATE VIEW category_performance_view AS
SELECT
    c.category AS Category,
    SUM(p.quantity * c.unit_price) AS Total_Revenue,
    COUNT(p.purchase_id) AS Number_of_Purchases,
    ROUND(
        SUM(p.quantity * c.unit_price) / COUNT(p.purchase_id),
        2
    ) AS Average_Revenue_Per_Purchase
FROM courses c
JOIN purchases p
    ON c.course_id = p.course_id
GROUP BY c.category;

SELECT * FROM category_performance_view;