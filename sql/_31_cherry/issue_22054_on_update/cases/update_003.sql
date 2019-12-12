drop table if exists foo;

create table foo (i int, dt datetime,c timestamp on update current_timestamp);

update foo set i = dt;

insert into foo(i,dt) values(1, now());

update foo set i =dt;
select c from foo;
alter table foo change i i varchar(100);
update foo set i =dt;
select if(c is not null,'ok','nok') from foo;

drop table if exists foo;
