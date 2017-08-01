/* 17.Find all employees with more than three employment histories */
/* Author: Jiayi Yu  Reviewer: Long Wan, Lu Yin */
SELECT EmployeeID, COUNT(*) AS historyCount
FROM EmploymentHistory
GROUP BY EmployeeID
HAVING COUNT(*) >2;