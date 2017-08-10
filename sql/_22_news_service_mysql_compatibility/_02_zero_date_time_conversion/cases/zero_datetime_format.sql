--TEST: insert zero datetime values with irregular formats


create table x1 (dt datetime);

--TEST: insert zero datetime values into a table with irregular formats
insert into x1 values (datetime'00-00-00 00:00:00.00');
insert into x1 values (datetime'00/00/00 00:00:00');
insert into x1 values (datetime'0:0:0.0 0/0/0');
insert into x1 values (datetime'00:0:0 00-0-0');
insert into x1 values ('00-00-00 00:00:00');
insert into x1 values ('00/00/00 00:00:00.000');
insert into x1 values ('0:0:0 0/0/0');
insert into x1 values ('0:00:0.0 000-0-00');


--TEST: insert zero datetime values with prepare statement
prepare dtp from 'insert into x1 values ( ? )';
execute dtp using datetime'000-0-00 0:00:0';
execute dtp using '00:00:0.000 00/0/000';
deallocate prepare dtp;


--TEST: check insert result
select * from x1 order by 1;

--TEST: check insert result
select if (count(*) = 5, 'ok', 'nok') from x1 where dt = datetime'00:00:00 0000-00-00';
select if (count(*) = 5, 'ok', 'nok') from x1 where dt = datetime'00/00/0000 00:00:00';
select if (count(*) = 5, 'ok', 'nok') from x1 where dt = '00:00:00.00 0000-00-00';
select if (count(*) = 5, 'ok', 'nok') from x1 where dt = '00/00/0000 00:00:00';
select if (count(*) = 0, 'ok', 'nok') from x1 where dt = datetime'01/01/0001 00:00:00';


drop table x1;




