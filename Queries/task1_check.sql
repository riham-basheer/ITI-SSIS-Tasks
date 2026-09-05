USE [Test];
GO

-- Task 1 - Transferring Departments --
-- 1. View the transferred rows
SELECT * FROM dbo.Department;

-- 2. Compare row counts between source and destination
SELECT COUNT(*) AS [Rows_In_Test] FROM [Test].[dbo].[Department];
SELECT COUNT(*) AS [Rows_In_ITI]  FROM [ITI].[dbo].[Department];