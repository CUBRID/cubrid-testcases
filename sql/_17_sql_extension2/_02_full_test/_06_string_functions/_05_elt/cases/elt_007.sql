--combinations of different types of arguments


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
	);


insert into ioo values ('aaa,bbb,ccc,ddd,eee', n'aaa,bbb,ccc,ddd,eee', 'hello,there', n'hello,there', 'this is a string', 
			1234, 345, -4748930303, 333.4378373, -222.638392, 234.627829292, 282937, 
			date'2010-10-26', time'17:30:23', timestamp'10/26/2010 17:30:23', datetime'17:30:23.222 pm 2010-10-26'
			);


select elt(1, col1, col6, col13) from ioo;
select elt(2, col2, col7, col14) from ioo;
select elt(3, col8, col3, col9, col15) from ioo;
select elt(4, col9, col10, col11, col16, col4) from ioo;
select elt(3, col5, col10, col12, col15, col3) from ioo;


drop table ioo;



--without a table
select elt(2, 'aaa,bbb,ccc,ddd', 4, 10, 33.3333333);
select elt(3, 'kkkkk-rrrrr', 5, 3, date'1999-12-12');
select elt(4, 1234567, 3, 7, 'tttttttttttt', time'12:12:12');
select elt(1, 1234567, 3, 7, datetime'1888-3-14 12:34:22.332 pm', 'aaa');
select elt(5, 33, timestamp'3/15/1898 20:20:20', 4, 6, -8473844, 'abc');
select elt(3, time'2:45:54', 2, 4, 'uuuuuu_zzzzzzzz');



