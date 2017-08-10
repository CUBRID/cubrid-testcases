--insert into columns with default value of SYSDATETIME using 'insert...on dulicate key update' syntax



create table i08(id int auto_increment primary key, col1 datetime default SYSDATETIME unique);


insert into i08 values (111, default);
insert into i08(col1) select col1 from i08 on duplicate key update col1 = datetime'2000-12-12 12:12:12.999';

insert into i08(col1) values (default);
--TEST: error, unique constraint violation
insert into i08(col1) select col1 from i08 where id=2 on duplicate key update col1  = '2000-12-12 12:12:12.999';
insert into i08(col1) select col1 from i08 where id=2 on duplicate key update col1  = '2000-11-11 11:11:11.999';

--TEST: error, unique constraint violation
insert into i08(col1) values (default), (default), (default);

insert into i08(col1) values (default), (default) on duplicate key update col1 = '2000-10-10 10:10:10.999';
--TEST: check the result
select * from i08 order by 1;
select if (count(*) = 3, 'ok', 'nok') from i08;


insert into i08(col1) values (default), (default), (default) on duplicate key update col1 = '2000-09-09 09:09:09.999';
--TEST: check the result
select if (count(*) = 5, 'ok', 'nok') from i08;

delete from i08 where col1 = (select max(col1) from i08);

--TEST: error, unique constraint violation
insert into i08(col1) values (default), (default), (default), (default) on duplicate key update col1 = '2000-08-08 08:08:08.999';

--TEST: different syntax
insert into i08(col1) select col1 from i08 on duplicate key update col1 = values(col1) + 1;
insert into i08(col1) select col1 from i08 on duplicate key update col1 = col1 + 1;

--TEST: check the result
select * from i08 order by col1;
select if (count(*) = 4, 'ok', 'nok') from i08;


drop table i08;

 
