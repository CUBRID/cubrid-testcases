set system parameters 'create_table_reuseoid=no';
--update views with check option



create table t1(a int);
insert into t1 values(1), (2), (3), (4);

create table t2(b int);
insert into t2 values(2), (4), (6);


create view v1 as select * from t1 where a<10 with check option;
create view v2 as select * from t2 where b<8 with check option;

select * from v1 order by 1;
select * from v2 order by 1;


select * from v1, v2 where v1.a=v2.b order by 1;

--TEST: error, update 1 view, check option exception.
update v1, v2 set v1.a=100 where v1.a=v2.b;
--TEST: update 1 view, 2 rows affected.
update v1, v2 set v1.a=6 where v1.a=v2.b;
select if(count(*)=2, 'ok', 'nok') from v1 where a=6;

alter view v2 as select * from t2 where b>1;
--TEST: error, update 2 views, check option exception.
update v1, v2 set v1.a=4, v2.b=1 where v1.a=v2.b;
--TEST: update 2 views, 3 rows affected
update v1, v2 set v1.a=4, v2.b=8 where v1.a=v2.b;
select if(count(*)=2, 'ok', 'nok') from v1 where a=4;
select if(count(*)=1, 'ok', 'nok') from v2 where b=8;



drop table if exists t1, t2;
drop view v1, v2;

set system parameters 'create_table_reuseoid=yes';
