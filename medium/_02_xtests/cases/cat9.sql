autocommit off;
call login('dba', '') on class db_user;
create class foo09 (fa int, fb varchar(10), fc float, fd numeric(2,2));
create index i_foo09_fa_fb_fc on foo09(fa, fb, fc);
select index_name, is_unique, key_count 
from db_index 
where class_name = 'foo09' 
order by index_name;
select index_name, key_attr_name, key_order 
from db_index_key 
where class_name = 'foo09' 
order by index_name, key_attr_name;
drop index i_foo09_fa_fb_fc on foo09(fa, fb, fc);
create index i_foo09_fc_fb_fa on foo09(fc, fb, fa);
select index_name, key_attr_name, key_order 
from db_index_key 
where class_name = 'foo09' 
order by index_name, key_attr_name;
create class bar09(ba int, bb varchar(10), unique(ba, bb));
select index_name, key_attr_name, key_order 
from db_index_key 
where class_name = 'bar09' 
order by index_name, key_attr_name;
create class foo09_1 (a int, b int, c int, unique(a,b));
create class foo09_2 (a int, b int, d int, unique(b,d));
create class subfoo09 under foo09_1, foo09_2 inherit a of foo09_1, b of foo09_2;
select * 
from db_attribute 
where class_name = 'subfoo09' 
order by attr_name, attr_type;
create index i_subfoo09_a on subfoo09(a);
select * 
from db_index_key 
where class_name = 'subfoo09' 
order by index_name, key_attr_name;
alter class foo09_2 drop constraint u_foo09_2_b_d;
select * 
from db_index_key 
where class_name = 'subfoo09' 
order by index_name, key_attr_name;
drop class foo09;
drop class bar09;
drop class foo09_1;
drop class foo09_2;
drop class subfoo09;
call login('dba', '') on class db_user;
rollback;
