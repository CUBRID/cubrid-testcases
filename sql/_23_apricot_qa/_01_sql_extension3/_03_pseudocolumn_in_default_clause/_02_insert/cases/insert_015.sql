--replace into columns with default value of SYSDATETIME



create table i15(id int primary key, col1 datetime default SYSDATETIME, col2 datetime default SYSDATETIME);


--TEST: replace with default
replace into i15 values (111, default, default);
replace into i15 values(111, '2000-12-12 12:12:12.123', '2000-12-12 12:12:12.123');

--TEST: check the result
select if (count(*) = 1, 'ok', 'nok') from i15;


--TEST: replace with default
replace into i15(id, col1) values (222, default);
replace into i15(id) values (333), (444), (555), (666);

--TEST: check the result
select if ((SYSDATETIME - col1) <= 1000, 'ok', 'nok') from i15 where id > 111;
select if ((SYSDATETIME - col2) <= 1000, 'ok', 'nok') from i15 where id > 111;
select if ((col1 - col2) = 0, 'ok', 'nok') from i15 where id > 111;
select if (count(*) = 6, 'ok', 'nok') from i15;


--TEST: replace with default
replace into i15(id, col1) values (222, default);
replace into i15(id, col2) values (333, default);
replace into i15(id, col1) values (444, default);

--TEST: check the result
select if ((SYSDATETIME - col1) <= 1000, 'ok', 'nok') from i15 where id > 111 and id < 555;
select if ((SYSDATETIME - col2) <= 1000, 'ok', 'nok') from i15 where id > 111 and id < 555;
select if ((col1 - col2) = 0, 'ok', 'nok') from i15 where id > 111;
select if (count(*) = 6, 'ok', 'nok') from i15;


--TEST: replace with default
replace into i15 set id=444, col1='2000-12-12 12:12:12.123', col2='2000-12-12 12:12:12.123';
replace into i15 set id=555, col1='2000-12-12 12:12:12.123', col2='2000-12-12 12:12:12.123';
replace into i15 set id=666, col1='2000-12-12 12:12:12.123', col2='2000-12-12 12:12:12.123';

--TEST: check the result
select if (col1 = '2000-12-12 12:12:12.123', 'ok', 'nok') from i15 where id >= 444;
select if (col2 = '2000-12-12 12:12:12.123', 'ok', 'nok') from i15 where id >= 444;


--TEST: replace with default
replace into i15(id, col1) select id, col1 from i15 where id >= 444;

--TEST: check the result
select if (col1 = '2000-12-12 12:12:12.123', 'ok', 'nok') from i15 where id >= 444;
select if ((SYSDATETIME - col2) <= 2000, 'ok', 'nok') from i15 where id >= 444;
select if (count(*) = 6, 'ok', 'nok') from i15;



drop table i15;

 
