--test normal insert without column list in insert statement
create class tb(
col1 int primary key,
col2 varchar(20),
col3 varchar(20)
);

insert into tb values(1, 'aaa1', 'bbb1');
insert into tb values(2, 'aaa2', 'bbb2');
insert into tb values(3, 'aaa3', 'bbb3');

select * from tb;

drop class tb;