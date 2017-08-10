--replace into columns with default value of SYSTIMESTAMP



create table i13(id int primary key, col1 timestamp default SYSTIMESTAMP, col2 timestamp default SYSTIMESTAMP);


--TEST: replace with default
replace into i13 values (111, default, default);
replace into i13 values(111, '2000-12-12 12:12:12', '2000-12-12 12:12:12');

--TEST: check the result
select if (count(*) = 1, 'ok', 'nok') from i13;


--TEST: replace with default
replace into i13(id, col1) values (222, default);
replace into i13(id) values (333), (444), (555), (666);

--TEST: check the result
select if ((CURRENT_TIMESTAMP - col1) <= 1, 'ok', 'nok') from i13 where id > 111;
select if ((CURRENT_TIMESTAMP - col2) <= 1, 'ok', 'nok') from i13 where id > 111;
select if ((col1 - col2) = 0, 'ok', 'nok') from i13 where id > 111;
select if (count(*) = 6, 'ok', 'nok') from i13;


--TEST: replace with default
replace into i13(id, col1) values (222, default);
replace into i13(id, col2) values (333, default);
replace into i13(id, col1) values (444, default);

--TEST: check the result
select if ((CURRENT_TIMESTAMP - col1) <= 2, 'ok', 'nok') from i13 where id > 111 and id < 555;
select if ((CURRENT_TIMESTAMP - col2) <= 2, 'ok', 'nok') from i13 where id > 111 and id < 555;
select if ((col1 - col2) = 0, 'ok', 'nok') from i13 where id > 111;
select if (count(*) = 6, 'ok', 'nok') from i13;


--TEST: replace with default
replace into i13 set id=444, col1='2000-12-12 12:12:12', col2='2000-12-12 12:12:12';
replace into i13 set id=555, col1='2000-12-12 12:12:12', col2='2000-12-12 12:12:12';
replace into i13 set id=666, col1='2000-12-12 12:12:12', col2='2000-12-12 12:12:12';

--TEST: check the result
select if (col1 = '2000-12-12 12:12:12', 'ok', 'nok') from i13 where id >= 444;


--TEST: replace with default
replace into i13(id, col1) select id, col1 from i13 where id >= 444;

select if (col1 = '2000-12-12 12:12:12', 'ok', 'nok') from i13 where id >= 444;
select if ((CURRENT_TIMESTAMP - col2) <= 1, 'ok', 'nok') from i13 where id >= 444;
select if (count(*) = 6, 'ok', 'nok') from i13;



drop table i13;

 
