
/****** Object:  StoredProcedure [dbo].[HousekeepingList_3CheckIsReadyYN]    Script Date: 2020/8/27 下午 02:56:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[HousekeepingList_3CheckIsReadyYN] 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    --宣告變數
declare @tablecount int				--總共幾筆資料
        ,@Whiletablecount int =1	--迴圈變數逐次加1
		,@sn smallint	            --流水序號
        ,@DBName nvarchar(30)		--DB名稱
		,@OYearCount int            --來源表年度計算    
		,@HYearCount int            --歷史表年度計算
		,@OTable nvarchar(50)		--來源TABLE名稱
		,@DTable nvarchar(50)		--歷史TABLE名稱
		,@IsReadyYN nchar(2)        --確認是否可刪除來源表
		--count筆數  決定迴圈執行次數
set @tablecount =(select count(sn)from  dbo.AHousekeepingList )

--開始迴圈，依序帶入每筆資料
while @Whiletablecount <=@tablecount 
Begin
--TABLE值 帶入變數@
select @sn=sn,@OYearCount=OYearCount,@HYearCount=HYearCount from AHousekeepingList where sn=@Whiletablecount
--指定 CountYN 參數為Y的才進行計數作業

If (@OYearCount = @HYearCount )
		Begin
		--select year rows count
		EXEC('UPDATE '+@DBName+'.dbo.'+'AHousekeepingList'+' SET IsReadyYN='+'''Y'''+'  WHERE sn='+@sn+' OPTION(MAXDOP 1) ')

		END
		ELSE 
		Begin
		EXEC('UPDATE '+@DBName+'.dbo.'+'AHousekeepingList'+' SET IsReadyYN='+'''N'''+'  WHERE sn='+@sn+' OPTION(MAXDOP 1) ')
		END
--迴圈變數逐次加1
set @Whiletablecount=@Whiletablecount+1
End
END
GO
