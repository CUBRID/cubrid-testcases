--inherit from a table including columns with default value of SYSDATETIME



create table c44(id int primary key auto_increment, col1 datetime not null default SYSDATETIME);


--TEST: inherit from a table including a column with default value of SYSDATETIME
create table sub1_c44 under c44;
--TEST: check the inherited column
show columns in sub1_c44;

--TEST: insert into an inherited table
insert into sub1_c44(col1) values (default), (default), (default);
--TEST: check inserted values of the inherited column
select if((SYSDATETIME - col1) <= 1000000, 'ok', 'nok') from sub1_c44;


--TEST: inherit a column with default value of SYSDATETIME and create another one
create table sub2_c44 under c44 (col2 datetime default SYSDATETIME, col3 datetime default SYSDATETIME);
--TEST: check the inherited column
desc sub2_c44;

--TEST: insert into an inherited table
insert into sub2_c44(col2, col3) values(default, default), (default, default), (default, default), (default, default);
--TEST: check inserted values of the inherited column
select if((SYSDATETIME - col2) <= 1000000 and (SYSDATETIME - col3) <= 1000000, 'ok', 'nok') from sub2_c44;


--TEST: inherit from an inherited table and create another column with default value of SYSDATETIME
create table sub_sub1_c44 under sub1_c44 (col2 datetime default SYSDATETIME, col3 datetime default SYSDATETIME);
--TEST: check the inherited column
show columns in sub_sub1_c44;

--TEST: insert into the inherited columns
insert into sub_sub1_c44(col2, col3) values(default, default), (default, default),(default, default),(default, default),(default, default);
--TEST: check inserted values of the inherited column
select if((SYSDATETIME - col2) <= 1000000 and (SYSDATETIME - col3) <= 1000000, 'ok', 'nok') from sub_sub1_c44;


--TEST: inherit from an inherited table
create table sub_sub2_c44 under sub2_c44;
--TEST: check the inherited column
show columns in sub_sub2_c44;

--TEST: insert into the inherited columns
insert into sub_sub2_c44(col1) values(default), (default), (default), (default);
--TEST: check inserted values of the inherited column
select if((SYSDATETIME - col2) <= 1000000 and (SYSDATETIME - col3) <= 1000000 and (SYSDATETIME - col1) <= 1000000, 'ok', 'nok') from sub_sub1_c44;



drop table c44;
drop table sub1_c44;
drop table sub2_c44;
drop table sub_sub1_c44;
drop table sub_sub2_c44;
