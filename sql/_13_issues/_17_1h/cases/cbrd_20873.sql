drop table if exists tb;
create table tb (id int primary key, a int);

insert into tb values (4,4);

insert into tb values (1,1);

create index i_tb_a on tb(a);

insert into tb values (2,2);

insert into tb values (3,3);

select /*+ recompile */ a from tb where a between 1 and 3 group by a desc having groupby_num() between 2 and 4 ;

WITH cte_s0lAS8PSg AS (
    select /*+ recompile */ a from tb where a between 3 and 1 group by a desc having groupby_num() between 2 and 4 )
select * from cte_s0lAS8PSg;

WITH cte_s0lAS8PSg AS (
    select /*+ recompile */ a from tb where a between 1 and 3 group by a desc having groupby_num() between 2 and 4 ) 
select * from cte_s0lAS8PSg;

drop table if exists tb;

drop table if exists tbl;
create TABLE tbl ( 
    Id INT,
    [Name] VARCHAR(20),
    ParentId INT
);

INSERT INTO tbl( Id, Name, ParentId ) 
VALUES 
   (1, 'Europe', NULL) 
  ,(2, 'Asia',   NULL) 
  ,(3, 'Germany',   1) 
  ,(4, 'UK',  1) 
  ,(5, 'China',   2) 
  ,(6, 'India',   2) 
  ,(7, 'Scotland',  4) 
  ,(8, 'Edinburgh', 7) 
  ,(9, 'Leith',   8);

WITH abcd AS (  
    SELECT id, Name, ParentID, lang
        FROM tbl, db_root WHERE ParentId IS NULL 
    UNION ALL 
    SELECT t.id, t.Name, t.ParentID, timezone_checksum
        FROM tbl AS t, db_root JOIN abcd AS a ON t.ParentId = a.id 
) SELECT * FROM abcd order by 1;

WITH abcd AS (
    SELECT id, Name, ParentID, lang
        FROM tbl, db_root WHERE ParentId IS NULL
    UNION ALL
    SELECT t.id, t.Name, t.ParentID, timezone_checksum
        FROM tbl AS t, db_root JOIN abcd AS a ON db_root.charset = a.id
) SELECT * FROM abcd order by id, name;

WITH abcd AS (
    SELECT id, Name, ParentID FROM tbl WHERE ParentId IS NULL
    UNION ALL
    SELECT t.id, t.Name, t.ParentID
        FROM  tbl AS t JOIN abcd AS a ON t.ParentId = a.id
) SELECT * FROM abcd order by id, name;

WITH 
 abcd AS (
    SELECT id, Name, ParentID, lang
        FROM tbl, db_root WHERE ParentId IS NULL
    UNION ALL  
    SELECT t.id, t.Name, t.ParentID, timezone_checksum 
        FROM tbl AS t , db_root JOIN abcd AS a ON db_root.charset = a.id),
 ctw AS (
    SELECT * 
        FROM db_root where charset in (
        with cte as (select abcd.id+2 from abcd) select * from cte limit 1)
) select abcd.id+ctw.charset from abcd, ctw order by 1; 

with test(X) as(
    select cast(to_date('2010-01-01','YYYY-MM-DD') as date) from db_root
    union all 
    (select (X + 1) from test where X <= to_date('2010-01-10','YYYY-MM-DD'))
) select * from test order by 1;

drop table if exists tbl;
drop table if exists pp_a;
create table pp_a(
col_varchar_5 character varying(5) ,
col_datetime datetime,
col_date date,
col_varchar_512 character varying(512) ,
col_datetime_key datetime,
col_int_key integer,
col_varchar_256_key character varying(256) ,
col_date_key date,
col_varchar_5_key character varying(5) ,
col_varchar_512_key character varying(512) ,
col_int integer,
col_varchar_256 character varying(256)) ;

ALTER CLASS pp_a
PARTITION BY RANGE ( col_varchar_5 )
( PARTITION p0  VALUES LESS THAN ('m'),
PARTITION p1  VALUES LESS THAN ('za') ) ;

insert into pp_a values(NULL,'02:38:26 03/27/2005','09/27/2008','m','12:32:51 02/02/2006',-425918464,'c','10/23/2002','r','v',1453719552,'q');
insert into pp_a values(NULL,'12:55:24 01/04/2002','11/01/2002','i','08:57:21 10/07/2006',2053308416,'k','11/25/2004','e','v',-1092026368,'s');
insert into pp_a values('a','07:09:02 04/07/2000','04/04/2005',NULL,'10:14:58 04/28/2003',NULL,'i','05/13/2003','t',NULL,2049114112,NULL);
insert into pp_a values('c','07:47:59 05/14/2004','12/10/2003','o','08:06:01 02/16/2003',-636289024,'e',NULL,'r',NULL,NULL,NULL);
insert into pp_a values('u','07:55:13 12/04/2000','12/16/2007','k','09:22:34 12/05/2008',NULL,'s','06/23/2006','b','j',-30927,'y');

WITH cte_U55jhT AS (
    SELECT table1."col_datetime" AS field1, SUM(table1.col_int) AS field2, 
           table1."col_varchar_512" AS field3, MAX(distinct table1.col_varchar_256_key) AS field4 
    FROM "pp_a" AS table1 WHERE ((table1.col_int < 2 ) XOR table1.col_date != '2008-05-16') GROUP BY field1, field3
) select * from cte_U55jhT order by 1;

drop table if exists tbl;
drop table if exists pp_a;
