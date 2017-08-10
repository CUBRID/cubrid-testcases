-- create  table which insert data into using data type of string and int and test "am,pm" in function of to_timestamp using parameter of selected format and 'Ko_KR' and then dorp table 

create table AMPM_Test ( u_day string, ord int);

insert into AMPM_TEST values ('2005/12/06 ?? 5:33:12',1);
insert into AMPM_TEST values ('2005/12/06 ?? 5:33:12',2);



select 'AM,PM', u_day, to_timestamp( u_day ,'YYYY/MM/DD AM HH:MI:SS','Ko_KR'), to_timestamp( u_day,'YYYY/MM/DD PM HH:MI:SS','Ko_KR') 
from AMPM_Test order by ord;

select 'Am,Pm', u_day, to_timestamp( u_day ,'YYYY/MM/DD Am HH:MI:SS','Ko_KR'), to_timestamp( u_day,'YYYY/MM/DD Pm HH:MI:SS','Ko_KR') 
from AMPM_Test order by ord;

select 'am,pm', u_day, to_timestamp( u_day ,'YYYY/MM/DD am HH:MI:SS','Ko_KR'), to_timestamp( u_day,'YYYY/MM/DD pm HH:MI:SS','Ko_KR') 
from AMPM_Test order by ord;

select 'A.M.,P.M.', u_day, to_timestamp( u_day ,'YYYY/MM/DD A.M. HH:MI:SS','Ko_KR'), to_timestamp( u_day,'YYYY/MM/DD P.M. HH:MI:SS','Ko_KR') 
from AMPM_Test order by ord;

select 'A.m.,P.m.', u_day, to_timestamp( u_day ,'YYYY/MM/DD A.m. HH:MI:SS','Ko_KR'), to_timestamp( u_day,'YYYY/MM/DD P.m. HH:MI:SS','Ko_KR') 
from AMPM_Test order by ord ;

select 'a.m.,p.m.', u_day, to_timestamp( u_day ,'YYYY/MM/DD a.m. HH:MI:SS','Ko_KR'), to_timestamp( u_day,'YYYY/MM/DD p.m. HH:MI:SS','Ko_KR') 
from AMPM_Test order by ord ;



drop table AMPM_Test ;