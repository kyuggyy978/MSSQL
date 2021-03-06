
/****** Object:  StoredProcedure [dbo].[HousekeepingListMoveBeginEndDaybyday]    Script Date: 2020/8/27 下午 02:56:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[HousekeepingListMoveBeginEndDaybyday] 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    --宣告變數
declare @tablecount int				--總共幾筆資料
        ,@Whiletablecount int =1	--迴圈變數逐次加1   
        , @dayadd1 int,@dayadd2 int,@daycount int
		 ,@sn smallint					--序號
        ,@DBName nvarchar(30)		--DB名稱
		,@DTable nvarchar(50)		--歷史TABLE名稱
		,@OTable nvarchar(50)		--來源TABLE名稱
		,@MoveYN nchar(1)		--是否搬移
		,@CountDateType varchar(2)  --日期種類(時間或字串)
		,@TableTheDate nvarchar(50)	--日期欄位
		,@BegMoveDate datetime2(0),@BegMoveDate1 datetime2(0)
		,@BegMoveDate2 varchar(19)
		,@BegMoveDate3 varchar(19),@BegMoveDate4 varchar(8)
		,@EndMoveDate1  datetime2(0),@EndMoveDate2 varchar(19)
		,@EndMoveDate3 varchar(19)	
		,@EndMoveDate4 varchar(8)
		,@sql1 varchar(50)             		
		
set @sql1='Waitfor Delay ''00:00:01'';'
set @tablecount =(select count(sn) from AHousekeepingList )

--開始迴圈，指定天數
while (@Whiletablecount <=@tablecount)  
	Begin 
	  select @sn=sn,@BegMoveDate1=BegMoveDate,@EndMoveDate1=EndMoveDate,@MoveYN=MoveYN  from  dbo.AHousekeepingList WHERE sn=@Whiletablecount
	  SET @dayadd1=0
	  SET @dayadd2=1
	  set @daycount=DATEDIFF(dd,@BegMoveDate1,@EndMoveDate1)+3

	    while (@dayadd1 <= @daycount)
		  BEGIN
		--TABLE值 帶入變數@
			select @sn=sn,@DBName=DBname,@DTable=DTable,@OTable=OTable,@MoveYN=MoveYN ,@TableTheDate=TableTheDate,@EndMoveDate1=EndMoveDate,@CountDateType=CountDateType from  dbo.AHousekeepingList WHERE sn=@Whiletablecount
		
			SET @BegMoveDate2= convert(varchar(19),DATEADD(dd,-@daycount,@EndMoveDate1),21);
			SET @BegMoveDate3= convert(datetime2(0),DATEADD(dd,+@dayadd1,@BegMoveDate2),21);
			SET @EndMoveDate3= convert(datetime2(0),DATEADD(dd,+@dayadd2,@BegMoveDate2),21);
		  
		--將更新搬移日期到指定資料表後,執行搬移作業
			IF @MoveYN='Y'  --指定 MoveYN 參數為Y的才進行作業
			  BEGIN
					IF @CountDateType='C1'---DateType='C1'為字串格式時間
							BEGIN
							set @BegMoveDate4=convert(varchar(8),dateadd(dd,+0,@BegMoveDate3),112)---8位元時間字串，EX.'20191231'
							set @EndMoveDate4=convert(varchar(8),dateadd(dd,+0,@EndMoveDate3),112)---8位元時間字串，EX.'20191231'
							EXEC('UPDATE '+@DBName+'.dbo.'+'AHousekeepingList'+' SET BegMoveDate='''+@BegMoveDate4+'''  WHERE sn='+@sn)
							EXEC(@sql1)
							EXEC('INSERT INTO '+@DBName+'.dbo.'+@DTable+ ' SELECT * FROM '+@DBName+'.dbo.'+@OTable+ ' With(nolock)  WHERE '+@TableTheDate+' BETWEEN '''+@BegMoveDate4+''' AND '''+@EndMoveDate4+''''+'  OPTION(MAXDOP 2) ')
							END
							
					ELSE
							 BEGIN
								 EXEC('UPDATE '+@DBName+'.dbo.'+'AHousekeepingList'+' SET BegMoveDate='''+@BegMoveDate3+'''  WHERE sn='+@sn)
								 EXEC(@sql1)
								 EXEC('INSERT INTO '+@DBName+'.dbo.'+@DTable+ ' SELECT * FROM '+@DBName+'.dbo.'+@OTable+ ' With(nolock)  WHERE '+@TableTheDate+' BETWEEN '''+@BegMoveDate3+''' AND '''+@EndMoveDate3+''''+'  OPTION(MAXDOP 2) ')
						   
							 END
					SET @dayadd1=@dayadd1+1
					SET @dayadd2=@dayadd2+1
				END
				ELSE
				BEGIN
				SET @dayadd1=@dayadd1+1
				END
		 END
		 ---執行完一張資料表完成一個大迴圈+1
		set @Whiletablecount=@Whiletablecount+1
		

	END
END

GO
