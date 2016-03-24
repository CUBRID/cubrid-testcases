create class aoo ( a int, b blob, c clob);
insert into aoo values(1, bit_to_blob(X'1122aabb'), char_to_clob('asselect'));
create class boo as select * from aoo;

select * from db_attribute where class_name='boo' order by 1;

delete from aoo;
delete from boo;
drop aoo;
drop boo;
