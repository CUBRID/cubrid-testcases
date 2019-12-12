--[er]Test data type of timestamp using error syntax

create table xx ( tt timestamp ) ; 

insert into xx values (TIMESTAMP'23:59:59 PM 12/31/2022 ) ; 

drop table xx;
