--[er]test insert with not null keyword and the value omitted
create class tb(
	col1 varchar(20), 
	col2 varchar(20) not null,
	col3 varchar(20)
);

insert into tb values('aaa',,'bbb');

select * from tb;

drop class tb;