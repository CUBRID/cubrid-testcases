--test implicit type conversion of float type



create table float_conversion(
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
insert into float_conversion(col1) values (cast(1234.5678901 as float));
--[er]date
insert into float_conversion(col2) values (cast(1234.5678901 as float));
--[er]time
insert into float_conversion(col3) values (cast(1234.5678901 as float));
--[er]timestamp
insert into float_conversion(col4) values (cast(1234.5678901 as float));
--[ok]double
insert into float_conversion(col5) values (cast(1234.5678901 as float));
select col5 from float_conversion order by 1;
--[nr]float
insert into float_conversion(col6) values (cast(1234.5678901 as float));
select col6 from float_conversion order by 1;
--[ok]numeric
insert into float_conversion(col7) values (cast(1234.5678901 as float));
select col7 from float_conversion order by 1;
--[ok]bigint
insert into float_conversion(col8) values (cast(1234.5678901 as float));
select col8 from float_conversion order by 1;
--[ok]int
insert into float_conversion(col9) values (cast(1234.5678901 as float));
select col9 from float_conversion order by 1;
--[ok]short
insert into float_conversion(col10) values (cast(1234.5678901 as float));
select col10 from float_conversion order by 1;
--[ok]monetary
insert into float_conversion(col11) values (cast(1234.5678901 as float));
select col11 from float_conversion order by 1;
--[er]bit
insert into float_conversion(col12) values (cast(1234.5678901 as float));
--[er]varbit
insert into float_conversion(col13) values (cast(1234.5678901 as float));
--[ok]char
insert into float_conversion(col14) values (cast(1234.5678901 as float));
select col14 from float_conversion order by 1;
--[ok]varchar
insert into float_conversion(col15) values (cast(1234.5678901 as float));
select col15 from float_conversion order by 1;
--[ok]nchar
insert into float_conversion(col16) values (cast(1234.5678901 as float));
select col16 from float_conversion order by 1;
--[ok]varnchar
insert into float_conversion(col17) values (cast(1234.5678901 as float));
select col17 from float_conversion order by 1;
--[er]set
insert into float_conversion(col18) values (cast(1234.5678901 as float));
--[er]multiset
insert into float_conversion(col19) values (cast(1234.5678901 as float));
--[er]list
insert into float_conversion(col20) values (cast(1234.5678901 as float));
--[er]sequence
insert into float_conversion(col21) values (cast(1234.5678901 as float));
--[er]blob
insert into float_conversion(col22) values (cast(1234.5678901 as float));
--[er]clob
insert into float_conversion(col23) values (cast(1234.5678901 as float));


drop table float_conversion;
	
