--different types of comination of the 1st and the 4th paramater


create table ioo(
	col1 char(20),
	col2 nchar(30),
	col3 varchar(22),
	col4 nchar varying(33),
	col5 string,
	col6 integer,
	col7 short,
	col8 bigint,
	col9 numeric,
	col10 float,
	col11 double,
	col12 monetary,
	col13 date,
	col14 time,
	col15 timestamp,
	col16 datetime
--	col17 bit(20),
--	col18 bit varying(30)
	);


insert into ioo values ('aaa,bbb,ccc,ddd,eee', n'aaa,bbb,ccc,ddd,eee', 'hello,there', n'hello,there', 'this is a string', 
			1234, 345, -4748930303, 333.4378373, -222.638392, 234.627829292, 282937, 
			date'2010-10-26', time'17:30:23', timestamp'10/26/2010 17:30:23', datetime'17:30:23.222 pm 2010-10-26'
--			b'101000101', b'10010101001'
			);


--combination of a string type and a numeric type
select insert(col1, 4, 6, col6) from ioo;
select insert(col2, 4, 8, col7) from ioo;
select insert(col8, 3, 4, col3) from ioo;
select insert(col9, 6, 2, col4) from ioo;
select insert(col5, 6, 3, col10) from ioo;
select insert(col1, 10, 3, col11) from ioo;
select insert(col12, 3, 8, col4) from ioo;


--combination of a stirng type and a date/time type
select insert(col1, 4, 6, col13) from ioo;
select insert(col2, 4, 8, col14) from ioo;
select insert(col15, 3, 4, col3) from ioo;
select insert(col16, 6, 2, col4) from ioo;
select insert(col15, 6, 3, col5) from ioo;


--combination of a numeric type and a date/time type
select insert(col6, 2, 3, col13) from ioo;
select insert(col7, 1, 3, col14) from ioo;
select insert(col15, 6, 6, col8) from ioo;
select insert(col16, 15, 5, col9) from ioo;
select insert(col10, 7, 3, col13) from ioo;
select insert(col11, 3, 5, col16) from ioo;
select insert(col14, 2, 5, col12) from ioo;


drop table ioo;



--without a table
select insert('aaa,bbb,ccc,ddd', 4, 10, 33.3333333);
select insert('kkkkk-rrrrr', 5, 3, date'1999-12-12');
select insert(1234567, 3, 7, 'tttttttttttt');
select insert(1234567, 3, 7, datetime'1888-3-14 12:34:22.332 pm');
select insert(timestamp'3/15/1898 20:20:20', 4, 6, -8473844);
select insert(time'2:45:54', 2, 4, 'uuuuuu_zzzzzzzz');



