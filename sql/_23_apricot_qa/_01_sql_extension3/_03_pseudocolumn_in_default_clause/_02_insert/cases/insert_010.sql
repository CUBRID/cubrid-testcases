--insert into columns with default value of CURRENT_USER using 'insert...on dulicate key update' syntax



create table i10(id int auto_increment primary key, col1 string default CURRENT_USER unique);


insert into i10 values (111, default);
insert into i10(col1) select col1 from i10 on duplicate key update col1 = 'DUPLICATED1';

insert into i10(col1) values (default);
--TEST: error, unique constraint violation
insert into i10(col1) select col1 from i10 where id=2 on duplicate key update col1  = 'DUPLICATED1';
insert into i10(col1) select col1 from i10 where id=2 on duplicate key update col1  = 'DUPLICATED2';

--TEST: error, unique constraint violation
insert into i10(col1) values (default), (default), (default);

insert into i10(col1) values (default), (default) on duplicate key update col1 = 'DUPLICATED3';
--TEST: check the result
select * from i10 order by 1;
select if (count(*) = 3, 'ok', 'nok') from i10;


insert into i10(col1) values (default), (default), (default) on duplicate key update col1 = 'DUPLICATED4';
--TEST: check the result
select if (count(*) = 5, 'ok', 'nok') from i10;

delete from i10 where col1 = USER;

--TEST: error, unique constraint violation
insert into i10(col1) values (default), (default), (default), (default) on duplicate key update col1 = 'DUPLICATED5';

--TEST: different  syntax
insert into i10(col1) select col1 from i10 on duplicate key update col1 = values(col1) + 'aaa';
insert into i10(col1) select col1 from i10 on duplicate key update col1 = col1 + 'aaa';

--TEST: check the result
select * from i10 order by col1;
select if (count(*) = 4, 'ok', 'nok') from i10;


drop table i10;

 
