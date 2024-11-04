-- This testcase use modified Oracle samples. See below for the license:
-- Copyright (c) 2015 Oracle
-- Permission is hereby granted, free of charge, to any person obtaining a copy
--  of this software and associated documentation files (the "Software"), to deal
--  in the Software without restriction, including without limitation the rights
--  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
--  copies of the Software, and to permit persons to whom the Software is
--  furnished to do so, subject to the following conditions:
-- The above copyright notice and this permission notice shall be included in all
--  copies or substantial portions of the Software.
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
--  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
--  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
--  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
--  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
--  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
--  SOFTWARE.



drop table if exists t1,t2,t3;
create table t1(col1 date);
insert into t1 values(date'1999-01-01'), (date'2000-01-01');
create table t2(col1 smallint, col2 date);
insert into t2 values(5, date'2000-01-01'), (13, '2007-12-12');
create table t3(col1 bigint, col2 date);
insert into t3 values(5, date'2000-01-01'), (13, '2007-12-12');
update t2 inner join  t1 on t1.col1=t2.col2 set t2.col1=t2.col1 where rownum<1;
update t2 inner join  t1 on t1.col1=t2.col2 set t2.col1=2 where rownum<2;
update t2 inner join  t1 on t1.col1=t2.col2 inner join  t3 on t3.col2=t1.col1  set  t1.col1=t2.col2  where rownum<2;
drop t1,t2,t3;






drop table if exists md1,md2;
create table md1(id1 int primary key, col1 varchar);
insert into md1 values(11, 'aaa'), (22, 'bbb');
create table md2(id2 smallint, col2 varchar);
insert into md2 values(22, 'ccc'), (22, 'ddd');
--trigger action table
create table action_tbl(a int primary key auto_increment, b char(20));

--create trigger
create trigger aft_upd after update on md1
execute insert into action_tbl(b) values('AFTER UPDATE');
update md1 m1 inner join md2 m2 on m1.id1=m2.id2 set m1.col1=m2.col2;
drop table md1,md2;
drop table action_tbl;





drop table if exists p1,p2;
create table p1(col1 time)
partition by range(col1)
(partition p1 values less than (time'12:12:13'),
partition p2 values less than (time'12:12:15'),
partition p3 values less than (time'12:12:18'));
insert into p1 values('12:12:16'), ('12:12:17'), ('12:12:15');
create table p2(col2 time)
partition by range(col2)
(partition p1 values less than (time'12:12:12'),
partition p2 values less than (time'12:12:16'),
partition p3 values less than (time'14:14:15'));
insert into p2 values('12:12:16'), ('12:12:16'), ('12:12:17');
update p1 right outer join p2 on p1.col1=p2.col2 set p1.col1=p2.col2-2, p2.col2=p1.col1;
drop table  p1,p2;





drop table if exists p1,p2;
create table p1(id1 int)
partition by list(id1) (
partition p1 values in (1, 2),
partition p2 values in (3, 4)
);
insert into p1 values(2);
create table p2(id2 int)
partition by hash(id2) partitions 3;
insert into p2 values(1), (2);
 update p1, p2 set p1.id1=3, p2.id2=8 where p1.id1=p2.id2;
drop table  p1,p2;





drop table if exists t1,t2;
create table t1(a int);
insert into t1 values(1), (1), (1), (1);
create table t2(b int);
insert into t2 values(1), (1), (1), (1);
update t1 m1, t2 m2 set m1.a=100, m2.b=100 where m1.a=m2.b;
update t1 m1, t2 m2 set m1.a=100 where m1.a=m2.b;
drop table t1;
create table t1(a int);
insert into t1 values(1), (2), (3), (4);
update t1 m1, t1 m2 set m1.a=100, m2.a=200 where m1.a=m2.a;
drop table  t1,t2;



drop table if exists t1,t2;
create table t1(id int, phone varchar(20)) 
partition by hash(id) partitions 5;
create table t2(id int , name varchar(20))
partition by hash(id) partitions 5;
insert into t1 values(1,'111-1111'), (2,'222-2222'), (3, '333-3333'), (4, '444-4444'), (5, '555-5555');
insert into t2 values(1,'George'),(2,'Laura'),(3,'Max');
update t1, t2 set t1.id=100, t2.id=200 where t1.id=t2.id;
drop table  t1,t2;



drop table if exists t1,t2;
create table t1(id1 int, col2 clob);
insert into t1 values(1, 'cubrid'), (2, 'mysql'), (3, 'abc');
create table t2(col1 clob, id2 int);
insert into t2 values('aa', 1), ('mysql', 2);
 update t1 m1 left outer join t2 on clob_to_char(t2.col1)=clob_to_char(m1.col2) set t2.col1=char_to_clob('updated2'), t2.id2=m1.id1;
drop table  t1,t2;


drop table if exists t1,t2;
create table t1(id1 bigint, col1 time);
insert into t1 values(1000000, '12:12:12'), (2000000, '12:12:13');
create table t2(id2 bigint, col2 time);
insert into t2 values(1, '11:11:11'), (2, '12:12:12');
prepare st from 'update t1 m1 right outer join t2 m2 on m1.col1=m2.col2 set m1.col1=date_add(m2.col2, interval ? second);';
drop table  t1,t2;
deallocate prepare st;






drop table if exists bonuses,emp;
create class bonuses (emp_id int, bonus int);
create class emp (emp_id int, salary int);
insert into bonuses values (153,100);
insert into bonuses values (154,100);
insert into bonuses values (155,100);
insert into bonuses values (156,100);
insert into bonuses values (157,100);
insert into bonuses values (158,100);
insert into bonuses values (159,100);
insert into bonuses values (160,100);
insert into bonuses values (161,100);
insert into bonuses values (162,100);
insert into bonuses values (163,100);
insert into emp values (153,200);
insert into emp values (154,500);
insert into emp values (155,550);
insert into emp values (156,350);
insert into emp values (157,600);
insert into emp values (158,450);
insert into emp values (159,550);
insert into emp values (160,650);
insert into emp values (161,700);
insert into emp values (162,520);
insert into emp values (163,675);
insert into emp values (201,400);
insert into emp values (202,450);
insert into emp values (203,300);
merge into bonuses using emp on bonuses.emp_id = emp.emp_id when matched then update set bonuses.bonus=bonuses.bonus+emp.salary*0.1 where emp.salary<600;
select count(*) from bonuses order by 1;
select count(*) from emp order by 1;
delete a,b from bonuses  a ,emp b  where a.emp_id=b.emp_id;
delete bonuses from emp  bonuses; 
drop table bonuses,emp;










drop table if exists t1;
create table t1 (a int primary key, b int, c int, d char(10),e char(100),f char(500),index i_t1_b(b)) ;
create index i_t_ab  on t1(a, abs(b));
insert into t1 select rownum,rownum, rownum, rownum||'', rownum||'', rownum||'' from db_class c1, db_class c2, db_class c3 limit 100;;
select count(*) from t1 ;
delete t1,t2 from t1 t1,t1 t2 where t1.a=t2.a and t1.a<10 using index  t1.i_t1_b ;
delete t1,t2 from t1 t1,t1 t2 where t1.a=t2.a and t1.a<100 and t2.a<100 using index  t1.i_t1_b ;








drop table if exists t1;
create table t1 (a int primary key, b int, c int, d char(10),e char(100),f char(500),index i_t1_b(b)) PARTITION BY RANGE (a) (PARTITION a VALUES LESS THAN (100),
PARTITION before_2008 VALUES LESS THAN (20000) );
create index i_t_ab  on t1(a, abs(b));
insert into t1 select rownum,rownum, rownum, rownum||'', rownum||'', rownum||'' from db_class c1, db_class c2, db_class c3 limit 100;;
select count(*) from t1 ;
delete t1,t2 from t1 t1,t1 t2 where t1.a=t2.a and t1.a<10 using index  t1.i_t1_b ;
delete t1,t2 from t1 t1,t1 t2 where t1.a=t2.a and t1.a<100 and t2.a<100 using index  t1.i_t1_b ;






drop table if exists t1;
create table t1 (a int primary key, b int, c int, d char(10),e char(100),f char(500),index i_t1_b(b)) PARTITION BY hash(a) partitions 2;
create index i_t_ab  on t1(a, abs(b));
insert into t1 select rownum,rownum, rownum, rownum||'', rownum||'', rownum||'' from db_class c1, db_class c2, db_class c3 limit 100;;
select count(*) from t1 ;
delete t1,t2 from t1 t1,t1 t2 where t1.a=t2.a and t1.a<10 using index  t1.i_t1_b ;
delete t1,t2 from t1 t1,t1 t2 where t1.a=t2.a and t1.a<10 and INST_NUM() <5 using index  t1.i_t1_b ;
delete t1,t2 from t1 t1,t1 t2 where t1.a=t2.a and t1.a<100 and t2.a<100 using index  t1.i_t1_b ;
drop table if exists t1;







drop table if exists test;
CREATE TABLE test (id int not null primary key, type int not null);
CREATE INDEX idx ON test (id, type);
insert into test select rownum ,rownum%9 from db_class a,db_class b ,db_class limit 100;
select * FROM test WHERE type=5 OR (type=3 AND id=123456) ;
select /*+ recompile */ * FROM test WHERE type=5 and (type=3 AND id=123456) ;
DELETE FROM test WHERE type=5 OR (type=3 AND id=123456);
drop table if exists test;





drop table if exists DISTRICT,WAREHOUSE;
CREATE TABLE WAREHOUSE(W_ID integer primary key);
CREATE TABLE DISTRICT(D_W_ID Int, foreign key (D_W_ID)references WAREHOUSE(W_ID));
alter table DISTRICT add constraint foreign key (D_W_ID)references WAREHOUSE(W_ID)  ON UPDATE RESTRICT;
insert into WAREHOUSE select rownum from db_class limit 10;
insert into DISTRICT select rownum from db_class limit 10;
alter table  DISTRICT drop CONSTRAINT  fk_district_d_w_id;
alter table  DISTRICT change d_w_id d_w_id varchar(10);
update DISTRICT set d_w_id=null;
DELETE a,b FROM WAREHOUSE a, DISTRICT b where a.W_ID=b.D_W_ID;
alter table  DISTRICT change d_w_id d_w_id char(10);
select count(*) from WAREHOUSE;
select count(*) from DISTRICT;
drop table if exists DISTRICT,WAREHOUSE;




drop table if exists t1,t2,t3;
CREATE TABLE t1 (C1 INT PRIMARY KEY, C2 CHAR(20), C3 BIT(1));
CREATE TABLE t2 (C1 INT PRIMARY KEY, C2 CHAR(20), C3 BIT(2));
CREATE TABLE t3 (C1 INT PRIMARY KEY, C2 CHAR(20), C3 BIT(3));
insert into t1 values (1,'FOO',B'0'), (2,'BAR', B'1');
insert into t2 values (1,'FOO',B'0'), (2,'BAR', B'1');
insert into t3 values (1,'FOO',B'0'), (2,'BAR', B'1');
insert into t1 values (4,'FOO',B'0'), (3,'BAR', B'0');
insert into t2 values (4,'FOO',B'0'), (3,'BAR', B'0');
insert into t3 values (4,'FOO',B'0'), (3,'BAR', B'0');
delete t2 from t1 left join t2 on t1.c1=t2.c1   where t1.c3=B'1'  ;
delete t1,t2 from t1,t2 where t1.c1=t2.c1;
drop table if exists t1,t2,t3;







