--insert into columns with default value of USER using 'insert...on dulicate key update' syntax



create table i09(id int auto_increment primary key, col1 varchar default USER unique);


insert into i09 values (111, default);
insert into i09(col1) select col1 from i09 on duplicate key update col1 = 'DUPLICATED1';

insert into i09(col1) values (default);
--TEST: error, unique constraint violation
insert into i09(col1) select col1 from i09 where id=2 on duplicate key update col1  = 'DUPLICATED1';
insert into i09(col1) select col1 from i09 where id=2 on duplicate key update col1  = 'DUPLICATED2';

--TEST: error, unique constraint violation
insert into i09(col1) values (default), (default), (default);

insert into i09(col1) values (default), (default) on duplicate key update col1 = 'DUPLICATED3';
--TEST: check the result
select * from i09 order by 1;
select if (count(*) = 3, 'ok', 'nok') from i09;


insert into i09(col1) values (default), (default), (default) on duplicate key update col1 = 'DUPLICATED4';
--TEST: check the result
select if (count(*) = 5, 'ok', 'nok') from i09;

delete from i09 where col1 = USER;

--TEST: error, unique constraint violation
insert into i09(col1) values (default), (default), (default), (default) on duplicate key update col1 = 'DUPLICATED5';

--TEST: different syntax
insert into i09(col1) select col1 from i09 on duplicate key update col1 = values(col1) + 1;
insert into i09(col1) select col1 from i09 on duplicate key update col1 = repeat(col1, 2);

--TEST: check the result
select * from i09 order by col1;
select if (count(*) = 4, 'ok', 'nok') from i09;


drop table i09;

 
