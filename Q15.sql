/*15.Find current employees with the highest base bonus but have been in this company for at least 3 years */
/*Author: LU YIN  Reviewer: Long Wan, Jiayi Yu*/
SELECT EmployeeID
FROM Employee
WHERE EmployeeID NOT IN (SELECT EmployeeID 
         FROM Former) 
AND EmployeeID IN (SELECT EmployeeID 
       FROM Employee 
       ORDER BY basebonus DESC 
       LIMIT 1)
	AND JULIANDAY(Employdate) + 365 * 3 < JULIANDAY('now')
