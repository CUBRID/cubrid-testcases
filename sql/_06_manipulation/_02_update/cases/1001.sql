--test normal update
create class tb1(
	col1 int auto_increment primary key,
	col2 varchar
);

insert into tb1 (col2) values('aaa1');
insert into tb1 (col2) values('aaa2');
insert into tb1 (col2) values('aaa3');

update tb1 set col2='col111' where col1=1;

drop class tb1;
