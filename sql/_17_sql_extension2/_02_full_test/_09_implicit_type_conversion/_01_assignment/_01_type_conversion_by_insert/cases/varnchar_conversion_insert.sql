--test implicit type conversion of varnchar type



create table varnchar_conversion(
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
insert into varnchar_conversion(col1) values (cast(n'11/08/2010 16:10:22.123' as nchar varying(30)));
select col1 from varnchar_conversion order by 1;
--[ok]date
insert into varnchar_conversion(col2) values (cast(n'11/08/2010 16:10:22' as nchar varying(30)));
select col2 from varnchar_conversion order by 1;
--[ok]time
insert into varnchar_conversion(col3) values (cast(n'11/08/2010 16:10:22' as nchar varying(30)));
select col3 from varnchar_conversion order by 1;
--[ok]timestamp
insert into varnchar_conversion(col4) values (cast(n'11/08/2010 16:10:22' as nchar varying(30)));
select col4 from varnchar_conversion order by 1;
--[ok]double
insert into varnchar_conversion(col5) values (cast(n'12323423423.3453' as nchar varying(30)));
select col5 from varnchar_conversion order by 1;
--[ok]float
insert into varnchar_conversion(col6) values (cast(n'63454334.565' as nchar varying(30)));
select col6 from varnchar_conversion order by 1;
--[ok]numeric
insert into varnchar_conversion(col7) values (cast(n'4325.56534' as nchar varying(30)));
select col7 from varnchar_conversion order by 1;
--[ok]bigint
insert into varnchar_conversion(col8) values (cast(n'123412345645' as nchar varying(30)));
select col8 from varnchar_conversion order by 1;
--[ok]int
insert into varnchar_conversion(col9) values (cast(n'83923423' as nchar varying(30)));
select col9 from varnchar_conversion order by 1;
--[ok]short
insert into varnchar_conversion(col10) values (cast(n'4321' as nchar varying(30)));
select col10 from varnchar_conversion order by 1;
--[ok]monetary
insert into varnchar_conversion(col11) values (cast(n'78273923.2342' as nchar varying(30)));
select col11 from varnchar_conversion order by 1;
--[ok]bit
insert into varnchar_conversion(col12) values (cast(n'b1010111' as nchar varying(30)));
select col12 from varnchar_conversion order by 1;
--[ok]varbit
insert into varnchar_conversion(col13) values (cast(n'b1010111' as nchar varying(30)));
select col13 from varnchar_conversion order by 1;
--[ok]char
insert into varnchar_conversion(col14) values (cast(n'11/08/2010 16:10:22.123' as nchar varying(30)));
select col14 from varnchar_conversion order by 1;
--[ok]varchar
insert into varnchar_conversion(col15) values (cast(n'11/08/2010 16:10:22.123' as nchar varying(30)));
select col15 from varnchar_conversion order by 1;
--[ok]nchar
insert into varnchar_conversion(col16) values (cast(n'11/08/2010 16:10:22.123' as nchar varying(30)));
select col16 from varnchar_conversion order by 1;
--[nr]varnchar
insert into varnchar_conversion(col17) values (cast(n'11/08/2010 16:10:22.123' as nchar varying(30)));
select col17 from varnchar_conversion order by 1;
--[er]set
insert into varnchar_conversion(col18) values (cast(n'11/08/2010 16:10:22.123' as nchar varying(30)));
--[er]multiset
insert into varnchar_conversion(col19) values (cast(n'11/08/2010 16:10:22.123' as nchar varying(30)));
--[er]list
insert into varnchar_conversion(col20) values (cast(n'11/08/2010 16:10:22.123' as nchar varying(30)));
--[er]sequence
insert into varnchar_conversion(col21) values (cast(n'11/08/2010 16:10:22.123' as nchar varying(30)));
--[er]blob
insert into varnchar_conversion(col22) values (cast(n'11/08/2010 16:10:22.123' as nchar varying(30)));
--[er]clob
insert into varnchar_conversion(col23) values (cast(n'11/08/2010 16:10:22.123' as nchar varying(30)));



drop table varnchar_conversion;
	
