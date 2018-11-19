drop table if exists t1;

create table t1 (a int primary key auto_increment, b int, c char(250));

insert into t1(b,c) values (1,'aaaaaaa');

insert into t1(b,c) values (1,'aaaaaaa');

create unique index idx_t1_b on t1(b desc) with online;

delete from t1;

create unique index idx_t1_b on t1(b desc) with online;

insert into t1(b,c) values (1,'aaaaaaa');

insert into t1(b,c) values (1,'aaaaaaa');

insert into t1(b,c) values (-1,'aaaaaaa');

drop index idx_t1_b on t1;

create unique index idx_t1_b on t1(b desc) with online;

create unique index idx_t1_ab on t1(b desc,c) with online;

select * from t1 where b > 0;

drop t1;
