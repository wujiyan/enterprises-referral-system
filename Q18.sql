/* 18.Calculate average difference between managers’ salary and base salary for each branch*/
/* Author: Jiayi Yu  Reviewer: Long Wan, Lu Yin */
SELECT Position.BranchID, AVG(Salary-BaseSalary)
FROM ((
(SELECT EmployeeID
	FROM Employee
	EXCEPT
	SELECT EmployeeID
	FROM Former
) currentEmployee 
NATURAL JOIN Employee)
JOIN EmploymentHistory USING (EmployeeID))
JOIN Position USING (PosID, DepID, BranchID)
WHERE PosName= "Manager" 
AND EmploymentHistory.EndDate IS NULL
GROUP BY Position.BranchID