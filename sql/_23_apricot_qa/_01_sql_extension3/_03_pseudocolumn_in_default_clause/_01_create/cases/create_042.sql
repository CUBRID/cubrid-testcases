--inherit from a table including columns with default value of SYSTIMESTAMP



create table c42(id int primary key auto_increment, col1 timestamp not null default SYSTIMESTAMP);


--TEST: inherit from a table including a column with default value of SYSTIMESTAMP
create table sub1_c42 under c42;
--TEST: check the inherited column
show columns in sub1_c42;

--TEST: insert into an inherited table
insert into sub1_c42(col1) values (default), (default), (default);
--TEST: check inserted values of the inherited column
select if((CURRENT_TIMESTAMP - col1) <= 100, 'ok', 'nok') from sub1_c42;


--TEST: inherit a column with default value of SYSTIMESTAMP and create another one
create table sub2_c42 under c42 (col2 timestamp default SYSTIMESTAMP, col3 timestamp default SYSTIMESTAMP);
--TEST: check the inherited column
desc sub2_c42;

--TEST: insert into an inherited table
insert into sub2_c42(col2, col3) values(default, default), (default, default), (default, default), (default, default);
--TEST: check inserted values of the inherited column
select if((CURRENT_TIMESTAMP - col2) <= 100 and (CURRENT_TIMESTAMP - col3) <= 100, 'ok', 'nok') from sub2_c42;


--TEST: inherit from an inherited table and create another column with default value of SYSTIMESTAMP
create table sub_sub1_c42 under sub1_c42 (col2 timestamp default SYSTIMESTAMP, col3 timestamp default SYSTIMESTAMP);
--TEST: check the inherited column
show columns in sub_sub1_c42;

--TEST: insert into the inherited columns
insert into sub_sub1_c42(col2, col3) values(default, default), (default, default),(default, default),(default, default),(default, default);
--TEST: check inserted values of the inherited column
select if((CURRENT_TIMESTAMP - col2) <= 100 and (CURRENT_TIMESTAMP - col3) <= 100, 'ok', 'nok') from sub_sub1_c42;


--TEST: inherit from an inherited table
create table sub_sub2_c42 under sub2_c42;
--TEST: check the inherited column
show columns in sub_sub2_c42;

--TEST: insert into the inherited columns
insert into sub_sub2_c42(col1) values(default), (default), (default), (default);
--TEST: check inserted values of the inherited column
select if((CURRENT_TIMESTAMP - col2) <= 100 and (CURRENT_TIMESTAMP - col3) <= 100 and (CURRENT_TIMESTAMP - col1) <= 100, 'ok', 'nok') from sub_sub1_c42;



drop table c42;
drop table sub1_c42;
drop table sub2_c42;
drop table sub_sub1_c42;
drop table sub_sub2_c42;
