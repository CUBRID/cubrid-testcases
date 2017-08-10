--test bit_length with char as parameter
create class tb(
		col1 char(2)
);

insert into tb values('ok');

select bit_length(col1) from tb;

drop class tb;
