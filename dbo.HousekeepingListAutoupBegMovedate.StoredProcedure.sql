
/****** Object:  StoredProcedure [dbo].[HousekeepingListAutoupBegMovedate]    Script Date: 2020/8/27 下午 02:56:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[HousekeepingListAutoupBegMovedate]
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
			,@OTable nvarchar(50)		--來源TABLE名稱
			,@MoveYN nchar(1)		--是否搬移
			,@TableTheDate nvarchar(50)	--日期欄位
			,@sql1 nvarchar(30)

	--count筆數  決定迴圈執行次數
	set @tablecount =(select count(sn)from AHousekeepingList )
	set @sql1='Waitfor Delay ''00:00:01'';'

	--開始迴圈，依序帶入每筆資料
	while @Whiletablecount <=@tablecount 
		Begin
			select @sn=sn,@DBName=DBName,@MoveYN=MoveYN,@OTable=OTable,@TableTheDate=TableTheDate from AHousekeepingList where sn=@Whiletablecount
		--指定 MoveYN參數為Y的才更新搬移日期
			If @MoveYN = 'Y'
			    BEGIN

				EXEC('UPDATE '+@DBName+'.dbo.'+'AHousekeepingList SET BegMoveDate=(Select TOP 1 ('+@TableTheDate+') From '+@DBName+'.dbo.'+@OTable+' WITH(NOLOCK) ORDER BY '+@TableTheDate+') Where sn='+@Whiletablecount)
				EXEC(@sql1)
				
				END
             ELSE
			   BEGIN
			    SELECT @Whiletablecount ;
			   END

		--迴圈變數逐次加1
		set @Whiletablecount=@Whiletablecount+1
		End
END
GO
