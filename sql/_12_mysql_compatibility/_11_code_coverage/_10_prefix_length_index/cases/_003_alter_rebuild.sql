create table t1 (id varchar(22));
create index idx on t1(id(2));

insert into t1 values ('ccbbbb');
insert into t1 values ('aaaaaa');
insert into t1 values ('aabbbb');
insert into t1 values ('aaaaaa');
insert into t1 values ('ccbbbb');

alter index idx on t1 rebuild;

alter index idx_1 on t1 rebuild;

select * from t1 order by id;

drop table t1;
