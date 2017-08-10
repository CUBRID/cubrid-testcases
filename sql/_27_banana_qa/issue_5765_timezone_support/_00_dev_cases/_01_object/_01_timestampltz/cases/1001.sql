--Test data type of timestampltz

create table xx ( tt timestampltz ) ; 

insert into xx values (timestampltz'23:59:59 PM 12/31/2022' ) ; 

select * from xx order by tt;


drop table xx;
