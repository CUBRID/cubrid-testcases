--test Relational operators(like >, <, >=, <=, =, <>) with flot type
create class tb ( 
	id int auto_increment primary key,
	col1 float
);

insert into tb (col1) values(1.175494e-38);
insert into tb (col1) values(-10);
insert into tb (col1) values(10);
insert into tb (col1) values(-2222);
insert into tb (col1) values(2222);
insert into tb (col1) values(-3333.91);
insert into tb (col1) values(3333.91);
insert into tb (col1) values(-1111.11);
insert into tb (col1) values(1111.11);
insert into tb (col1) values(3.402823e+38);

select * from tb where col1>1111 order by 1,2;
select * from tb where col1>=1111 order by 1,2;
select * from tb where col1<2222 order by 1,2;
select * from tb where col1<=2222 order by 1,2;
select * from tb where col1=1111 order by 1,2;
select * from tb where col1<>1111 order by 1,2;

select * from tb where col1>-1111 order by 1,2;
select * from tb where col1>=-1111 order by 1,2;
select * from tb where col1<-2222 order by 1,2;
select * from tb where col1<=-2222 order by 1,2;
select * from tb where col1=-1111 order by 1,2;
select * from tb where col1<>-1111 order by 1,2;

select * from tb where col1>3333.91 order by 1,2;
select * from tb where col1>=3333.91 order by 1,2;
select * from tb where col1<3333.91 order by 1,2;
select * from tb where col1<=3333.91 order by 1,2;
select * from tb where col1=3333.91 order by 1,2;
select * from tb where col1<>3333.91 order by 1,2;

select * from tb where col1>-3333.91 order by 1,2;
select * from tb where col1>=-3333.91 order by 1,2;
select * from tb where col1<-3333.91 order by 1,2;
select * from tb where col1<=-3333.91 order by 1,2;
select * from tb where col1=-3333.91 order by 1,2;
select * from tb where col1<>-3333.91 order by 1,2;

select * from tb where col1>-1.175494e-38 order by 1,2;
select * from tb where col1>=-1.175494e-38 order by 1,2;
select * from tb where col1<-1.175494e-38 order by 1,2;
select * from tb where col1<=-1.175494e-38 order by 1,2;
select * from tb where col1=-1.175494e-38 order by 1,2;
select * from tb where col1<>-1.175494e-38 order by 1,2;

select * from tb where col1>3.402823e+38 order by 1,2;
select * from tb where col1>=3.402823e+38 order by 1,2;
select * from tb where col1<3.402823e+38 order by 1,2;
select * from tb where col1<=3.402823e+38 order by 1,2;
select * from tb where col1=3.402823e+38 order by 1,2;
select * from tb where col1<>3.402823e+38 order by 1,2;

drop table tb;
