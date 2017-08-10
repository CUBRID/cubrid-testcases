--test bit_length with varchar as parameter
create class tb(
		col1 varchar
);

insert into tb values('ok');

select bit_length(col1) from tb;

drop class tb;
