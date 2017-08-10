-- create view from a table which have blob/clob column.
create table vc_tb(a int, b blob,c clob);

insert into vc_tb values (1, bit_to_blob(B'10010'), char_to_clob('abcdef'));
insert into vc_tb values (2, bit_to_blob(B'10011'), char_to_clob('cefabc'));

create view fbo_view1 as select * from vc_tb;
create view fbo_view2 as select a+1 x , b , c from vc_tb;
create view fbo_view3 as select * from vc_tb where a >5 with check option;
insert into v(a) values (6);
insert into v(a) values (3);

select a,blob_to_bit(b),clob_to_char(c) from vc_tb order by 1;
select a,blob_to_bit(b),clob_to_char(c) from fbo_view1 order by 1;
select x,blob_to_bit(b),clob_to_char(c) from fbo_view2 order by 1;
select a,blob_to_bit(b),clob_to_char(c) from fbo_view3 order by 1;


select class_name, attr_name from db_attribute where class_name = 'fbo_view1' order by 2,1;
select class_name, attr_name from db_attribute where class_name = 'fbo_view2' order by 2,1;
select class_name, attr_name from db_attribute where class_name = 'fbo_view3' order by 2,1;


drop view fbo_view1;
drop view fbo_view2;
drop view fbo_view3;
delete from vc_tb;
drop table vc_tb;

