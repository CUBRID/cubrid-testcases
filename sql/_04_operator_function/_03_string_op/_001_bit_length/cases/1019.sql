--[er]test bit_length with time as parameter
create class tb(
		col1 time
);

insert into tb values('10:10:10 am');

select bit_length(col1) from tb;

drop class tb;
