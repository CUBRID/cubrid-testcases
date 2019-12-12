--test implicit type conversion of date type



create table date_conversion(
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


--[ok]datetime
insert into date_conversion(col1) values (date'2010-11-08');
select col1 from date_conversion order by 1;
--[nr]date
insert into date_conversion(col2) values (date'2010-11-08');
select col2 from date_conversion order by 1;
--[er]time
insert into date_conversion(col3) values (date'2010-11-08');
--[ok]timestamp
insert into date_conversion(col4) values (date'2010-11-08');
select col4 from date_conversion order by 1;
--[er]double
insert into date_conversion(col5) values (date'2010-11-08');
--[er]float
insert into date_conversion(col6) values (date'2010-11-08');
--[er]numeric
insert into date_conversion(col7) values (date'2010-11-08');
--[er]bigint
insert into date_conversion(col8) values (date'2010-11-08');
--[er]int
insert into date_conversion(col9) values (date'2010-11-08');
--[er]short
insert into date_conversion(col10) values (date'2010-11-08');
--[er]monetary
insert into date_conversion(col11) values (date'2010-11-08');
--[er]bit
insert into date_conversion(col12) values (date'2010-11-08');
--[er]varbit
insert into date_conversion(col13) values (date'2010-11-08');
--[ok]char
insert into date_conversion(col14) values (date'2010-11-08');
select col14 from date_conversion order by 1;
--[ok]varchar
insert into date_conversion(col15) values (date'2010-11-08');
select col15 from date_conversion order by 1;
--[ok]nchar
insert into date_conversion(col16) values (date'2010-11-08');
select col16 from date_conversion order by 1;
--[ok]varnchar
insert into date_conversion(col17) values (date'2010-11-08');
select col17 from date_conversion order by 1;
--[er]set
insert into date_conversion(col18) values (date'2010-11-08');
--[er]multiset
insert into date_conversion(col19) values (date'2010-11-08');
--[er]list
insert into date_conversion(col20) values (date'2010-11-08');
--[er]sequence
insert into date_conversion(col21) values (date'2010-11-08');
--[er]blob
insert into date_conversion(col22) values (date'2010-11-08');
--[er]clob
insert into date_conversion(col23) values (date'2010-11-08');



drop table date_conversion;
	
