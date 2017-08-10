--insert into columns with default value of SYSTIMESTAMP using 'insert...on dulicate key update' syntax



create table i06(id int auto_increment primary key, col1 timestamp default SYSTIMESTAMP unique);


insert into i06 values (111, default);
insert into i06(col1) select col1 from i06 on duplicate key update col1 = timestamp'2000-12-12 12:12:12';

insert into i06(col1) values (default);
--TEST: error, unique constraint violation
insert into i06(col1) select col1 from i06 where id=2 on duplicate key update col1  = '2000-12-12 12:12:12';
insert into i06(col1) select col1 from i06 where id=2 on duplicate key update col1  = '2000-11-11 11:11:11';

--TEST: error, unique constraint violation
insert into i06(col1) values (default), (default), (default);

insert into i06(col1) values (default), (default) on duplicate key update col1 = '2000-10-10 10:10:10';
--TEST: check the result
select * from i06 order by 1;
select if (count(*) = 3, 'ok', 'nok') from i06;


insert into i06(col1) values (default), (default), (default) on duplicate key update col1 = '2000-09-09 09:09:09';
--TEST: check the result
select if (count(*) = 5, 'ok', 'nok') from i06;

delete from i06 where col1 = (select max(col1) from i06);

--TEST: error, unique constraint violation
insert into i06(col1) values (default), (default), (default), (default) on duplicate key update col1 = '2000-08-08 08:08:08';

--TEST: different syntax
insert into i06(col1) select col1 from i06 on duplicate key update col1 = values(col1) + 1;
insert into i06(col1) select col1 from i06 on duplicate key update col1 = col1 + 1;

--TEST: check the result
select * from i06 order by col1;
select if (count(*) = 4, 'ok', 'nok') from i06;


drop table i06;

 
