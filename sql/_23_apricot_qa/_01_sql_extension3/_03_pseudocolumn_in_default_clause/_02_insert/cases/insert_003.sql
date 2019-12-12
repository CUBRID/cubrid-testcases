--insert into columns with default value of USER and CURRENT_USER 'insert...values' syntax



create table i03(id int auto_increment, col1 string default USER, col2 char(50) default CURRENT_USER);

--TEST: insert ... values statement

--TEST: insert a single row with default values of all columns 
insert into i03 values default;
--TEST: insert a single row specifying only one column value
insert into i03(col1) values (default); 
insert into i03(col2) values (default); 
--TEST: insert a single row specifying part of the column values
insert into i03(col1, col2) values (default, default);
--TEST: insert a single row specifying column values for all
insert into i03 values (default, default, default);
--TEST: insert default values with DEFAULT keyword before VALUES
insert into i03 default values;
--TEST: insert 2 rowws
insert into i03(col2) values (default), (default);
--TEST: insert a single row with SET clauses
insert into i03 set col1=default;


--TEST: check the result
select if(col1 = CURRENT_USER, 'ok', 'nok') from i03;
select if(col2 = USER, 'ok', 'nok') from i03;


drop table i03;

 
