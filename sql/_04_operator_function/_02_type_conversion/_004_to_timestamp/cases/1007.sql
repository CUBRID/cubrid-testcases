-- create  table which insert data into using data type of string and int and test "am,pm" in function of to_timestamp using parameter of selected format and 'En_US' and then dorp table

create table AMPM_TEST_US ( u_date String, u_type String, ord int);
insert into AMPM_TEST_US values ('2005/12/06 AM 5:33:12','AM',1);
insert into AMPM_TEST_US values ('2005/12/06 PM 5:33:12','AM',2);
insert into AMPM_TEST_US values ('2005/12/06 Am 5:33:12','AM',3);
insert into AMPM_TEST_US values ('2005/12/06 Pm 5:33:12','AM',4);
insert into AMPM_TEST_US values ('2005/12/06 am 5:33:12','AM',5);
insert into AMPM_TEST_US values ('2005/12/06 pm 5:33:12','AM',6);

insert into AMPM_TEST_US values ('2005/12/06 A.M. 5:33:12','AM.',7);
insert into AMPM_TEST_US values ('2005/12/06 P.M. 5:33:12','AM.',8);
insert into AMPM_TEST_US values ('2005/12/06 A.m. 5:33:12','AM.',9);
insert into AMPM_TEST_US values ('2005/12/06 P.m. 5:33:12','AM.',10);
insert into AMPM_TEST_US values ('2005/12/06 a.m. 5:33:12','AM.',11);
insert into AMPM_TEST_US values ('2005/12/06 p.m. 5:33:12','AM.',12);
select u_date, to_timestamp( u_date, 'YYYY/MM/DD AM HH:MI:SS','En_US') , to_timestamp( u_date, 'YYYY/MM/DD PM HH:MI:SS','En_US') 
from AMPM_TEST_US order by ord ;

select u_date, to_timestamp( u_date, 'YYYY/MM/DD Am HH:MI:SS','En_US') , to_timestamp( u_date, 'YYYY/MM/DD Pm HH:MI:SS','En_US') 
from AMPM_TEST_US order by ord ;

select u_date, to_timestamp( u_date, 'YYYY/MM/DD am HH:MI:SS','En_US') , to_timestamp( u_date, 'YYYY/MM/DD pm HH:MI:SS','En_US') 
from AMPM_TEST_US order by ord ;

select u_date, to_timestamp( u_date, 'YYYY/MM/DD A.M. HH:MI:SS','En_US') , to_timestamp( u_date, 'YYYY/MM/DD P.M. HH:MI:SS','En_US') 
from AMPM_TEST_US order by ord ;

select u_date, to_timestamp( u_date, 'YYYY/MM/DD A.m. HH:MI:SS','En_US') , to_timestamp( u_date, 'YYYY/MM/DD P.m. HH:MI:SS','En_US') 
from AMPM_TEST_US order by ord ;

select u_date, to_timestamp( u_date, 'YYYY/MM/DD a.m. HH:MI:SS','En_US') , to_timestamp( u_date, 'YYYY/MM/DD p.m. HH:MI:SS','En_US') 
from AMPM_TEST_US order by ord ;


drop table AMPM_TEST_US;