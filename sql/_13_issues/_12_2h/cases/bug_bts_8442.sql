set @v1=0;
create table z1 (a int, b int);
insert into z1 values (1,1);
insert into z1 values (1,2);
insert into z1 values (2,1);

select a,b,ROW_NUMBER() over(PARTITION BY a ORDER BY b) c11 from z1 order by a, b;

select a,b,ROW_NUMBER() over(PARTITION BY a+@v1 ORDER BY b) c11 from z1 order by a, b;
drop variable @v1;
drop table z1;
