--+ holdcas on;

drop table if exists t;

create table t(s1 varchar,s2 char(500));

insert into t values(repeat('a',200),repeat('b',200));

insert into t values(repeat('b',300),repeat('c',300));

select disk_size() from t;

select disk_size(s1),disk_size(s2) from t order by 1;

select t into :a from t order by s1 desc limit 1;

select disk_size(:a.s1),:a.s1;

create index idx_t on t(s1,s2) where disk_size(s2) > 10;

drop t;


-- disk_size with operation +,-,*,/,>,<...
drop table if exists t1;

create table t1(s1 varchar,i1 int,s2 char(200),s3 nchar(100),s4 nchar varying(500));

insert into t1 values(null,1,null,null,null);

insert into t1 values('',-1,'',n'',n'');

insert into t1 values(repeat('a',300),0,repeat('a',300),repeat(n'a',300),repeat(n'a',300));

select disk_size(s1),disk_size(i1),disk_size(s2),disk_size(s3),disk_size(s4) from t1;

select disk_size(s1)+20 from t1;

select disk_size(s1)-20 from t1;

select disk_size(s1)*20 from t1;

select disk_size(s1)/20 from t1;

select s1 from t1 where disk_size(s1) > 24 order by s1;

select s1 from t1 where disk_size(s1) >= 24 order by s1;

select s1 from t1 where disk_size(s1) < 24 order by s1;

select s1 from t1 where disk_size(s1) <= 24 order by s1;

select s1 from t1 where disk_size(s1) <> 24 order by s1;

select disk_size(abc) from t1;

select disk_size(123) from t1;

drop t1;


drop table if exists t2;

create table t2(i1 int,s1 string);

insert into t2 values(1,repeat('abc',100));

insert into t2 values(2,repeat('abc',100));

insert into t2 values(3,repeat('def',100));

create index idx_t2 on t2(s1);

select disk_size(s1) from t2 where s1 like 'abc%';

select disk_size(substr(s1,6,100)) from t2 order by i1;

drop t2;


-- prepare
prepare st from 'select disk_size(?)';

execute st using 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';

deallocate prepare st;


-- session variable
set @a=repeat('a',300);

select @a,disk_size(@a);

select @a,disk_size(cast(@a as char(100)));


--+ holdcas off;