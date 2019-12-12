--test implicit type conversion of numeric type



create table numeric_conversion(
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
insert into numeric_conversion(col1) values (cast(1234.5678901 as numeric));
--[er]date
insert into numeric_conversion(col2) values (cast(1234.5678901 as numeric));
--[er]time
insert into numeric_conversion(col3) values (cast(1234.5678901 as numeric));
--[er]timestamp
insert into numeric_conversion(col4) values (cast(1234.5678901 as numeric));
--[ok]double
insert into numeric_conversion(col5) values (cast(1234.5678901 as numeric));
select col5 from numeric_conversion order by 1;
--[ok]float
insert into numeric_conversion(col6) values (cast(1234.5678901 as numeric));
select col6 from numeric_conversion order by 1;
--[nr]numeric
insert into numeric_conversion(col7) values (cast(1234.5678901 as numeric));
select col7 from numeric_conversion order by 1;
--[ok]bigint
insert into numeric_conversion(col8) values (cast(1234.5678901 as numeric));
select col8 from numeric_conversion order by 1;
--[ok]int
insert into numeric_conversion(col9) values (cast(1234.5678901 as numeric));
select col9 from numeric_conversion order by 1;
--[ok]short
insert into numeric_conversion(col10) values (cast(1234.5678901 as numeric));
select col10 from numeric_conversion order by 1;
--[ok]monetary
insert into numeric_conversion(col11) values (cast(1234.5678901 as numeric));
select col11 from numeric_conversion order by 1;
--[er]bit
insert into numeric_conversion(col12) values (cast(1234.5678901 as numeric));
--[er]varbit
insert into numeric_conversion(col13) values (cast(1234.5678901 as numeric));
--[ok]char
insert into numeric_conversion(col14) values (cast(1234.5678901 as numeric));
select col14 from numeric_conversion order by 1;
--[ok]varchar
insert into numeric_conversion(col15) values (cast(1234.5678901 as numeric));
select col15 from numeric_conversion order by 1;
--[ok]nchar
insert into numeric_conversion(col16) values (cast(1234.5678901 as numeric));
select col16 from numeric_conversion order by 1;
--[ok]varnchar
insert into numeric_conversion(col17) values (cast(1234.5678901 as numeric));
select col17 from numeric_conversion order by 1;
--[er]set
insert into numeric_conversion(col18) values (cast(1234.5678901 as numeric));
--[er]multiset
insert into numeric_conversion(col19) values (cast(1234.5678901 as numeric));
--[er]list
insert into numeric_conversion(col20) values (cast(1234.5678901 as numeric));
--[er]sequence
insert into numeric_conversion(col21) values (cast(1234.5678901 as numeric));
--[er]blob
insert into numeric_conversion(col22) values (cast(1234.5678901 as numeric));
--[er]clob
insert into numeric_conversion(col23) values (cast(1234.5678901 as numeric));



drop table numeric_conversion;
	
