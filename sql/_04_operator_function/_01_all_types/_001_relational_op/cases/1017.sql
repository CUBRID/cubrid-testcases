--test Relational operators(like >, <, >=, <=, =, <>) with smallint type
create class tb ( 
	id int auto_increment primary key,
	col1 smallint
);

insert into tb (col1) values(-32768);
insert into tb (col1) values(-10);
insert into tb (col1) values(10);
insert into tb (col1) values(-2222);
insert into tb (col1) values(2222);
insert into tb (col1) values(-3333.91);
insert into tb (col1) values(3333.91);
insert into tb (col1) values(-1111.11);
insert into tb (col1) values(1111.11);
insert into tb (col1) values(32767);

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

select * from tb where col1>-32768 order by id asc;
select * from tb where col1>=-32768 order by id asc;
select * from tb where col1<-32768 order by id asc;
select * from tb where col1<=-32768 order by id asc;
select * from tb where col1=-32768 order by id asc;
select * from tb where col1<>-32768 order by id asc;

select * from tb where col1>32767 order by id asc;
select * from tb where col1>=32767 order by id asc;
select * from tb where col1<32767 order by id asc;
select * from tb where col1<=32767 order by id asc;
select * from tb where col1=32767 order by id asc;
select * from tb where col1<>32767 order by id asc;

drop table tb;