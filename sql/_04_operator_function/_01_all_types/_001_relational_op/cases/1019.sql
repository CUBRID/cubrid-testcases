--test Relational operators(like >, <, >=, <=, =, <>) with numeric type
create class tb ( 
	id int auto_increment primary key,
	col1 NUMERIC(38,2)
);

insert into tb (col1) values(-999999999999999999999999999999999999.99);
insert into tb (col1) values(-10);
insert into tb (col1) values(10);
insert into tb (col1) values(-2222);
insert into tb (col1) values(2222);
insert into tb (col1) values(-3333.91);
insert into tb (col1) values(3333.91);
insert into tb (col1) values(-1111.11);
insert into tb (col1) values(1111.11);
insert into tb (col1) values(999999999999999999999999999999999999.99);

select * from tb where col1>1111 order by id asc;
select * from tb where col1>=1111 order by id asc;
select * from tb where col1<2222 order by id asc;
select * from tb where col1<=2222 order by id asc;
select * from tb where col1=1111 order by id asc;
select * from tb where col1<>1111 order by id asc;

select * from tb where col1>-1111 order by id asc;
select * from tb where col1>=-1111 order by id asc;
select * from tb where col1<-2222 order by id asc;
select * from tb where col1<=-2222 order by id asc;
select * from tb where col1=-1111 order by id asc;
select * from tb where col1<>-1111 order by id asc;

select * from tb where col1>3333.91 order by id asc;
select * from tb where col1>=3333.91 order by id asc;
select * from tb where col1<3333.91 order by id asc;
select * from tb where col1<=3333.91 order by id asc;
select * from tb where col1=3333.91 order by id asc;
select * from tb where col1<>3333.91 order by id asc;

select * from tb where col1>-3333.91 order by id asc;
select * from tb where col1>=-3333.91 order by id asc;
select * from tb where col1<-3333.91 order by id asc;
select * from tb where col1<=-3333.91 order by id asc;
select * from tb where col1=-3333.91 order by id asc;
select * from tb where col1<>-3333.91 order by id asc;

select * from tb where col1>-999999999999999999999999999999999999.99 order by id asc;
select * from tb where col1>=-999999999999999999999999999999999999.99 order by id asc;
select * from tb where col1<-999999999999999999999999999999999999.99 order by id asc;
select * from tb where col1<=-999999999999999999999999999999999999.99 order by id asc;
select * from tb where col1=-999999999999999999999999999999999999.99 order by id asc;
select * from tb where col1<>-999999999999999999999999999999999999.99 order by id asc;

select * from tb where col1>999999999999999999999999999999999999.99 order by id asc;
select * from tb where col1>=999999999999999999999999999999999999.99 order by id asc;
select * from tb where col1<999999999999999999999999999999999999.99 order by id asc;
select * from tb where col1<=999999999999999999999999999999999999.99 order by id asc;
select * from tb where col1=999999999999999999999999999999999999.99 order by id asc;
select * from tb where col1<>999999999999999999999999999999999999.99 order by id asc;

drop table tb;