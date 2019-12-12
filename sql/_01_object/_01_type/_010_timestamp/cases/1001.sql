--Test data type of timestamp

create table xx ( tt timestamp ) ; 

insert into xx values (TIMESTAMP'23:59:59 PM 12/31/2022' ) ; 

select * from xx order by tt;


drop table xx;
