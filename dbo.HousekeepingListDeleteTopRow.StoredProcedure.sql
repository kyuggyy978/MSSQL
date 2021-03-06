
/****** Object:  StoredProcedure [dbo].[HousekeepingListDeleteTopRow]    Script Date: 2020/8/27 下午 02:56:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- 程式執行邏輯:
-- 1.將TABLE數值 帶入變數
-- 2.將變數組成動態SQL 
-- 3.Clear 參數為Y的，執行匯出指定日期以前的資料 並刪除
-- =============================================
CREATE PROCEDURE [dbo].[HousekeepingListDeleteTopRow]
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
		,@IsReadyYN char(1)		--是否刪除
		,@TableTheDate nvarchar(50)	--日期欄位
		,@EndDelDate varchar(19)		--多久以前的日期刪除資料
		,@sql1 varchar(50)          --waitfor delay
		
		--,@BegDelDate varchar(19)
		,@RowCT int  ---ROWCOUNT 刪除筆數
	    , @delrwct int --計算刪除筆數
		,@ReadyDelRows int --預備刪除筆數
		
--count筆數  決定迴圈執行次數
set @tablecount =(select count(sn)from  dbo.AHousekeepingList )
set @sql1=' Waitfor Delay ''00:00:03''; '

--開始迴圈，依序帶入每筆資料
while @Whiletablecount <= @tablecount 
 Begin
--TABLE值 帶入變數@
	select @sn=sn,@DBName=DBName,@OTable=OTable,@IsReadyYN=IsReadyYN,@TableTheDate=TableTheDate,@EndDelDate=EndDelDate,@RowCT=RowCT from  dbo.AHousekeepingList where sn=@Whiletablecount
		
--指定 IsReadyYN 參數為Y的才進行Housekeeping作業
		If @IsReadyYN = 'Y'
		   Begin
		        --帶入需要刪除的列數
				Select @sn=sn,@ReadyDelRows=ReadyDelRows From   dbo.AHousekeepingList where sn=@Whiletablecount
                
				--計算需要執行次數
				SET @delrwct=@ReadyDelRows/@RowCT+1
				WHILE @delrwct>0
				BEGIN
		   	   	   Select @sn=sn,@IsReadyYN=IsReadyYN From   dbo.AHousekeepingList where sn=@Whiletablecount
				   If @IsReadyYN = 'Y'---每次刪除前確認是否刪除，可配合設定停止排程
				   BEGIN
				   ---使用delete top() 刪除
				   EXEC(@sql1)
				   EXEC(' Delete TOP('+@RowCT+') FROM '+@DBName+'.dbo.'+ @OTable + '  With(TABLOCK) WHERE '+ @TableTheDate +' < '''+ @EndDelDate +''''+'  OPTION(MAXDOP 2) ' )
				    
				   ---執行迴圈次數逐次-1
				   END
				   SET @delrwct=@delrwct-1
		         END

		    END
			   ELSE 
				BEGIN
				SELECT @Whiletablecount
				END
 
--迴圈變數逐次加1
	set @Whiletablecount=@Whiletablecount+1
 End
END


GO
