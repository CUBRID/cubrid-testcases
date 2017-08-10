--[er]test bit_length with date as parameter
create class tb(
		col1 date
);

insert into tb values('5/5/2008');

select bit_length(col1) from tb;

drop class tb;
