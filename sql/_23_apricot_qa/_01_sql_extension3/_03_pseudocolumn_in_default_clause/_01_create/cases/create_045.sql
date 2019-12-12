--inherit from a table including columns with default value of USER



create table c45(id int primary key auto_increment, col1 string not null default USER);


--TEST: inherit from a table including a column with default value of USER
create table sub1_c45 under c45;
--TEST: check the inherited column
show columns in sub1_c45;

--TEST: insert into an inherited table
insert into sub1_c45(col1) values (default), (default), (default);
--TEST: check inserted values of the inherited column
select if(CURRENT_USER = col1, 'ok', 'nok') from sub1_c45;


--TEST: inherit a column with default value of USER and create another one
create table sub2_c45 under c45 (col2 string default USER, col3 string default USER);
--TEST: check the inherited column
desc sub2_c45;

--TEST: insert into an inherited table
insert into sub2_c45(col2, col3) values(default, default), (default, default), (default, default), (default, default);
--TEST: check inserted values of the inherited column
select if(CURRENT_USER = col2 and USER = col3, 'ok', 'nok') from sub2_c45;


--TEST: inherit from an inherited table and create another column with default value of USER
create table sub_sub1_c45 under sub1_c45 (col2 string default USER, col3 string default USER);
--TEST: check the inherited column
show columns in sub_sub1_c45;

--TEST: insert into the inherited columns
insert into sub_sub1_c45(col2, col3) values(default, default), (default, default),(default, default),(default, default),(default, default);
--TEST: check inserted values of the inherited column
select if(CURRENT_USER = col2 and USER = col3, 'ok', 'nok') from sub_sub1_c45;


--TEST: inherit from an inherited table
create table sub_sub2_c45 under sub2_c45;
--TEST: check the inherited column
show columns in sub_sub2_c45;

--TEST: insert into the inherited columns
insert into sub_sub2_c45(col1) values(default), (default), (default), (default);
--TEST: check inserted values of the inherited column
select if(CURRENT_USER = col2 and USER = col3 and USER = col1, 'ok', 'nok') from sub_sub1_c45;



drop table c45;
drop table sub1_c45;
drop table sub2_c45;
drop table sub_sub1_c45;
drop table sub_sub2_c45;
