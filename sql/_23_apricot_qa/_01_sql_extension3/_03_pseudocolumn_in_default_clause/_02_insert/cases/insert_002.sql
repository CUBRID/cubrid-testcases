--insert into columns with default value of SYSDATE and SYSDATETIME 'insert...values' syntax



create table i02(id int auto_increment, col1 date default SYSDATE, col2 datetime default SYSDATETIME);

--TEST: insert ... values statement

--TEST: insert a single row with default values of all columns 
insert into i02 values default;
--TEST: insert a single row specifying only one column value
insert into i02(col1) values (default); 
insert into i02(col2) values (default); 
--TEST: insert a single row specifying part of the column values
insert into i02(col1, col2) values (default, default);
--TEST: insert a single row specifying column values for all
insert into i02 values (default, default, default);
--TEST: insert default values with DEFAULT keyword before VALUES
insert into i02 default values;
--TEST: insert 2 rowws
insert into i02(col2) values (default), (default);
--TEST: insert a single row with SET clauses
insert into i02 set col1=default;


--TEST: check the result
select if(col1 -  SYSDATE = 0, 'ok', 'nok') from i02;
select if(SYSDATETIME - col2 <= 2000, 'ok', 'nok') from i02;


drop table i02;

 
