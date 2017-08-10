--replace into columns with default value of USER



create table i16(id int primary key, col1 string default USER, col2 string default USER);


--TEST: replace with defaul
replace into i16 values (111, default, default);
replace into i16 values(111, 'DUPLICATED1', 'DUPLICATED2');

--TEST: check the result
select if (count(*) = 1, 'ok', 'nok') from i16;


--TEST: replace with defaul
replace into i16(id, col1) values (222, default);
replace into i16(id) values (333), (444), (555), (666);

--TEST: check the result
select if (col1 = CURRENT_USER, 'ok', 'nok') from i16 where id > 111;
select if (col2 = CURRENT_USER, 'ok', 'nok') from i16 where id > 111;
select if (count(*) = 6, 'ok', 'nok') from i16;


--TEST: replace with defaul
replace into i16(id, col1) values (222, 'AAA'), (333, 'BBB'), (444, 'CCC');

--TEST: check the result
select if (col2 = CURRENT_USER, 'ok', 'nok') from i16 where id > 111 and id < 555;
select if (count(*) = 6, 'ok', 'nok') from i16;


--TEST: replace with defaul
replace into i16 set id=444, col1='DUPLICATED1', col2='DUPLICATED2';
replace into i16 set id=555, col1='DUPLICATED1', col2='DUPLICATED2';
replace into i16 set id=666, col1='DUPLICATED1', col2='DUPLICATED2';

--TEST: check the result
select if (col1 = 'DUPLICATED1', 'ok', 'nok') from i16 where id >= 444;
select if (col2 = 'DUPLICATED2', 'ok', 'nok') from i16 where id >= 444;


--TEST: replace with defaul
replace into i16(id, col1) select id, col1 from i16 where id >= 444;

--TEST: check the result
select if (col1 = 'DUPLICATED1', 'ok', 'nok') from i16 where id >= 444;
select if (col2 = CURRENT_USER, 'ok', 'nok') from i16 where id >= 444;
select if (count(*) = 6, 'ok', 'nok') from i16;



drop table i16;

 
