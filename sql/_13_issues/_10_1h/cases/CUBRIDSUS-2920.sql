create table tbl (
a int not null unique,
b int default 0,
c int,
index i_tbl_a_b_d_c (a, b desc, c)); 
create table tbl2 like tbl;

select * from db_index_key where class_name = 'tbl' order by index_name, key_order;
select * from db_index_key where class_name = 'tbl2' order by index_name, key_order;

drop table tbl;
drop table tbl2;
