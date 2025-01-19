
GO
SELECT TOP (1000)
      [Title]
      , [Article]
      , CONCAT('---', CHAR(13), CHAR(10), 'layout: usenetfun', CHAR(13), CHAR(10), 'title: ', [Title], CHAR(13), CHAR(10), '---',  CHAR(13), CHAR(10),  CHAR(13), CHAR(10),
       dbo.RemoveHTML(REPLACE([Article], '&gt;', '>')), CHAR(13), CHAR(10), '   ') as CONTENT
  FROM [dbo].[Usenetfuns]

-- Function to remove HTML tags
---
layout: usenetfun
title: Worst Name
/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000)
      [Title]
      , [Article]
      , CONCAT('---', CHAR(13), CHAR(10), 'layout: usenetfun', CHAR(13), CHAR(10), 'title: ', [Title], CHAR(13), CHAR(10), '---',  CHAR(13), CHAR(10),  CHAR(13), CHAR(10),
       dbo.RemoveHTML(REPLACE(REPLACE(LTRIM([Article]), CHAR(13) + CHAR(10), '   ' + CHAR(13) + CHAR(10)), '&gt;', '>')), CHAR(13), CHAR(10), '   ') as CONTENT
  FROM [dbo].[Usenetfuns]

-- Function to remove HTML tags
CREATE FUNCTION dbo.RemoveHTML (@HTML NVARCHAR(MAX))
RETURNS NVARCHAR(MAX)
AS
BEGIN
    DECLARE @Start INT
    DECLARE @End INT
    DECLARE @Length INT

    SET @Start = PATINDEX('%<[^>]%>', @HTML)
    WHILE @Start > 0
    BEGIN
        SET @End = PATINDEX('%>%', STUFF(@HTML, 1, @Start - 1, '')) + @Start - 1
        SET @Length = @End - @Start + 1
        SET @HTML = STUFF(@HTML, @Start, @Length, '')
        SET @Start = PATINDEX('%<[^>]%>', @HTML)
    END

    RETURN @HTML
END