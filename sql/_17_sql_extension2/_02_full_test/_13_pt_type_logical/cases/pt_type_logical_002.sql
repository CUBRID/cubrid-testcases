--test logical operators with integer operands on server side


create table pt_type_test(col1 int, col2 float, col3 int, col4 float);

insert into pt_type_test values(234, 54.0984, -92829, -84353.293048203);
insert into pt_type_test values(8983, 3234.5565, -1123222, -58934.2342);


--and operator
select (col1<>0 and col2<>0) from pt_type_test order by 1;
select (col1<>0 and col3<>0) from pt_type_test where (col3<>0 and col4<>0) = 1 order by 1;
select (col2<>0 and true) from pt_type_test order by 1;
select (col3<>0 and null<>0) from pt_type_test where (col4<>0 or 0<>0) = 0 order by 1;
select (col4<>0 and 0<>0), (col2<>0 and 1<>0) from pt_type_test where not col3 = 0 order by 1;


--or operator
select (col1<>0 or col4<>0) from pt_type_test order by 1;
select (col2<>0 or 0<>0) from pt_type_test order by 1;
select (col3<>0 or col4<>0) from pt_type_test where (col1<>0 xor col4<>0) = 1 order by 1;
select (col1<>0 or true), (col2<>0 or false) from pt_type_test where (col3<>0 and col4<>0) = 1 order by 1;


--xor operator
select (col1<>0 xor col2<>0) from pt_type_test order by 1;
select (col1<>0 xor 1<>0) from pt_type_test where col1<>0 xor (col4 = 1)<>0 order by 1;
select (col3<>0 xor 0<>0) from pt_type_test order by 1;
select (col4<>0 xor true) from pt_type_test where not col3 = 0 order by 1;
select (col1<>0 xor col2<>0 xor col3<>0 xor col4<>0) from pt_type_test order by 1;
select (col1<>0 xor col2<>0 xor col3<>0 xor col4<>0 xor null<>0) from pt_type_test order by 1;


--not operator
select (not col1<>0), (not col2<>0) from pt_type_test order by 1;
select (not col3<>0), (not col4<>0) from pt_type_test where col1<>0 xor (col2 = 1)<>0 order by 1;


drop table pt_type_test;
