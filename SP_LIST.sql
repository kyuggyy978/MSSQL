----預存程序參數表[dbo].[AHousekeepingList]
----[sn] -自編流水序號
----[DBName] --資料庫名稱    ##要給值
----[OTable] --線上來源表    ##要給值   
----[DTable] --目的歷史表    ##要給值
----[MoveYN] --是否搬移,Y為搬移,N為不搬移     ##要給值
----[CountYN] --計算預備搬移或刪除列數,Y為確認計算
----[IsReadyYN] --使用sp [HousekeepingList_3CheckIsReadyYN]來更新此欄，此欄參數供刪除來源表sp確認是否執行刪除,Y為來源表以可刪除,N為列數不同，不刪除
----[CountDateType] --時間欄位資料型態種類,C1表示時間欄位為字串資料型態,N表示時間欄位為datetime資料型態，為正式時間表示法      ##要給值
----[TableTheDate] --資料表時間欄位之名稱   ##要給值
----[BegMoveDate] --搬移起始時間，第一次需自行輸入或設定     ##要給值 格式2020-01-01 00:00:00
----[EndMoveDate] --sp可更新結束日期，可依需求變更預備搬移之結束日期
----[EndDelDate] --歷史資料搬移完成，每年自行輸入預備刪除日期(每年01-01 00:00:00)以前資料
----[RowCT] --設定每張資料表，執行每次刪除時之列數，依資料表使用頻率，大小考量，避免刪除時鎖定時間過長    ##要給值    
----[ReadyDelRows] --使用sp HousekeepingListCheckO後會更新此欄，確認預備刪除列數，且刪除資料sp HousekeepingListDeleteTopRow需使用此欄為參數
----[OYearCount]  --使用sp [dbo].[HousekeepingList_1OYearCount] @year1=18 更新此欄，此欄表示輸入年度之來源表列數
----[HYearCount]  --使用sp [dbo].[HousekeepingList_2HYearCount] @year1=18 更新此欄，此欄表示輸入年度之歷史表列數
----[Remarks]  --依情況自行輸入[備註]

-----預存程序
EXEC  [dbo].[HousekeepingListAutoupBegMovedate] ; ---更新開始搬移日期[BegMoveDate]:第一次搬移時才需使用，更新[BegMoveDate]-搬移開始日期，依資料表起始日期 
EXEC  [dbo].[HousekeepingListAutoupEndMovedate];  ---更新結束搬移日期[EndMoveDate]:移結束日期,預設去年同一日(依情況調整)

EXEC [dbo].[HousekeepingListMoveBeginEndDaybyday]; --【主要搬移預存程序】:[BegMoveDate]開始日期,[EndMoveDate]結束日期;

---------
EXEC [dbo].[HousekeepingList_1OYearCount] @year1=18 ; --計算來源表年度筆數:計算2018年來源表列數

EXEC [dbo].[HousekeepingList_2HYearCount] @year1=18 ; --計算歷史表年度筆數:計算2018年歷史表列數

EXEC [dbo].[HousekeepingList_3CheckIsReadyYN] ; --確認資料搬移是否遺漏:Y表示來源表[OTable]與歷史表[DTable]計算年度列數相同，來源表2018年度已準備好可以刪除;N表示資料搬移有遺漏，需再搬移一次
---------
EXEC [dbo].[HousekeepingListCheckO]; ---確認預備刪除列數:計算日期小於[EndDelDate]

EXEC [dbo].[HousekeepingListDeleteTopRow]; ---刪除來源表:以欄位[IsReadyYN]='Y'時，刪除小於[EndDelDate]日期之來源表[OTable]，每次刪除[RowCT]欄位所設定列數
