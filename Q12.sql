SELECT (CAST(temp2.num2 AS DOUBLE)/CAST(temp1.num1 AS DOUBLE)) AS FemaleRatioByMale, temp1.BranchID
FROM (SELECT COUNT(*) AS num1, p.BranchID
FROM (Employee NATURAL JOIN EmploymentHistory) p, Referral r, Application app, Applicant apl
WHERE p.EmployeeID = r.EmployeeID AND r.ApplicationID = app.ApplicationID
AND app.ApplicantID = apl.ApplicantID
AND p.Gender = "M" AND p.EndDate IS NULL
GROUP BY p.BranchID) temp1,
(SELECT COUNT(*) AS num2, p.BranchID
FROM (Employee NATURAL JOIN EmploymentHistory) p, Referral r, Application app, Applicant apl
WHERE p.EmployeeID = r.EmployeeID AND r.ApplicationID = app.ApplicationID
AND app.ApplicantID = apl.ApplicantID 
AND p.Gender = "M" AND apl.Gender = "F" 
AND p.EndDate IS NULL
GROUP BY p.BranchID) temp2
WHERE temp1.BranchID = temp2.BranchID