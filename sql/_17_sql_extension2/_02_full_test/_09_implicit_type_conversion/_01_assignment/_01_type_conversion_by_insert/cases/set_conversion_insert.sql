--test implicit type conversion of set type



create table set_conversion(
	col1 datetime,
	col2 date,
	col3 time,
	col4 timestamp,
	col5 double,
	col6 float,
	col7 numeric,
	col8 bigint,
	col9 int,
	col10 short,
	col11 monetary,
	col12 bit,
	col13 bit varying,
	col14 char(20),
	col15 varchar(20),
	col16 nchar(20),
	col17 nchar varying(20),
	col18 set,
	col19 multiset,
	col20 list,
	col21 sequence,
	col22 blob,
	col23 clob
);


--[er]datetime
insert into set_conversion(col1) values (cast({1, 2, 3, 4, 5} as set));
--[er]date
insert into set_conversion(col2) values (cast({1, 2, 3, 4, 5} as set));
--[er]time
insert into set_conversion(col3) values (cast({1, 2, 3, 4, 5} as set));
--[er]timestamp
insert into set_conversion(col4) values (cast({1, 2, 3, 4, 5} as set));
--[er]double
insert into set_conversion(col5) values (cast({1, 2, 3, 4, 5} as set));
--[er]float
insert into set_conversion(col6) values (cast({1, 2, 3, 4, 5} as set));
--[er]numeric
insert into set_conversion(col7) values (cast({1, 2, 3, 4, 5} as set));
--[er]bigint
insert into set_conversion(col8) values (cast({1, 2, 3, 4, 5} as set));
--[er]int
insert into set_conversion(col9) values (cast({1, 2, 3, 4, 5} as set));
--[er]short
insert into set_conversion(col10) values (cast({1, 2, 3, 4, 5} as set));
--[er]monetary
insert into set_conversion(col11) values (cast({1, 2, 3, 4, 5} as set));
--[er]bit
insert into set_conversion(col12) values (cast({1, 2, 3, 4, 5} as set));
--[er]varbit
insert into set_conversion(col13) values (cast({1, 2, 3, 4, 5} as set));
--[er]char
insert into set_conversion(col14) values (cast({1, 2, 3, 4, 5} as set));
--[er]varchar
insert into set_conversion(col15) values (cast({1, 2, 3, 4, 5} as set));
--[er]nchar
insert into set_conversion(col16) values (cast({1, 2, 3, 4, 5} as set));
--[er]varnchar
insert into set_conversion(col17) values (cast({1, 2, 3, 4, 5} as set));
--[nr]set
insert into set_conversion(col18) values (cast({1, 2, 3, 4, 5} as set));
select col18 from set_conversion order by 1;
--[ok]multiset
insert into set_conversion(col19) values (cast({1, 2, 3, 4, 5} as set));
select col19 from set_conversion order by 1;
--[ok]list
insert into set_conversion(col20) values (cast({1, 2, 3, 4, 5} as set));
select col20 from set_conversion order by 1;
--[ok]sequence
insert into set_conversion(col21) values (cast({1, 2, 3, 4, 5} as set));
select col21 from set_conversion order by 1;
--[er]blob
insert into set_conversion(col22) values (cast({1, 2, 3, 4, 5} as set));
--[er]clob
insert into set_conversion(col23) values (cast({1, 2, 3, 4, 5} as set));


drop table set_conversion;
	
