create database company1;
use company1;
CREATE TABLE Employees (
    EmpID INT PRIMARY KEY,
    EmpName VARCHAR(50),
    DeptID INT,
    Salary INT,
    JoiningDate DATE
);

INSERT INTO Employees (EmpID, EmpName, DeptID, Salary, JoiningDate) VALUES
(1, 'GAURAV', 101, 70000, '2020-01-10'),
(2, 'RUSHIKESH', 102, 80000, '2021-06-15'),
(3, 'VIRAJ', 101, 75000, '2019-03-20'),
(4, 'ASHWINI', 103, 90000, '2018-11-05'),
(5, 'TEJASWI', 102, 72000, '2022-07-01'),
(6, 'ASHITOSH', 101, 67000, '2023-01-20');

-- 1. Average Salary by Department (Using Window Function)

SELECT 
    EmpName,
    DeptID,
    Salary,
    AVG(Salary) OVER (PARTITION BY DeptID) AS DeptAvgSalary
FROM Employees;

-- 2. Rank Employees by Salary (Across Entire Company)
SELECT 
    EmpName,
    DeptID,
    Salary,
    RANK() OVER (ORDER BY Salary DESC) AS SalaryRank
FROM Employees;

-- 3. Identify Latest Employee in Each Department (Using ROW_NUMBER)
SELECT *
FROM (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY DeptID ORDER BY JoiningDate DESC) AS rn
    FROM Employees
) AS Ranked
WHERE rn = 1;

-- 4. Use of CTE: Employees Earning Above Department Average
WITH DeptAvg AS (
    SELECT DeptID, AVG(Salary) AS AvgSal
    FROM Employees
    GROUP BY DeptID
)
SELECT E.EmpName, E.Salary, D.AvgSal, E.DeptID
FROM Employees E
JOIN DeptAvg D ON E.DeptID = D.DeptID
WHERE E.Salary > D.AvgSal;


-- 5. Subquery: Find Department with Highest Average Salary
SELECT DeptID, AVG(Salary) AS AvgSalary
FROM Employees
GROUP BY DeptID
HAVING AVG(Salary) = (
    SELECT MAX(AvgSal)
    FROM (
        SELECT DeptID, AVG(Salary) AS AvgSal
        FROM Employees
        GROUP BY DeptID
    ) AS Sub
);

