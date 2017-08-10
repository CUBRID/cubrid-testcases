--test bit_length with bit as parameter
create class tb(
		col1 bit(4)
);

insert into tb values(b'0001');

select bit_length(col1) from tb;

drop class tb;
