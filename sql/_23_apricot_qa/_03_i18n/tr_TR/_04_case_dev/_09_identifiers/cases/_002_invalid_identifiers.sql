-- invalid chars for identifier
create table t1;

alter table t1 add column i_€ int;

-- not a letter in TR
alter table t1 add column i_Ÿ int;

drop table t1;
