--test implicit type conversion of int type



create table int_conversion(
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
insert into int_conversion(col1) values (cast(12345 as int));
--[er]date
insert into int_conversion(col2) values (cast(12345 as int));
--[er]time
insert into int_conversion(col3) values (cast(12345 as int));
--[er]timestamp
insert into int_conversion(col4) values (cast(12345 as int));
--[ok]double
insert into int_conversion(col5) values (cast(12345 as int));
select col5 from int_conversion order by 1;
--[ok]float
insert into int_conversion(col6) values (cast(12345 as int));
select col6 from int_conversion order by 1;
--[ok]numeric
insert into int_conversion(col7) values (cast(12345 as int));
select col7 from int_conversion order by 1;
--[ok]bigint
insert into int_conversion(col8) values (cast(12345 as int));
select col8 from int_conversion order by 1;
--[nr]int
insert into int_conversion(col9) values (cast(12345 as int));
select col9 from int_conversion order by 1;
--[ok]short
insert into int_conversion(col10) values (cast(12345 as int));
select col10 from int_conversion order by 1;
--[ok]monetary
insert into int_conversion(col11) values (cast(12345 as int));
select col11 from int_conversion order by 1;
--[er]bit
insert into int_conversion(col12) values (cast(12345 as int));
--[er]varbit
insert into int_conversion(col13) values (cast(12345 as int));
--[ok]char
insert into int_conversion(col14) values (cast(12345 as int));
select col14 from int_conversion order by 1;
--[ok]varchar
insert into int_conversion(col15) values (cast(12345 as int));
select col15 from int_conversion order by 1;
--[ok]nchar
insert into int_conversion(col16) values (cast(12345 as int));
select col16 from int_conversion order by 1;
--[ok]varnchar
insert into int_conversion(col17) values (cast(12345 as int));
select col17 from int_conversion order by 1;
--[er]set
insert into int_conversion(col18) values (cast(12345 as int));
--[er]multiset
insert into int_conversion(col19) values (cast(12345 as int));
--[er]list
insert into int_conversion(col20) values (cast(12345 as int));
--[er]sequence
insert into int_conversion(col21) values (cast(12345 as int));
--[er]blob
insert into int_conversion(col22) values (cast(12345 as int));
--[er]clob
insert into int_conversion(col23) values (cast(12345 as int));



drop table int_conversion;
	
