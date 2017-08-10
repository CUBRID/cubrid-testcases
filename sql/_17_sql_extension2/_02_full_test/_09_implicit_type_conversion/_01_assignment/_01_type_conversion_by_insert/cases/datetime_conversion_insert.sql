--test implicit type conversion of datetime type



create table datetime_conversion(
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
	col14 char(30),
	col15 varchar(30),
	col16 nchar(30),
	col17 nchar varying(30),
	col18 set,
	col19 multiset,
	col20 list,
	col21 sequence,
	col22 blob,
	col23 clob
);


--[nr]datetime
insert into datetime_conversion(col1) values (datetime'11/08/2010 16:10:22.123');
select col1 from datetime_conversion order by 1;
--[ok]date
insert into datetime_conversion(col2) values (datetime'11/08/2010 16:10:22.123');
select col2 from datetime_conversion order by 1;
--[ok]time
insert into datetime_conversion(col3) values (datetime'11/08/2010 16:10:22.123');
select col3 from datetime_conversion order by 1;
--[ok]timestamp
insert into datetime_conversion(col4) values (datetime'11/08/2010 16:10:22.123');
select col4 from datetime_conversion order by 1;
--[er]double
insert into datetime_conversion(col5) values (datetime'11/08/2010 16:10:22.123');
--[er]float
insert into datetime_conversion(col6) values (datetime'11/08/2010 16:10:22.123');
--[er]numeric
insert into datetime_conversion(col7) values (datetime'11/08/2010 16:10:22.123');
--[er]bigint
insert into datetime_conversion(col8) values (datetime'11/08/2010 16:10:22.123');
--[er]int
insert into datetime_conversion(col9) values (datetime'11/08/2010 16:10:22.123');
--[er]short
insert into datetime_conversion(col10) values (datetime'11/08/2010 16:10:22.123');
--[er]monetary
insert into datetime_conversion(col11) values (datetime'11/08/2010 16:10:22.123');
--[er]bit
insert into datetime_conversion(col12) values (datetime'11/08/2010 16:10:22.123');
--[er]varbit
insert into datetime_conversion(col13) values (datetime'11/08/2010 16:10:22.123');
--[ok]char
insert into datetime_conversion(col14) values (datetime'11/08/2010 16:10:22.123');
select col14 from datetime_conversion order by 1;
--[ok]varchar
insert into datetime_conversion(col15) values (datetime'11/08/2010 16:10:22.123');
select col15 from datetime_conversion order by 1;
--[ok]nchar
insert into datetime_conversion(col16) values (datetime'11/08/2010 16:10:22.123');
select col16 from datetime_conversion order by 1;
--[ok]varnchar
insert into datetime_conversion(col17) values (datetime'11/08/2010 16:10:22.123');
select col17 from datetime_conversion order by 1;
--[er]set
insert into datetime_conversion(col18) values (datetime'11/08/2010 16:10:22.123');
--[er]multiset
insert into datetime_conversion(col19) values (datetime'11/08/2010 16:10:22.123');
--[er]list
insert into datetime_conversion(col20) values (datetime'11/08/2010 16:10:22.123');
--[er]sequence
insert into datetime_conversion(col21) values (datetime'11/08/2010 16:10:22.123');
--[er]blob
insert into datetime_conversion(col22) values (datetime'11/08/2010 16:10:22.123');
--[er]clob
insert into datetime_conversion(col23) values (datetime'11/08/2010 16:10:22.123');



drop table datetime_conversion;
	
