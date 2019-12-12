--update columns with default value of CURRENT_USER



create table u07(id int primary key, col1 string default CURRENT_USER unique, col2 string default CURRENT_USER not null, col3 string default CURRENT_USER, col4 string default CURRENT_USER);

insert into u07 values(1, 'aaaaa', 'aaaaa', 'aaaaa', 'aaaaa');
insert into u07 values(2, 'bbbbb', 'bbbbb', 'bbbbb', 'bbbbb');
insert into u07 values(3, 'ccccc', 'ccccc', 'ccccc', 'ccccc');
insert into u07 values(4, 'ddddd', 'ddddd', 'ddddd', 'ddddd');
insert into u07 values(5, 'eeeee', 'eeeee', 'eeeee', 'eeeee');


--TEST: error, unique constraint violance
update u07 set col1=default;

update u07 set col2=default;
select if (USER = col2, 'ok', 'nok') from u07;

--TEST: where clause
update u07 set col1=default where id=1;
select if (USER = col1, 'ok', 'nok') from u07 where id=1;
update u07 set col3=default, col4=default, col2=default where id=1;
select if (USER = col3, 'ok', 'nok') from u07 where id=1;
select if (USER = col4, 'ok', 'nok') from u07 where id=1;
select if (col2 = col3, 'ok', 'nok') from u07 where id=1;


--TEST: order by clause
update u07 set col2=default where id > 1 order by id desc;
select if (USER = col2, 'ok', 'nok') from u07 where id>1;


--TEST: order by and limit
update u07 set col3=default, col4=default where id < 4 order by id desc limit 1;
select if (USER = col3, 'ok', 'nok') from u07 where id=3;
select if (col3='bbbbb', 'ok', 'nok') from u07 where id=2;
update u07 set col3=default order by id desc limit 2;
select if (USER = col3, 'ok', 'nok') from u07 where id>3;

select if (count(*) = 5, 'ok', 'nok') from u07;


drop table u07;




