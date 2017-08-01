
/* 7. Find all current employees that were hired before 2000. */
/*Author: Jiayi Yu  Reviewer: Long Wan, Lu Yin*/
SELECT Employee.EmployeeID, Name, EmployDate
FROM (
	SELECT EmployeeID FROM Employee
	EXCEPT
	SELECT EmployeeID FROM Former
) CurrentEmployee NATURAL JOIN Employee
WHERE EmployDate< DATE ('2000-01-01');