--test implicit type conversion of blob type



create table blob_conversion(
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
	col12 bit(10),
	col13 bit varying(10),
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
insert into blob_conversion(col1) values (bit_to_blob(B'1010111'));
--[er]date
insert into blob_conversion(col2) values (bit_to_blob(B'1010111'));
--[er]time
insert into blob_conversion(col3) values (bit_to_blob(B'1010111'));
--[er]timestamp
insert into blob_conversion(col4) values (bit_to_blob(B'1010111'));
--[er]double
insert into blob_conversion(col5) values (bit_to_blob(B'1010111'));
--[er]float
insert into blob_conversion(col6) values (bit_to_blob(B'1010111'));
--[er]numeric
insert into blob_conversion(col7) values (bit_to_blob(B'1010111'));
--[er]bigint
insert into blob_conversion(col8) values (bit_to_blob(B'1010111'));
--[er]int
insert into blob_conversion(col9) values (bit_to_blob(B'1010111'));
--[er]short
insert into blob_conversion(col10) values (bit_to_blob(B'1010111'));
--[er]monetary
insert into blob_conversion(col11) values (bit_to_blob(B'1010111'));
--[er]bit
insert into blob_conversion(col12) values (bit_to_blob(B'1010111'));
select col12 from blob_conversion order by 1;
--[er]varbit
insert into blob_conversion(col13) values (bit_to_blob(B'1010111'));
select col13 from blob_conversion order by 1;
--[er]char
insert into blob_conversion(col14) values (bit_to_blob(B'1010111'));
--[er]varchar
insert into blob_conversion(col15) values (bit_to_blob(B'1010111'));
--[er]nchar
insert into blob_conversion(col16) values (bit_to_blob(B'1010111'));
--[er]varnchar
insert into blob_conversion(col17) values (bit_to_blob(B'1010111'));
--[er]set
insert into blob_conversion(col18) values (bit_to_blob(B'1010111'));
--[er]multiset
insert into blob_conversion(col19) values (bit_to_blob(B'1010111'));
--[er]list
insert into blob_conversion(col20) values (bit_to_blob(B'1010111'));
--[er]sequence
insert into blob_conversion(col21) values (bit_to_blob(B'1010111'));
--[nr]blob
insert into blob_conversion(col22) values (bit_to_blob(B'1010111'));
select blob_to_bit(col22) from blob_conversion order by 1;
--[er]clob
insert into blob_conversion(col23) values (bit_to_blob(B'1010111'));


delete from blob_conversion;
drop table blob_conversion;
	
