
create table b(
       col_int integer,
       col_varchar_10 character varying(10) ,
       col_datetime datetime,
       col_varchar_10_key character varying(10) ,
       col_varchar_1024 character varying(1024) ,
       pk integer primary key,
       col_date_key date,
       col_int_key integer,
       col_date date,
       col_varchar_1024_key character varying(1024) ,
       col_datetime_key datetime);



create table d(
       col_varchar_10 character varying(10) ,
       col_datetime_key datetime,
       col_varchar_10_key character varying(10) ,
       col_date date,
       col_date_key date,
       col_int integer,
       col_datetime datetime,
       col_int_key integer,
       col_varchar_1024 character varying(1024) ,
       pk integer primary key,
       col_varchar_1024_key character varying(1024) );
insert into b values(-22811,'f',NULL,NULL,'e',1,NULL,28280,'10/03/2008',NULL,NULL);
insert into d values('n','11:02:36 01/16/2001',NULL,NULL,'06/01/2001',-690552832,'10:04:56 05/03/2005',-1615593472,NULL,1,'n');
insert into d values(NULL,'12:57:46 10/04/2002',NULL,'04/19/2001','02/15/2001',-1392771072,'09:22:50 08/09/2007',-19566,'z',2,'o');
insert into d values('n','11:58:23 04/24/2005','j',NULL,'12/16/2005',-1298661376,'12:19:16 05/25/2003',NULL,NULL,3,NULL);
insert into d values('t','03:54:00 05/18/2003',NULL,'03/12/2003','05/15/2004',NULL,'08:15:36 12/17/2008',330104832,NULL,4,'x');
insert into d values('j','10:23:28 04/04/2001',NULL,'10/12/2003','11/12/2001',-1938554880,'09:11:20 03/06/2006',-1740308480,'e',5,NULL);
insert into d values('q','05:45:09 05/08/2002','d',NULL,'01/25/2003',-13124,'02:18:35 02/02/2006',NULL,'l',6,'o');
insert into d values('q','07:14:00 04/11/2000',NULL,'12/03/2003','04/07/2004',-1250164736,'04:59:50 11/06/2003',-622067712,'z',7,'y');
insert into d values('e',NULL,'j','02/05/2001','06/09/2000',1675558912,NULL,2009726976,NULL,8,'h');
insert into d values('d','12:49:34 10/21/2007','s',NULL,'07/16/2009',133300224,'03:05:29 03/23/2004',-753205248,'x',9,NULL);
insert into d values('m','05:20:04 02/13/2008','v',NULL,'02/05/2008',-1110966272,'09:46:47 07/22/2004',-744882176,NULL,10,NULL);
insert into d values('e','07:39:04 10/15/2002',NULL,'08/08/2007',NULL,-1187512320,NULL,1347354624,'f',11,'n');
insert into d values('p','07:46:28 07/23/2005','e','02/06/2007','03/06/2004',NULL,'09:03:02 04/25/2006',16740,'x',12,'n');
insert into d values('m','01:48:58 06/07/2009','g',NULL,NULL,236584960,'09:14:43 08/17/2000',-1157562368,'q',13,'e');
insert into d values('t',NULL,NULL,'07/24/2008',NULL,NULL,'12:14:46 04/01/2006',31327,'n',14,NULL);
insert into d values('t','05:46:38 05/27/2006',NULL,'01/13/2008',NULL,1297285120,NULL,-1506934784,NULL,15,'c');
insert into d values('k','06:24:16 02/21/2006','l','03/26/2003','06/01/2006',1277624320,'07:16:17 07/01/2005',NULL,'o',16,'d');
insert into d values('j','05:53:51 12/11/2003','d','06/13/2005','10/05/2003',-1129316352,NULL,NULL,'c',17,'u');
insert into d values('m','10:51:06 09/13/2005',NULL,'12/18/2008','09/15/2008',20910,'12:36:47 06/22/2006',-15192,'g',18,'p');
insert into d values('i','11:35:13 02/26/2001','y',NULL,'03/25/2001',1753481216,'09:17:36 02/25/2005',-1864826880,'t',19,'n');
insert into d values('i',NULL,NULL,'03/15/2007','04/20/2004',-1578827776,'07:25:19 06/03/2002',26790,'r',20,'v');

CREATE INDEX col_varchar_10_key_idx ON b (col_varchar_10_key);
CREATE INDEX col_date_key_idx ON b (col_date_key);
CREATE INDEX col_int_key_idx ON b (col_int_key);
CREATE INDEX col_varchar_1024_key_idx ON b (col_varchar_1024_key);
CREATE INDEX col_datetime_key_idx ON b (col_datetime_key);
CREATE INDEX col_datetime_key_idx ON d (col_datetime_key);
CREATE INDEX col_varchar_10_key_idx ON d (col_varchar_10_key);
CREATE INDEX col_date_key_idx ON d (col_date_key);
CREATE INDEX col_int_key_idx ON d (col_int_key);
CREATE INDEX col_varchar_1024_key_idx ON d (col_varchar_1024_key);

SELECT /*+ USE_MERGE*/ table2 . "col_varchar_10" AS field1 FROM d AS table1 RIGHT JOIN d AS table2 ON table1 . col_varchar_1024 = table2 . col_varchar_1024 LEFT JOIN b AS table3 ON table2 . col_varchar_1024_key = table3 . col_varchar_1024 WHERE table2 . col_int < 1 ORDER BY field1 DESC LIMIT 10;
select table2 . "col_varchar_10" AS field1 FROM d AS table1 RIGHT JOIN d AS table2 ON table1 . col_varchar_1024 = table2 . col_varchar_1024 LEFT JOIN b AS table3 ON table2 . col_varchar_1024_key = table3 . col_varchar_1024 WHERE table2 . col_int < 1 ORDER BY field1 DESC LIMIT 10;
drop table b,d;
