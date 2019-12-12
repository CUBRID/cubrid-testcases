--test implicit type conversion of bigint type



create table bigint_conversion(
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
insert into bigint_conversion(col1) values (cast(12345678901 as bigint));
--[er]date
insert into bigint_conversion(col2) values (cast(12345678901 as bigint));
--[er]time
insert into bigint_conversion(col3) values (cast(12345678901 as bigint));
--[er]timestamp
insert into bigint_conversion(col4) values (cast(12345678901 as bigint));
--[ok]double
insert into bigint_conversion(col5) values (cast(12345678901 as bigint));
select col5 from bigint_conversion order by 1;
--[ok]float
insert into bigint_conversion(col6) values (cast(12345678901 as bigint));
select col6 from bigint_conversion order by 1;
--[ok]numeric
insert into bigint_conversion(col7) values (cast(12345678901 as bigint));
select col7 from bigint_conversion order by 1;
--[nr]bigint
insert into bigint_conversion(col8) values (cast(12345678901 as bigint));
select col8 from bigint_conversion order by 1;
--[ok]int
insert into bigint_conversion(col9) values (cast(123456789 as bigint));
select col9 from bigint_conversion order by 1;
--[ok]short
insert into bigint_conversion(col10) values (cast(12345 as bigint));
select col10 from bigint_conversion order by 1;
--[ok]monetary
insert into bigint_conversion(col11) values (cast(12345678901 as bigint));
select col11 from bigint_conversion order by 1;
--[er]bit
insert into bigint_conversion(col12) values (cast(12345678901 as bigint));
--[er]varbit
insert into bigint_conversion(col13) values (cast(12345678901 as bigint));
--[ok]char
insert into bigint_conversion(col14) values (cast(12345678901 as bigint));
select col14 from bigint_conversion order by 1;
--[ok]varchar
insert into bigint_conversion(col15) values (cast(12345678901 as bigint));
select col15 from bigint_conversion order by 1;
--[ok]nchar
insert into bigint_conversion(col16) values (cast(12345678901 as bigint));
select col16 from bigint_conversion order by 1;
--[ok]varnchar
insert into bigint_conversion(col17) values (cast(12345678901 as bigint));
select col17 from bigint_conversion order by 1;
--[er]set
insert into bigint_conversion(col18) values (cast(12345678901 as bigint));
--[er]multiset
insert into bigint_conversion(col19) values (cast(12345678901 as bigint));
--[er]list
insert into bigint_conversion(col20) values (cast(12345678901 as bigint));
--[er]sequence
insert into bigint_conversion(col21) values (cast(12345678901 as bigint));
--[er]blob
insert into bigint_conversion(col22) values (cast(12345678901 as bigint));
--[er]clob
insert into bigint_conversion(col23) values (cast(12345678901 as bigint));



drop table bigint_conversion;
	
