--insert data with all data type
create class tb(
	col1 char(20),
	col2 nchar(20),
	col3 nchar varying(20),
	col4 bit(8),
	col5 bit varying(8),
	col6 numeric,
	col7 integer,
	col8 smallint,
	col9 monetary,
	col10 float,
	col11 double,
	col12 date,
	col13 time,
	col14 timestamp,
	col15 set,
	col16 multiset,
	col17 sequence
);

insert into tb (col1, col2, col3, col4, col5, col6, col7, col8, col9, col10, col11, col12, col13, col14,col15, col16, col17)
 values('aaa', n'aaa', n'aaa', b'0011', b'0011', 10, 11, 12, 13, 14, 15, '1/1/2008', '1:1:1 pm', '01/31/1994 8:15:00 pm', {10, 20}, {'abc','def'}, {50,60,70});

select * from tb;

drop class tb;
