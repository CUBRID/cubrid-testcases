--case1
CREATE TABLE t1 (a int primary key, b int, key i_t1_b (b), CONSTRAINT fk_t1 FOREIGN KEY (b) REFERENCES t1 (a));
insert into t1 values (1,1);
insert into t1 values (2,3);
select * from t1;
drop table t1;

--case 2
create table t2 (a int primary key, b int, CONSTRAINT fk_t2 FOREIGN KEY (b) REFERENCES t2 (a));
alter table t2 add key i_t2_b (b);
insert into t2 values (1,1);
insert into t2 values (2,3);

select * from t2;
drop table t2;

--case 3
create table t3 (a int primary key, b int, key i_t3_b (b));
alter table t3 add FOREIGN key (b) REFERENCES t3 (a);
insert into t3 values (1,1);
insert into t3 values (2,3);

select * from t3;
drop table t3;
--case 4
create table t4 (a int primary key, b int, key i_t4_b (b));
insert into t4 values (1,2);
alter table t4 add FOREIGN key (b) REFERENCES t4 (a);

select * from t4;
drop table t4;
--case 5
create table t5 (a int primary key, b int, key i_t5_b (b));
insert into t5 values (1,1);
alter table t5 add FOREIGN key (b) REFERENCES t5 (a);
insert into t5 values (2,3);

drop table t5;

--case 6
create table t6 (a int primary key, b int, key i_t6_b (b));
create index t6_index_b1 on t6(b);
create REVERSE index t6_index_b2 on t6(b);

drop table t6;

--case 7
CREATE TABLE t7 (a int primary key, b int, CONSTRAINT fk_t7 FOREIGN KEY (b) REFERENCES t7 (a));
create index t7_index_b1 on t7(b);
create index t7_index_b2 on t7(b);

drop table t7;

--case 8
CREATE TABLE t8 (a int primary key, b int, CONSTRAINT fk_t8 FOREIGN KEY (b) REFERENCES t8 (a));
alter table t8 add FOREIGN key (b) REFERENCES t8 (a);

select * from _db_index where index_name like '%t8%' order by 2;

drop table t8;
--case 9
CREATE TABLE t9 (a int primary key , b int, key i_t9_b (b));
insert into t9 values (1, 2);
ALTER TABLE t9 ADD CONSTRAINT fk FOREIGN KEY (b) REFERENCES t9 (a);
drop table t9;
--case 10
create table t10_1 (a int primary key);
insert into t10_1 values (2);
create table t10_2 (b int primary key);
insert into t10_2 values (1);
alter table t10_2 add constraint foreign key(b) references t10_1(a);

drop table t10_1;
drop table t10_2;
--case 11, create index on multi column

create table t11(a int primary key, b int);
alter table t11 add key i_t11_a_b (a,b);
alter table t11 add foreign key(b) references t11(a);
insert into t11 values(1,1);
insert into t11 values(2,3);
select * from t11;

drop table t11;


