-- make prefic index while creating and altering a table

create table c1 (a char(10), b char(10), c char(10), d char(10), index i_c1_a (a(5)), index idx_c1 (b(5)), index i_c1_c_d (c(5) desc), key i_c1_d_d (d(5) desc)); 
create table c2 (a char(10), b char(10), c char(10)); 
alter table c2 add index i_c2_a (a(5) asc); 
alter table c2 add index idx_c2 (b(5)), add key i_c2_c_d(c(5) desc) ; 

select * from db_index where class_name like 'c%' order by class_name, index_name; 
select * from db_index_key where class_name like 'c%' order by class_name, index_name; 

drop table c1;
drop table c2;
