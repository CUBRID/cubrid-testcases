--[er]Test data type of timestampltz using error syntax

create table xx ( tt timestampltz ) ; 

insert into xx values (timestampltz'23:59:59 PM 12/31/2022 ) ; 

drop table xx;
