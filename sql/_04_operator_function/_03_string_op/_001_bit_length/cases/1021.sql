--test bit_length with string as parameter
create class tb(
		col1 string
);

insert into tb values('hello');

select bit_length(col1) from tb;

drop class tb;
