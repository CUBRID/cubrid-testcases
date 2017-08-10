create table tb (id int primary key, a FLOAT);
insert into tb values (1,-1.1);
insert into tb values (2,0);
insert into tb values (3,0.01);
insert into tb values (4,1.013);
--A: In fact, data id in (2,3) return.
select a from tb where a between 0 and 1.013 order by 1;
--B: according to result of A, no data should return.
select a from tb where a between 0 and 1.013 and a=1.013;

drop table tb;

