autocommit off;
call login('dba', '') on class db_user;
create class foo05 (fa int, fb varchar(10), fc float, fd numeric(2,2));
create index i_foo05_fa_fb_fc on foo05(fa, fb, fc);
select index_name, is_unique, key_count 
from db_index 
where class_name = 'foo05' 
order by index_name;
select index_name, key_attr_name, key_order 
from db_index_key 
where class_name = 'foo05' 
order by index_name, key_attr_name;
drop index i_foo05_fa_fb_fc on foo05(fa, fb, fc);
create index i_foo05_fc_fb_fa on foo05(fc, fb, fa);
select index_name, key_attr_name, key_order 
from db_index_key 
where class_name = 'foo05' 
order by index_name, key_attr_name;
create class bar05(ba int, bb varchar(10), unique(ba, bb));
select index_name, key_attr_name, key_order 
from db_index_key 
where class_name = 'bar05' 
order by index_name, key_attr_name;
create class foo051 (a int, b int, c int, unique(a,b));
create class foo052 (a int, b int, d int, unique(b,d));
create class subfoo05 under foo051, foo052 inherit a of foo051, b of foo052;
select * 
from db_attribute 
where class_name = 'subfoo05' 
order by attr_name, attr_type;
create index i_subfoo05_a on subfoo05(a);
select * 
from db_index_key 
where class_name = 'subfoo05' 
order by index_name, key_attr_name;
alter class foo052 drop constraint u_foo052_b_d;
select * 
from db_index_key 
where class_name = 'subfoo05' 
order by index_name, key_attr_name;
drop class foo05;
drop class foo051;
drop class foo052;
drop class subfoo05;
drop class bar05;
call login('dba', '') on class db_user;
rollback;
