--test octet_length with char, varchar, nchar, nchar varying, bit, bit varying
create class tb(
	col1 char(10),
	col2 varchar,
	col3 nchar(20),
	col4 nchar varying(20),
	col5 bit(8),
	col6 bit varying(8),
	col7 string
);

insert into tb values('char', 'varchar', n'nchar', n'nchar varying', b'0001', b'0001', 'string');

select octet_length(col1), octet_length(col2), octet_length(col3), octet_length(col4), octet_length(col5), octet_length(col6), octet_length(col7) from tb;
 
drop class tb;