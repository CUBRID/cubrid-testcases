create table basic(id int);
insert into basic values(1);
insert into basic values(2);
insert into basic values(3);
insert into basic values(4);

CREATE TABLE t1 (i int);
CREATE TABLE t2 (i int);
create trigger ins after insert on t1 execute insert into t2(i) values(1);
insert into t1 select id from basic;
drop trigger ins;
drop table basic;
drop table t1;
drop table t2;


--test 2
create class source_table (a int, b int, c int);
create class target_table (a int, b int, c int);
insert into source_table values (1,1,1);
insert into source_table values (1,3,2);
insert into source_table values (2,4,5);
insert into source_table values (3,1,3);
insert into target_table values (1,1,4);
insert into target_table values (1,2,5);
insert into target_table values (1,3,2);
insert into target_table values (3,1,6);
insert into target_table values (5,5,2);

merge into target_table tt using source_table st on (st.a=tt.a and st.b=tt.b) when matched then update set tt.c=st.c when not matched then insert values (6,6,6);
drop table source_table;
drop table target_table;

--test 3
CREATE TABLE a_tbl(id INT NOT NULL DEFAULT 0 PRIMARY KEY,phone VARCHAR(10));
INSERT INTO a_tbl VALUES(1,'111-1111'), (2,'222-2222'), (3, '333-3333');
CREATE TABLE new_tbl1 AS SELECT * FROM a_tbl;
drop table a_tbl;
drop table new_tbl1;

--test 4
create table basic(id int);
insert into basic values(1);
insert into basic values(2);
insert into basic values(3);
insert into basic values(4);
CREATE TABLE t1 (i int);
insert into t1 select id from basic;
drop table basic;
drop table t1;
