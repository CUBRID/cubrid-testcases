--CBRD-22618
drop table if exists t1;
create table t1 (i int, d double);
create index idx on t1 (sqrt(d));
insert into t1 values (4,25), (16,256), (20,400);
alter index idx on t1 invisible;
select * from t1 where sqrt(d) > 5 order by 1;

drop table if exists t1;
create table t1( n DATE );
create index i_t1_a2d on t1(dayofweek(n)) invisible;
select * from t1 where dayofweek(n)=6 ;
drop table if exists t1;


