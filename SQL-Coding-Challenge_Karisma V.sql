-- Database Creation:
create database crimemanagementdb;

use crimemanagementdb;

-- Create tables

-- Creating table Crime

CREATE TABLE Crime (
CrimeID INT PRIMARY KEY,
IncidentType VARCHAR(255),
IncidentDate DATE,
Location VARCHAR(255),
Description TEXT,
Status VARCHAR(20)
); 

-- Creating table Victim

CREATE TABLE Victim (
VictimID INT PRIMARY KEY,
CrimeID INT,
Name VARCHAR(255),
ContactInfo VARCHAR(255),
Injuries VARCHAR(255),
FOREIGN KEY (CrimeID) REFERENCES Crime(CrimeID)
); 

-- Creating table Suspect

CREATE TABLE Suspect (
SuspectID INT PRIMARY KEY,
CrimeID INT,
Name VARCHAR(255),
Description TEXT,
CriminalHistory TEXT,
FOREIGN KEY (CrimeID) REFERENCES Crime(CrimeID)
); 
 
-- Insert sample data 

--Inserting datas into Crime table
 
INSERT INTO Crime (CrimeID, IncidentType, IncidentDate, Location, Description, Status)
VALUES
(1, 'Robbery', '2023-09-15', '123 Main St, Cityville', 'Armed robbery at a convenience store', 'Open'),
(2, 'Homicide', '2023-09-20', '456 Elm St, Townsville', 'Investigation into a murder case', 'Under Investigation'),
(3, 'Theft', '2023-09-10', '789 Oak St, Villagetown', 'Shoplifting incident at a mall', 'Closed'); 
 
 --Inserting datas into Victim table

INSERT INTO Victim (VictimID, CrimeID, Name, ContactInfo, Injuries,Age)
VALUES
(1, 1, 'John Doe', 'johndoe@example.com', 'Minor injuries'),
(2, 2, 'Jane Smith', 'janesmith@example.com', 'Deceased'),
(3, 3, 'Alice Johnson', 'alicejohnson@example.com', 'None'); 

--Inserting datas into Suspect table

INSERT INTO Suspect (SuspectID, CrimeID, Name, Description, CriminalHistory,Age)
VALUES
(1, 1, 'Robber 1', 'Armed and masked robber', 'Previous robbery convictions'),
(2, 2, 'Unknown', 'Investigation ongoing', NULL),
(3, 3, 'Suspect 1', 'Shoplifting suspect', 'Prior shoplifting arrests');

select*from Crime;
select*from Victim;
select*from Suspect;

-- 1. Select all open incidents

SELECT * FROM Crime
WHERE Status = 'Open';

-- 2. Find the total number of incidents

SELECT COUNT(*) AS TotalIncidents FROM Crime;

-- 3. List all unique incident types

SELECT DISTINCT IncidentType FROM Crime;

-- 4. Retrieve incidents that occurred between '2023-09-01' and '2023-09-10'

SELECT * FROM Crime
WHERE IncidentDate BETWEEN '2023-09-01' AND '2023-09-10';

-- 5. List persons involved in incidents in descending order of age

SELECT Name, Age FROM Victim
UNION
SELECT Name, Age FROM Suspect
ORDER BY Age DESC;

-- 6. Find the average age of persons involved in incidents
SELECT AVG(Age) AS AverageAge FROM (
  SELECT Age FROM Victim
  UNION
  SELECT Age FROM Suspect
) AS Persons;

-- 7. List incident types and their counts,only for open cases:
SELECT IncidentType, COUNT(*) AS IncidentCount
FROM Crime
WHERE Status = 'Open'
GROUP BY IncidentType;

-- 8. Find persons with names containing 'Doe':
SELECT Name FROM Victim WHERE Name LIKE '%Doe%';

-- 9. Retrieve the names of persons involved in open cases and closed cases:
SELECT v.Name
FROM Victim v
JOIN Crime c ON v.CrimeID = c.CrimeID
WHERE c.Status IN ('Open', 'Closed');

--10. List incident types where there are persons aged 30 or 35 involved:
SELECT DISTINCT c.IncidentType
FROM Crime c
JOIN Victim v ON c.CrimeID = v.CrimeID
WHERE v.Age IN (30, 35);

--11. Find persons involved in incidents of the same type as 'Robbery':
SELECT v.Name
FROM Victim v
JOIN Crime c ON v.CrimeID = c.CrimeID
WHERE c.IncidentType = 'Robbery';

--12. List incident types with more than one open case:
SELECT IncidentType, COUNT(*) AS OpenCount
FROM Crime
WHERE Status = 'Open'
GROUP BY IncidentType
HAVING COUNT(*) > 1;

--13. List all incidents with suspects whose names also appear as victims in other incidents:
SELECT c.CrimeID, c.IncidentType, s.Name AS SuspectName
FROM Suspect s
JOIN Crime c ON s.CrimeID = c.CrimeID
WHERE s.Name IN (SELECT Name FROM Victim);

--14. Retrieve all incidents along with victim and suspect details:
SELECT c.*, v.Name AS VictimName, s.Name AS SuspectName
FROM Crime c
LEFT JOIN Victim v ON c.CrimeID = v.CrimeID
LEFT JOIN Suspect s ON c.CrimeID = s.CrimeID;

--15. Find incidents where the suspect is older than any victim:
SELECT c.CrimeID, s.Name AS SuspectName
FROM Suspect s
JOIN Crime c ON s.CrimeID = c.CrimeID
WHERE s.Age > (SELECT MAX(v.Age) FROM Victim v WHERE v.CrimeID = c.CrimeID);

--16. Find suspects involved in multiple incidents:
SELECT Name, COUNT(DISTINCT CrimeID) AS IncidentCount
FROM Suspect
GROUP BY Name
HAVING COUNT(DISTINCT CrimeID) > 1;

--17. List incidents with no suspects involved:
SELECT c.CrimeID, c.IncidentType, c.Status
FROM Crime c
LEFT JOIN Suspect s ON c.CrimeID = s.CrimeID
WHERE s.SuspectID IS NULL;

--18. List all cases where at least one incident is of type 'Homicide' and all other incidents are of type 'Robbery':
SELECT c.*
FROM Crime c
WHERE EXISTS (SELECT 1 FROM Crime WHERE IncidentType = 'Homicide')
AND NOT EXISTS (SELECT 1 FROM Crime WHERE IncidentType NOT IN ('Homicide', 'Robbery'));

--19. Retrieve a list of all incidents and the associated suspects, showing suspects for each incident, or 'No Suspect' if there are none:
SELECT c.CrimeID, c.IncidentType, COALESCE(s.Name, 'No Suspect') AS SuspectName
FROM Crime c
LEFT JOIN Suspect s ON c.CrimeID = s.CrimeID;

--20. List all suspects who have been involved in incidents with incident types 'Robbery' or 'Assault':
SELECT s.Name
FROM Suspect s
JOIN Crime c ON s.CrimeID = c.CrimeID
WHERE c.IncidentType IN ('Robbery', 'Assault');

--- There is no column name for age in the victim and suspect tables but there was a questions regarding age hence we are altering and updating the victim and suspect tables:
---- For Victims:
ALTER TABLE Victim
ADD Age INT;

UPDATE Victim 
SET Age= CASE 
             WHEN VictimID=1 THEN 33
			 WHEN VictimID=2 THEN 30
			 WHEN VictimID=3 THEN 29
		 END
WHERE VictimID In (1,2,3);
SELECT* FROM Victim;

-- For Suspects:
ALTER TABLE Suspect
ADD Age INT;

UPDATE Suspect 
SET Age= CASE 
             WHEN SuspectID=1 THEN 25
			 WHEN SuspectID=2 THEN 45
			 WHEN SuspectID=3 THEN 34
		 END
WHERE SuspectID In (1,2,3);
SELECT*FROM Suspect;