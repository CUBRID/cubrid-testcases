create table cov_t2 (id1 int, id2 varchar(30), id3 int);
insert into cov_t2 values (5,'mnpqrt',55);
insert into cov_t2 values (10,'abcd',100);
insert into cov_t2 values ( 11,'abmnp',111);
insert into cov_t2 values ( 15,'mnpde',111);
insert into cov_t2 values ( 5,'abcde',55);
insert into cov_t2 values ( 10,'abc',100);
insert into cov_t2 values ( 10,'abc',100);
insert into cov_t2 values (11,'ab ',111);
create index idx_covering_t2 on cov_t2 (id1, id3); 
create index idx_t2_1_2 on cov_t2 (id1, id2);
create index idx_t2_1_2_3 on cov_t2 (id1, id2, id3);

select id1 from cov_t2 where id3 = 100 and id1 is not null;
select id1 from cov_t2 where id3 < 100 and id1 is not null;
select id1 from cov_t2 where id1 < id3 and id3 is not null order by id1;
select id1,id3 from cov_t2 where 2 * id3 < 100 and id1 is not null;
select id1,id3 from cov_t2 where id3 * id3 > 300 and id1 is not null order by id1;
select id3 from cov_t2 where id1 + id1  < id3 * id3 and id1 is not null order by id3;

drop table cov_t2;