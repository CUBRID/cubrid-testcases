--test implicit type conversion of bit type



create table bit_conversion(
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
insert into bit_conversion(col1) values (cast(B'1010111' as bit(10)));
--[er]date
insert into bit_conversion(col2) values (cast(B'1010111' as bit(10)));
--[er]time
insert into bit_conversion(col3) values (cast(B'1010111' as bit(10)));
--[er]timestamp
insert into bit_conversion(col4) values (cast(B'1010111' as bit(10)));
--[er]double
insert into bit_conversion(col5) values (cast(B'1010111' as bit(10)));
--[er]float
insert into bit_conversion(col6) values (cast(B'1010111' as bit(10)));
--[er]numeric
insert into bit_conversion(col7) values (cast(B'1010111' as bit(10)));
--[er]bigint
insert into bit_conversion(col8) values (cast(B'1010111' as bit(10)));
--[er]int
insert into bit_conversion(col9) values (cast(B'1010111' as bit(10)));
--[er]short
insert into bit_conversion(col10) values (cast(B'1010111' as bit(10)));
--[er]monetary
insert into bit_conversion(col11) values (cast(B'1010111' as bit(10)));
--[nr]bit
insert into bit_conversion(col12) values (cast(B'1010111' as bit(10)));
select col12 from bit_conversion order by 1;
--[ok]varbit
insert into bit_conversion(col13) values (cast(B'1010111' as bit(10)));
select col13 from bit_conversion order by 1;
--[ok]char
insert into bit_conversion(col14) values (cast(B'1010111' as bit(10)));
select col14 from bit_conversion order by 1;
--[ok]varchar
insert into bit_conversion(col15) values (cast(B'1010111' as bit(10)));
select col15 from bit_conversion order by 1;
--[ok]nchar
insert into bit_conversion(col16) values (cast(B'1010111' as bit(10)));
select col16 from bit_conversion order by 1;
--[ok]varnchar
insert into bit_conversion(col17) values (cast(B'1010111' as bit(10)));
select col17 from bit_conversion order by 1;
--[er]set
insert into bit_conversion(col18) values (cast(B'1010111' as bit(10)));
--[er]multiset
insert into bit_conversion(col19) values (cast(B'1010111' as bit(10)));
--[er]list
insert into bit_conversion(col20) values (cast(B'1010111' as bit(10)));
--[er]sequence
insert into bit_conversion(col21) values (cast(B'1010111' as bit(10)));
--[ok]blob
insert into bit_conversion(col22) values (cast(B'1010111' as bit(10)));
select blob_to_bit(col22) from bit_conversion order by 1;
--[er]clob
insert into bit_conversion(col23) values (cast(B'1010111' as bit(10)));



drop table bit_conversion;
	
