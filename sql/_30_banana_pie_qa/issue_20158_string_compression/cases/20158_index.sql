--+ holdcas on;

-- test index
drop table if exists t1;

create table t1(i1 int,s1 varchar,s2 string,s3 char(300));

insert into t1 values(1,repeat('a',300),repeat('b',300),repeat('c',300));

insert into t1 values(2,repeat('d',200),repeat('e',300),repeat('f',200));

insert into t1 values(1,repeat('a',300),repeat('b',300),repeat('c',300));

insert into t1 values(2,repeat('d',200),repeat('e',300),repeat('f',200));

insert into t1 values(1,repeat('a',300),repeat('b',300),repeat('c',300));

insert into t1 values(2,repeat('d',200),repeat('e',300),repeat('f',200));

create index idx_t1_1 on t1(s1);

create index idx_t1_2 on t1(s1,s2);

create index idx_t1_3 on t1(i1,s1,s2,s3);

select /*+ recompile */* from t1 where s1>'a' order by s1 limit 2;       

select /*+ recompile */* from t1 where s1>'a' and s2>'a' order by s1,s2 limit 2;

select /*+ recompile */* from t1 where i1=1 and s1>'a' and s2>'a' and s3<'m' order by s1,s2,s3 limit 2;

select /*+ recompile */* from t1 where s1>'a' group by s2 having s2>'b' order by i1;

select /*+ recompile */* from t1 where s1>'a' and s2>'a' group by s3 having s3>'b' order by s1,s2 limit 2;

drop table t1;


-- test unique index
drop table if exists t2;

create table t2(i1 int,s1 varchar,s2 string,s3 char(300));

insert into t2 values(1,repeat('a',300),repeat('b',300),repeat('c',300));

insert into t2 values(2,repeat('d',200),repeat('e',300),repeat('f',200));

create unique index idx_t1_1 on t2(s1);

create unique index idx_t1_2 on t2(s1,s2);

create unique index idx_t1_3 on t2(i1,s1,s2,s3);

select /*+ recompile */* from t2 where s1>'a' order by s1 limit 2;       

select /*+ recompile */* from t2 where s1>'a' and s2>'a' order by s1,s2 limit 2;

select /*+ recompile */* from t2 where i1=1 and s1>'a' and s2>'a' and s3<'m' order by s1,s2,s3 limit 2;

select /*+ recompile */* from t2 where s1>'a' group by s2 having s2>'b' order by s1;

select /*+ recompile */* from t2 where s1>'a' and s2>'a' group by s3 having s3>'b' order by s1,s2 limit 2;

drop table t2;


-- test reverse unique test
drop table if exists t3;

create table t3(i1 int,s1 varchar,s2 string,s3 char(300));

insert into t3 values(1,repeat('a',300),repeat('b',300),repeat('c',300));

insert into t3 values(2,repeat('d',200),repeat('e',300),repeat('f',200));

create reverse unique index idx_t1_1 on t3(s1);

create reverse unique index idx_t1_2 on t3(s1,s2);

create reverse unique index idx_t1_3 on t3(i1,s1,s2,s3);

select /*+ recompile */* from t3 where s1>'a' order by s1 limit 2;       

select /*+ recompile */* from t3 where s1>'a' and s2>'a' order by s1,s2 limit 2;

select /*+ recompile */* from t3 where i1=1 and s1>'a' and s2>'a' and s3<'m' order by s1,s2,s3 limit 2;

select /*+ recompile */* from t3 where s1>'a' group by s2 having s2>'b' order by s1;

select /*+ recompile */* from t3 where s1>'a' and s2>'a' group by s3 having s3>'b' order by s1,s2 limit 2;

drop table t3;


-- filter index
drop table if exists t4;

create table t4(i1 int,s1 string,s2 string);

insert into t4 values(1,repeat('a',300),repeat('b',300));

insert into t4 values(1,repeat('a',300),repeat('b',300));

insert into t4 values(1,repeat('a',300),repeat('b',300));

insert into t4 values(2,repeat('a',300),repeat('b',300));

insert into t4 values(3,repeat('a',300),repeat('b',300)); 

insert into t4 values(4,repeat('a',300),repeat('b',300));  

create index idx_t4 on t4(i1,s1,s2) where i1=1;

select /*+ recompile */* from t4 use index(idx_t4) where s1>'a' and i1=1;

select /*+ recompile */* from t4 where s1>'a' and i1=1 using index idx_t4 keylimit 1,2;

select /*+ recompile */* from t4 use index(idx_t4) where i1=1 and s1>'aa' group by s1 desc order by s2; 

drop t4;



-- function-based index
drop table if exists t5;

create table t5(i1 int,s1 string,s2 string);

insert into t5 values(1,'  '||repeat('a',300)||'     ',repeat('b',300));

insert into t5 values(1,'  '||repeat('a',300)||'     ',repeat('b',300));

insert into t5 values(1,repeat(' ',300),repeat(' ',300));

insert into t5 values(1,repeat(' ',300),repeat(' ',300));

insert into t5 values(2,repeat('a',300),repeat('b',300));

insert into t5 values(3,repeat('a',300),repeat('b',300)); 

insert into t5 values(4,repeat('a',300),repeat('b',300));  

create index idx_t5 on t5(trim(s1),s2);

select /*+ recompile */* from t5 where trim(s1) > 'a' and s2>'b' order by s1 limit 2;

select /*+ recompile */* from t5 where s2>'b' group by s1 having trim(s1)>'a' order by s1,s2 desc;     

drop t5;

--+ holdcas off;