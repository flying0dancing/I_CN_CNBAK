
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'RegressionTests_Prepare') AND type in (N'P', N'PC'))
DROP PROCEDURE RegressionTests_Prepare
GO

CREATE PROCEDURE RegressionTests_Prepare
	-- Add the parameters for the stored procedure here
	@procdate smalldatetime
AS
BEGIN

	SET NOCOUNT ON;
	
	DECLARE @var nvarchar(128), @sql nvarchar(max), @cnt int;
	
	SELECT REGPREFIX INTO #REGULATORS from RegulatoryInfo where object_id(REGPREFIX+'List') is not null;
	
	SELECT * FROM #REGULATORS;
	--select all MTables in all regulator.clearing locks.
	CREATE TABLE #MTables (tabname sysname);	
	DECLARE cr CURSOR FOR SELECT REGPREFIX FROM #REGULATORS;
	OPEN cr;
	FETCH NEXT FROM cr INTO @var;
	WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @sql = 'INSERT INTO #MTables SELECT TABNAME FROM '+@var+'List WHERE OBJECT_ID(TABNAME) IS NOT NULL ';
		execute sp_executesql @sql;
		
		SET @sql = 'UPDATE '+@var+'Stat SET STATUS=''Ult'' WHERE PROCESS_DATE=@procdate';
		execute sp_executesql @sql, N'@procdate smalldatetime', @procdate=@procdate;
	
		FETCH NEXT FROM cr INTO @var;
	END
	CLOSE cr;
	DEALLOCATE cr;
	--delete formlocks in formlocks tables
	DECLARE cr CURSOR FOR SELECT REGPREFIX FROM #REGULATORS;
	OPEN cr;
	FETCH NEXT FROM cr INTO @var;
	WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @sql = 'DELETE FROM '+@var+'FORMLOCKS';
		execute sp_executesql @sql;
		FETCH NEXT FROM cr INTO @var;
	END
	CLOSE cr;
	DEALLOCATE cr;
	--delete not compute MTables in #MTable
	DECLARE cr CURSOR FOR SELECT TABNAME FROM #MTables;
	OPEN cr;
	FETCH NEXT FROM cr INTO @var;
	WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @sql = 'DELETE FROM #MTables WHERE TABNAME='''+@var+''' AND (SELECT COUNT(*) FROM ['+@var+'] WHERE STBSTATUS=''A'' AND PROCESS_DATE=@procdate)=0';
		execute sp_executesql @sql, N'@procdate smalldatetime', @procdate=@procdate;
	
		FETCH NEXT FROM cr INTO @var;
	END
	CLOSE cr;
	DEALLOCATE cr;	
	
	SELECT * FROM #MTables;	
	--update Mtables's Status to M
/*
	DECLARE cr CURSOR FOR SELECT TABNAME FROM #MTables;
	OPEN cr;
	FETCH NEXT FROM cr INTO @var;
	WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @sql = 'UPDATE '+@var+' SET STBSTATUS=''M'' WHERE STBSTATUS=''A'' AND PROCESS_DATE=@procdate';
		execute sp_executesql @sql, N'@procdate smalldatetime', @procdate=@procdate;
	
		FETCH NEXT FROM cr INTO @var;
	END
	CLOSE cr;
	DEALLOCATE cr;
	*/
END