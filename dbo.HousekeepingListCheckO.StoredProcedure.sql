
/****** Object:  StoredProcedure [dbo].[HousekeepingListCheckO]    Script Date: 2020/8/27 下午 02:56:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:APES Mike 於移民署開發
-- Create date: 20181214
-- Description:	
-- 客戶需求:
-- 建立指定TABLE(HousekeepingList)，依照TABLE中指定名稱及日期，做資料搬移後刪除

-- 程式執行邏輯:
-- 1.將TABLE數值 帶入變數
-- 2.將變數組成動態SQL 
-- 3.Clear 參數為Y的，執行匯出指定日期以前的資料 並刪除
-- =============================================
CREATE PROCEDURE [dbo].[HousekeepingListCheckO]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	

--宣告變數
declare @tablecount int				--總共幾筆資料
        ,@Whiletablecount int =1	--迴圈變數逐次加1
		,@sn int					--序號
        ,@DBName nvarchar(30)		--DB名稱
		,@DTable nvarchar(50)		--歷史TABLE名稱
		,@OTable nvarchar(50)		--來源TABLE名稱
		,@CountYN nchar(1)		--是否刪除
		,@TableTheDate nvarchar(50)	--日期欄位
		,@EndDelDate nvarchar(19)		--多久以前的日期刪除資料
		,@sql1 nvarchar(30)

--count筆數  決定迴圈執行次數
set @tablecount =(select count(sn)from AHousekeepingList )
set @sql1='Waitfor Delay ''00:00:01'';'

--開始迴圈，依序帶入每筆資料
while @Whiletablecount <=@tablecount 
Begin
--TABLE值 帶入變數@
select @sn=sn,@DBName=DBname,@OTable=OTable,@CountYN=CountYN,@TableTheDate=TableTheDate,@EndDelDate=EndDelDate from AHousekeepingList where sn=@Whiletablecount
--指定 CountYN 參數為Y的才進行作業

If @CountYN = 'Y'
Begin

			EXEC('UPDATE '+@DBName+'.dbo.'+'AHousekeepingList SET ReadyDelRows=(Select count(*) From '+@DBName+'.dbo.'+@OTable+' WITH(NOLOCK) Where '+@TableTheDate+' < '''+@EndDelDate+''') Where sn='+@Whiletablecount)
			EXEC(@sql1)
			--本次要異動的資料筆數
			EXEC ('Select ReadyDelRows AS '''+@OTable+'預備刪除筆數總計'+''' FROM  AHousekeepingList Where sn='+@Whiletablecount)

END

--迴圈變數逐次加1
set @Whiletablecount=@Whiletablecount+1
End
	END

GO
