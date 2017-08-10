--[er]test insert without table name in insert statement 
create class tb(
	col1 varchar(20)
);

insert into values('aaa');

select * from tb;

drop class tb;