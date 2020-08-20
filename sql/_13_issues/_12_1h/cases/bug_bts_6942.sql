set system parameters 'create_table_reuseoid=no';
--TEST: Accessing deleted object error occurs when trying to update a view.


create table foo(a int);
insert into foo values(3);
create view v as select * from foo where a <2;
update v set a=3;

drop view v;
create view v as select * from foo where a <2;
update foo set a=1;
update v set a=3;
select if(count(*)=0, 'ok', 'nok') from v order by 1;
select if(count(*)=1, 'ok', 'nok') from foo order by 1;


drop view v;
create view v as select * from foo where a <2;
update foo set a=1;
update v set a=3;
select if(count(*)=0, 'ok', 'nok') from v order by 1;
select if(count(*)=1, 'ok', 'nok') from foo order by 1;


drop view v;
drop table foo;
set system parameters 'create_table_reuseoid=yes';
