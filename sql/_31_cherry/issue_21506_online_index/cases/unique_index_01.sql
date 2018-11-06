drop table if exists t1;

create table t1(id int);

create unique index idx1 on t1(id) with online;

insert into t1 values(1),(2),(3);

create unique index idx2 on t1(id) with online;

select sum(set{id}) into :s from t1 ignore index (idx1) where id > -999 order by 1; 

select sum(set{id}) into :i from t1 force index (idx1) where id > -999 order by 1;

select if (:s = :i, 'OK', 'NOK');

drop t1;


drop table if exists t2;

create table t2(a int primary key,b varchar(50));

create unique index idx1 on t2(a,b) with online;

insert into t2 values(1,'a'),(2,'b');

create unique index idx2 on t2(a,b) with online;

select sum(set{a}) into :s2 from t2 ignore index (idx2) where a > -999 order by 1;

select sum(set{a}) into :i2 from t2 force index (idx2) where a > -999 order by 1;

select if (:s2 = :i2, 'OK', 'NOK');


drop t2;
