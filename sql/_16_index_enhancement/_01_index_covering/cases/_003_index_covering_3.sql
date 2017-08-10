create table cov_t3 (id1 int, id2 varchar(30), id3 int);
insert into cov_t3 values (5,'mnpqrt',55);
insert into cov_t3 values (10,'abcd',100);
insert into cov_t3 values ( 11,'abmnp',111);
insert into cov_t3 values ( 15,'mnpde',111);
insert into cov_t3 values ( 5,'abcde',55);
insert into cov_t3 values ( 10,'abc',100);
insert into cov_t3 values ( 10,'abc',100);
insert into cov_t3 values (11,'ab ',111);

create index idx_covering_t3 on cov_t3 (id1, id3); 
create index idx_t3_1_2 on cov_t3 (id1, id2);
create index idx_t3_1_2_3 on cov_t3 (id1, id2, id3);

select id3, count (id3) from cov_t3 where id1 = 10 and id3 > 10 group by id3;
select id3, count (id1) from cov_t3 where id1 < 7 and id3 > 10 group by id3;
select id3, count (id3) from cov_t3 where id3 > 10 and id1 is not null group by id3;
select id1, id3 from cov_t3 where id1 = 10 order by id3;
select id1, id3 from cov_t3 where id1 < 100 order by id3;



drop table cov_t3;