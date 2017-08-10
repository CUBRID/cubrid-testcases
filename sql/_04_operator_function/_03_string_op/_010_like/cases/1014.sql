--[er]test like function with nchar and other types
create class tb(
	col1 nchar(10)
);

insert into tb values(n'nchar1');
insert into tb values(n'nchar2');

select * from tb where col1 like 1;
select * from tb where col1 like b'0001';
select * from tb where col1 like {1,2};
select * from tb where col1 like 1.23;
select * from tb where col1 like '%ch%';
select * from tb where col1 like n'%ch%';

drop class tb;
