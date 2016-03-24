
drop table if exists aoo,boo;
create table aoo(a int, b bigint primary key );
create table boo(a int, b bigint primary key );
insert into aoo values(1,1), (2,2), (3,3);
insert into boo values(1,1), (2,2), (3,3);
update aoo left join boo on (aoo.a)=boo.a set aoo.a=incr(aoo.a);
drop table if exists aoo,boo;







drop table if exists t1,t2,t3,t4;
create table t1(a int, b bigint primary key );
create table t2(a int, b bigint primary key );
create table t3(a int, b bigint primary key );
create table t4(a int, b bigint primary key );
insert into t1 select rownum,rownum from db_class a,db_class limit 100;
insert into t2 select rownum,rownum from db_class a,db_class limit 100;
insert into t3 select rownum,rownum from db_class a,db_class limit 100;
insert into t4 select rownum,rownum from db_class a,db_class limit 100;
PREPARE s FROM 'update t1 inner join t2 on t1.a=t2.a  inner join t3 on t1.a=t3.a set t2.a=?,t1.a=?,t3.a=?  where  t1.a>=0';
EXECUTE s USING  -999999999 ,-999999999,-999999999;
PREPARE s1 FROM 'delete t1.*,t2.* from t1,t2   where t1.a=t2.a and t1.a=?';
EXECUTE s1 USING -999999999;
drop table if exists t1,t2,t3,t4;






drop table if exists t1,t2,t3,t4;
create table t1 (a int , b int, c int, d char(10),e char(100),f char(5000),index i_t1_b(b) ,PRIMARY KEY(a,b,c,d,e,f)) ;
insert into t1 select rownum,rownum, rownum, rownum||'', rownum||'', rownum||'' from db_class c1, db_class c2 limit 100;
create table t2 (a int , b int, c int, d char(10),e char(100),f char(5000),index i_t1_b(b) ,PRIMARY KEY(a,b,c,d,e,f)) ;
insert into t2 select rownum,rownum, rownum, rownum||'', rownum||'', rownum||'' from db_class c1, db_class c2 limit 100;
create table t3 (a int , b int, c int, d char(10),e char(100),f char(5000),index i_t1_b(b) ,PRIMARY KEY(a,b,c,d,e,f)) partition by hash(f) partitions 2;
insert into t3 select * from t1;
delete t1,t2,t3 from t1,t2,t3  where t1.a=t2.a and t1.a=t3.a and (t1.a in (select a from t2) and t1.a in (select a from t3)) and rownum<50;  
--select *  from t1,t2,t3  where t1.a=t2.a and t1.a=t3.a and (t1.a in (select a from t2) and t1.a in (select a from t3)) and rownum<50
drop table if exists t1,t2,t3,t4;






drop table if exists t1,t2;
create table t1 (i1 int, i2 int, i3 varchar(255), i4 float, i5 date);
insert into t1 values (1, 2, '\xF1\x90\x98\x8D\xEF\xBF', 4, '09/22/2011');
insert into t1 values (10, 20, '30', 40, '09/23/2011');
insert into t1 values (100, 200, '300', 400, '09/24/2011');
create table t2 (i1 int, i2 int, i3 varchar(255), i4 float, i5 date);
insert into t2 values (-1, -2, '\xF1\x90\x98\x8D\xEF\xBF', -4,'09/25/2011');
insert into t2 values (-10, -20, '-30', -40, '09/26/2011');
insert into t2 values (-100, -200, '-40', -400, '09/27/2011');
create table t3 (i1 int, i2 int, i3 varchar(255), i4 float, i5 date);
insert into t3 values (-1, -2, '\xF1\x90\x98\x8D\xEF\xBF', -4,'09/25/2011');
insert into t3 values (-10, -20, '-30', -40, '09/26/2011');
insert into t3 values (-100, -200, '-40', -400, '09/27/2011');
update t1 inner join t2 on t1.i1=-t2.i1 set t1.i5=now() , t1.i3='\xF1\x90\x98\x8D\xEF\xBF';
update t1 inner join t2 on t1.i3=t2.i3 set t1.i5=now() , t1.i3='\xF1\x90\x98\x8D\xEF\xBF';
update t1 inner join t2 on t1.i1=-t2.i1 inner join t3 on t1.i1=-t3.i1 set t1.i3=addtime(now(),'34 00:00:00') , t1.i5=CURRENT_DATE(),t2.i3=addtime(now(),'34 00:00:00') , t2.i5=CURRENT_DATE(),t3.i3=addtime(now(),'34 00:00:00') , t3.i5=CURRENT_DATE();
update t1 inner join t2 on t1.i5=t2.i5 set t1.i5=now();
update t1 inner join t2 on t1.i5=t2.i5  inner join t3 on t1.i5=t2.i5 set t1.i5=now();
drop table t1,t2;










drop table if exists t1,t2;
drop table if exists t3;
CREATE TABLE t1 (a INTEGER primary key, b VARCHAR(200)) partition by hash(a) partitions 3;
INSERT INTO t1 VALUES   ('1', 'val1'),   ('2', 'val2'),   ('3', 'val3'),   ('4', 'val4'); 
CREATE TABLE t2 (a INTEGER  primary key, b VARCHAR(200))partition by hash(a) partitions 3;
INSERT INTO t2 VALUES   ('1', 'val-1'),   ('2', 'val-2'),   ('3', 'val-3'),   ('4', 'val-4'); 
create VIEW t3 AS SELECT * FROM t1 ;
UPDATE t1  inner JOIN (SELECT t2.a FROM t2,t1 WHERE t2.a=t1.a UNION   SELECT t3.a FROM t3,t1 WHERE t3.a=t1.a ) AS T ON T.a = t1.a  set t1.b=T.a;
UPDATE t1  inner JOIN (SELECT t2.a FROM t2,t1 WHERE t2.a=t1.a UNION   SELECT t3.a FROM t3,t1 WHERE t3.a=t1.a) AS T ON T.a = t1.a  set t1.b=T.a;
UPDATE t1  inner JOIN (SELECT t2.a FROM t2,t1 WHERE t2.a=t1.a UNION   SELECT t3.a FROM t3,t1 WHERE t3.a=t1.a) AS T ON T.a = t1.a  set t1.b=T.a;
UPDATE t1  inner JOIN (SELECT t2.a FROM t2,t1 WHERE t2.a=t1.a UNION   SELECT t3.a FROM t3,t1 WHERE t3.a=t1.a) AS T ON T.a = t1.a  set t1.a=t.a,t1.b=t.a+t.a;
UPDATE t1  left outer JOIN (SELECT t2.a FROM t2,t1 WHERE t2.a=t1.a UNION   SELECT t3.a FROM t3,t1 WHERE t3.a=t1.a)  T ON T.a = t1.a  set t1.a=t.a,t1.b=t.a+t.a;
UPDATE t1  right outer JOIN (SELECT t2.a FROM t2,t1 WHERE t2.a=t1.a UNION   SELECT t3.a FROM t3,t1 WHERE t3.a=t1.a)  T ON T.a = t1.a  set t1.a=t.a,t1.b=t.a+t.a;
UPDATE t3  right outer JOIN (SELECT t2.a FROM t2,t1 WHERE t2.a=t1.a DIFFERENCE
   SELECT t3.a FROM t3,t1 WHERE t3.a=t1.a)  t ON t.a = t3.a  set t3.a=t.a,t3.b=t.a+t.a;
UPDATE t3  inner JOIN (SELECT t2.a FROM t2,t1 WHERE t2.a=t1.a INTERSECTION
   SELECT t3.a FROM t3,t1 WHERE t3.a=t1.a)  t ON t.a = t3.a  set t3.a=t.a,t3.b=t.a+t.a;
drop view t3;
drop table t1,t2;








drop table if exists foo,bar;
create table foo(id int primary key, parentid int, text varchar(32));
insert into foo select rownum,rownum-4,rownum||'' from db_class a,db_class b limit 100;
create table bar(id int primary key, parentid int, text varchar(32));
insert into bar select rownum,rownum-4,rownum||'' from db_class a,db_class b limit 100;
update foo inner join 
((select * from foo connect by prior id=parentid order by id)  UNION (select * from foo connect by prior id=parentid order by id)) t on foo.id=t.id set foo.text = t.text;
delete foo from foo where foo.id in ((select foo.id from foo connect by prior id=parentid order by id)  UNION (select foo.id from foo connect by prior id=parentid order by id)) ;
drop table foo, bar;




drop table if exists t1,t2;
CREATE TABLE t1 (a decimal(19,0),b  decimal(19,0) primary key);
INSERT INTO t1 VALUES ('99999999999999999','99999999999999999');
SELECT * FROM t1 WHERE a = cast('99999999999999999' as decimal(19,0));
CREATE TABLE t2 (a decimal(19,0),b  decimal(19,0) primary key);
INSERT INTO t2 VALUES ('99999999999999999','99999999999999999');
update t1 inner join t2 on t1.a=t2.a set t1.b='0000000000';
PREPARE st FROM 'SELECT * from t1 limit ?';
EXECUTE st USING 0;
drop table t1,t2;




