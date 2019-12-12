--[er]test bit_length with smallint as parameter
create class tb(
		col1 smallint
);

insert into tb values(10);

select bit_length(col1) from tb;

drop class tb;
