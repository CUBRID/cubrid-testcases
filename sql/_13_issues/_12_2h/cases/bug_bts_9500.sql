drop table if exists tb2;

CREATE TABLE tb2 (a NUMERIC(4,4));
--info: good result
insert into tb2 values (0.5);

prepare stmt from 'insert into tb2 values (?)';
--info: good result
execute stmt using 0.1;
--test: fail to execute. we expect below statement will execute successfully.
execute stmt using 0.5;
deallocate prepare stmt;
select * from tb2 order by 1;

drop table if exists tb2;
