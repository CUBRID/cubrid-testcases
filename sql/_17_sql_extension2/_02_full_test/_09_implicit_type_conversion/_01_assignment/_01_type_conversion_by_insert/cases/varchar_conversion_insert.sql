--test implicit type conversion of varchar type



create table varchar_conversion(
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
	col12 bit(50),
	col13 bit varying,
	col14 char(30),
	col15 varchar,
	col16 nchar(30),
	col17 nchar varying,
	col18 set,
	col19 multiset,
	col20 list,
	col21 sequence,
	col22 blob,
	col23 clob
);


--[ok]datetime
insert into varchar_conversion(col1) values (cast('11/08/2010 16:10:22.123' as varchar(30)));
select col1 from varchar_conversion order by 1;
--[ok]date
insert into varchar_conversion(col2) values (cast('11/08/2010 16:10:22' as varchar(30)));
select col2 from varchar_conversion order by 1;
--[ok]time
insert into varchar_conversion(col3) values (cast('11/08/2010 16:10:22' as varchar(30)));
select col3 from varchar_conversion order by 1;
--[ok]timestamp
insert into varchar_conversion(col4) values (cast('11/08/2010 16:10:22' as varchar(30)));
select col4 from varchar_conversion order by 1;
--[ok]double
insert into varchar_conversion(col5) values (cast('12323423423.3453' as varchar(30)));
select col5 from varchar_conversion order by 1;
--[ok]float
insert into varchar_conversion(col6) values (cast('63454334.565' as varchar(30)));
select col6 from varchar_conversion order by 1;
--[ok]numeric
insert into varchar_conversion(col7) values (cast('4325.56534' as varchar(30)));
select col7 from varchar_conversion order by 1;
--[ok]bigint
insert into varchar_conversion(col8) values (cast('123412345645' as varchar(30)));
select col8 from varchar_conversion order by 1;
--[ok]int
insert into varchar_conversion(col9) values (cast('83923423' as varchar(30)));
select col9 from varchar_conversion order by 1;
--[ok]short
insert into varchar_conversion(col10) values (cast('4321' as varchar(30)));
select col10 from varchar_conversion order by 1;
--[ok]monetary
insert into varchar_conversion(col11) values (cast('78273923.2342' as varchar(30)));
select col11 from varchar_conversion order by 1;
--[ok]bit
insert into varchar_conversion(col12) values (cast(B'1010111' as varchar(30)));
select col12 from varchar_conversion order by 1;
--[ok]varbit
insert into varchar_conversion(col13) values (cast(B'1010111' as varchar(30)));
select col13 from varchar_conversion order by 1;
--[ok]char
insert into varchar_conversion(col14) values (cast('11/08/2010 16:10:22.123' as varchar(30)));
select col14 from varchar_conversion order by 1;
--[nr]varchar
insert into varchar_conversion(col15) values (cast('11/08/2010 16:10:22.123' as varchar(30)));
select col15 from varchar_conversion order by 1;
--[ok]nchar
insert into varchar_conversion(col16) values (cast('11/08/2010 16:10:22.123' as varchar(30)));
select col16 from varchar_conversion order by 1;
--[ok]varnchar
insert into varchar_conversion(col17) values (cast('11/08/2010 16:10:22.123' as varchar(30)));
select col17 from varchar_conversion order by 1;
--[er]set
insert into varchar_conversion(col18) values (cast('11/08/2010 16:10:22.123' as varchar(30)));
--[er]multiset
insert into varchar_conversion(col19) values (cast('11/08/2010 16:10:22.123' as varchar(30)));
--[er]list
insert into varchar_conversion(col20) values (cast('11/08/2010 16:10:22.123' as varchar(30)));
--[er]sequence
insert into varchar_conversion(col21) values (cast('11/08/2010 16:10:22.123' as varchar(30)));
--[er]blob
insert into varchar_conversion(col22) values (cast('11/08/2010 16:10:22.123' as varchar(30)));
--[er]clob
insert into varchar_conversion(col23) values (cast('11/08/2010 16:10:22.123' as varchar(30)));
select clob_to_char(col23) from varchar_conversion order by 1;



drop table varchar_conversion;
	
