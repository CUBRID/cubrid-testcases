--inherit from a table including columns with default value of CURRENT_USER



create table c46(id int primary key auto_increment, col1 varchar not null default CURRENT_USER);


--TEST: inherit from a table including a column with default value of CURRENT_USER
create table sub1_c46 under c46;
--TEST: check the inherited column
show columns in sub1_c46;

--TEST: insert into an inherited table
insert into sub1_c46(col1) values (default), (default), (default);
--TEST: check inserted values of the inherited column
select if(USER = col1, 'ok', 'nok') from sub1_c46;


--TEST: inherit a column with default value of CURRENT_USER and create another one
create table sub2_c46 under c46 (col2 varchar default CURRENT_USER, col3 varchar default CURRENT_USER);
--TEST: check the inherited column
desc sub2_c46;

--TEST: insert into an inherited table
insert into sub2_c46(col2, col3) values(default, default), (default, default), (default, default), (default, default);
--TEST: check inserted values of the inherited column
select if(USER = col2 and CURRENT_USER = col3, 'ok', 'nok') from sub2_c46;


--TEST: inherit from an inherited table and create another column with default value of CURRENT_USER
create table sub_sub1_c46 under sub1_c46 (col2 varchar default CURRENT_USER, col3 varchar default CURRENT_USER);
--TEST: check the inherited column
show columns in sub_sub1_c46;

--TEST: insert into the inherited columns
insert into sub_sub1_c46(col2, col3) values(default, default), (default, default),(default, default),(default, default),(default, default);
--TEST: check inserted values of the inherited column
select if(USER = col2 and CURRENT_USER = col3, 'ok', 'nok') from sub_sub1_c46;


--TEST: inherit from an inherited table
create table sub_sub2_c46 under sub2_c46;
--TEST: check the inherited column
show columns in sub_sub2_c46;

--TEST: insert into the inherited columns
insert into sub_sub2_c46(col1) values(default), (default), (default), (default);
--TEST: check inserted values of the inherited column
select if(USER = col2 and CURRENT_USER = col3 and CURRENT_USER = col1, 'ok', 'nok') from sub_sub1_c46;



drop table c46;
drop table sub1_c46;
drop table sub2_c46;
drop table sub_sub1_c46;
drop table sub_sub2_c46;
