
create table t1 (a int, b varchar(100));

insert into t1 values (0, chr(0));
insert into t1 values (1, chr(1));
insert into t1 values (2, chr(2));
insert into t1 values (32, chr(32));
insert into t1 values (33, chr(33));

--test: incorrect data result occur
select * from t1 order by b  asc;
drop table t1;
