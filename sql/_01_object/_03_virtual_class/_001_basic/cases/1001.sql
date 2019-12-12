-- create class,create view with alias,select data from system tables about the vclass information,drop table and view

create class a_tbl( a int, b int);

create view a_view as select a +1 x from a_tbl;
create view b_view as select to_char(a ) x from a_tbl;
create view c_view as select a + b x from a_tbl;
create view d_view as select cast( a as string) x from a_tbl;

create view e_view as select cast( a as string) x, a, b  from a_tbl;
create view f_view as select cast( a as string) x, a y, a xx,  b  from a_tbl;
create view g_view as select cast( a as string) x, a +b xx  from a_tbl;
create view h_view as select cast( a as string) x, a xxx, a xx,  b y , b + 1 yy  from a_tbl;

select class_name, attr_name from db_attribute where class_name = 'a_view' order by 1,2;
select class_name, attr_name from db_attribute where class_name = 'b_view' order by 1,2;
select class_name, attr_name from db_attribute where class_name = 'c_view' order by 1,2;
select class_name, attr_name from db_attribute where class_name = 'd_view' order by 1,2;
select class_name, attr_name from db_attribute where class_name = 'e_view' order by 1,2;
select class_name, attr_name from db_attribute where class_name = 'f_view' order by 1,2;
select class_name, attr_name from db_attribute where class_name = 'g_view' order by 1,2;
select class_name, attr_name from db_attribute where class_name = 'h_view' order by 1,2;

select * from  a_tbl ; 
select * from  a_view ;
select * from  b_view ;
select * from  c_view ;
select * from  d_view ;
select * from  e_view ;
select * from  f_view ;
select * from  g_view ;
select * from  h_view ;



drop a_tbl;
drop view a_view;
drop view b_view;
drop view c_view;
drop view d_view;
drop view e_view;
drop view f_view;
drop view g_view;
drop view h_view;
