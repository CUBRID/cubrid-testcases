--test Relational operators(like >, <, >=, <=, =, <>) with MONETARY type
create class tb ( 
	id int auto_increment primary key,
	col1 MONETARY
);

insert into tb (col1) values(2.2250738585072014e-308);
insert into tb (col1) values(-10);
insert into tb (col1) values(10);
insert into tb (col1) values(-2222);
insert into tb (col1) values(2222);
insert into tb (col1) values(-3333.91);
insert into tb (col1) values(3333.91);
insert into tb (col1) values(-1111.11);
insert into tb (col1) values(1111.11);
insert into tb (col1) values(1.7976931348623157e+308);

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

select * from tb where col1>2.2250738585072014e-308 order by 1,2;
select * from tb where col1>=2.2250738585072014e-308 order by 1,2;
select * from tb where col1<2.2250738585072014e-308 order by 1,2;
select * from tb where col1<=2.2250738585072014e-308 order by 1,2;
select * from tb where col1=2.2250738585072014e-308 order by 1,2;
select * from tb where col1<>2.2250738585072014e-308 order by 1,2;

select * from tb where col1>1.7976931348623157e+308 order by 1,2;
select * from tb where col1>=1.7976931348623157e+308 order by 1,2;
select * from tb where col1<1.7976931348623157e+308 order by 1,2;
select * from tb where col1<=1.7976931348623157e+308 order by 1,2;
select * from tb where col1=1.7976931348623157e+308 order by 1,2;
select * from tb where col1<>1.7976931348623157e+308 order by 1,2;

drop table tb;
