--+ holdcas on;

set system parameters 'alter_table_change_type_strict=yes';
drop table if exists foo;
create table foo(a int auto_increment, b char(20), c smallint default 22)auto_increment=100;
insert into foo(b) values('aaa');

alter table foo change a aa int auto_increment;
alter table foo modify b char(10) default 'kkk';

drop table if exists foo;
--can't create the table
create table foo(a int auto_increment, b char(20), c smallint default 22)auto_increment=100;

set system parameters 'alter_table_change_type_strict=no';
drop table if exists foo;
create table foo(a int auto_increment, b char(20), c smallint default 22)auto_increment=100;

select * from db_serial order by 1;
drop serial foo_ai_a;

drop table if exists foo;
set system parameters 'alter_table_change_type_strict=no';

--+ holdcas off;
commit;
