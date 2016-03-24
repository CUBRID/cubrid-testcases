--+ holdcas on;
set system parameters 'dont_reuse_heap_file=yes';
create table t1(a int,b char(1000), c varchar(1000), d date);
create table t2(a int,b char(1000), c varchar(1000), d date);

create index idx_t1_a on t1(a);
create index idx_t1_ab on t1(a,b);
create index idx_t1_abc on t1(a,b,c);
create index idx_t1_abcd on t1(a,b,c,d);

create index idx_t2_a on t2(a);
create index idx_t2_ab on t2(a,b);
create index idx_t2_abc on t2(a,b,c);
create index idx_t2_abcd on t2(a,b,c,d);
create index idx_t2_bc on t2(b,c);

insert into t1 values (1,'Y', 'Monday', DATE('2010-10-27'));
insert into t1 values (2,'N', 'Friday', DATE('2010-10-28'));
insert into t2 values (3,'Y', 'Monday', DATE('2010-10-29'));
insert into t2 values (4,'N', 'Friday', DATE('2010-10-30'));

--TEST:  should not use index
select /*+ RECOMPILE */ count(t1.a||t1.b||t1.c||t2.b||t2.c) from t1,t2;

--TEST:  should not use index
select /*+ RECOMPILE */ count(t1.a||t1.b||t1.c||t2.d||t2.a||t2.b||t2.c||t2.d) from t1,t2;

--TEST:  should not use index
select /*+ RECOMPILE */ count(t1.a||t2.a) from t1,t2;

--TEST:  should use index idx_t2_a
select /*+ RECOMPILE */ count(t1.a) from t1,t2 where t2.a>3;

--TEST:  should use idx_t2_ab;
select /*+ RECOMPILE */ count(t1.a) from t1,t2 where t2.a>3 and t2.b>'A';

--TEST:  should use index idx_t1_ab and idx_t2_ab;
select /*+ RECOMPILE */ count(t1.a) from t1,t2 where t1.a>1 and t1.b>'A' and t2.a>3 and t2.b>'A';

--TEST:  should use index idx_t1_abcd ;
select /*+ RECOMPILE */ count(t1.a) from t1,t2 where t1.a is not null and t1.b is not null and t1.c is not null and t1.d is not null;

--TEST:  should use index idx_t1_abcd and idx_t2_abcd ;
select /*+ RECOMPILE */ count(t1.a) from t1,t2 where t1.a is not null and t1.b is not null and t1.c is not null and t1.d is not null and t2.a is not null and t2.b is not null and t2.c is not null and t2.d is not null;

--TEST:  should use index idx_t1_abc;
select /*+ RECOMPILE */ count(t1.c) from t1,t2 where t1.a is not null and t1.b is not null;

--TEST:  should use index idx_t1_abc and idx_t2_abcd (oracle is the same);
select /*+ RECOMPILE */ count(t1.c||t2.d) from t1,t2 where t1.a is not null and t1.b is not null and t2.a is not null and t2.b is not null;

--TEST:  should use index idx_t1_abcd and idx_t2_abcd (oracle is the same);
select /*+ RECOMPILE */ count(t1.a) from t1,t2 where t1.d is not null and t1.c is not null and t2.d is not null and t2.a is not null;

--TEST:  should use index idx_t1_abcd and idx_t2_bc
select /*+ RECOMPILE */ count(t1.a) from t1,t2 where t1.d is not null and t2.c is not null and t2.b is not null;


drop table t1,t2;
set system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;
