--Test data type of timestamptz

create table xx ( tt timestamptz ) ; 

insert into xx values (timestamptz'23:59:59 PM 12/31/2022' ) ; 

select * from xx order by tt;


drop table xx;
