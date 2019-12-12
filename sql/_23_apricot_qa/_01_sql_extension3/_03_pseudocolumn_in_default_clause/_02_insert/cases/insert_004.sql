--insert into columns with default value of CURRENT_TIMESTAMP using 'insert...on dulicate key update' syntax



create table i04(id int auto_increment primary key, col1 timestamp default CURRENT_TIMESTAMP unique);


insert into i04 values (111, default);
--TEST: 'insert...on dulicate key update' syntax
insert into i04(col1) select col1 from i04 on duplicate key update col1 = timestamp'2000-12-12 12:12:12';

insert into i04(col1) values (default);
--TEST: error, unique constraint violation
insert into i04(col1) select col1 from i04 where id=2 on duplicate key update col1  = '2000-12-12 12:12:12';
insert into i04(col1) select col1 from i04 where id=2 on duplicate key update col1  = '2000-11-11 11:11:11';

--TEST: error, unique constraint violation
insert into i04(col1) values (default), (default), (default);

--TEST: 'insert...on dulicate key update' syntax
insert into i04(col1) values (default), (default) on duplicate key update col1 = '2000-10-10 10:10:10';
--TEST: check the result
select * from i04 order by 1;
select if (count(*) = 3, 'ok', 'nok') from i04;


--TEST: 'insert...on dulicate key update' syntax
insert into i04(col1) values (default), (default), (default) on duplicate key update col1 = '2000-09-09 09:09:09';
--TEST: check the result
select if (count(*) = 5, 'ok', 'nok') from i04;

delete from i04 where col1 = (select max(col1) from i04);

--TEST: error, unique constraint violation
insert into i04(col1) values (default), (default), (default), (default) on duplicate key update col1 = '2000-08-08 08:08:08';

--TEST: different syntax
insert into i04(col1) select col1 from i04 on duplicate key update col1 = values(col1) + 1;
insert into i04(col1) select col1 from i04 on duplicate key update col1 = col1 + 1;

--TEST: check the result
select * from i04 order by col1;
select if (count(*) = 4, 'ok', 'nok') from i04;


drop table i04;

 
