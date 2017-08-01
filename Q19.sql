/* 19.Find all applicantion history for each employee*/
/* Author: Jiayi Yu  Reviewer: Long Wan, Lu Yin */
SELECT Employee.EmployeeID, Application.ApplicationID, IfAdmitted, Acceptance, Resume, ApplyDate, Application.PosID, Application.DepID, Application.BranchID
FROM((SELECT EmployeeID, ApplicantID
FROM Application
WHERE Acceptance="TRUE"
)temp1 JOIN Application USING (ApplicantID)) 
JOIN Employee USING (EmployeeID)
WHERE ApplyDate<EmployDate
