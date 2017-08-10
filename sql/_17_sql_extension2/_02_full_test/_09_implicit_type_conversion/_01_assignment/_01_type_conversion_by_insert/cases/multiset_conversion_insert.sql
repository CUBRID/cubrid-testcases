--test implicit type conversion of multiset type



create table multiset_conversion(
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
insert into multiset_conversion(col1) values (cast({1, 2, 3, 4, 5} as multiset));
--[er]date
insert into multiset_conversion(col2) values (cast({1, 2, 3, 4, 5} as multiset));
--[er]time
insert into multiset_conversion(col3) values (cast({1, 2, 3, 4, 5} as multiset));
--[er]timestamp
insert into multiset_conversion(col4) values (cast({1, 2, 3, 4, 5} as multiset));
--[er]double
insert into multiset_conversion(col5) values (cast({1, 2, 3, 4, 5} as multiset));
--[er]float
insert into multiset_conversion(col6) values (cast({1, 2, 3, 4, 5} as multiset));
--[er]numeric
insert into multiset_conversion(col7) values (cast({1, 2, 3, 4, 5} as multiset));
--[er]bigint
insert into multiset_conversion(col8) values (cast({1, 2, 3, 4, 5} as multiset));
--[er]int
insert into multiset_conversion(col9) values (cast({1, 2, 3, 4, 5} as multiset));
--[er]short
insert into multiset_conversion(col10) values (cast({1, 2, 3, 4, 5} as multiset));
--[er]monetary
insert into multiset_conversion(col11) values (cast({1, 2, 3, 4, 5} as multiset));
--[er]bit
insert into multiset_conversion(col12) values (cast({1, 2, 3, 4, 5} as multiset));
--[er]varbit
insert into multiset_conversion(col13) values (cast({1, 2, 3, 4, 5} as multiset));
--[er]char
insert into multiset_conversion(col14) values (cast({1, 2, 3, 4, 5} as multiset));
--[er]varchar
insert into multiset_conversion(col15) values (cast({1, 2, 3, 4, 5} as multiset));
--[er]nchar
insert into multiset_conversion(col16) values (cast({1, 2, 3, 4, 5} as multiset));
--[er]varnchar
insert into multiset_conversion(col17) values (cast({1, 2, 3, 4, 5} as multiset));
--[ok]set
insert into multiset_conversion(col18) values (cast({1, 1, 2, 3, 4, 5} as multiset));
select col18 from multiset_conversion order by 1;
--[nr]multiset
insert into multiset_conversion(col19) values (cast({1, 1, 2, 3, 4, 5} as multiset));
select col19 from multiset_conversion order by 1;
--[ok]list
insert into multiset_conversion(col20) values (cast({1, 1, 2, 3, 6, 4, 5} as multiset));
select col20 from multiset_conversion order by 1;
--[ok]sequence
insert into multiset_conversion(col21) values (cast({1, 2, 1, 3, 6, 4, 5} as multiset));
select col21 from multiset_conversion order by 1;
--[er]blob
insert into multiset_conversion(col22) values (cast({1, 2, 3, 4, 5} as multiset));
--[er]clob
insert into multiset_conversion(col23) values (cast({1, 2, 3, 4, 5} as multiset));



drop table multiset_conversion;
	
