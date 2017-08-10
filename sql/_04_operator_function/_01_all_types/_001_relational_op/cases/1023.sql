--test Relational operators(like >, <, >=, <=, =, <>) with date type
create class tb ( 
	id int auto_increment primary key,
	col1 date
);

insert into tb (col1) values('5/1/2008');
insert into tb (col1) values('5/2/2007');
insert into tb (col1) values('5/3/2009');
insert into tb (col1) values('5/4/2008');
insert into tb (col1) values('5/5/2006');


select * from tb order by 1,2;

select * from tb where col1>'5/3/2009' order by 1,2;
select * from tb where col1>='5/3/2009' order by 1,2;
select * from tb where col1<'5/3/2009' order by 1,2;
select * from tb where col1<='5/3/2009' order by 1,2;
select * from tb where col1='5/3/2009' order by 1,2;
select * from tb where col1<>'5/3/2009' order by 1,2;

drop table tb;
