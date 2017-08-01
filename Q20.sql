/* 20.Find all applicants that were used to be an employee and dismissed. */
/* Author: Jiayi Yu  Reviewer: Long Wan, Lu Yin */
SELECT temp1.Name, temp1.Gender, temp1.DOB, temp1.ApplicantID
FROM(SELECT Name, Gender, DOB, ApplyDate, ApplicantID
FROM Application JOIN Applicant USING (ApplicantID)
WHERE IfAdmitted IS NULL
) temp1,
	(SELECT Name, Gender, DOB,DimDate
FROM Former JOIN Employee USING (EmployeeID)
) temp2
WHERE temp1.Name=temp2.Name 
AND temp1.Gender= temp2.Gender 
AND temp1.DOB=temp2.DOB 
AND julianday(temp1.ApplyDate)-julianday(temp2.DimDate) > 0;