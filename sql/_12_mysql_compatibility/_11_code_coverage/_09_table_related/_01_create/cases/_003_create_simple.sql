create table t1 (id int default 'a');

create table t1 (id int default cast (1 + 'a' as int));

create table t1 (id int default aaaaaa);

drop table t1;
