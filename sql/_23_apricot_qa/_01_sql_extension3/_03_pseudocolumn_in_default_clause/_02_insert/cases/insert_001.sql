--insert into columns with default value of CURRENT_TIMESTAMP, UNIX_TIMESTAMP and SYSTIMESTAMP using 'insert¡¦values' syntax



create table i01(id int auto_increment, col1 timestamp default CURRENT_TIMESTAMP, col2 timestamp default UNIX_TIMESTAMP(), col3 timestamp default SYSTIMESTAMP);

--TEST: insert ... values statement

--TEST: insert a single row with default values of all columns 
insert into i01 values default;
--TEST: insert a single row specifying only one column value
insert into i01(col1) values (default); 
insert into i01(col2) values (default); 
insert into i01(col3) values (default); 
--TEST: insert a single row specifying part of the column values
insert into i01(col1, col2) values (default, default);
--TEST: insert a single row specifying column values for all
insert into i01 values (default, default, default, default);
--TEST: insert default values with DEFAULT keyword before VALUES
insert into i01 default values;
--TEST: insert 2 rowws
insert into i01(col3) values (default), (default);
--TEST: insert a single row with SET clauses
insert into i01 set col1=default;


--TEST: check the result
select if(abs(col1-col2) <=100, 'ok', 'nok') from i01;
select if(abs(col1-col3) <=100, 'ok', 'nok') from i01;

drop table i01;

 
