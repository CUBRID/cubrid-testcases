drop table if exists CbrdStmt;
CREATE TABLE CbrdStmt
(PK_NO varchar(100),
Cbrd_Data_Vol numeric(29, 5),
CbrdResCTERemoveDataTT numeric(29, 5),
CBD_NO varchar(100),
CBD_TDD varchar(100),
MM_ID bigint,
REC_STATUS_CD varchar(100),
OK_DT DateTime);

insert into CbrdStmt
select '043','0','50','36563','','83062200','OR','12/1/2011' union all
select '002','0','100','36563','','83062222','OR','12/1/2011' union all
select '002','0','-.99','36563','','-83062299','RR','12/1/2011' union all
select '002','0','-.99','36563','','-83062299','RR','2/1/2013' union all
select '002','0','-.99','36563','','-83062299','RR','4/1/2013' union all
select '002','0','-.99','36563','','83062299','OR','2/1/2011' union all
select '002','0','-.99','36563','','-86768195','RR','12/1/2011' union all
select '002','0','-.99','36563','','-86768195','RR','2/1/2013' union all
select '002','0','-.99','36563','','-86768195','RR','4/1/2013' union all
select '002','0','-.99','36563','','86768195','OR','3/1/2011' union all
select '002','0','-.99','36563','','-90467786','RR','1/1/2012' union all
select '002','0','-.99','36563','','-90467786','RR','2/1/2013' union all
select '002','0','-.99','36563','','-90467786','RR','4/1/2013' union all
select '002','0','-.99','36563','','90467786','OR','4/1/2011' union all
select '002','0','-.99','36563','','-77671301','RR','2/1/2013' union all
select '002','0','-.99','36563','','-77671301','RR','4/1/2013' union all
select '002','0','-.99','36563','','77671301','OR','1/1/2011' union all
select '002','0','-.99','36563','','-68420423','RR','2/1/2013' union all
select '002','0','-.99','36563','','68420423','OR','4/1/2013' union all
select '002','0','-.99','36563','','-188808446','RR','3/1/2013' union all
select '002','0','-.99','36563','','188808446','OR','1/1/2013' union all
select '002','1205.15','0','36563','A','138365544','OR','2/1/2012';

WITH RemoveData AS
   (
   SELECT a.PK_NO,a.Cbrd_Data_Vol,a.CbrdResCTERemoveDataTT, a.CBD_NO, a.CBD_TDD, a.MM_ID, a.REC_STATUS_CD, 
MAX(a.OK_DT) OK_DT
   FROM CbrdStmt a
   WHERE a.REC_STATUS_CD = 'RR'
   GROUP BY a.PK_NO,a.Cbrd_Data_Vol,a.CbrdResCTERemoveDataTT, a.CBD_NO, a.CBD_TDD, a.MM_ID, a.REC_STATUS_CD
   HAVING COUNT(a.REC_STATUS_CD) > 2
   ),
  RemoveData2 AS 
   (
   SELECT PK_NO "PKNumber"
   ,SUM(-a.Cbrd_Data_Vol) "CbrdDataVol"
   ,SUM(CbrdResCTERemoveDataTT) "CbrdRemoveDataTT"
   FROM RemoveData a
   GROUP BY PK_NO
   ),
  OriginalData AS
   (
   SELECT a.PK_NO "PKNumber"
   ,SUM(a.Cbrd_Data_Vol) "CbrdDataVol"
   ,SUM(CASE WHEN a.REC_STATUS_CD = 'RR' THEN -a.CbrdResCTERemoveDataTT ELSE a.CbrdResCTERemoveDataTT END) "CbrdRemoveDataTT"
   FROM CbrdStmt a
   LEFT OUTER JOIN (SELECT CBD_NO, CBD_TDD, MM_ID, REC_STATUS_CD, MAX(OK_DT) OK_DT
   FROM CbrdStmt 
   WHERE REC_STATUS_CD = 'RR'
   GROUP BY CBD_NO, CBD_TDD, MM_ID, REC_STATUS_CD
   HAVING COUNT(MM_ID) > 1) b
   ON a.CBD_NO = b.CBD_NO
   AND a.MM_ID = b.MM_ID
   AND a.Rec_Status_Cd = b.REC_STATUS_CD
   AND a.OK_DT = b.OK_DT
   WHERE a.OK_DT > '1/1/2010'
   AND b.CBD_NO IS NULL 
   GROUP BY a.PK_NO
   ),
UnionCTE AS (   
SELECT *
FROM RemoveData2
UNION 
SELECT *
FROM OriginalData
)
SELECT PKNumber, SUM(CbrdDataVol) AS CbrdDataVol,SUM(CbrdRemoveDataTT) AS CbrdRemoveDataTT
FROM UnionCTE
GROUP BY PKNumber order by 1,2,3;


WITH family (id, name, parent_id) AS
(SELECT  1,     'John',NULL FROM db_root UNION ALL
  SELECT  2,   'Herman', 1   FROM db_root UNION ALL
  SELECT  3,     'Anne', 1   FROM db_root UNION ALL
  SELECT  4,   'Louise', 1   FROM db_root UNION ALL
  SELECT  5,     'Noel', 2   FROM db_root UNION ALL
  SELECT  6,    'Karen', 3   FROM db_root UNION ALL
  SELECT  7,     'Kent', 4   FROM db_root UNION ALL
  SELECT  8, 'Lorraine', 4   FROM db_root UNION ALL
  SELECT  9,  'Barbara', 5   FROM db_root UNION ALL
  SELECT 10,     'Lisa', 5   FROM db_root UNION ALL
  SELECT 11, 'Christie', 6   FROM db_root UNION ALL
  SELECT 12,   'Alicia', 6   FROM db_root UNION ALL
  SELECT 13,     'Sean',10   FROM db_root UNION ALL
  SELECT 14,     'Reid',10   FROM db_root),
     t (gen, id, name, parent_id, id_list) AS
(SELECT  1, id, name, parent_id, to_char(id)
    FROM family
   WHERE parent_id IS NULL
   UNION ALL
  SELECT t.gen + 1 gen, f.id, f.name, f.parent_id, id_list || ',' || f.id
    FROM t
    JOIN family f
      ON t.id = f.parent_id)
SELECT  gen,
        id,
        name,
        parent_id,
        (
         select  cast(f.name
                      as varchar
                     )
           from  family f
           where instr(',' || id_list || ',',',' || f.id || ',') > 0
        ) tmap
  FROM t;

with q ( str, ct ) as ( select char_to_clob('x'), 0 from db_root ), r ( str, ct ) as ( select clob_to_char(str), ct from q union all select clob_to_char(str) || ',a', ct + 1 from q) select * from r order by str,ct;
with r ( str, ct ) as (select  CHAR_TO_CLOB('x'), 0 from db_root
union all 
select  char_to_clob(str || ',a'), ct + 1
from    r where   ct <= 0 ) select clob_to_char(str),ct from r order by 1, 2;

with q ( str, ct ) as ( select char_to_clob('x'), 0 from db_root ), r ( str, ct ) as ( select clob_to_char(str), ct from q union all select clob_to_char(str) || ',a', ct + 1 from q) select * from r order by str,ct;


WITH CTE
AS
(
SELECT 1 ID, 'A' D FROM db_root
UNION
SELECT 2 ID, 'B' FROM db_root
UNION
SELECT 3 ID, 'C' FROM db_root
)
SELECT MAX_ID
FROM (
SELECT ID, MAX(ID) MAX_ID
FROM CTE
GROUP BY D
) order by 1;

drop CbrdStmt; 
