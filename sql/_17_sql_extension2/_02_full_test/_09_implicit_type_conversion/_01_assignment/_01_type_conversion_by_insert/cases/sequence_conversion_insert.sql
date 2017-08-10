--test implicit type conversion of sequence type



create table sequence_conversion(
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
insert into sequence_conversion(col1) values (cast({1, 2, 3, 4, 5} as sequence));
--[er]date
insert into sequence_conversion(col2) values (cast({1, 2, 3, 4, 5} as sequence));
--[er]time
insert into sequence_conversion(col3) values (cast({1, 2, 3, 4, 5} as sequence));
--[er]timestamp
insert into sequence_conversion(col4) values (cast({1, 2, 3, 4, 5} as sequence));
--[er]double
insert into sequence_conversion(col5) values (cast({1, 2, 3, 4, 5} as sequence));
--[er]float
insert into sequence_conversion(col6) values (cast({1, 2, 3, 4, 5} as sequence));
--[er]numeric
insert into sequence_conversion(col7) values (cast({1, 2, 3, 4, 5} as sequence));
--[er]bigint
insert into sequence_conversion(col8) values (cast({1, 2, 3, 4, 5} as sequence));
--[er]int
insert into sequence_conversion(col9) values (cast({1, 2, 3, 4, 5} as sequence));
--[er]short
insert into sequence_conversion(col10) values (cast({1, 2, 3, 4, 5} as sequence));
--[er]monetary
insert into sequence_conversion(col11) values (cast({1, 2, 3, 4, 5} as sequence));
--[er]bit
insert into sequence_conversion(col12) values (cast({1, 2, 3, 4, 5} as sequence));
--[er]varbit
insert into sequence_conversion(col13) values (cast({1, 2, 3, 4, 5} as sequence));
--[er]char
insert into sequence_conversion(col14) values (cast({1, 2, 3, 4, 5} as sequence));
--[er]varchar
insert into sequence_conversion(col15) values (cast({1, 2, 3, 4, 5} as sequence));
--[er]nchar
insert into sequence_conversion(col16) values (cast({1, 2, 3, 4, 5} as sequence));
--[er]varnchar
insert into sequence_conversion(col17) values (cast({1, 2, 3, 4, 5} as sequence));
--[ok]set
insert into sequence_conversion(col18) values (cast({1, 2, 3, 4, 5} as sequence));
select col18 from sequence_conversion order by 1;
--[ok]multiset
insert into sequence_conversion(col19) values (cast({1, 2, 3, 4, 5} as sequence));
select col19 from sequence_conversion order by 1;
--[ok]list
insert into sequence_conversion(col20) values (cast({1, 2, 3, 4, 5} as sequence));
select col20 from sequence_conversion order by 1;
--[nr]sequence
insert into sequence_conversion(col21) values (cast({1, 2, 3, 4, 5} as sequence));
select col21 from sequence_conversion order by 1;
--[er]blob
insert into sequence_conversion(col22) values (cast({1, 2, 3, 4, 5} as sequence));
--[er]clob
insert into sequence_conversion(col23) values (cast({1, 2, 3, 4, 5} as sequence));



drop table sequence_conversion;
	
