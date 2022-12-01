drop table if exists t1;

create table t1 (a int primary key auto_increment, b int, c char(250));

insert into t1(b,c) values (1,'aaaaaaa');

insert into t1(b,c) values (1,'aaaaaaa');

create unique index idx_t1_b on t1(b desc) with online;

update statistics on t1;
show index from t1;

delete from t1 where a=1 limit 1;

create unique index idx_t1_b on t1(b desc) with online;

update statistics on t1;
show index from t1;

drop t1;
