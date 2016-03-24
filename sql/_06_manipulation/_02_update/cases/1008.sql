--[er]test update without update columns
create class tb1(
	col1 int primary key,
	col2 varchar
);

insert into tb1 (col1, col2) values(1, 'aaa');
update tb1 set ;

drop class tb1;
