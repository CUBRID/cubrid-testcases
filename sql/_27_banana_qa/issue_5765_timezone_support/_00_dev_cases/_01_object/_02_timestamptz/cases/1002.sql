--[er]Test data type of timestamptz using error syntax

create table xx ( tt timestamptz ) ; 

insert into xx values (timestamptz'23:59:59 PM 12/31/2022 ) ; 

drop table xx;
