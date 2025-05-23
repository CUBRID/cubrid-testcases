drop table if exists tbl;
create table tbl(i1 int, i2 int, i3 int); 
insert into tbl values(1,1,1),(1,1,2),(1,2,1),(1,2,2),(1,2,3),(2,1,1),(2,1,2),(2,1,3),(2,1,4),(2,2,1),(2,2,2),(2,3,1),(2,3,2),(2,3,3);

prepare stmt from 'select i1,i2,i3,count(?) over(),min(?) over(),trunc((max(?) over()),1),trunc((sum(?) over()),1),trunc((avg(?) over()),1),trunc((stddev(?) over()),1),trunc((variance(?) over()),1),trunc((stddev_pop(?) over()),1),trunc((var_pop(?) over()),1),trunc((stddev_samp(?) over()),1),trunc((var_samp(?) over()),1) from tbl order by i1,i2,i3';
execute stmt using '1.1', '2.2', '3.1', '4.4', '5.7', '0.2', '7.9', '8.5', '9.3', '0.4', '11.8';
deallocate prepare stmt;

drop tbl;
