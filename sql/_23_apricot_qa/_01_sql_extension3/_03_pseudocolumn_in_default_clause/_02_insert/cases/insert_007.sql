--insert into columns with default value of SYSDATE using 'insert...on dulicate key update' syntax



create table i07(id int auto_increment primary key, col1 date default SYSDATE unique);


insert into i07 values (111, default);
insert into i07(col1) select col1 from i07 on duplicate key update col1 = date'2000-12-12';

insert into i07(col1) values (default);
--TEST: error, unique constraint violation
insert into i07(col1) select col1 from i07 where id=2 on duplicate key update col1  = '2000-12-12';
insert into i07(col1) select col1 from i07 where id=2 on duplicate key update col1  = '2000-11-11';

--TEST: error, unique constraint violation
insert into i07(col1) values (default), (default), (default);

insert into i07(col1) values (default), (default) on duplicate key update col1 = '2000-10-10';
--TEST: check the result
select * from i07 order by 1;
select if (count(*) = 3, 'ok', 'nok') from i07;


insert into i07(col1) values (default), (default), (default) on duplicate key update col1 = '2000-09-09';
--TEST: check the result
select if (count(*) = 5, 'ok', 'nok') from i07;

delete from i07 where col1 = (select max(col1) from i07);

--TEST: error, unique constraint violation
insert into i07(col1) values (default), (default), (default), (default) on duplicate key update col1 = '2000-08-08';

--TEST: different syntax
insert into i07(col1) select col1 from i07 on duplicate key update col1 = values(col1) + 1;
insert into i07(col1) select col1 from i07 on duplicate key update col1 = col1 + 1;

--TEST: check the result
select * from i07 order by col1;
select if (count(*) = 4, 'ok', 'nok') from i07;


drop table i07;

 
