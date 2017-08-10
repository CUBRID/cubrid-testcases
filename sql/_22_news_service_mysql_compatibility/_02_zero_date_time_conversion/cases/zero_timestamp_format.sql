--TimeZone: Seoul
--TEST: insert zero timestamp values with irregular formats


create table ts (col timestamp);

--TEST: insert zero timestamp values into a table
insert into ts values (timestamp'00-00-00 00:00:00');
insert into ts values (timestamp'00/00/00 00:00:00');
insert into ts values (timestamp'0:0:0 0/0/0');
insert into ts values (timestamp'0:0:00 000-0-00');
insert into ts values ('00-00-00 00:00:00');
insert into ts values ('00/00/00 00:00:00');
insert into ts values ('0:0:0 0/0/00');
insert into ts values ('00:0:00 000-00-00');


--TEST: insert zero timestamp values with prepare statement
prepare tsp from 'insert into ts values ( ? )';
execute tsp using timestamp'00-00-00 00:00:00';
execute tsp using '0:0:0 00/0/000';
deallocate prepare tsp;


--TEST: check insert result
select * from ts;

--TEST: check isnert result
select if (count(*) = 4, 'ok', 'nok') from ts where col = timestamp'00:00:00 0000-00-00';
select if (count(*) = 4, 'ok', 'nok') from ts where col = timestamp'00/00/0000 00:00:00';
select if (count(*) = 4, 'ok', 'nok') from ts where col = '00:00:00 0000-00-00';
select if (count(*) = 4, 'ok', 'nok') from ts where col = '00/00/0000 00:00:00';
select if (count(*) = 4, 'ok', 'nok') from ts where col = '09:00:00 AM 01/01/1970';


drop table ts;
