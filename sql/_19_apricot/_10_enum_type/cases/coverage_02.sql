set system parameters 'create_table_reuseoid=no';
create table t (e enum ('Yes', 'No', 'Cancel'));
insert into t values(1);
insert into t values(2);
insert into t values(3);

insert into t values(1);
insert into t values(2);
insert into t values(3);

insert into t values(1);
insert into t values(2);
insert into t values(3);

create view v as select e from t;

select * from v order by 1;

drop view v;

create view v as select e from t where e < 3;

select * from v order by 1;

delete from v;

select * from v order by 1;

insert into v values (1);

select * from v order by 1;

drop view v;

create view v as select e from t where e < 3 with check option;

insert into v values (1);

select * from v order by 1;

insert into v values (3);

select * from v order by 1;

drop view v;

drop table t;
set system parameters 'create_table_reuseoid=yes';
