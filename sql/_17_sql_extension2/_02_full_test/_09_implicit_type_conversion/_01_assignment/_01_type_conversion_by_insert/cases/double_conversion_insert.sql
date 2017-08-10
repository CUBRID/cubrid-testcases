--test implicit type conversion of double type



create table double_conversion(
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
insert into double_conversion(col1) values (cast(1234.5678901 as double));
--[er]date
insert into double_conversion(col2) values (cast(1234.5678901 as double));
--[er]time
insert into double_conversion(col3) values (cast(1234.5678901 as double));
--[er]timestamp
insert into double_conversion(col4) values (cast(1234.5678901 as double));
--[nr]double
insert into double_conversion(col5) values (cast(1234.5678901 as double));
--[ok]float
insert into double_conversion(col6) values (cast(1234.5678901 as double));
select col6 from double_conversion order by 1;
--[ok]numeric
insert into double_conversion(col7) values (cast(1234.5678901 as double));
select col7 from double_conversion order by 1;
--[ok]bigint
insert into double_conversion(col8) values (cast(1234.5678901 as double));
select col8 from double_conversion order by 1;
--[ok]int
insert into double_conversion(col9) values (cast(1234.5678901 as double));
select col9 from double_conversion order by 1;
--[ok]short
insert into double_conversion(col10) values (cast(1234.5678901 as double));
select col10 from double_conversion order by 1;
--[ok]monetary
insert into double_conversion(col11) values (cast(1234.5678901 as double));
select col11 from double_conversion order by 1;
--[er]bit
insert into double_conversion(col12) values (cast(1234.5678901 as double));
--[er]varbit
insert into double_conversion(col13) values (cast(1234.5678901 as double));
--[ok]char
insert into double_conversion(col14) values (cast(1234.5678901 as double));
select col14 from double_conversion order by 1;
--[ok]varchar
insert into double_conversion(col15) values (cast(1234.5678901 as double));
select col15 from double_conversion order by 1;
--[ok]nchar
insert into double_conversion(col16) values (cast(1234.5678901 as double));
select col16 from double_conversion order by 1;
--[ok]varnchar
insert into double_conversion(col17) values (cast(1234.5678901 as double));
select col17 from double_conversion order by 1;
--[er]set
insert into double_conversion(col18) values (cast(1234.5678901 as double));
--[er]multiset
insert into double_conversion(col19) values (cast(1234.5678901 as double));
--[er]list
insert into double_conversion(col20) values (cast(1234.5678901 as double));
--[er]sequence
insert into double_conversion(col21) values (cast(1234.5678901 as double));
--[er]blob
insert into double_conversion(col22) values (cast(1234.5678901 as double));
--[er]clob
insert into double_conversion(col23) values (cast(1234.5678901 as double));



drop table double_conversion;
	
