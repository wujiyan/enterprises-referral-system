/* 6. Find employees that all candidates they referred are hired. */
/*Author: Jiayi Yu  Reviewer: Long Wan, Lu Yin*/
SELECT Temp1.EmployeeID
FROM (
(SELECT R.EmployeeID, COUNT (DISTINCT Ap.ApplicantID) AS referralNum
FROM Referral R, Application A, Applicant Ap
WHERE R.ApplicationID=A.ApplicationID 
   AND Ap.ApplicantID=A.ApplicantID
GROUP BY R.EmployeeID) Temp1,
(SELECT R.EmployeeID, COUNT (DISTINCT Ap.ApplicantID) AS hiredNum
FROM Referral R, Application A, Applicant Ap
WHERE R.ApplicationID=A.ApplicationID 
  AND AP.ApplicantID=A.ApplicantID 
  AND A.Acceptance="TRUE"
GROUP BY R.EmployeeID) Temp2
)
WHERE Temp1.EmployeeID=Temp2.EmployeeID 
AND referralNum = hiredNum
