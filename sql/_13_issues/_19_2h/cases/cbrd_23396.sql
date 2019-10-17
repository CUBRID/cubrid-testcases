drop table if exists c;
create table c (a numeric(38,0) auto_increment(1,1), b int);
alter serial [c_ai_a] START WITH 2;  
insert into c(b) values (1);
select * from c;

drop c;
