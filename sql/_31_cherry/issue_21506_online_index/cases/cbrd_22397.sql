drop table if exists t1;

create table t1 (a int primary key auto_increment, b int, c char(250));

insert into t1(b,c) values (1,'aaaaaaa');

create unique index idx_t1_b on t1(a,b,c desc) with online;

create unique index idx_t1_b_1 on t1(a,b,c desc) with online;

update statistics on t1;
show index from t1;

select index_name,status from db_index where class_name = 't1'
order by index_name;

drop t1;
