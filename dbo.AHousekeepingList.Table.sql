
/****** Object:  Table [dbo].[AHousekeepingList]    Script Date: 2020/8/27 上午 11:40:24 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE DATABASE HOTELHOUSEKEEPING
GO

CREATE TABLE [dbo].[AHousekeepingList](
	[sn] [smallint] NOT NULL,
	[DBName] [nvarchar](30) NOT NULL,
	[OTable] [nvarchar](50) NOT NULL,
	[DTable] [nvarchar](50) NULL,
	[MoveYN] [nchar](1) NULL,
	[CountYN] [nchar](1) NULL,
	[IsReadyYN] [nchar](1) NULL,
	[CountDateType] [varchar](2) NULL,
	[TableTheDate] [nvarchar](50) NULL,
	[BegMoveDate] [varchar](19) NULL,
	[EndMoveDate] [varchar](19) NULL,
	[EndDelDate] [varchar](19) NULL,
	[RowCT] [int] NULL,
	[ReadyDelRows] [int] NULL,
	[OYearCount] [int] NULL,
	[HYearCount] [int] NULL,
	[Remarks] [nvarchar](150) NULL,
 CONSTRAINT [AHousekeepingList_2$snPK] PRIMARY KEY CLUSTERED 
(
	[sn] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = ON, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]   --檔案群組預設為[PRIMARY]
GO


