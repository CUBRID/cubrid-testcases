--inherit from a table including columns with default value of SYSDATE



create table c43(id int primary key auto_increment, col1 date not null default SYSDATE);


--TEST: inherit from a table including a column with default value of SYSDATE
create table sub1_c43 under c43;
--TEST: check the inherited column
show columns in sub1_c43;

--TEST: insert into an inherited table
insert into sub1_c43(col1) values (default), (default), (default);
--TEST: check inserted values of the inherited column
select if(SYSDATE = col1, 'ok', 'nok') from sub1_c43;


--TEST: inherit a column with default value of SYSDATE and create another one
create table sub2_c43 under c43 (col2 date default SYSDATE, col3 date default SYSDATE);
--TEST: check the inherited column
desc sub2_c43;

--TEST: insert into an inherited table
insert into sub2_c43(col2, col3) values(default, default), (default, default), (default, default), (default, default);
--TEST: check inserted values of the inherited column
select if(SYSDATE = col2 and SYSDATE = col3, 'ok', 'nok') from sub2_c43;


--TEST: inherit from an inherited table and create another column with default value of SYSDATE
create table sub_sub1_c43 under sub1_c43 (col2 date default SYSDATE, col3 date default SYSDATE);
--TEST: check the inherited column
show columns in sub_sub1_c43;

--TEST: insert into the inherited columns
insert into sub_sub1_c43(col2, col3) values(default, default), (default, default),(default, default),(default, default),(default, default);
--TEST: check inserted values of the inherited column
select if(SYSDATE = col2 and SYSDATE = col3, 'ok', 'nok') from sub_sub1_c43;


--TEST: inherit from an inherited table
create table sub_sub2_c43 under sub2_c43;
--TEST: check the inherited column
show columns in sub_sub2_c43;

--TEST: insert into the inherited columns
insert into sub_sub2_c43(col1) values(default), (default), (default), (default);
--TEST: check inserted values of the inherited column
select if(SYSDATE = col2 and SYSDATE = col3 and SYSDATE = col1, 'ok', 'nok') from sub_sub1_c43;



drop table c43;
drop table sub1_c43;
drop table sub2_c43;
drop table sub_sub1_c43;
drop table sub_sub2_c43;
