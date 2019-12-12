--test implicit type conversion of time type



create table time_conversion(
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
insert into time_conversion(col1) values (time'16:47:22');
--[er]date
insert into time_conversion(col2) values (time'16:47:22');
--[nr]time
insert into time_conversion(col3) values (time'16:47:22');
select col3 from time_conversion order by 1;
--[er]timestamp
insert into time_conversion(col4) values (time'16:47:22');
--[er]double
insert into time_conversion(col5) values (time'16:47:22');
--[er]float
insert into time_conversion(col6) values (time'16:47:22');
--[er]numeric
insert into time_conversion(col7) values (time'16:47:22');
--[er]bigint
insert into time_conversion(col8) values (time'16:47:22');
--[er]int
insert into time_conversion(col9) values (time'16:47:22');
--[er]short
insert into time_conversion(col10) values (time'16:47:22');
--[er]monetary
insert into time_conversion(col11) values (time'16:47:22');
--[er]bit
insert into time_conversion(col12) values (time'16:47:22');
--[er]varbit
insert into time_conversion(col13) values (time'16:47:22');
--[ok]char
insert into time_conversion(col14) values (time'16:47:22');
select col14 from time_conversion order by 1;
--[ok]varchar
insert into time_conversion(col15) values (time'16:47:22');
select col15 from time_conversion order by 1;
--[ok]nchar
insert into time_conversion(col16) values (time'16:47:22');
select col16 from time_conversion order by 1;
--[ok]varnchar
insert into time_conversion(col17) values (time'16:47:22');
select col17 from time_conversion order by 1;
--[er]set
insert into time_conversion(col18) values (time'16:47:22');
--[er]multiset
insert into time_conversion(col19) values (time'16:47:22');
--[er]list
insert into time_conversion(col20) values (time'16:47:22');
--[er]sequence
insert into time_conversion(col21) values (time'16:47:22');
--[er]blob
insert into time_conversion(col22) values (time'16:47:22');
--[er]clob
insert into time_conversion(col23) values (time'16:47:22');



drop table time_conversion;
	
