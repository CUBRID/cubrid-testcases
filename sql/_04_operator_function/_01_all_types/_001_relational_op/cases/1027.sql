--test Relational operators(like >, <, >=, <=, =, <>) with LIST  type
create class tb ( 
	id int auto_increment primary key,
	col1 LIST 
);

insert into tb (col1) values({1,2,3});
insert into tb (col1) values({11,12,13});
insert into tb (col1) values({21,22,23});
insert into tb (col1) values({31,32,33});
insert into tb (col1) values({41,42,43});

select * from tb order by id;;

select * from tb where col1>{11,12,13} order by id;
select * from tb where col1>={11,12,13} order by id;
select * from tb where col1<{11,12,13} order by id;
select * from tb where col1<={11,12,13} order by id;
select * from tb where col1={11,12,13} order by id;
select * from tb where col1<>{11,12,13} order by id;

drop table tb;
