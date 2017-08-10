--test delete by delete the same table two times
create class tb(
	col1 int auto_increment primary key,
	col2 varchar(20)
);

insert into tb (col2) values('aaa1');
insert into tb (col2) values('aaa2');
insert into tb (col2) values('aaa3');

delete from tb;
delete from tb;

drop class tb;

