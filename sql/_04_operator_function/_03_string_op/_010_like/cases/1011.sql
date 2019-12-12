--[er]test like function with date and other types
create class tb(
	col1 date
);

insert into tb values('8/8/2008');
insert into tb values('8/18/2008');
insert into tb values('2/8/2008');
insert into tb values('6/8/2008');

select * from tb where col1 like 1;
select * from tb where col1 like b'0001';
select * from tb where col1 like {1,2};
select * from tb where col1 like 1.23;
select * from tb where col1 like '%8%';
select * from tb where col1 like n'%8%';

drop class tb;

