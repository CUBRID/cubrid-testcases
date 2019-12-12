--[er]test insert with auto_increment keyword and without column list in insert statement
create class tb(
col1 int auto_increment primary key,
col2 varchar(20),
col3 varchar(20)
);

insert into tb values('aaa1', 'bbb1');
insert into tb values('aaa2', 'bbb2');
insert into tb values('aaa3', 'bbb3');

select * from tb;

drop class tb;
