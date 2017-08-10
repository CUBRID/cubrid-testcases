--[er]test bit_length with int as parameter
create class tb(
		col1 int
);

insert into tb values(10);

select bit_length(col1) from tb;

drop class tb;
