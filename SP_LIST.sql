----�w�s�{�ǰѼƪ�[dbo].[AHousekeepingList]
----[sn] -�۽s�y���Ǹ�
----[DBName] --��Ʈw�W��    ##�n����
----[OTable] --�u�W�ӷ���    ##�n����   
----[DTable] --�ت����v��    ##�n����
----[MoveYN] --�O�_�h��,Y���h��,N�����h��     ##�n����
----[CountYN] --�p��w�Ʒh���ΧR���C��,Y���T�{�p��
----[IsReadyYN] --�ϥ�sp [HousekeepingList_3CheckIsReadyYN]�ӧ�s����A����ѼƨѧR���ӷ���sp�T�{�O�_����R��,Y���ӷ���H�i�R��,N���C�Ƥ��P�A���R��
----[CountDateType] --�ɶ�����ƫ��A����,C1��ܮɶ���쬰�r���ƫ��A,N��ܮɶ���쬰datetime��ƫ��A�A�������ɶ���ܪk      ##�n����
----[TableTheDate] --��ƪ�ɶ���줧�W��   ##�n����
----[BegMoveDate] --�h���_�l�ɶ��A�Ĥ@���ݦۦ��J�γ]�w     ##�n���� �榡2020-01-01 00:00:00
----[EndMoveDate] --sp�i��s��������A�i�̻ݨD�ܧ�w�Ʒh�����������
----[EndDelDate] --���v��Ʒh�������A�C�~�ۦ��J�w�ƧR�����(�C�~01-01 00:00:00)�H�e���
----[RowCT] --�]�w�C�i��ƪ�A����C���R���ɤ��C�ơA�̸�ƪ�ϥ��W�v�A�j�p�Ҷq�A�קK�R������w�ɶ��L��    ##�n����    
----[ReadyDelRows] --�ϥ�sp HousekeepingListCheckO��|��s����A�T�{�w�ƧR���C�ơA�B�R�����sp HousekeepingListDeleteTopRow�ݨϥΦ��欰�Ѽ�
----[OYearCount]  --�ϥ�sp [dbo].[HousekeepingList_1OYearCount] @year1=18 ��s����A�����ܿ�J�~�פ��ӷ���C��
----[HYearCount]  --�ϥ�sp [dbo].[HousekeepingList_2HYearCount] @year1=18 ��s����A�����ܿ�J�~�פ����v��C��
----[Remarks]  --�̱��p�ۦ��J[�Ƶ�]

-----�w�s�{��
EXEC  [dbo].[HousekeepingListAutoupBegMovedate] ; ---��s�}�l�h�����[BegMoveDate]:�Ĥ@���h���ɤ~�ݨϥΡA��s[BegMoveDate]-�h���}�l����A�̸�ƪ�_�l��� 
EXEC  [dbo].[HousekeepingListAutoupEndMovedate];  ---��s�����h�����[EndMoveDate]:���������,�w�]�h�~�P�@��(�̱��p�վ�)

EXEC [dbo].[HousekeepingListMoveBeginEndDaybyday]; --�i�D�n�h���w�s�{�ǡj:[BegMoveDate]�}�l���,[EndMoveDate]�������;

---------
EXEC [dbo].[HousekeepingList_1OYearCount] @year1=18 ; --�p��ӷ���~�׵���:�p��2018�~�ӷ���C��

EXEC [dbo].[HousekeepingList_2HYearCount] @year1=18 ; --�p����v��~�׵���:�p��2018�~���v��C��

EXEC [dbo].[HousekeepingList_3CheckIsReadyYN] ; --�T�{��Ʒh���O�_��|:Y��ܨӷ���[OTable]�P���v��[DTable]�p��~�צC�ƬۦP�A�ӷ���2018�~�פw�ǳƦn�i�H�R��;N��ܸ�Ʒh������|�A�ݦA�h���@��
---------
EXEC [dbo].[HousekeepingListCheckO]; ---�T�{�w�ƧR���C��:�p�����p��[EndDelDate]

EXEC [dbo].[HousekeepingListDeleteTopRow]; ---�R���ӷ���:�H���[IsReadyYN]='Y'�ɡA�R���p��[EndDelDate]������ӷ���[OTable]�A�C���R��[RowCT]���ҳ]�w�C��
