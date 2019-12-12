--test implicit type conversion of char type



create table char_conversion(
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
	col12 bit(30),
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
insert into char_conversion(col1) values (cast('11/08/2010 16:10:22.123' as char(30)));
select col1 from char_conversion order by 1;
--[ok]date
insert into char_conversion(col2) values (cast('11/08/2010 16:10:22' as char(30)));
select col2 from char_conversion order by 1;
--[ok]time
insert into char_conversion(col3) values (cast('11/08/2010 16:10:22' as char(30)));
select col3 from char_conversion order by 1;
--[ok]timestamp
insert into char_conversion(col4) values (cast('11/08/2010 16:10:22' as char(30)));
select col4 from char_conversion order by 1;
--[ok]double
insert into char_conversion(col5) values (cast('12345.678901' as char(30)));
select col5 from char_conversion order by 1;
--[ok]float
insert into char_conversion(col6) values (cast('12345.6789' as char(30)));
select col6 from char_conversion order by 1;
--[ok]numeric
insert into char_conversion(col7) values (cast('1234.123' as char(30)));
select col7 from char_conversion order by 1;
--[ok]bigint
insert into char_conversion(col8) values (cast('1357924680' as char(20)));
select col8 from char_conversion order by 1;
--[ok]int
insert into char_conversion(col9) values (cast('123123456' as char(30)));
select col9 from char_conversion order by 1;
--[ok]short
insert into char_conversion(col10) values (cast('4321' as char(30)));
select col10 from char_conversion order by 1;
--[ok]monetary
insert into char_conversion(col11) values (cast('12312.3453' as char(30)));
select col11 from char_conversion order by 1;
--[ok]bit
insert into char_conversion(col12) values (cast('B1010111' as char(30)));
select col12 from char_conversion order by 1;
--[ok]varbit
insert into char_conversion(col13) values (cast('1010111' as char(30)));
select col13 from char_conversion order by 1;
--[nr]char
insert into char_conversion(col14) values (cast('11/08/2010 16:10:22.123' as char(30)));
select col14 from char_conversion order by 1;
--[ok]varchar
insert into char_conversion(col15) values (cast('11/08/2010 16:10:22.123' as char(30)));
select col15 from char_conversion order by 1;
--[ok]nchar
insert into char_conversion(col16) values (cast('11/08/2010 16:10:22.123' as char(30)));
select col16 from char_conversion order by 1;
--[ok]varnchar
insert into char_conversion(col17) values (cast('11/08/2010 16:10:22.123' as char(30)));
select col17 from char_conversion order by 1;
--[er]set
insert into char_conversion(col18) values (cast('11/08/2010 16:10:22.123' as char(30)));
--[er]multiset
insert into char_conversion(col19) values (cast('11/08/2010 16:10:22.123' as char(30)));
--[er]list
insert into char_conversion(col20) values (cast('11/08/2010 16:10:22.123' as char(30)));
--[er]sequence
insert into char_conversion(col21) values (cast('11/08/2010 16:10:22.123' as char(30)));
--[ok]blob
insert into char_conversion(col22) values (cast('11/08/2010 16:10:22.123' as char(30)));
select blob_to_bit(col22) from char_conversion order by 1;
--[ok]clob
insert into char_conversion(col23) values (cast('11/08/2010 16:10:22.123' as char(30)));
select clob_to_char(col23) from char_conversion order by 1;



drop table char_conversion;
	
