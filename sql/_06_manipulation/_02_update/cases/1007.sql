--[er]the same column appeared in one update statement two times
create class tb1(
	col1 int primary key,
	col2 varchar
);

insert into tb1 (col1, col2) values(1, 'aaa1');
insert into tb1 (col1, col2) values(2, 'aaa1');
insert into tb1 (col1, col2) values(3, 'aaa3');

update tb1 set col2='aaa4',col2='aaa5' where col2='aaa1';

drop class tb1;
