--TEST: insert zero date values and check the result


create table x3 (dt date);

--TEST: insert zero date values into a table
insert into x3 values (date'0000-00-00');
insert into x3 values (date'00/00/0000');
insert into x3 values ('0000-00-00');
insert into x3 values ('00/00/0000');


--TEST: insert zero date values with prepare statement
prepare dp from 'insert into x3 values ( ? )';
execute dp using date'0000-00-00';
execute dp using '00/00/0000';
deallocate prepare dp;


--TEST: check insert result
select * from x3 order by 1;

--TEST: check insert result
select if (count(*) = 6, 'ok', 'nok') from x3 where dt = date'0000-00-00';
select if (count(*) = 6, 'ok', 'nok') from x3 where dt = date'00/00/0000';
select if (count(*) = 6, 'ok', 'nok') from x3 where dt = '0000-00-00';
select if (count(*) = 6, 'ok', 'nok') from x3 where dt = '00/00/0000';
select if (count(*) = 0, 'ok', 'nok') from x3 where dt = '01/01/0001';


drop table x3;




