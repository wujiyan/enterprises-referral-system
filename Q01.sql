SELECT Reason, num
FROM(SELECT ResignReason AS Reason, COUNT(*) AS num 
 FROM Resign
           GROUP BY Reason
 UNION
 SELECT FiredReason AS Reason, COUNT(*) AS num FROM Fired
           GROUP BY Reason)
ORDER BY num DESC
LIMIT 1;



