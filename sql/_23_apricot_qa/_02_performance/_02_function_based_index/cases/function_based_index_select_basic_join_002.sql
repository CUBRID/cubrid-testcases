--+ holdcas on;
create table t1(a int,b varchar(1000), c varchar(1000), d date);
create table t2(a int,b varchar(1000), c varchar(1000), d date);
create table t3(a int,b varchar(1000), c varchar(1000), d date);
create table t4(a int,b varchar(1000), c varchar(1000), d date);
create table t5(a int,b varchar(1000), c varchar(1000), d date);
create table t6(a int,b varchar(1000), c varchar(1000), d date);
create table t7(a int,b varchar(1000), c varchar(1000), d date);
create table t8(a int,b varchar(1000), c varchar(1000), d date);
create table t9(a int,b varchar(1000), c varchar(1000), d date);
create table t10(a int,b varchar(1000), c varchar(1000), d date);


create index idx_t1_b on t1(lower(b));
create index idx_t1_c on t1(UPPER(c));

create index idx_t2_b on t2(lower(b));
create index idx_t2_c on t2(UPPER(c));


create index idx_t3_b on t3(lower(b));
create index idx_t3_c on t3(UPPER(c));


create index idx_t4_b on t4(lower(b));
create index idx_t4_c on t4(UPPER(c));

create index idx_t5_b on t5(lower(b));
create index idx_t5_c on t5(UPPER(c));

create index idx_t6_b on t6(lower(b));
create index idx_t6_c on t6(UPPER(c));


create index idx_t7_b on t7(lower(b));
create index idx_t7_c on t7(UPPER(c));

create index idx_t8_b on t8(lower(b));
create index idx_t8_c on t8(UPPER(c));


create index idx_t9_b on t9(lower(b));
create index idx_t9_c on t9(UPPER(c));


create index idx_t10_b on t10(lower(b));
create index idx_t10_c on t10(UPPER(c));


insert into t1 values (1,'Y', 'Monday', DATE('2010-10-01'));
insert into t1 values (2,'N', 'Friday', DATE('2010-10-02'));
insert into t2 values (3,'Y', 'Monday', DATE('2010-10-03'));
insert into t2 values (4,'N', 'Friday', DATE('2010-10-04'));
insert into t3 values (5,'Y', 'Monday', DATE('2010-10-05'));
insert into t3 values (6,'N', 'Friday', DATE('2010-10-06'));
insert into t4 values (7,'Y', 'Monday', DATE('2010-10-07'));
insert into t4 values (8,'N', 'Friday', DATE('2010-10-08'));
insert into t5 values (9,'Y', 'Monday', DATE('2010-10-09'));
insert into t5 values (10,'N', 'Friday', DATE('2010-10-10'));
insert into t6 values (11,'Y', 'Monday', DATE('2010-10-11'));
insert into t6 values (12,'N', 'Friday', DATE('2010-10-12'));
insert into t7 values (13,'Y', 'Monday', DATE('2010-10-13'));
insert into t7 values (14,'N', 'Friday', DATE('2010-10-14'));
insert into t8 values (15,'Y', 'Monday', DATE('2010-10-15'));
insert into t8 values (16,'N', 'Friday', DATE('2010-10-16'));
insert into t9 values (17,'Y', 'Monday', DATE('2010-10-17'));
insert into t9 values (18,'N', 'Friday', DATE('2010-10-18'));
insert into t10 values (19,'Y', 'Monday', DATE('2010-10-19'));
insert into t10 values (20,'N', 'Friday', DATE('2010-10-20'));


select count(t1.d||t2.d||t3.d||t4.d||t5.d||t6.d||t7.d||t8.d||t9.d||t10.d) 
  from t1,t2,t3,t4,t5,t6,t7,t8,t9,t10 
  where
  UPPER(t1.c) > 'A' and lower(t1.b) > 'A'
  and UPPER(t2.c) > 'A' and lower(t2.b) > 'A'
  and UPPER(t3.c) > 'A' and lower(t3.b) > 'A'
  and UPPER(t4.c) > 'A' and lower(t4.b) > 'A'
  and UPPER(t5.c) > 'A' and lower(t5.b) > 'A'
  and UPPER(t6.c) > 'A' and lower(t6.b) > 'A'
  and UPPER(t7.c) > 'A' and lower(t7.b) > 'A'
  and UPPER(t8.c) > 'A' and lower(t8.b) > 'A'
  and UPPER(t9.c) > 'A' and lower(t9.b) > 'A'
  and UPPER(t10.c) > 'A' and lower(t10.b) > 'A';



drop table t1,t2,t3,t4,t5,t6,t7,t8,t9,t10;

commit;
--+ holdcas off;
