drop table if exists foo;
create table foo ( a integer, b integer );
insert into foo values ( 1, null );
insert into foo values ( 2, null );
insert into foo values ( null, null );
alter table foo add primary key ( a, b );
drop table if exists foo;
