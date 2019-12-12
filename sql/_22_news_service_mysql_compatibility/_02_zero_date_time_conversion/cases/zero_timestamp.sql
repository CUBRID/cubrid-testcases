--TEST: insert zero timestamp values and check the result


create table x2 (ts timestamp);

--TEST: insert zero timestamp values into a table
insert into x2 values (timestamp'0000-00-00 00:00:00');
insert into x2 values (timestamp'00/00/0000 00:00:00');
insert into x2 values (timestamp'00:00:00 00/00/0000');
insert into x2 values (timestamp'00:00:00 0000-00-00');
insert into x2 values ('0000-00-00 00:00:00');
insert into x2 values ('00/00/0000 00:00:00');
insert into x2 values ('00:00:00 00/00/0000');
insert into x2 values ('00:00:00 0000-00-00');


--TEST: insert zero timestamp values with prepare statement
prepare tsp from 'insert into x2 values ( ? )';
execute tsp using timestamp'0000-00-00 00:00:00';
execute tsp using '00:00:00 00/00/0000';
deallocate prepare tsp;


--TEST: check insert result
select * from x2;

--TEST: check isnert result
select if (count(*) = 10, 'ok', 'nok') from x2 where ts = timestamp'00:00:00 0000-00-00';
select if (count(*) = 10, 'ok', 'nok') from x2 where ts = timestamp'00/00/0000 00:00:00';
select if (count(*) = 10, 'ok', 'nok') from x2 where ts = '00:00:00 0000-00-00';
select if (count(*) = 10, 'ok', 'nok') from x2 where ts = '00/00/0000 00:00:00';
select if (count(*) = 0, 'ok', 'nok') from x2 where ts = '09:00:00 AM 01/01/1970';


drop table x2;
