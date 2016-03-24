autocommit off;
create view v_x_int;
alter view v_x_int add attribute x int;
select * from db_attribute where class_name = 'v_x_int';
drop view v_x_int;
rollback;
