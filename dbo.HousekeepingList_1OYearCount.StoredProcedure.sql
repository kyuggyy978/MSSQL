
/****** Object:  StoredProcedure [dbo].[HousekeepingList_1OYearCount]    Script Date: 2020/8/27 下午 02:56:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[HousekeepingList_1OYearCount] @year1 smallint --輸入西元年份末兩位參數,例2019年的[19]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    --宣告變數
declare @tablecount int				--總共幾筆資料
        ,@Whiletablecount int =1	--迴圈變數逐次加1
		,@sn smallint	  --序號
        ,@DBName nvarchar(30)		--DB名稱
		,@OTable nvarchar(50)		--來源TABLE名稱
		,@DTable nvarchar(50)		--歷史TABLE名稱
		,@MoveYN char(1)		--是否計數
        ,@CountDateType char(2) --日期種類
		,@TableTheDate nvarchar(50)	--日期欄位
		,@year2 smallint 
		,@BeginDate varchar(19) --計數開始日期
		,@EndDate varchar(19) --計數結束日期
		,@BeginDate2 varchar(8) --計數開始日期
		,@EndDate2 varchar(8) --計數結束日期
		,@sql1 varchar(50) 
set @year2=@year1+1
set @sql1='Waitfor Delay ''00:00:01'';'

SET @BeginDate= convert(varchar(19),DATEADD(yy,+@year1,'00-01-01 00:00:00'),21);
SET @EndDate= convert(varchar(19),DATEADD(yy,+@year2,'00-01-01 00:00:00'),21);
SET @BeginDate2= convert(varchar(19),DATEADD(yy,+@year1,'00-01-01 00:00:00'),112);
SET @EndDate2= convert(varchar(19),DATEADD(yy,+@year2,'00-01-01 00:00:00'),112);
		--count筆數  決定迴圈執行次數
set @tablecount =(select count(sn)from  dbo.AHousekeepingList )

--開始迴圈，依序帶入每筆資料
while @Whiletablecount <=@tablecount 
Begin
--TABLE值 帶入變數@
select @sn=sn,@DBName=DBName,@OTable=OTable,@MoveYN=MoveYN,@TableTheDate=TableTheDate,@CountDateType=CountDateType from AHousekeepingList where sn=@Whiletablecount
--指定 @MoveYN 參數為Y的才進行計數作業
     IF (@MoveYN = 'Y')
	   BEGIN
		If  @CountDateType='C1'
			Begin
			--select year rows count
			EXEC('UPDATE '+@DBName+'.dbo.'+'AHousekeepingList'+' SET OYearCount=(select COUNT(1) From '
			+@DBName+'.dbo.'+@OTable +' With(nolock) WHERE '+@TableTheDate
			+' >= '''+@BeginDate2+''' AND '+@TableTheDate+' < '''+@EndDate2+''')  WHERE sn='+@sn+' OPTION(MAXDOP 1) ')
			EXEC (@sql1)
			END
         ELSE
		    BEGIN
			EXEC('UPDATE '+@DBName+'.dbo.'+'AHousekeepingList'+' SET OYearCount=(select COUNT('+@TableTheDate+') From '
			+@DBName+'.dbo.'+@OTable +' With(nolock) WHERE '+@TableTheDate
			+' >= '''+@BeginDate+''' AND '+@TableTheDate+' < '''+@EndDate+''')  WHERE sn='+@sn+' OPTION(MAXDOP 1) ')
			EXEC (@sql1)
			END 
			
		END
--迴圈變數逐次加1
set @Whiletablecount=@Whiletablecount+1
End
END
GO
