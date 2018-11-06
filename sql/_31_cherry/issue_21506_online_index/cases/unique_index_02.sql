drop table if exists t1;

create table t1(id int);

insert into t1 values(1);

insert into t1 values(1);

insert into t1 values(NULL),(NULL);

create unique index idx1 on t1(id) with online;

update t1 set id=-1 where id=1 limit 1;

create unique index idx1 on t1(id) with online;

select * from t1 order by 1;

select sum(set{id}) into :s from t1 ignore index (idx1) where id > -999 order by 1; 

select sum(set{id}) into :i from t1 force index (idx1) where id > -999 order by 1;

select if (:s = :i, 'OK', 'NOK');

drop t1;
