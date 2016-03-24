create table t1(a varchar(10),b int);

insert into t1 value('SQL',1);

create index i_t1_a2a on t1(lower(a));

create index i_t1_a2b on t1(b) where b > 0;

SHOW INDEXES FROM t1;

create table t2 like t1;

SHOW INDEXES FROM t2;

insert into t2 select * from t1 where lower(a)>'0';

select /*+ RECOMPILE */ count(*) from t2 where lower(a)>'0';

select /*+ RECOMPILE */ count(*) from t2 where b > 0 using index i_t1_a2b(+);

drop table t1, t2;

create table t1(a varchar(10),b int);
insert into t1 value('SQL',1);
create index i_t1_a2a on t1(lower(a));
create table t2 like t1;
insert into t2 select * from t1 where lower(a)>'0' ;
set optimization level 513;
select /*+ RECOMPILE */ count(*) from t1 where lower(a)>'0' ;
-- test: we expect the statement should use index
select /*+ RECOMPILE */ count(*) from t2 where lower(a)>'0' ;
drop table t1;
drop table t2;

