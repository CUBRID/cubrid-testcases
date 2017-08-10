--test implicit type conversion of short type



create table short_conversion(
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
insert into short_conversion(col1) values (cast(1234 as short));
--[er]date
insert into short_conversion(col2) values (cast(1234 as short));
--[er]time
insert into short_conversion(col3) values (cast(1234 as short));
--[er]timestamp
insert into short_conversion(col4) values (cast(1234 as short));
--[ok]double
insert into short_conversion(col5) values (cast(1234 as short));
select col5 from short_conversion order by 1;
--[ok]float
insert into short_conversion(col6) values (cast(1234 as short));
select col6 from short_conversion order by 1;
--[ok]numeric
insert into short_conversion(col7) values (cast(1234 as short));
select col7 from short_conversion order by 1;
--[ok]bigint
insert into short_conversion(col8) values (cast(1234 as short));
select col8 from short_conversion order by 1;
--[ok]int
insert into short_conversion(col9) values (cast(1234 as short));
select col9 from short_conversion order by 1;
--[nr]short
insert into short_conversion(col10) values (cast(1234 as short));
select col10 from short_conversion order by 1;
--[ok]monetary
insert into short_conversion(col11) values (cast(1234 as short));
select col11 from short_conversion order by 1;
--[er]bit
insert into short_conversion(col12) values (cast(1234 as short));
--[er]varbit
insert into short_conversion(col13) values (cast(1234 as short));
--[ok]char
insert into short_conversion(col14) values (cast(1234 as short));
select col14 from short_conversion order by 1;
--[ok]varchar
insert into short_conversion(col15) values (cast(1234 as short));
select col15 from short_conversion order by 1;
--[ok]nchar
insert into short_conversion(col16) values (cast(1234 as short));
select col16 from short_conversion order by 1;
--[ok]varnchar
insert into short_conversion(col17) values (cast(1234 as short));
select col17 from short_conversion order by 1;
--[er]set
insert into short_conversion(col18) values (cast(1234 as short));
--[er]multiset
insert into short_conversion(col19) values (cast(1234 as short));
--[er]list
insert into short_conversion(col20) values (cast(1234 as short));
--[er]sequence
insert into short_conversion(col21) values (cast(1234 as short));
--[er]blob
insert into short_conversion(col22) values (cast(1234 as short));
--[er]clob
insert into short_conversion(col23) values (cast(1234 as short));



drop table short_conversion;
	
