--test bit_length with nchar varying as parameter
create class tb(
		col1 nchar varying(2)
);

insert into tb values(n'ok');

select bit_length(col1) from tb;

drop class tb;
