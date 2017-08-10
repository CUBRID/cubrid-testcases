--delete all data with delete conditions
create class tb(
	col1 int auto_increment primary key,
	col2 varchar(20)
);

insert into tb (col2) values('aaa1');
insert into tb (col2) values('aaa2');
insert into tb (col2) values('aaa3');
select * from tb order by 1;

delete from tb where col1=1;
select * from tb order by 1;

drop class tb;
