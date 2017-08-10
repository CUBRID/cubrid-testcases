create table table1(pk int primary key,col_int_key int,col_int int,col char(10),col1 varchar(50),col2 varchar(50),col3 char(50),col4 varchar(50),col5 char(50),col6 varchar(50),col7 char(50));
create table table2(pk int primary key,col_int_key int,col_int int,col char(10),col1 varchar(50),col2 varchar(50),col3 char(50),col4 varchar(50),col5 char(50),col6 varchar(50),col7 char(50));
create table table3(pk int primary key,col_int_key int,col_int int,col char(10),col1 varchar(50),col2 varchar(50),col3 char(50),col4 varchar(50),col5 char(50),col6 varchar(50),col7 char(50));
create table table4(pk int primary key,col_int_key int,col_int int,col char(10),col1 varchar(50),col2 varchar(50),col3 char(50),col4 varchar(50),col5 char(50),col6 varchar(50),col7 char(50));
create table table5(pk int primary key,col_int_key int,col_int int,col char(10),col1 varchar(50),col2 varchar(50),col3 char(50),col4 varchar(50),col5 char(50),col6 varchar(50),col7 char(50));
create table table6(pk int primary key,col_int_key int,col_int int,col char(10),col1 varchar(50),col2 varchar(50),col3 char(50),col4 varchar(50),col5 char(50),col6 varchar(50),col7 char(50));
create table table7(pk int primary key,col_int_key int,col_int int,col char(10),col1 varchar(50),col2 varchar(50),col3 char(50),col4 varchar(50),col5 char(50),col6 varchar(50),col7 char(50));
create table table8(pk int primary key,col_int_key int,col_int int,col char(10),col1 varchar(50),col2 varchar(50),col3 char(50),col4 varchar(50),col5 char(50),col6 varchar(50),col7 char(50));
create table table9(pk int primary key,col_int_key int,col_int int,col char(10),col1 varchar(50),col2 varchar(50),col3 char(50),col4 varchar(50),col5 char(50),col6 varchar(50),col7 char(50));
create table table10(pk int primary key,col_int_key int,col_int int,col char(10),col1 varchar(50),col2 varchar(50),col3 char(50),col4 varchar(50),col5 char(50),col6 varchar(50),col7 char(50));
insert into table1 select rownum,rownum-1,rownum+10,'col0','1','2',3,4,5,6,7 from db_class a,db_class b,db_class c limit 1000;
insert into table2 select rownum,rownum-12,rownum+20,'col0','1','2',3,4,5,6,7 from db_class a,db_class b,db_class c limit 2000;
insert into table3 select rownum,rownum-13,rownum+30,'col0','1','2',3,4,5,6,7 from db_class a,db_class b,db_class c limit 3000;
insert into table4 select rownum,rownum-14,rownum+40,'col0','1','2',3,4,5,6,7 from db_class a,db_class b,db_class c limit 4000;
insert into table5 select rownum,rownum-15,rownum+50,'col0','1','2',3,4,5,6,7 from db_class a,db_class b,db_class c limit 5000;
insert into table6 select rownum,rownum-16,rownum+60,'col0','1','2',3,4,5,6,7 from db_class a,db_class b,db_class c limit 6000;
insert into table7 select rownum,rownum-17,rownum+70,'col0','1','2',3,4,5,6,7 from db_class a,db_class b,db_class c limit 7000;
insert into table8 select rownum,rownum-18,rownum+80,'col0','1','2',3,4,5,6,7 from db_class a,db_class b,db_class c limit 8000;
insert into table9 select rownum,rownum-19,rownum+90,'col0','1','2',3,4,5,6,7 from db_class a,db_class b,db_class c limit 9000;
insert into table10 select rownum,rownum-10,rownum+100,'col0','1','2',3,4,5,6,7 from db_class a,db_class b,db_class c limit 1000;

create index t1_col_int_key on table1(col_int_key);
create index t2_col_int_key on table2(col_int_key);
create index t3_col_int_key on table3(col_int_key);
create index t4_col_int_key on table4(col_int_key);
create index t5_col_int_key on table5(col_int_key);
create index t6_col_int_key on table6(col_int_key);
create index t7_col_int_key on table7(col_int_key);
create index t8_col_int_key on table8(col_int_key);
create index t9_col_int_key on table9(col_int_key);
create index t10_col_int_key on table10(col_int_key);


  SELECT    table2 . `col_int` AS field1 , table2 . `col_int` AS field2 , table2 . `col_int_key` AS field3 , MIN(  table1 . `col_int_key` ) AS field4 FROM  table1 AS table1  RIGHT  JOIN table8 AS table2 ON  table1 . `pk` =  table2 . `pk`  WHERE table1 . `pk`  IN (9, 7, 4)  GROUP BY field1, field2, field3 HAVING (field2 != 3 AND field4 <> 7)  ;
  SELECT    table1 . `pk` AS field1 FROM  table3 AS table1  LEFT  JOIN table8 AS table2 ON  table1 . `col2` =  table2 . `col4`  WHERE table1 . `pk` <= 8  GROUP BY field1   ;
   SELECT    table2 . `pk` AS field1 , table1 . `col_int` AS field2 , table1 . `col_int_key` AS field3 , MAX(  table2 . `col_int_key` ) AS field4 , table2 . `col_int` AS field5 FROM  table1 AS table1  RIGHT  JOIN table8 AS table2 ON  table1 . `col3` =  table2 . `col`  WHERE table1 . `col_int` < table2 . `col_int`  GROUP BY field1, field2, field3, field5 HAVING ((field1 > 9 OR field1 > 96) AND field4 = 6) ORDER BY field1  , field4 DESC ;
   --SELECT    table1 . `col_int_key` AS field1 FROM   table6 AS table1  LEFT  JOIN table4 AS table2 ON  table1 . `pk` =  table2 . `col_int`   RIGHT  JOIN table9 AS table3 ON  table1 . `col_int_key` =  table3 . `col_int_key`  WHERE table2 . `col_int_key` <= table3 . `pk`   ORDER BY field1 ASC ;
  -- SELECT    table2 . `col_int_key` AS field1 , table1 . `pk` AS field2 FROM  table5 AS table1  LEFT  JOIN table3 AS table2 ON  table1 . `col_int_key` =  table2 . `col_int_key`  WHERE ( table1 . `col_int` <> table1 . `col_int_key` OR table1 . `pk` <= table2 . `col_int_key` )    ;
  SELECT    table1 . `col_int` AS field1 , table1 . `col_int_key` AS field2 , table1 . `col_int_key` AS field3 , table2 . `col_int` AS field4 FROM  table5 AS table1  LEFT OUTER JOIN table9 AS table2 ON  table1 . `col1` =  table2 . `col7`  WHERE ( ( ( ( table2 . `col_int_key`  IN (4) OR table1 . `pk`  BETWEEN 1 AND ( 1 + 6 ) ) AND table1 . `col_int` IS  NULL ) AND table2 . `col_int` <= 1 ) AND table2 . `pk` IS  NULL )    ;
  -- SELECT    table1 . `col_int_key` AS field1 FROM  table7 AS table1  LEFT  JOIN table3 AS table2 ON  table1 . `col_int` =  table2 . `pk`  WHERE table2 . `col_int_key` IS  NULL  GROUP BY field1 HAVING field1 >= 2 ORDER BY field1   ;
  SELECT    MIN(  table2 . `pk` ) AS field1 FROM  table3 AS table1  LEFT  JOIN table9 AS table2 ON  table1 . `col_int_key` =  table2 . `col_int_key`  WHERE table1 . `pk` >= 2    ;
  SELECT    table1 . `pk` AS field1 FROM  table2 AS table1  LEFT  JOIN table10 AS table2 ON  table1 . `pk` =  table2 . `col_int_key`  WHERE table1 . `pk` <> 9  GROUP BY field1  ORDER BY field1  LIMIT 1 OFFSET 3 ;
   SELECT    table1 . `col_int` AS field1 , table2 . `pk` AS field2 , table1 . `col_int` AS field3 , table1 . `pk` AS field4 , table2 . `col_int` AS field5 FROM  table8 AS table1  LEFT  JOIN table4 AS table2 ON  table1 . `pk` =  table2 . `pk`  WHERE table2 . `col_int` < 5  GROUP BY field1, field2, field3, field4, field5 HAVING (field4 >= 5 AND field1 = 9) ORDER BY field1, field2, field3, field4, field5  LIMIT 100 OFFSET 239 ;
  SELECT    table2 . `col_int` AS field1 , COUNT(  table1 . `pk` ) AS field2 , table2 . `col_int` AS field3 , table1 . `col_int` AS field4 FROM  table3 AS table1  LEFT  JOIN table1 AS table2 ON  table1 . `col7` =  table2 . `col1`  WHERE ( table2 . `col_int_key` IS  NULL AND table2 . `pk` <> 3 )  GROUP BY field1, field3, field4 HAVING field2 <= 5 ORDER BY field4 ASC ;

drop table table1,table2,table3,table4,table5,table6,table7,table8,table9,table10;
