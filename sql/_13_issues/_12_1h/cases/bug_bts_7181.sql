set system parameters 'create_table_reuseoid=no';
--TEST: [Multi-table Update] Updating an updatable view failed when it joins with a non-updatable view.


create table t1(a int);
insert into t1 values(1), (2), (3), (4);

create table t2(b int);
insert into t2 values(2), (4), (6);

create view v1 as select * from t1 where a < 200;
create view v2 as select * from t1, t2 where t1.a=t2.b;

update v1, v2 set v1.a=100 where v1.a=v2.b;
select * from v1 order by 1;

drop view v2;
create view v2 as select * from t1 right outer join t2 on t1.a=t2.b;
update v1 right outer join v2 on v1.a=v2.b set v1.a=150, v2.b=100;

select * from v1 order by 1;
select * from v2 order by 1, 2;

drop view v1, v2;
drop table t1, t2;

set system parameters 'create_table_reuseoid=yes';
