--+ holdcas on;
--test about all types


set system parameters 'add_column_update_hard_default = yes';

create table foo(a int);
insert into foo values(100);
select * from foo;

--numeric types
alter table foo add column col1 int not null;
alter table foo add column col2 float not null;
alter table foo add column col3 double not null;
alter table foo add column col4 smallint not null;
alter table foo add column col5 numeric not null;
alter table foo add column col6 monetary not null;
alter table foo add column col7 bigint not null;

select * from foo;

--string types
alter table foo add column col8 char(20) not null;
alter table foo add column col9 varchar not null;
alter table foo add column col10 nchar(20) not null;
alter table foo add column col11 nchar varying not null;

select col8, col9, col10, col11 from foo;

--bit types
alter table foo add column col12 bit(20) not null;
alter table foo add column col13 bit varying not null;

select col12, col13 from foo;

--date/time types
alter table foo add column col14 date not null;
alter table foo add column col15 time not null;
alter table foo add column col16 timestamp not null;
alter table foo add column col17 datetime not null;

select col14, col15, col16, col17 from foo;

--collection types
alter table foo add column col18 set(int) not null;
alter table foo add column col19 multiset(char(20)) not null;
alter table foo add column col20 sequence(smallint) not null;

select col18, col19, col20 from foo;

--blob/clob
alter table foo add column col21 blob not null;
alter table foo add column col22 clob not null;

select col21, col22 from foo;

select * from foo;
desc foo;

drop table foo;

set system parameters 'add_column_update_hard_default = no';
commit;
--+ holdcas off;
