--TEST: insert zero datetime values and check the result


create table x1 (dt datetime);

--TEST: insert zero datetime values into a table
insert into x1 values (datetime'0000-00-00 00:00:00');
insert into x1 values (datetime'00/00/0000 00:00:00');
insert into x1 values (datetime'00:00:00 00/00/0000');
insert into x1 values (datetime'00:00:00 0000-00-00');
insert into x1 values ('0000-00-00 00:00:00');
insert into x1 values ('00/00/0000 00:00:00');
insert into x1 values ('00:00:00 00/00/0000');
insert into x1 values ('00:00:00 0000-00-00');


--TEST: insert zero datetime values with prepare statement
prepare dtp from 'insert into x1 values ( ? )';
execute dtp using datetime'0000-00-00 00:00:00';
execute dtp using '00:00:00 00/00/0000';
deallocate prepare dtp;


--TEST: check insert result
select * from x1 order by 1;

--TEST: check insert result
select if (count(*) = 10, 'ok', 'nok') from x1 where dt = datetime'00:00:00 0000-00-00';
select if (count(*) = 10, 'ok', 'nok') from x1 where dt = datetime'00/00/0000 00:00:00';
select if (count(*) = 10, 'ok', 'nok') from x1 where dt = '00:00:00 0000-00-00';
select if (count(*) = 10, 'ok', 'nok') from x1 where dt = '00/00/0000 00:00:00';
select if (count(*) = 0, 'ok', 'nok') from x1 where dt = datetime'01/01/0001 00:00:00';


drop table x1;




