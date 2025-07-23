set names utf8;

drop table if exists t;

create table t(i int,s string collate utf8_fr_exp_ab);
insert into t values(1,'è'),(2,'é'),(3,'èa'),(4,'éa');

-- expect: 2 1 4 3
select * from t order by s;

select * from t order by s desc;
drop t;

create table t(i int, s string) collate utf8_fr_exp_ab;
insert into t values
(1,'cotè'),
(2,'côtè'),
(3,'coté'),
(4,'côté');

-- expect: 3 4 1 2
select * from t order by s;

select * from t order by s desc;

drop t;
create table t(i int,s string collate utf8_gen);
insert into t values
(1,'cotè'),
(2,'côtè'),
(3,'coté'),
(4,'côté');

-- expect: 3 4 1 2
select * from t order by s collate utf8_fr_exp_ab;

select * from t order by s collate utf8_fr_exp_ab desc;

drop t;
set names iso88591;
