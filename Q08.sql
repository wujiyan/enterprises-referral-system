/* 8. Find all branches that have more than 3 employees. */
/*Author: Jiayi Yu  Reviewer: Long Wan, Lu Yin*/
SELECT BranchID, COUNT (*) AS EmployeeCount
FROM ((
	SELECT EmployeeID FROM Employee
	EXCEPT
	SELECT EmployeeID FROM Former
) CurrentEmployee
NATURAL JOIN EmploymentHistory)
NATURAL JOIN Position
WHERE EmploymentHistory.EndDate IS NULL
GROUP BY Position.BranchID
HAVING COUNT (*) >3;