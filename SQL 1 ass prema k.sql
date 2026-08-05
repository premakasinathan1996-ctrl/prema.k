DROP DATABASE employee;

CREATE DATABASE Employee;
USE Employee;

CREATE TABLE Departments (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(100));
    
    CREATE TABLE Location (
    location_id INT PRIMARY KEY,
    location_name VARCHAR(100));
    
    CREATE TABLE Employees (
    employee_id INT PRIMARY KEY,
    employee_name VARCHAR(100),
    gender CHAR(1),
    age INT,
    hire_date DATE,
    designation VARCHAR(50),
    salary DECIMAL(10,2),
    department_id INT,
    location_id INT,
    FOREIGN KEY (department_id) REFERENCES Departments(department_id),
    FOREIGN KEY (location_id) REFERENCES Location(location_id));
    
    
    
    ALTER TABLE Employees
ADD email VARCHAR(100);

ALTER TABLE Employees
MODIFY designation VARCHAR(150);

ALTER TABLE Employees
DROP COLUMN age;


ALTER TABLE Employees
RENAME COLUMN hire_date TO date_of_joining;


RENAME TABLE Departments TO Departments_Info;


RENAME TABLE Location TO Locations;

SHOW TABLES;

TRUNCATE TABLE Employees;


DROP TABLE Employees;

DROP DATABASE employee;

DROP DATABASE IF EXISTS employee;

CREATE DATABASE employee;

USE employee;

CREATE TABLE Departments (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(100) NOT NULL UNIQUE);
    
    CREATE TABLE Locations (
    location_id INT AUTO_INCREMENT PRIMARY KEY,
    location_name VARCHAR(100) NOT NULL UNIQUE);
    
    CREATE TABLE Employees (
    employee_id INT PRIMARY KEY,
    employee_name VARCHAR(100) NOT NULL,
    gender CHAR(1) CHECK (gender IN ('M','F')),
    age INT CHECK (age >= 18),
    hire_date DATE DEFAULT (CURRENT_DATE),
    designation VARCHAR(150),
    salary DECIMAL(10,2),
    department_id INT,
    location_id INT,

    CONSTRAINT fk_department
        FOREIGN KEY (department_id)
        REFERENCES Departments(department_id),

    CONSTRAINT fk_location
        FOREIGN KEY (location_id)
        REFERENCES Locations(location_id));
        
        INSERT INTO Departments VALUES
(101,'HR'),
(102,'Finance'),
(103,'IT');

INSERT INTO Locations(location_name)
VALUES
('Chennai'),
('Bangalore'),
('Hyderabad');

INSERT INTO Employees
(employee_id, employee_name, gender, age, designation,
salary, department_id, location_id)
VALUES
(1,'Nirmal Kumar','M',24,'Data Analyst',45000,103,1),
(2,'Priya','F',26,'HR Executive',35000,101,2),
(3,'Rahul','M',28,'Finance Analyst',50000,102,3);

SHOW TABLES;

DESC Departments;

DESC Locations;

DESC Employees;


SELECT * FROM Departments;

SELECT * FROM Locations;

SELECT * FROM Employees;




