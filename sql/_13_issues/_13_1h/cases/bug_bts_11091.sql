-- on partition table
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

SELECT table1 . "col_datetime" AS field1, SUM( table1 . col_int ) AS field2, table1 . "col_varchar_512" AS field3, MAX( distinct table1 . col_varchar_256_key ) AS field4 FROM "pp_a" AS table1 WHERE  (  ( table1 . col_int < 2 ) XOR table1 . col_date != '2008-05-16' )  GROUP BY field1, field3  ;
drop table pp_a;

--on no partition table
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


insert into pp_a values(NULL,'02:38:26 03/27/2005','09/27/2008','m','12:32:51 02/02/2006',-425918464,'c','10/23/2002','r','v',1453719552,'q');
insert into pp_a values(NULL,'12:55:24 01/04/2002','11/01/2002','i','08:57:21 10/07/2006',2053308416,'k','11/25/2004','e','v',-1092026368,'s');
insert into pp_a values('a','07:09:02 04/07/2000','04/04/2005',NULL,'10:14:58 04/28/2003',NULL,'i','05/13/2003','t',NULL,2049114112,NULL);
insert into pp_a values('c','07:47:59 05/14/2004','12/10/2003','o','08:06:01 02/16/2003',-636289024,'e',NULL,'r',NULL,NULL,NULL);
insert into pp_a values('u','07:55:13 12/04/2000','12/16/2007','k','09:22:34 12/05/2008',NULL,'s','06/23/2006','b','j',-30927,'y');
SELECT table1 . "col_datetime" AS field1, SUM( table1 . col_int ) AS field2, table1 . "col_varchar_512" AS field3, MAX( distinct table1 . col_varchar_256_key ) AS field4 FROM "pp_a" AS table1 WHERE  (  ( table1 . col_int < 2 ) XOR table1 . col_date != '2008-05-16' )  GROUP BY field1, field3  ;
drop table pp_a;
