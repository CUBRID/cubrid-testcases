--insert data with oid
create class tb2(
	id int primary key,
	address varchar(100)
);

create class tb1(
	id int primary key,
	name varchar(10),
	address tb2
);

insert into tb2 (id, address) values(1, 'beijing');
insert into tb2 (id, address) values(2, 'shanghai');

select tb2 into oid1 from tb2 where id = 1;
select tb2 into oid2 from tb2 where id = 2;

insert into tb1 (id, name, address) values(1, 'aaa', oid1);
insert into tb1 (id, name, address) values(2, 'bbb', oid2);

select * from tb1 order by 1,2;

drop class tb1;
drop class tb2;

