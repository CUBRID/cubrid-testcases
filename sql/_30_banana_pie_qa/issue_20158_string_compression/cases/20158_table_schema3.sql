--+ holdcas on;

drop table if exists t1;
drop table if exists t2;

create table t1(i1 int,s1 string,s2 char(500));

create table t2(a int,b t1);

insert into t2 values(1,insert into t1 values(1,'a','b'));
insert into t2 values(2,insert into t1 values(1,repeat('a',300),repeat('b',300)));

select i1,disk_size(s1),disk_size(s2),s1,s2 from t1 order by 1, 2;

select a,disk_size(b.s1),disk_size(b.s2),b.s1,b.s2 from t2 order by a;

create index idx_t2 on t2(a,b);

select a,disk_size(b.s1),disk_size(b.s2),b.s1,b.s2 from t2 where b.s2>'a' and b.s1>'a' using index idx_t2 order by a;

alter table t1 add column s3 varchar default repeat('a',1000) after s1;

select disk_size(b.s3),b.s3 from t2;

drop t2;

drop t1;

--+ holdcas off;