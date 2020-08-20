set system parameters 'create_table_reuseoid=no';
--+ holdcas on;
drop table if exists t;
drop table if exists foo;

create class foo(
        col1 char(20),
        col2 varchar(20),
        col3 enum ('a', 'b', 'c'),
        col4 bit(8),
        col5 bit varying(8),
        col6 numeric,
        col7 integer,
        col8 smallint,   
	col9 monetary, 
        col10 float,
        col11 double,
        col12 date,
        col13 time,
        col14 timestamp,
        col15 set,
        col16 multiset,
        col17 sequence,
        col18 blob,
        col19 clob,
 	col20 datetime,
        col21 string,
        col22 bigint
);

create table t(a int, b char(10));
insert into t values(1, 'abc');
select t into var from t;

insert into foo(col1) values(var); 
insert into foo(col2) values(var); 
insert into foo(col3) values(var); 
insert into foo(col4) values(var); 
insert into foo(col5) values(var); 
insert into foo(col6) values(var); 
insert into foo(col7) values(var); 
insert into foo(col8) values(var); 
insert into foo(col9) values(var); 
insert into foo(col10) values(var); 
insert into foo(col11) values(var); 
insert into foo(col12) values(var); 
insert into foo(col13) values(var); 
insert into foo(col14) values(var); 
insert into foo(col15) values(var); 
insert into foo(col16) values(var); 
insert into foo(col17) values(var); 
insert into foo(col18) values(var); 
insert into foo(col19) values(var); 
insert into foo(col20) values(var); 
insert into foo(col21) values(var); 
insert into foo(col22) values(var); 


drop table foo;
drop table t;

--+ holdcas off;
set system parameters 'create_table_reuseoid=yes';
