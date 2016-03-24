--[er]test update pk with a value existed already 
create class tb1(
	col1 int primary key,
	col2 varchar
);

insert into tb1 (col1, col2) values(1, 'aaa1');
insert into tb1 (col1, col2) values(2, 'aaa2');
insert into tb1 (col1, col2) values(3, 'aaa3');

update tb1 set col1=2 where col1=1;

drop class tb1;
