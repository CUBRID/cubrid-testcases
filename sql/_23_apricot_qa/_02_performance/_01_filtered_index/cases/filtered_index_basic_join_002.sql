--+ holdcas on;
set  system parameters 'dont_reuse_heap_file=yes';
create table t1(a int,b char(1000), c varchar(1000), d date);
create table t2(a int,b char(1000), c varchar(1000), d date);
create table t3(a int,b char(1000), c varchar(1000), d date);
create table t4(a int,b char(1000), c varchar(1000), d date);
create table t5(a int,b char(1000), c varchar(1000), d date);
create table t6(a int,b char(1000), c varchar(1000), d date);
create table t7(a int,b char(1000), c varchar(1000), d date);
create table t8(a int,b char(1000), c varchar(1000), d date);
create table t9(a int,b char(1000), c varchar(1000), d date);
create table t10(a int,b char(1000), c varchar(1000), d date);

create index idx_t1_a on t1(a)where c > 'A' and b > 'A';
create index idx_t1_ab on t1(a,b)where c > 'A' and b > 'A';
create index idx_t1_abc on t1(a,b,c)where c > 'A' and b > 'A';
create index idx_t1_abcd on t1(a,b,c,d)where c > 'A' and b > 'A';
create index idx_t1_b on t1(b)where c > 'A' and b > 'A';
create index idx_t1_bc on t1(b,c)where c > 'A' and b > 'A';
create index idx_t1_bcd on t1(b,c,d) where c > 'A' and b > 'A';
create index idx_t1_c on t1(c)where c > 'A' and b > 'A';
create index idx_t1_cd on t1(c,d)where c > 'A' and b > 'A';
create index idx_t1_d on t1(d)where c > 'A' and b > 'A';

create index idx_t2_a on t2(a)where c > 'A' and b > 'A';
create index idx_t2_ab on t2(a,b)where c > 'A' and b > 'A';
create index idx_t2_abc on t2(a,b,c)where c > 'A' and b > 'A';
create index idx_t2_abcd on t2(a,b,c,d)where c > 'A' and b > 'A';
create index idx_t2_b on t2(b)where c > 'A' and b > 'A';
create index idx_t2_bc on t2(b,c)where c > 'A' and b > 'A';
create index idx_t2_bcd on t2(b,c,d) where c > 'A' and b > 'A';
create index idx_t2_c on t2(c)where c > 'A' and b > 'A';
create index idx_t2_cd on t2(c,d)where c > 'A' and b > 'A';
create index idx_t2_d on t2(d)where c > 'A' and b > 'A';

create index idx_t3_a on t3(a)where c > 'A' and b > 'A';
create index idx_t3_ab on t3(a,b)where c > 'A' and b > 'A';
create index idx_t3_abc on t3(a,b,c)where c > 'A' and b > 'A';
create index idx_t3_abcd on t3(a,b,c,d)where c > 'A' and b > 'A';
create index idx_t3_b on t3(b)where c > 'A' and b > 'A';
create index idx_t3_bc on t3(b,c)where c > 'A' and b > 'A';
create index idx_t3_bcd on t3(b,c,d) where c > 'A' and b > 'A';
create index idx_t3_c on t3(c)where c > 'A' and b > 'A';
create index idx_t3_cd on t3(c,d)where c > 'A' and b > 'A';
create index idx_t3_d on t3(d)where c > 'A' and b > 'A';

create index idx_t4_a on t4(a)where c > 'A' and b > 'A';
create index idx_t4_ab on t4(a,b)where c > 'A' and b > 'A';
create index idx_t4_abc on t4(a,b,c)where c > 'A' and b > 'A';
create index idx_t4_abcd on t4(a,b,c,d)where c > 'A' and b > 'A';
create index idx_t4_b on t4(b)where c > 'A' and b > 'A';
create index idx_t4_bc on t4(b,c)where c > 'A' and b > 'A';
create index idx_t4_bcd on t4(b,c,d) where c > 'A' and b > 'A';
create index idx_t4_c on t4(c)where c > 'A' and b > 'A';
create index idx_t4_cd on t4(c,d)where c > 'A' and b > 'A';
create index idx_t4_d on t4(d)where c > 'A' and b > 'A';

create index idx_t5_a on t5(a)where c > 'A' and b > 'A';
create index idx_t5_ab on t5(a,b)where c > 'A' and b > 'A';
create index idx_t5_abc on t5(a,b,c)where c > 'A' and b > 'A';
create index idx_t5_abcd on t5(a,b,c,d)where c > 'A' and b > 'A';
create index idx_t5_b on t5(b)where c > 'A' and b > 'A';
create index idx_t5_bc on t5(b,c)where c > 'A' and b > 'A';
create index idx_t5_bcd on t5(b,c,d) where c > 'A' and b > 'A';
create index idx_t5_c on t5(c)where c > 'A' and b > 'A';
create index idx_t5_cd on t5(c,d)where c > 'A' and b > 'A';
create index idx_t5_d on t5(d)where c > 'A' and b > 'A';

create index idx_t6_a on t6(a)where c > 'A' and b > 'A';
create index idx_t6_ab on t6(a,b)where c > 'A' and b > 'A';
create index idx_t6_abc on t6(a,b,c)where c > 'A' and b > 'A';
create index idx_t6_abcd on t6(a,b,c,d)where c > 'A' and b > 'A';
create index idx_t6_b on t6(b)where c > 'A' and b > 'A';
create index idx_t6_bc on t6(b,c)where c > 'A' and b > 'A';
create index idx_t6_bcd on t6(b,c,d) where c > 'A' and b > 'A';
create index idx_t6_c on t6(c)where c > 'A' and b > 'A';
create index idx_t6_cd on t6(c,d)where c > 'A' and b > 'A';
create index idx_t6_d on t6(d)where c > 'A' and b > 'A';

create index idx_t7_a on t7(a)where c > 'A' and b > 'A';
create index idx_t7_ab on t7(a,b)where c > 'A' and b > 'A';
create index idx_t7_abc on t7(a,b,c)where c > 'A' and b > 'A';
create index idx_t7_abcd on t7(a,b,c,d)where c > 'A' and b > 'A';
create index idx_t7_b on t7(b)where c > 'A' and b > 'A';
create index idx_t7_bc on t7(b,c)where c > 'A' and b > 'A';
create index idx_t7_bcd on t7(b,c,d) where c > 'A' and b > 'A';
create index idx_t7_c on t7(c)where c > 'A' and b > 'A';
create index idx_t7_cd on t7(c,d)where c > 'A' and b > 'A';
create index idx_t7_d on t7(d)where c > 'A' and b > 'A';

create index idx_t8_a on t8(a)where c > 'A' and b > 'A';
create index idx_t8_ab on t8(a,b)where c > 'A' and b > 'A';
create index idx_t8_abc on t8(a,b,c)where c > 'A' and b > 'A';
create index idx_t8_abcd on t8(a,b,c,d)where c > 'A' and b > 'A';
create index idx_t8_b on t8(b)where c > 'A' and b > 'A';
create index idx_t8_bc on t8(b,c)where c > 'A' and b > 'A';
create index idx_t8_bcd on t8(b,c,d) where c > 'A' and b > 'A';
create index idx_t8_c on t8(c)where c > 'A' and b > 'A';
create index idx_t8_cd on t8(c,d)where c > 'A' and b > 'A';
create index idx_t8_d on t8(d)where c > 'A' and b > 'A';

create index idx_t9_a on t9(a)where c > 'A' and b > 'A';
create index idx_t9_ab on t9(a,b)where c > 'A' and b > 'A';
create index idx_t9_abc on t9(a,b,c)where c > 'A' and b > 'A';
create index idx_t9_abcd on t9(a,b,c,d)where c > 'A' and b > 'A';
create index idx_t9_b on t9(b)where c > 'A' and b > 'A';
create index idx_t9_bc on t9(b,c)where c > 'A' and b > 'A';
create index idx_t9_bcd on t9(b,c,d) where c > 'A' and b > 'A';
create index idx_t9_c on t9(c)where c > 'A' and b > 'A';
create index idx_t9_cd on t9(c,d)where c > 'A' and b > 'A';
create index idx_t9_d on t9(d)where c > 'A' and b > 'A';

create index idx_t10_a on t10(a)where c > 'A' and b > 'A';
create index idx_t10_ab on t10(a,b)where c > 'A' and b > 'A';
create index idx_t10_abc on t10(a,b,c)where c > 'A' and b > 'A';
create index idx_t10_abcd on t10(a,b,c,d)where c > 'A' and b > 'A';
create index idx_t10_b on t10(b)where c > 'A' and b > 'A';
create index idx_t10_bc on t10(b,c)where c > 'A' and b > 'A';
create index idx_t10_bcd on t10(b,c,d) where c > 'A' and b > 'A';
create index idx_t10_c on t10(c)where c > 'A' and b > 'A';
create index idx_t10_cd on t10(c,d)where c > 'A' and b > 'A';
create index idx_t10_d on t10(d)where c > 'A' and b > 'A';


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


--TEST:  should not use any index  ;
select /*+ RECOMPILE */count(t1.d||t2.d||t3.d||t4.d||t5.d||t6.d||t7.d||t8.d||t9.d||t10.d) 
  from t1,t2,t3,t4,t5,t6,t7,t8,t9,t10 
  where
  t1.c > 'A' and t1.b > 'A'
  and t2.c > 'A' and t2.b > 'A'
  and t3.c > 'A' and t3.b > 'A'
  and t4.c > 'A' and t4.b > 'A'
  and t5.c > 'A' and t5.b > 'A'
  and t6.c > 'A' and t6.b > 'A'
  and t7.c > 'A' and t7.b > 'A'
  and t8.c > 'A' and t8.b > 'A'
  and t9.c > 'A' and t9.b > 'A'
  and t10.c > 'A' and t10.b > 'A';

--TEST:  should use index idx_t1_bcd and idx_t2_bcd,idx_t3_bcd ... ,idx_t10_bcd ;
select /*+ RECOMPILE */count(t1.d||t2.d||t3.d||t4.d||t5.d||t6.d||t7.d||t8.d||t9.d||t10.d) 
  from t1,t2,t3,t4,t5,t6,t7,t8,t9,t10 
  where
  t1.c > 'A' and t1.b > 'A'
  and t2.c > 'A' and t2.b > 'A'
  and t3.c > 'A' and t3.b > 'A'
  and t4.c > 'A' and t4.b > 'A'
  and t5.c > 'A' and t5.b > 'A'
  and t6.c > 'A' and t6.b > 'A'
  and t7.c > 'A' and t7.b > 'A'
  and t8.c > 'A' and t8.b > 'A'
  and t9.c > 'A' and t9.b > 'A'
  and t10.c > 'A' and t10.b > 'A' using index idx_t1_bcd,idx_t2_bcd,idx_t3_bcd,idx_t4_bcd,idx_t5_bcd,idx_t6_bcd,idx_t7_bcd,idx_t8_bcd,idx_t9_bcd,idx_t10_bcd;
  --TEST:  should use index idx_t1_bcd and idx_t2_bcd,idx_t3_bcd ... ,idx_t10_bcd ;
select /*+ RECOMPILE */count(t1.d||t2.d||t3.d||t4.d||t5.d||t6.d||t7.d||t8.d||t9.d||t10.d) 
  from t1,t2,t3,t4,t5,t6,t7,t8,t9,t10 
  where
  t1.c > 'A' and t1.b > 'A'
  and t2.c > 'A' and t2.b > 'A'
  and t3.c > 'A' and t3.b > 'A'
  and t4.c > 'A' and t4.b > 'A'
  and t5.c > 'A' and t5.b > 'A'
  and t6.c > 'A' and t6.b > 'A'
  and t7.c > 'A' and t7.b > 'A'
  and t8.c > 'A' and t8.b > 'A'
  and t9.c > 'A' and t9.b > 'A'
  and t10.c > 'A' and t10.b > 'A';
  
  --TEST:  should not use any index;
select /*+ RECOMPILE */count(t1.d||t2.d||t3.d||t4.d||t5.d||t6.d||t7.d||t8.d||t9.d||t10.d) 
  from t1,t2,t3,t4,t5,t6,t7,t8,t9,t10 
  where
  t1.c > 'A' and t1.b > 'A'
  and t2.c > 'A' and t2.b > 'A'
  and t3.c > 'A' and t3.b > 'A'
  and t4.c > 'A' and t4.b > 'A'
  and t5.c > 'A' and t5.b > 'A'
  and t6.c > 'A' and t6.b > 'A'
  and t7.c > 'A' and t7.b > 'A'
  and t8.c > 'A' and t8.b > 'A'
  and t9.c > 'A' and t9.b > 'A'
  and t10.c > 'A' and t10.b > 'A' using index idx_t1_abcd,idx_t2_abcd,idx_t3_abcd,idx_t4_abcd,idx_t5_abcd,idx_t6_abcd,idx_t7_abcd,idx_t8_abcd,idx_t9_abcd,idx_t10_abcd;
    
  --TEST:  should not use any index;
select /*+ RECOMPILE */count(t1.d||t2.d||t3.d||t4.d||t5.d||t6.d||t7.d||t8.d||t9.d||t10.d) 
  from t1,t2,t3,t4,t5,t6,t7,t8,t9,t10 
  where
  t1.c > 'A' and t1.b > 'A'
  and t2.c > 'A' and t2.b > 'A'
  and t3.c > 'A' and t3.b > 'A'
  and t4.c > 'A' and t4.b > 'A'
  and t5.c > 'A' and t5.b > 'A'
  and t6.c > 'A' and t6.b > 'A'
  and t7.c > 'A' and t7.b > 'A'
  and t8.c > 'A' and t8.b > 'A'
  and t9.c > 'A' and t9.b > 'A'
  and t10.c > 'A' and t10.b > 'A'��
  
  
  --TEST:  should not use any index;
select /*+ RECOMPILE */count(t1.d||t2.d||t3.d||t4.d||t5.d||t6.d||t7.d||t8.d||t9.d||t10.d) 
  from t1,t2,t3,t4,t5,t6,t7,t8,t9,t10 
  where
  t1.c > 'A' and t1.b > 'A'
  and t2.c > 'A' and t2.b > 'A'
  and t3.c > 'A' and t3.b > 'A'
  and t4.c > 'A' and t4.b > 'A'
  and t5.c > 'A' and t5.b > 'A'
  and t6.c > 'A' and t6.b > 'A'
  and t7.c > 'A' and t7.b > 'A'
  and t8.c > 'A' and t8.b > 'A'
  and t9.c > 'A' and t9.b > 'A'
  and t10.c > 'A' and t10.b > 'A' using index idx_t1_abc,idx_t2_abc,idx_t3_abc,idx_t4_abc,idx_t5_abc,idx_t6_abc,idx_t7_abc,idx_t8_abc,idx_t9_abc,idx_t10_abc;

drop table t1,t2,t3,t4,t5,t6,t7,t8,t9,t10;

set  system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;
