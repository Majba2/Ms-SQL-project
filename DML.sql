-- DML Script: dml_script.sql

-- Insert Data into Tables
-- Insert data into StudentRegistration table
INSERT INTO StudentRegistration (StudentId, StudentName, Phone, Email, Gender, Passwords) VALUES
(1284775, 'Mohammed Majba Uddin', '01876238245', 'majba@gmail.com', 'Male', 'M$23#%f'),
(1284776, 'Shafayet Uddin', '01946238245', 'shafayet3@gmail.com', 'Male', 'M07^23#%f'),
(1284777, 'Habib', '01786238245', 'habibits@gmail.com', 'Male', '*hu8#%f'),
(1284778, 'Samia Akter', '01877238245', 'samia32@gmail.com', 'FeMale', 'M$23&gf'),
(1284779, 'Zerin Sultana', '01457238245', 'itszerin@gmail.com', 'FeMale', 'zer$3#%f');
GO

-- Insert data into AdmissionForm table
INSERT INTO AdmissionForm (ProgramName, AdmissionDate, Phone, [Address], FacultyId) VALUES
('BBA', '2001-03-01', '600 458 9963', '71/1, Mirpur Road, Dhanmondi, Dhaka-1215, Bangladesh', 4),
('BSc', '2001-04-01', '600 458 2963', 'Flat 3B, 123, Gulshan Avenue, Gulshan, Dhaka-1212, Bangladesh', 1),
('Masters', '2001-07-01', '600 358 9963', 'Apartment 6A, 45/1, West Rajabazar, Dhaka-1215, Bangladesh', 2),
('Hons', '2002-08-01', '600 459 9963', 'Building 20, 3rd Floor, Sector 10, Uttara, Dhaka-1230, Bangladesh', 3),
('Msc', '2003-09-01', '600 457 9963', 'Office 502, 78/1, Kazi Nazrul Islam Avenue, Dhaka-1212, Bangladesh', 2);
GO

-- Insert data into Faculty table
INSERT INTO Faculty (FacultyId, FacultyName) VALUES
(1, 'Engineering'),
(2, 'Science'),
(3, 'Commerce'),
(4, 'Arts');
GO

-- Insert data into Subjects table
INSERT INTO Subjects (SubjectId, SubjectName, FacultyId) VALUES
(1, 'CSE', 1),
(2, 'EEE', 1),
(3, 'Physics', 2),
(4, 'Management', 3),
(5, 'Humanity', 4),
(6, 'Accounting', 3),
(7, 'Bangla', 4),
(8, 'Chemistry', 2);
GO

-- Insert data into TutionFees table
INSERT INTO TutionFees (FeeId, Amount, FacultyId) VALUES
(1, 10000, 4),
(2, 8000, 2),
(3, 6000, 3),
(4, 9000, 1),
(5, 11000, 4);
GO

-- Test the Triggers

-- Test AFTER INSERT Trigger
INSERT INTO StudentRegistration (StudentId, StudentName, Phone, Email, Gender, Passwords)
VALUES (1284780, 'Abdur Rahman', '01799999999', 'abdur232@gmail.com', 'Male', '#ersfdsfgd');
GO

-- Test AFTER UPDATE Trigger
UPDATE StudentRegistration
SET StudentName = 'Habib'
WHERE StudentId = 1284775;
GO

-- Test AFTER DELETE Trigger
DELETE FROM StudentRegistration
WHERE StudentId = 1284779;
GO

-- Test Any, All, Some Keywords
IF 4 <= ANY (SELECT StudentId FROM StudentRegistration)
    PRINT 'True';
ELSE
    PRINT 'False';
GO

-- All Keyword
IF 11 <= ALL (SELECT AdmissionId FROM AdmissionForm)
    PRINT 'True';
ELSE
    PRINT 'False';
GO

-- Some Keyword
IF 4 <= SOME (SELECT FacultyId FROM Faculty)
    PRINT 'True';
ELSE
    PRINT 'False';
GO

-- Case Function Example
SELECT 
    StudentName,
    ProgramName,
    CASE 
        WHEN ProgramName IN ('BBA', 'Hons') THEN 'Undergraduate'
        WHEN ProgramName IN ('Masters', 'Msc') THEN 'Postgraduate'
        ELSE 'Other'
    END AS ProgramCategory
FROM 
    AdmissionForm AF
JOIN 
    StudentRegistration SR ON SR.StudentId = AF.AdmissionId;
GO

-- CTE Example
WITH AddmissonCte AS
(
    SELECT * 
    FROM AdmissionForm 
    WHERE ProgramName = 'BBA'
)
SELECT *
FROM AddmissonCte;
GO

-- Merge Example
SELECT 
    SR.StudentId,
    SR.StudentName,
    AF.ProgramName,
    AF.AdmissionDate,
    AF.Phone AS AdmissionPhone,
    AF.[Address] AS AdmissionAddress
FROM 
    StudentRegistration SR
FULL JOIN 
    AdmissionForm AF
ON 
    SR.StudentId = AF.AdmissionId;
GO
