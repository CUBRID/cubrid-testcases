--test Relational operators(like >, <, >=, <=, =, <>) with TIMESTAMP type
create class tb ( 
	id int auto_increment primary key,
	col1 TIMESTAMP
);

insert into tb (col1) values('5/1/2008 1:15:45 pm');
insert into tb (col1) values('5/2/2008 2:15:45 pm');
insert into tb (col1) values('5/3/2008 3:15:45 am');
insert into tb (col1) values('5/4/2008 4:15:45 am');
insert into tb (col1) values('5/5/2008 5:15:45 pm');

select * from tb order by 1,2;

select * from tb where col1>'5/4/2008 4:15:45 am' order by 1,2;
select * from tb where col1>='5/4/2008 4:15:45 am' order by 1,2;
select * from tb where col1<'5/4/2008 4:15:45 am' order by 1,2;
select * from tb where col1<='5/4/2008 4:15:45 am' order by 1,2;
select * from tb where col1='5/4/2008 4:15:45 am' order by 1,2;
select * from tb where col1<>'5/4/2008 4:15:45 am' order by 1,2;

drop table tb;
