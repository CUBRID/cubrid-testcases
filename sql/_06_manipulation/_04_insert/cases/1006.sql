--[er]test insert with not null keyword and null value.
create class tb(
	col1 varchar(20), 
	col2 varchar(20) not null,
	col3 varchar(20)
);

insert into tb values('aaa',null,'bbb');

select * from tb;

drop class tb;