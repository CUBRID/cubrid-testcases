--[er]test bit_length with timestamp as parameter
create class tb(
		col1 timestamp
);

insert into tb values('8/8/2008 10:10:10 am');

select bit_length(col1) from tb;

drop class tb;
