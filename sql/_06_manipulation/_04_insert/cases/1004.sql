--test insert with a column whose attribute has auto_increment keyword
create class tb(
col1 int auto_increment primary key,
col2 varchar(20),
col3 varchar(20)
);

insert into tb (col2, col3) values('aaa1', 'bbb1');
insert into tb (col2, col3) values('aaa2', 'bbb2');
insert into tb (col2, col3) values('aaa3', 'bbb3');

select * from tb;

drop class tb;




