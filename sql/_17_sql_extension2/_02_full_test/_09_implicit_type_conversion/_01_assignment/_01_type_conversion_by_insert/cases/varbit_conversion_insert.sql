--test implicit type conversion of varbit type



create table varbit_conversion(
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
	col12 bit(20),
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
insert into varbit_conversion(col1) values (cast(B'1010111' as bit varying(20)));
--[er]date
insert into varbit_conversion(col2) values (cast(B'1010111' as bit varying(20)));
--[er]time
insert into varbit_conversion(col3) values (cast(B'1010111' as bit varying(20)));
--[er]timestamp
insert into varbit_conversion(col4) values (cast(B'1010111' as bit varying(20)));
--[er]double
insert into varbit_conversion(col5) values (cast(B'1010111' as bit varying(20)));
--[er]float
insert into varbit_conversion(col6) values (cast(B'1010111' as bit varying(20)));
--[er]numeric
insert into varbit_conversion(col7) values (cast(B'1010111' as bit varying(20)));
--[er]bigint
insert into varbit_conversion(col8) values (cast(B'1010111' as bit varying(20)));
--[er]int
insert into varbit_conversion(col9) values (cast(B'1010111' as bit varying(20)));
--[er]short
insert into varbit_conversion(col10) values (cast(B'1010111' as bit varying(20)));
--[er]monetary
insert into varbit_conversion(col11) values (cast(B'1010111' as bit varying(20)));
--[ok]bit
insert into varbit_conversion(col12) values (cast(B'1010111' as bit varying(20)));
select col12 from varbit_conversion order by 1;
--[nr]varbit
insert into varbit_conversion(col13) values (cast(B'1010111' as bit varying(20)));
select col13 from varbit_conversion order by 1;
--[ok]char
insert into varbit_conversion(col14) values (cast(B'1010111' as bit varying(20)));
select col14 from varbit_conversion order by 1;
--[ok]varchar
insert into varbit_conversion(col15) values (cast(B'1010111' as bit varying(20)));
select col15 from varbit_conversion order by 1;
--[ok]nchar
insert into varbit_conversion(col16) values (cast(B'1010111' as bit varying(20)));
select col16 from varbit_conversion order by 1;
--[ok]varnchar
insert into varbit_conversion(col17) values (cast(B'1010111' as bit varying(20)));
select col17 from varbit_conversion order by 1;
--[er]set
insert into varbit_conversion(col18) values (cast(B'1010111' as bit varying(20)));
--[er]multiset
insert into varbit_conversion(col19) values (cast(B'1010111' as bit varying(20)));
--[er]list
insert into varbit_conversion(col20) values (cast(B'1010111' as bit varying(20)));
--[er]sequence
insert into varbit_conversion(col21) values (cast(B'1010111' as bit varying(20)));
--[ok]blob
insert into varbit_conversion(col22) values (cast(B'1010111' as bit varying(20)));
select blob_to_bit(col22) from varbit_conversion order by 1;
--[er]clob
insert into varbit_conversion(col23) values (cast(B'1010111' as bit varying(20)));



drop table varbit_conversion;
	
