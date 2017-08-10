--[er]test operator + with date and bit
create class tb(
		col1 date,
		col2 bit(8)
);

insert into tb  values('5/5/2008', b'0001');

select col1+col2 from tb;


drop class tb;

