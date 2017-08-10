--[er]test insert with invalid use of single quote
create class tb(
	col1 varchar(20)
);

insert into tb values(''a');

select * from tb;

drop class tb;