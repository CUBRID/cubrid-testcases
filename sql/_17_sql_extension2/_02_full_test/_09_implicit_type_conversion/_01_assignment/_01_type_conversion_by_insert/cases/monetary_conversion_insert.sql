--test implicit type conversion of monetary type



create table monetary_conversion(
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
insert into monetary_conversion(col1) values (cast(1234.56 as monetary));
--[er]date
insert into monetary_conversion(col2) values (cast(1234.56 as monetary));
--[er]time
insert into monetary_conversion(col3) values (cast(1234.56 as monetary));
--[er]timestamp
insert into monetary_conversion(col4) values (cast(1234.56 as monetary));
--[ok]double
insert into monetary_conversion(col5) values (cast(1234.56 as monetary));
select col5 from monetary_conversion order by 1;
--[ok]float
insert into monetary_conversion(col6) values (cast(1234.56 as monetary));
select col6 from monetary_conversion order by 1;
--[ok]numeric
insert into monetary_conversion(col7) values (cast(1234.56 as monetary));
select col7 from monetary_conversion order by 1;
--[ok]bigint
insert into monetary_conversion(col8) values (cast(1234.56 as monetary));
select col8 from monetary_conversion order by 1;
--[ok]int
insert into monetary_conversion(col9) values (cast(1234.56 as monetary));
select col9 from monetary_conversion order by 1;
--[ok]short
insert into monetary_conversion(col10) values (cast(1234.56 as monetary));
select col10 from monetary_conversion order by 1;
--[nr]monetary
insert into monetary_conversion(col11) values (cast(1234.56 as monetary));
select col11 from monetary_conversion order by 1;
--[er]bit
insert into monetary_conversion(col12) values (cast(1234.56 as monetary));
--[er]varbit
insert into monetary_conversion(col13) values (cast(1234.56 as monetary));
--[ok]char
insert into monetary_conversion(col14) values (cast(1234.56 as monetary));
select col14 from monetary_conversion order by 1;
--[ok]varchar
insert into monetary_conversion(col15) values (cast(1234.56 as monetary));
select col15 from monetary_conversion order by 1;
--[ok]nchar
insert into monetary_conversion(col16) values (cast(1234.56 as monetary));
select col16 from monetary_conversion order by 1;
--[ok]varnchar
insert into monetary_conversion(col17) values (cast(1234.56 as monetary));
select col17 from monetary_conversion order by 1;
--[er]set
insert into monetary_conversion(col18) values (cast(1234.56 as monetary));
--[er]multiset
insert into monetary_conversion(col19) values (cast(1234.56 as monetary));
--[er]list
insert into monetary_conversion(col20) values (cast(1234.56 as monetary));
--[er]sequence
insert into monetary_conversion(col21) values (cast(1234.56 as monetary));
--[er]blob
insert into monetary_conversion(col22) values (cast(1234.56 as monetary));
--[er]clob
insert into monetary_conversion(col23) values (cast(1234.56 as monetary));


drop table monetary_conversion;
	
