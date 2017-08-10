--test implicit type conversion of timestamp type



create table timestamp_conversion(
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


--[ok]datetime
insert into timestamp_conversion(col1) values (timestamp'2010-11-08 16:47:22 PM');
select col1 from timestamp_conversion order by 1;
--[ok]date
insert into timestamp_conversion(col2) values (timestamp'2010-11-08 16:47:22 PM');
select col2 from timestamp_conversion order by 1;
--[ok]time
insert into timestamp_conversion(col3) values (timestamp'2010-11-08 16:47:22 PM');
select col3 from timestamp_conversion order by 1;
--[nr]timestamp
insert into timestamp_conversion(col4) values (timestamp'2010-11-08 16:47:22 PM');
select col4 from timestamp_conversion order by 1;
--[er]double
insert into timestamp_conversion(col5) values (timestamp'2010-11-08 16:47:22 PM');
--[er]float
insert into timestamp_conversion(col6) values (timestamp'2010-11-08 16:47:22 PM');
--[er]numeric
insert into timestamp_conversion(col7) values (timestamp'2010-11-08 16:47:22 PM');
--[er]bigint
insert into timestamp_conversion(col8) values (timestamp'2010-11-08 16:47:22 PM');
--[er]int
insert into timestamp_conversion(col9) values (timestamp'2010-11-08 16:47:22 PM');
--[er]short
insert into timestamp_conversion(col10) values (timestamp'2010-11-08 16:47:22 PM');
--[er]monetary
insert into timestamp_conversion(col11) values (timestamp'2010-11-08 16:47:22 PM');
--[er]bit
insert into timestamp_conversion(col12) values (timestamp'2010-11-08 16:47:22 PM');
--[er]varbit
insert into timestamp_conversion(col13) values (timestamp'2010-11-08 16:47:22 PM');
--[ok]char
insert into timestamp_conversion(col14) values (timestamp'2010-11-08 16:47:22 PM');
select col14 from timestamp_conversion order by 1;
--[ok]varchar
insert into timestamp_conversion(col15) values (timestamp'2010-11-08 16:47:22 PM');
select col15 from timestamp_conversion order by 1;
--[ok]nchar
insert into timestamp_conversion(col16) values (timestamp'2010-11-08 16:47:22 PM');
select col16 from timestamp_conversion order by 1;
--[ok]varnchar
insert into timestamp_conversion(col17) values (timestamp'2010-11-08 16:47:22 PM');
select col17 from timestamp_conversion order by 1;
--[er]set
insert into timestamp_conversion(col18) values (timestamp'2010-11-08 16:47:22 PM');
--[er]multiset
insert into timestamp_conversion(col19) values (timestamp'2010-11-08 16:47:22 PM');
--[er]list
insert into timestamp_conversion(col20) values (timestamp'2010-11-08 16:47:22 PM');
--[er]sequence
insert into timestamp_conversion(col21) values (timestamp'2010-11-08 16:47:22 PM');
--[er]blob
insert into timestamp_conversion(col22) values (timestamp'2010-11-08 16:47:22 PM');
--[er]clob
insert into timestamp_conversion(col23) values (timestamp'2010-11-08 16:47:22 PM');



drop table timestamp_conversion;
	
