CREATE DATABASE Event

USE Event

CREATE TABLE Cities
(
	Id INT PRIMARY KEY IDENTITY,
	Name NVARCHAR(30) CONSTRAINT UNQ_Cities_Name UNIQUE(Name)

SELECT * FROM Cities

CREATE TABLE Events 
(
	Id INT PRIMARY KEY IDENTITY,
	Name NVARCHAR(30) NOT NULL,
	CityId INT FOREIGN KEY REFERENCES Cities(Id),
	StartDate DATETIME2 NOT NULL,
	EndDate DATETIME2 NOT NULL
)

SELECT * FROM Events

CREATE TABLE Speakers
(
	Id INT PRIMARY KEY IDENTITY,
	Fullname NVARCHAR(30) NOT NULL
)

SELECT * FROM Speakers

CREATE TABLE EventSpeakers
(
	Id INT PRIMARY KEY IDENTITY,
	SpeakerId INT FOREIGN KEY REFERENCES Speakers(Id),
	EventId INT FOREIGN KEY REFERENCES Events(Id)
)

SELECT * FROM EventSpeakers

INSERT INTO EventSpeakers
VALUES
(1,1),
(2,3),
(3,2),
(4,5),
(5,4),
(6,6),
(7,7)


SELECT *,(SELECT DATEDIFF(MINUTE,StartDate,EndDate)) AS 'Strat Time',
(SELECT COUNT(Id)From EventSpeakers WHERE EventId=E.Id) AS 'SpeakersCount'FROM Events AS E
JOIN Cities ON E.CityId=Cities.Id


CREATE PROCEDURE USP_CreateCity @City NVARCHAR(30)
AS
INSERT INTO Cities
VALUES
(@City)

CREATE VIEW EventsData
AS
(SELECT E.Name AS 'Event Name ',E.StartDate ,E.EndDate, Cities.Name AS 'City Name',
(SELECT COUNT(Id) FROM EventSpeakers WHERE EventId=E.Id )AS 'SpeakersCount' FROM Events AS E
JOIN Cities ON E.CityId=Cities.Id
WHERE YEAR(StartDate)=YEAR(DATEADD(YEAR,0,GETDATE())))

CREATE PROCEDURE USP_SelectEvent @StartDate DATETIME2, @EndDate DATETIME2
AS
SELECT * FROM Events WHERE StartDate = @StartDate AND EndDate = @EndDate