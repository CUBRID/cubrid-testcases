--[er]test insert with data overflow
create class tb(
	col1 varchar(3)
);

insert into tb values('aaa4');

select * from tb;

drop class tb;