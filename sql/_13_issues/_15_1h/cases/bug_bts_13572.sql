drop table if exists tt1;

create table tt1 (s1 sequence ( integer, char varying, integer ), i1 integer, i2 integer auto_increment, i3 integer unique, i4 integer default 33, n1 numeric(10) not NULL, n2 numeric (10,2), n3 numeric);

set optimization level 513;
-- show columns didn't show queryPlan
show columns from tt1 where `Type` like 'NUMERIC%';

drop table tt1;
-- 1 is a default value used in CUBRID  
set optimization level 1;
