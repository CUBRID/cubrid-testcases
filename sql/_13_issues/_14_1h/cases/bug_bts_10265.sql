drop table if exists s1;
CREATE TABLE s1(i int, j int);
insert into s1 values (1,1), (2,2), (3,3), (4,4), (5,5), (6,6), (7,7), (8,8), (9,9), (10,10);
create view v1 as (select * from s1 union select * from s1) limit 2;

--note: good result
(select * from s1 union select * from s1) limit 2;

--test: result is not correct.
select * from v1;
drop view if exists v1;
drop table if exists s1;
