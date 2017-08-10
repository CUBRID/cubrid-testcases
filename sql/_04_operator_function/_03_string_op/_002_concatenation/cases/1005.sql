--test operator || with all type without nchar and nchar varying 
create class tb(
		col1 char(4),
		col2 varchar,
		col3 bit(8),
		col4 bit varying(8),
		col5 numeric,
		col6 integer,
		col7 smallint,
		col8 monetary,
		col9 float,
		col10 double,
		col11 date,
		col12 time,
		col13 timestamp,
		col14 string
);

insert into tb values('char', 'varchar',  b'0001', b'0001', 7, 8, 9, 10, 11, 12, '5/5/2008', '10:10:10 am', '5/5/2008 10:10:10 am', 'string');

select col1||col2||col3||col4||col5||col6||col7||col8||col9||col10||col11||col12||col13||col14 from tb;

drop class tb;
