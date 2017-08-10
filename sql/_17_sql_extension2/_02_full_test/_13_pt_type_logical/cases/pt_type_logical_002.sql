--test logical operators with integer operands on server side


create table pt_type_test(col1 int, col2 float, col3 int, col4 float);

insert into pt_type_test values(234, 54.0984, -92829, -84353.293048203);
insert into pt_type_test values(8983, 3234.5565, -1123222, -58934.2342);


--and operator
select (col1 and col2) from pt_type_test order by 1;
select (col1 and col3) from pt_type_test where (col3 and col4) = 1 order by 1;
select (col2 and true) from pt_type_test order by 1;
select (col3 and null) from pt_type_test where (col4 or 0) = 0 order by 1;
select (col4 and 0), (col2 and 1) from pt_type_test where not col3 = 0 order by 1;


--or operator
select (col1 or col4) from pt_type_test order by 1;
select (col2 or 0) from pt_type_test order by 1;
select (col3 or col4) from pt_type_test where (col1 xor col4) = 1 order by 1;
select (col1 or true), (col2 or false) from pt_type_test where (col3 and col4) = 1 order by 1;


--xor operator
select (col1 xor col2) from pt_type_test order by 1;
select (col1 xor 1) from pt_type_test where col1 xor col4 = 1 order by 1;
select (col3 xor 0) from pt_type_test order by 1;
select (col4 xor true) from pt_type_test where not col3 = 0 order by 1;
select (col1 xor col2 xor col3 xor col4) from pt_type_test order by 1;
select (col1 xor col2 xor col3 xor col4 xor null) from pt_type_test order by 1;


--not operator
select (not col1), (not col2) from pt_type_test order by 1;
select (not col3), (not col4) from pt_type_test where col1 xor col2 = 1 order by 1;


drop table pt_type_test;
