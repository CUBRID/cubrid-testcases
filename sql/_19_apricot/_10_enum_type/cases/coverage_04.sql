set system parameters 'create_table_reuseoid=no';
--
create table t1(e enum('Yes', 'No', 'Cancel'));
insert into t1 values(2), (1), (3);
create index idx on t1(e);
update statistics on t1;

create view v as select * from t1;
select * from v order by 1;

update v set e=1 where e='No';
select * from v order by 1;

drop view v;
drop table t1;
set system parameters 'create_table_reuseoid=yes';
