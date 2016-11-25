--test hint using USE_NL
create class tb1(
	id int auto_increment primary key,
	name varchar(10)
);

create class tb2(
	id int auto_increment primary key,
	address varchar(10)
);

insert into tb1 (name) values('aaa');
insert into tb1 (name) values('bbb');
insert into tb2 (address) values('beijing');
insert into tb2 (address) values('shanghai');

SELECT /*+ USE_NL */
     a.id, a.name, b.address 
FROM tb1 a, tb2 b 
WHERE a.id = b.id order by 1;
 
drop table tb1;
drop table tb2;

