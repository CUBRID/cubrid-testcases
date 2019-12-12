--insert into columns with default value of SYSDATE and SYSDATETIME 'insert...values' syntax



prepare st from 'create table i02(id int auto_increment, col1 date default SYSDATE, col2 datetime default SYSDATETIME)';
execute st;

--TEST: insert ... values statement

--TEST: insert a single row with default values of all columns 
prepare st from 'insert into i02 values default';
execute st;
--TEST: insert a single row specifying only one column value
prepare st from 'insert into i02(col1) values (default)';
execute st;
prepare st from 'insert into i02(col2) values (default)'; 
execute st;
--TEST: insert a single row specifying part of the column values
prepare st from 'insert into i02(col1, col2) values (default, default)';
execute st;
--TEST: insert a single row specifying column values for all
prepare st from 'insert into i02 values (default, default, default)';
execute st;
--TEST: insert default values with DEFAULT keyword before VALUES
prepare st from 'insert into i02 default values';
execute st;
--TEST: insert 2 rowws
prepare st from 'insert into i02(col2) values (default), (default)';
execute st;
--TEST: insert a single row with SET clauses
prepare st from 'insert into i02 set col1=default';
execute st;
--TEST: insert default values implicitly
prepare st from 'insert into i02(id) values(?)';
execute st using 22;

deallocate prepare st;

--TEST: check the result
select if(col1 -  SYSDATE = 0, 'ok', 'nok') from i02;
select if(SYSDATETIME - col2 >= 0, 'ok', 'nok') from i02;


drop table i02;

 
