/*11.Show the applicant who has already been admitted by the company but haven"t give any response*/
/*Author: LU YIN  Reviewer: Long Wan, Jiayi Yu*/
SELECT Ap. ApplicantID, Ap.name
FROM Application A, Applicant Ap
WHERE Ap.applicantID=A.applicantID AND A.IfAdmitted="TRUE" AND Acceptance IS NULL;
