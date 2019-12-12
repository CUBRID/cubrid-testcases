--test bit_length with operators(+,-,*,/) and string as parameter
create class tb(
		col1 string
);

insert into tb values('hello');

select bit_length(col1)+20 from tb;
select bit_length(col1)-20 from tb;
select bit_length(col1)*20 from tb;
select bit_length(col1)/20 from tb;

drop class tb;
