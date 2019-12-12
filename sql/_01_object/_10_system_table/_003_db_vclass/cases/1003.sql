--Create view with alias,select data from system tables about the vclass information

create class a_tbl( a int, b int);

create view a_view as select a +1 x from a_tbl;
create view b_view as select to_char(a ) x from a_tbl;

select * from db_vclass
where  vclass_name like '%view';

drop a_tbl;


select * from db_vclass
where  vclass_name like '%view';

drop view a_view;
drop view b_view;