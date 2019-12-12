--replace into columns with default value of CURRENT_USER



create table i17(id int primary key, col1 varchar default CURRENT_USER, col2 varchar default CURRENT_USER);


--TEST: replace with default
replace into i17 values (111, default, default);
replace into i17 values(111, 'DUPLICATED1', 'DUPLICATED2');

--TEST: check the result
select if (count(*) = 1, 'ok', 'nok') from i17;


--TEST: replace with default
replace into i17(id, col1) values (222, default);
replace into i17(id) values (333), (444), (555), (666);

--TEST: check the result
select if (col1 = USER, 'ok', 'nok') from i17 where id > 111;
select if (col2 = USER, 'ok', 'nok') from i17 where id > 111;
select if (count(*) = 6, 'ok', 'nok') from i17;


--TEST: replace with default
replace into i17(id, col1) values (222, 'AAA'), (333, 'BBB'), (444, 'CCC');

--TEST: check the result
select if (col2 = USER, 'ok', 'nok') from i17 where id > 111 and id < 555;
select if (count(*) = 6, 'ok', 'nok') from i17;


--TEST: replace with default
replace into i17 set id=444, col1='DUPLICATED1', col2='DUPLICATED2';
replace into i17 set id=555, col1='DUPLICATED1', col2='DUPLICATED2';
replace into i17 set id=666, col1='DUPLICATED1', col2='DUPLICATED2';

--TEST: check the result
select if (col1 = 'DUPLICATED1', 'ok', 'nok') from i17 where id >= 444;
select if (col2 = 'DUPLICATED2', 'ok', 'nok') from i17 where id >= 444;


--TEST: replace with default
replace into i17(id, col1) select id, col1 from i17 where id >= 444;

--TEST: check the result
select if (col1 = 'DUPLICATED1', 'ok', 'nok') from i17 where id >= 444;
select if (col2 = USER, 'ok', 'nok') from i17 where id >= 444;
select if (count(*) = 6, 'ok', 'nok') from i17;



drop table i17;

 
