--test implicit type conversion of list type



create table list_conversion(
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
insert into list_conversion(col1) values (cast({1, 2, 3, 4, 5} as list));
--[er]date
insert into list_conversion(col2) values (cast({1, 2, 3, 4, 5} as list));
--[er]time
insert into list_conversion(col3) values (cast({1, 2, 3, 4, 5} as list));
--[er]timestamp
insert into list_conversion(col4) values (cast({1, 2, 3, 4, 5} as list));
--[er]double
insert into list_conversion(col5) values (cast({1, 2, 3, 4, 5} as list));
--[er]float
insert into list_conversion(col6) values (cast({1, 2, 3, 4, 5} as list));
--[er]numeric
insert into list_conversion(col7) values (cast({1, 2, 3, 4, 5} as list));
--[er]bigint
insert into list_conversion(col8) values (cast({1, 2, 3, 4, 5} as list));
--[er]int
insert into list_conversion(col9) values (cast({1, 2, 3, 4, 5} as list));
--[er]short
insert into list_conversion(col10) values (cast({1, 2, 3, 4, 5} as list));
--[er]monetary
insert into list_conversion(col11) values (cast({1, 2, 3, 4, 5} as list));
--[er]bit
insert into list_conversion(col12) values (cast({1, 2, 3, 4, 5} as list));
--[er]varbit
insert into list_conversion(col13) values (cast({1, 2, 3, 4, 5} as list));
--[er]char
insert into list_conversion(col14) values (cast({1, 2, 3, 4, 5} as list));
--[er]varchar
insert into list_conversion(col15) values (cast({1, 2, 3, 4, 5} as list));
--[er]nchar
insert into list_conversion(col16) values (cast({1, 2, 3, 4, 5} as list));
--[er]varnchar
insert into list_conversion(col17) values (cast({1, 2, 3, 4, 5} as list));
--[ok]set
insert into list_conversion(col18) values (cast({1, 2, 3, 4, 5} as list));
select col18 from list_conversion order by 1;
--[ok]multiset
insert into list_conversion(col19) values (cast({1, 2, 3, 4, 5} as list));
select col19 from list_conversion order by 1;
--[nr]list
insert into list_conversion(col20) values (cast({1, 2, 3, 4, 5} as list));
select col20 from list_conversion order by 1;
--[ok]sequence
insert into list_conversion(col21) values (cast({1, 2, 3, 4, 5} as list));
select col21 from list_conversion order by 1;
--[er]blob
insert into list_conversion(col22) values (cast({1, 2, 3, 4, 5} as list));
--[er]clob
insert into list_conversion(col23) values (cast({1, 2, 3, 4, 5} as list));


select * from list_conversion order by 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23;


drop table list_conversion;
	
