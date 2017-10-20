--+ holdcas on;
set system parameters 'insert_execution_mode=7';

create table ids (id int);
alter table ids change column id id int default 22;
insert into ids default values;
select * from ids order by id;

drop table ids;


create table ids (id int default 10);
insert into ids default;
alter table ids change column id id int default 22;
insert into ids default values;
select * from ids order by id;

drop table ids;


create table foo(name char(20) default 'aaa');
insert into foo default;
alter table foo change column name name char(20) default 'abc';
insert into foo default;
select * from foo order by name;

drop table foo;

set system parameters 'insert_execution_mode=3';
commit;
--+ holdcas off;
