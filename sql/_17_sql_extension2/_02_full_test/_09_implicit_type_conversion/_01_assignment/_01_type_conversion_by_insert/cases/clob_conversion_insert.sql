--test implicit type conversion of clob type



create table clob_conversion(
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
insert into clob_conversion(col1) values (char_to_clob('aabbcc'));
--[er]date
insert into clob_conversion(col2) values (char_to_clob('aabbcc'));
--[er]time
insert into clob_conversion(col3) values (char_to_clob('aabbcc'));
--[er]timestamp
insert into clob_conversion(col4) values (char_to_clob('aabbcc'));
--[er]double
insert into clob_conversion(col5) values (char_to_clob('aabbcc'));
--[er]float
insert into clob_conversion(col6) values (char_to_clob('aabbcc'));
--[er]numeric
insert into clob_conversion(col7) values (char_to_clob('aabbcc'));
--[er]bigint
insert into clob_conversion(col8) values (char_to_clob('aabbcc'));
--[er]int
insert into clob_conversion(col9) values (char_to_clob('aabbcc'));
--[er]short
insert into clob_conversion(col10) values (char_to_clob('aabbcc'));
--[er]monetary
insert into clob_conversion(col11) values (char_to_clob('aabbcc'));
--[er]bit
insert into clob_conversion(col12) values (char_to_clob('aabbcc'));
--[er]varbit
insert into clob_conversion(col13) values (char_to_clob('aabbcc'));
--[er]char
insert into clob_conversion(col14) values (char_to_clob('aabbcc'));
select col14 from clob_conversion order by 1;
--[er]varchar
insert into clob_conversion(col15) values (char_to_clob('aabbcc'));
select col15 from clob_conversion order by 1;
--[er]nchar
insert into clob_conversion(col16) values (char_to_clob('aabbcc'));
select col16 from clob_conversion order by 1;
--[er]varnchar
insert into clob_conversion(col17) values (char_to_clob('aabbcc'));
select col17 from clob_conversion order by 1;
--[er]set
insert into clob_conversion(col18) values (char_to_clob('aabbcc'));
--[er]multiset
insert into clob_conversion(col19) values (char_to_clob('aabbcc'));
--[er]list
insert into clob_conversion(col20) values (char_to_clob('aabbcc'));
--[er]sequence
insert into clob_conversion(col21) values (char_to_clob('aabbcc'));
--[er]blob
insert into clob_conversion(col22) values (char_to_clob('aabbcc'));
--[nr]clob
insert into clob_conversion(col23) values (char_to_clob('aabbcc'));
select clob_to_char(col23) from clob_conversion order by 1;



delete from clob_conversion;
drop table clob_conversion;
	
