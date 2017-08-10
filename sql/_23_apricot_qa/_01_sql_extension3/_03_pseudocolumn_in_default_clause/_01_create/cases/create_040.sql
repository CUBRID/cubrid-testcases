--inherit from a table including columns with default value of CURRENT_TIMESTAMP



create table c40(id int primary key auto_increment, col1 timestamp not null default CURRENT_TIMESTAMP);


--TEST: inherit from a table including a column with default value of CURRENT_TIMESTAMP
create table sub1_c40 under c40;
--TEST: check the inherited column
show columns in sub1_c40;

--TEST: insert into an inherited table
insert into sub1_c40(col1) values (default), (default), (default);
--TEST: check inserted values of the inherited column
select SYSTIMESTAMP >= col1 from sub1_c40;


--TEST: inherit a column with default value of CURRENT_TIMESTAMP and create another one
create table sub2_c40 under c40 (col2 timestamp default CURRENT_TIMESTAMP, col3 timestamp default CURRENT_TIMESTAMP);
--TEST: check the inherited column
desc sub2_c40;

--TEST: insert into an inherited table
insert into sub2_c40(col2, col3) values(default, default), (default, default), (default, default), (default, default);
--TEST: check inserted values of the inherited column
select SYSTIMESTAMP >= col2, col2 = col3 from sub2_c40;


--TEST: inherit from an inherited table and create another column with default value of CURRENT_TIMESTAMP
create table sub_sub1_c40 under sub1_c40 (col2 timestamp default CURRENT_TIMESTAMP, col3 timestamp default CURRENT_TIMESTAMP);
--TEST: check the inherited column
show columns in sub_sub1_c40;

--TEST: insert into the inherited columns
insert into sub_sub1_c40(col2, col3) values(default, default), (default, default),(default, default),(default, default),(default, default);
--TEST: check inserted values of the inherited column
select SYSTIMESTAMP >= col2, col2 = col3 from sub_sub1_c40;


--TEST: inherit from an inherited table
create table sub_sub2_c40 under sub2_c40;
--TEST: check the inherited column
show columns in sub_sub2_c40;

--TEST: insert into the inherited columns
insert into sub_sub2_c40(col1) values(default), (default), (default), (default);
--TEST: check inserted values of the inherited column
select col1 = col2 , col2 = col3, SYSTIMESTAMP >= col1 from sub_sub1_c40;



drop table c40;
drop table sub1_c40;
drop table sub2_c40;
drop table sub_sub1_c40;
drop table sub_sub2_c40;
