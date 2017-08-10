create table c (a numeric(38,0) auto_increment(9223372036854775807,1), b int);

insert into c(b) values (0);
select * from c order by 1;
select last_insert_id();

insert into c(b) values (1);
select * from c order by 1;
select last_insert_id();

drop table c;
