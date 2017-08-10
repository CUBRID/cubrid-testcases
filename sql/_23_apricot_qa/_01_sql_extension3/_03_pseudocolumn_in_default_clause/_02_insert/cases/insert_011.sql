--replace into columns with default value of CURRENT_TIMESTAMP



create table i11(id int primary key, col1 timestamp default CURRENT_TIMESTAMP, col2 timestamp default CURRENT_TIMESTAMP);


--TEST: replace with default
replace into i11 values (111, default, default);
replace into i11 values(111, '2000-12-12 12:12:12', '2000-12-12 12:12:12');

--TEST: check the result
select if (count(*) = 1, 'ok', 'nok') from i11;


--TEST: replace with default
replace into i11(id, col1) values (222, default);
replace into i11(id) values (333), (444), (555), (666);

--TEST: check the result
select if ((SYS_TIMESTAMP - col1) <= 1, 'ok', 'nok') from i11 where id > 111;
select if ((SYS_TIMESTAMP - col2) <= 1, 'ok', 'nok') from i11 where id > 111;
select if ((col1 - col2) = 0, 'ok', 'nok') from i11 where id > 111;
select if (count(*) = 6, 'ok', 'nok') from i11;


--TEST: replace with default
replace into i11(id, col1) values (222, default);
replace into i11(id, col2) values (333, default);
replace into i11(id, col1) values (444, default);

--TEST: check the result
select if ((SYS_TIMESTAMP - col1) <= 2, 'ok', 'nok') from i11 where id > 111 and id < 555;
select if ((SYS_TIMESTAMP - col2) <= 2, 'ok', 'nok') from i11 where id > 111 and id < 555;
select if ((col1 - col2) = 0, 'ok', 'nok') from i11 where id > 111;
select if (count(*) = 6, 'ok', 'nok') from i11;


--TEST: replace with default
replace into i11 set id=444, col1='2000-12-12 12:12:12', col2='2000-12-12 12:12:12';
replace into i11 set id=555, col1='2000-12-12 12:12:12', col2='2000-12-12 12:12:12';
replace into i11 set id=666, col1='2000-12-12 12:12:12', col2='2000-12-12 12:12:12';

--TEST: check the result
select if (col1 = '2000-12-12 12:12:12', 'ok', 'nok') from i11 where id >= 444;


--TEST: replace with default
replace into i11(id, col1) select id, col1 from i11 where id >= 444;

--TEST: check the result
select if (col1 = '2000-12-12 12:12:12', 'ok', 'nok') from i11 where id >= 444;
select if ((SYS_TIMESTAMP - col2) <= 1, 'ok', 'nok') from i11 where id >= 444;
select if (count(*) = 6, 'ok', 'nok') from i11;



drop table i11;

 
