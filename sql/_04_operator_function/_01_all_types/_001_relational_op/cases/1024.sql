--test Relational operators(like >, <, >=, <=, =, <>) with time type
create class tb ( 
	id int auto_increment primary key,
	col1 time
);

insert into tb (col1) values('1:15:45 pm');
insert into tb (col1) values('2:15:45 pm');
insert into tb (col1) values('3:15:45 am');
insert into tb (col1) values('4:15:45 am');
insert into tb (col1) values('5:15:45 pm');


select * from tb order by 1,2;

select * from tb where col1>'3:15:45 am' order by 1,2;
select * from tb where col1>='3:15:45 am' order by 1,2;
select * from tb where col1<'3:15:45 am' order by 1,2;
select * from tb where col1<='3:15:45 am' order by 1,2;
select * from tb where col1='3:15:45 am' order by 1,2;
select * from tb where col1<>'3:15:45 am' order by 1,2;

drop table tb;
