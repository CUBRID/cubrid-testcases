create table c01(id bigint primary key, col1 timestamp);
alter table c01 change col1 col1 timestamp default CURRENT_TIMESTAMP;
select col1 from c01 where id =1;
select col1 from c01;
drop table c01;


