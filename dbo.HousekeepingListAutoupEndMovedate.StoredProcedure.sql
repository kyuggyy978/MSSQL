
/****** Object:  StoredProcedure [dbo].[HousekeepingListAutoupEndMovedate]    Script Date: 2020/8/27 下午 02:56:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[HousekeepingListAutoupEndMovedate]
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
			,@MoveYN nchar(1)		--是否搬移
			,@CountDateType varchar(2)  --日期類型(時間或字串;'N'為時間;'C1'為8位字串)
			,@EndMoveDate  varchar(19)		--多久以前的日期搬移資料
			,@EndMoveDate1 varchar(8)		--多久以前的日期搬移資料
			,@atime varchar(10)
	--count筆數  決定迴圈執行次數
	set @tablecount =(select count(sn)from AHousekeepingList )

	set @atime=' 00:00:00'
	--開始迴圈，依序帶入每筆資料
	while @Whiletablecount <=@tablecount 
		Begin
			select @sn=sn,@DBName=DBname,@MoveYN=MoveYN,@CountDateType=CountDateType from AHousekeepingList where sn=@Whiletablecount
			set @EndMoveDate=(convert(varchar(10),DATEADD(YY,-1,GETDATE()),21)+@atime)
		--指定 MoveYN參數為Y的才更新搬移日期
			If @MoveYN = 'Y'
			    BEGIN
			    IF @CountDateType='C1'---DateType='C1'為字串格式時間
				   BEGIN
					set @EndMoveDate1=convert(varchar(8),DATEADD(DD,+0,@EndMoveDate),112)---8位元時間字串，EX.'20191231'
					EXEC('UPDATE '+@DBName+'.dbo.'+'AHousekeepingList'+' SET EndMoveDate='''+@EndMoveDate1+'''  WHERE sn='+@sn)
					END
				ELSE
					Begin
					EXEC('UPDATE '+@DBName+'.dbo.'+'AHousekeepingList'+' SET EndMoveDate='''+@EndMoveDate+'''  WHERE sn='+@sn)
					END
				END
		--迴圈變數逐次加1
		set @Whiletablecount=@Whiletablecount+1
		End
END
GO
