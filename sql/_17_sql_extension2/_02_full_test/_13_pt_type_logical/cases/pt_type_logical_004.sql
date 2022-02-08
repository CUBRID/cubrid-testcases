--test mixed logical operators with integer operands on server side


create table pt_type_logical(col1 int, col2 int, col3 double, col4 double);

insert into pt_type_logical values(90021, -82932, 234.8080122384237492834234, 239874923.2934902384023);


select (col1<>0 xor col2<>0 xor 0<>0 xor 0<>0 xor col3<>0 xor col4<>0) from pt_type_logical;
select (col1<>0 and 0<>0 or col2<>0 xor true), (not col3<>0 and 1<>0 xor (not col4<>0 or false)) from pt_type_logical where (col1<>0 xor not col2<>0 or 0<>0) = 1;
select (not col3<>0 xor (col1<>0 or 0<>0) xor ((col1<>0 and col2<>0 or not false) xor (col4<>0 or col3<>0 xor true or null<>0))) from pt_type_logical;


drop table pt_type_logical;
