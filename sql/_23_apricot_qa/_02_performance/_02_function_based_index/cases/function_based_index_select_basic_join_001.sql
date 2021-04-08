--+ holdcas on;
create table t1(a double,b varchar(1000), c varchar(1000), d date);
create table t2(a double,b varchar(1000), c varchar(1000), d date);

create index idx_t1_a on t1(log2(a));
create index idx_t1_b on t1(lower(b));
create index idx_t1_c on t1(lower(c));
create index idx_t1_d on t1(DAY(d));

create index idx_t2_a on t2(log2(a));
create index idx_t2_b on t2(lower(b));
create index idx_t2_c on t2(lower(c));
create index idx_t2_d on t2(DAY(d));

insert into t1 values (1,'Y', 'Monday', DATE('2010-10-27'));
insert into t1 values (2,'N', 'Friday', DATE('2010-10-28'));
insert into t2 values (3,'Y', 'Monday', DATE('2010-10-29'));
insert into t2 values (4,'N', 'Friday', DATE('2010-10-30'));

--TEST:  should not use index
select /*+ RECOMPILE */ count(t1.a||t1.b||t1.c||t2.b||t2.c) from t1,t2 ;

--TEST:  should not use index
select /*+ RECOMPILE */ count(t1.a||t1.b||t1.c||t2.d||t2.a||t2.b||t2.c||t2.d) from t1,t2 ;

--TEST:  should not use index
select /*+ RECOMPILE */ count(t1.a||t2.a) from t1,t2 ;

--TEST:  should use index idx_t2_a
select /*+ RECOMPILE */ count(t1.a) from t1,t2 where log2(t2.a)>1 ;

--TEST:  should use idx_t2_a 
select /*+ RECOMPILE */ count(t1.a) from t1,t2 where log2(t2.a)>1 and lower(t2.b)>'A' ;

--TEST:  should use index (idx_t1_a or idx_t1_b) and (idx_t2_a or idx_t2_b);
select /*+ RECOMPILE */ count(t1.a) from t1,t2 where log2(t1.a)>1 and lower(t1.b)>'A' and log2(t2.a)>3 and lower(t2.b)>'A' ;

--TEST:  should not use index
select /*+ RECOMPILE */ count(t1.a) from t1,t2 where log2(t1.a) is not null and lower(t1.b) is not null and lower(t1.c) is not null and day(t1.d) is not null ;

--TEST:  should not use index
select /*+ RECOMPILE */ count(t1.a) from t1,t2 where log2(t1.a) is not null and lower(t1.b)is not null and lower(t1.c) is not null and day(t1.d) is not null and log2(t2.a) is not null and lower(t2.b) is not null and lower(t2.c) is not null and day(t2.d) is not null ;

--TEST:  should not use index
select /*+ RECOMPILE */ count(lower(t1.c)) from t1,t2 where log2(t1.a) is not null and lower(t1.b) is not null ;

--TEST:  should not use index
select /*+ RECOMPILE */ count(lower(t1.c)||day(t2.d)) from t1,t2 where log2(t1.a) is not null and lower(t1.b) is not null and log2(t2.a) is not null and lower(t2.b) is not null ;

--TEST:  should not use index
select /*+ RECOMPILE */ count(t1.a) from t1,t2 where day(t1.d) is not null and lower(t1.c) is not null and day(t2.d) is not null and log2(t2.a) is not null ;

--TEST:  should not use index
select /*+ RECOMPILE */ count(t1.a) from t1,t2 where day(t1.d) is not null and lower(t2.c) is not null and lower(t2.b) is not null ;


drop table t1,t2;

commit;
--+ holdcas off;
