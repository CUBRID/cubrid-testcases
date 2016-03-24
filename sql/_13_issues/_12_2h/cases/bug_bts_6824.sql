--This case needs to be executed in HA environment to check the data consistency


--test:
create table foo(a int primary key, d timestamp);
insert into foo(a) values(1);

--check
select * from foo;

--test:
alter table foo change d d timestamp default CURRENT_TIMESTAMP;

--check:
insert into foo(a) values(2);
select if(d is not null, 'ok','nok') from foo where a=2;

--test:
drop table foo;

