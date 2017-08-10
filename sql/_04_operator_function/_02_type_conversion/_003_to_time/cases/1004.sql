-- create table which insert data into using data type of string and int and test 'AMPM' in function of to_time using parameter of time string and using format_argument of 'Am HH:MI:SS', 'am HH:MI:SS','Pm HH:MI:SS', 'pm HH:MI:SS', 'A.M. HH:MI:SS', 'P.M. HH:MI:SS', 'a.m. HH:MI:SS', 'p.m. HH:MI:SS' and then dorp table

create table AMPM_TEST_US ( u_date String, u_type String, ord int);
insert into AMPM_TEST_US values ('AM 5:33:12','AM',1);
insert into AMPM_TEST_US values ('PM 5:33:12','AM',2);
insert into AMPM_TEST_US values ('Am 5:33:12','AM',3);
insert into AMPM_TEST_US values ('Pm 5:33:12','AM',4);
insert into AMPM_TEST_US values ('am 5:33:12','AM',5);
insert into AMPM_TEST_US values ('pm 5:33:12','AM',6);
insert into AMPM_TEST_US values ('A.M. 5:33:12','AM.',7);
insert into AMPM_TEST_US values ('P.M. 5:33:12','AM.',8);
insert into AMPM_TEST_US values ('A.m. 5:33:12','AM.',9);
insert into AMPM_TEST_US values ('P.m. 5:33:12','AM.',10);
insert into AMPM_TEST_US values ('a.m. 5:33:12','AM.',11);
insert into AMPM_TEST_US values ('p.m. 5:33:12','AM.',12);
select u_date, to_time( u_date, 'AM HH:MI:SS','En_US') , to_time( u_date, 'PM HH:MI:SS','En_US') 
from AMPM_TEST_US order by ord;

select u_date, to_time( u_date, 'Am HH:MI:SS','En_US') , to_time( u_date, 'Pm HH:MI:SS','En_US') 
from AMPM_TEST_US order by ord;

select u_date, to_time( u_date, 'am HH:MI:SS','En_US') , to_time( u_date, 'pm HH:MI:SS','En_US') 
from AMPM_TEST_US order by ord;

select u_date, to_time( u_date, 'A.M. HH:MI:SS','En_US') , to_time( u_date, 'P.M. HH:MI:SS','En_US') 
from AMPM_TEST_US order by ord;

select u_date, to_time( u_date, 'A.m. HH:MI:SS','En_US') , to_time( u_date, 'P.m. HH:MI:SS','En_US') 
from AMPM_TEST_US order by ord;

select u_date, to_time( u_date, 'a.m. HH:MI:SS','En_US') , to_time( u_date, 'p.m. HH:MI:SS','En_US') 
from AMPM_TEST_US order by ord;


drop table AMPM_TEST_US;