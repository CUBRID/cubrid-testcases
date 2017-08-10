--inherit from a table including columns with default value of UNIX_TIMESTAMP



create table c41(id int primary key auto_increment, col1 timestamp not null default UNIX_TIMESTAMP());


--TEST: inherit from a table including a column with default value of UNIX_TIMESTAMP
create table sub1_c41 under c41;
--TEST: check the inherited column
show columns in sub1_c41;

--TEST: insert into an inherited table
insert into sub1_c41(col1) values (default), (default), (default);
--TEST: check inserted values of the inherited column
select if((SYSTIMESTAMP - col1) <= 1, 'ok', 'nok') from sub1_c41;


--TEST: inherit a column with default value of UNIX_TIMESTAMP and create another one
create table sub2_c41 under c41 (col2 timestamp default UNIX_TIMESTAMP(), col3 timestamp default UNIX_TIMESTAMP());
--TEST: check the inherited column
desc sub2_c41;

--TEST: insert into an inherited table
insert into sub2_c41(col2, col3) values(default, default), (default, default), (default, default), (default, default);
--TEST: check inserted values of the inherited column
select if((SYSTIMESTAMP - col2) <= 1 and (SYSTIMESTAMP - col3) <= 1, 'ok', 'nok') from sub2_c41;


--TEST: inherit from an inherited table and create another column with default value of UNIX_TIMESTAMP
create table sub_sub1_c41 under sub1_c41 (col2 timestamp default UNIX_TIMESTAMP(), col3 timestamp default UNIX_TIMESTAMP());
--TEST: check the inherited column
show columns in sub_sub1_c41;

--TEST: insert into the inherited columns
insert into sub_sub1_c41(col2, col3) values(default, default), (default, default),(default, default),(default, default),(default, default);
--TEST: check inserted values of the inherited column
select if((SYSTIMESTAMP - col2) <= 1 and (SYSTIMESTAMP - col3) <= 1, 'ok', 'nok') from sub_sub1_c41;


--TEST: inherit from an inherited table
create table sub_sub2_c41 under sub2_c41;
--TEST: check the inherited column
show columns in sub_sub2_c41;

--TEST: insert into the inherited columns
insert into sub_sub2_c41(col1) values(default), (default), (default), (default);
--TEST: check inserted values of the inherited column
select if((SYSTIMESTAMP - col2) <= 1 and (SYSTIMESTAMP - col3) <= 1 and (SYSTIMESTAMP - col1) <= 1, 'ok', 'nok') from sub_sub1_c41;



drop table c41;
drop table sub1_c41;
drop table sub2_c41;
drop table sub_sub1_c41;
drop table sub_sub2_c41;
