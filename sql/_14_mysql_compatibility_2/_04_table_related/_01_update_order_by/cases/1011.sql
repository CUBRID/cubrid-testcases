-- UPDATE ... ORDER BY    + on multiple tables in class hierarchy

-- 
create table c1 (i1 integer ,i2 integer);
create table c2 under c1 (i2p integer);
create table c3 under c2 (i3p integer);
insert into c1 values (4,4), (1,7) , (7,1),(20,60), (30,50), (6,2),(5,3);
insert into c2 values (4,4,4), (10,70,10) , (7,1,7),(2,6,2), (300,500,300), (6,2,6),(5,3,5);
insert into c3 values (4,4,4,4), (100,700,100,700) , (7,1,7,1),(200,600,200,600), (3,5,3,5), (6,2,6,2),(5,3,5,3);


select * from c1 order by 1,2;
select * from c2 order by 1,2,3;
select * from c3 order by 1,2,3,4;

update all c1 set i2=-1 order by i1 limit 5;

select * from c1 order by 1,2;
select * from c2 order by 1,2,3;
select * from c3 order by 1,2,3,4;

drop c3;
drop c2;
drop c1;



