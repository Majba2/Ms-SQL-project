-- DDL Script: ddl_script.sql

/*
Name=Mohammed Majba Uddin
BatchId=1284931
Email=majba13529@gmail.com
ProjectName=UniversityAdmissionManagementSystem
*/

-- Drop Database
DROP DATABASE IF EXISTS UAMS;
GO

-- Create Database
CREATE DATABASE UAMS
ON PRIMARY
(
    NAME = 'UniversityAdmissionManagementSystem_Data',
    FILENAME = 'E:\New folder\Sql Project\UAMS\data.mdf',
    SIZE = 25MB,
    MAXSIZE = 150MB,
    FILEGROWTH = 5%
)
LOG ON
(
    NAME = 'UniversityAdmissionManagementSystem_Log',
    FILENAME = 'E:\New folder\Sql Project\UAMS\log.ldf',
    SIZE = 10MB,
    MAXSIZE = 75MB,
    FILEGROWTH = 2MB
);
GO

-- Use Database
USE UAMS;
GO

-- Create Tables
CREATE TABLE StudentRegistration (
    StudentId INT PRIMARY KEY,
    StudentName VARCHAR(100) NOT NULL,
    Phone VARCHAR(15),
    Email VARCHAR(100),
    Gender CHAR(6) CHECK (Gender IN ('Male', 'FeMale')) NOT NULL,
    Passwords VARCHAR(50)
);
GO

CREATE TABLE Faculty (
    FacultyId INT PRIMARY KEY,
    FacultyName VARCHAR(100) NOT NULL
);
GO

CREATE TABLE Subjects (
    SubjectId INT PRIMARY KEY,
    SubjectName VARCHAR(100),
    FacultyId INT FOREIGN KEY REFERENCES Faculty(FacultyId)
);
GO

CREATE TABLE AdmissionForm (
    AdmissionId INT IDENTITY(1,1) PRIMARY KEY,
    ProgramName VARCHAR(100),
    AdmissionDate DATE,
    Phone VARCHAR(15),
    [Address] VARCHAR(255),
    FacultyId INT FOREIGN KEY REFERENCES Faculty(FacultyId)
);
GO

CREATE TABLE TutionFees (
    FeeId INT PRIMARY KEY,
    Amount DECIMAL(10,2),
    FacultyId INT FOREIGN KEY REFERENCES Faculty(FacultyId)
);
GO

-- Create Functions
CREATE FUNCTION F_GetStudentsByGender (@Gender VARCHAR(10))
RETURNS TABLE
AS
RETURN
(
    SELECT * 
    FROM StudentRegistration 
    WHERE Gender = @Gender
);
GO

CREATE FUNCTION F_GetTutionFees (@FacultyId INT)
RETURNS TABLE
AS
RETURN
(
    SELECT FeeId, Amount, FacultyId
    FROM TutionFees
    WHERE FacultyId = @FacultyId
);
GO

-- Create Procedures
CREATE PROCEDURE Sp_SubjectsUpdate(
    @SubjectId INT,
    @SubjectName VARCHAR(20),
    @StatementType VARCHAR(20) = ''
)
AS 
BEGIN
    IF @StatementType = 'Update'
    BEGIN
        UPDATE Subjects
        SET SubjectName = @SubjectName
        WHERE SubjectId = @SubjectId;
    END
END
GO

CREATE PROCEDURE Sp_SubjectsDelete(
    @SubjectId INT,
    @StatementType VARCHAR(20) = ''
)
AS 
BEGIN
    IF @StatementType = 'Delete'
    BEGIN
        DELETE FROM Subjects
        WHERE SubjectId = @SubjectId;
    END
END
GO

-- Create Views
CREATE VIEW V_Faculty
AS
SELECT FacultyId, FacultyName
FROM Faculty;
GO

CREATE VIEW V_AdmissonForm 
WITH ENCRYPTION, SCHEMABINDING
AS
SELECT AdmissionId, ProgramName, AdmissionDate
FROM AdmissionForm;
GO

CREATE VIEW V_Student
AS
SELECT StudentId, StudentName, Email, Gender, Passwords
FROM StudentRegistration
WHERE Gender = 'Male'
WITH CHECK OPTION;
GO

-- Create Triggers
CREATE TABLE Student_Extra (
    ExtraId INT,
    Ex_Description VARCHAR(30)
);
GO

CREATE TRIGGER Tr_StudentRegistration
ON StudentRegistration
INSTEAD OF DELETE
AS 
BEGIN
    DECLARE @StudentId INT;
    SELECT @StudentId = Deleted.StudentId
    FROM Deleted;
    
    IF @StudentId = 1284778
    BEGIN
        RAISERROR('Can Not Delete', 16, 1);
        ROLLBACK;
        INSERT INTO Student_Extra VALUES (@StudentId, 'Invalid');
    END
    ELSE
    BEGIN
        DELETE FROM StudentRegistration
        WHERE StudentId = @StudentId;
        INSERT INTO Student_Extra VALUES (@StudentId, 'Deleted');
    END
END
GO

CREATE TRIGGER trg_AfterStudentInsert
ON StudentRegistration
AFTER INSERT
AS
BEGIN
    INSERT INTO StudentChangeLog (StudentId, StudentName, ActionType)
    SELECT StudentId, StudentName, 'INSERT'
    FROM inserted;
END
GO

CREATE TRIGGER Tr_AfterStudentUpdate
ON StudentRegistration
AFTER UPDATE
AS
BEGIN
    INSERT INTO StudentChangeLog (StudentId, StudentName, ActionType)
    SELECT StudentId, StudentName, 'UPDATE'
    FROM inserted;
END
GO

CREATE TRIGGER trg_AfterStudentDelete
ON StudentRegistration
AFTER DELETE
AS
BEGIN
    INSERT INTO StudentChangeLog (StudentId, StudentName, ActionType)
    SELECT StudentId, StudentName, 'DELETE'
    FROM deleted;
END
GO

-- Cube, RollUp, Grouping Sets
-- Note: These examples use GROUP BY operators

-- Cube Operator
SELECT 
    FacultyId, 
    SUM(Amount) AS TotalAmount
FROM 
    TutionFees
GROUP BY 
    CUBE(FacultyId);
GO

-- RollUp Operator
SELECT 
    FacultyId, 
    SUM(Amount) AS TotalAmount
FROM 
    TutionFees
GROUP BY 
    ROLLUP(FacultyId);
GO

-- Grouping Sets Operator
SELECT 
    FacultyId, 
    SUM(Amount) AS TotalAmount
FROM 
    TutionFees
GROUP BY 
    GROUPING SETS (
        (FacultyId),
        (Amount)
    );
GO

-- OVER Clause
SELECT 
    FacultyId,
    Amount,
    SUM(Amount) OVER (PARTITION BY FacultyId ORDER BY Amount) AS RunningTotal
FROM 
    TutionFees;
GO
