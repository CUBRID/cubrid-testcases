create table cov_t1 (id1 int, id2 varchar(30), id3 int);
insert into cov_t1 values (5,'mnpqrt',55);
insert into cov_t1 values (10,'abcd',100);
insert into cov_t1 values ( 11,'abmnp',111);
insert into cov_t1 values ( 15,'mnpde',111);
insert into cov_t1 values ( 5,'abcde',55);
insert into cov_t1 values ( 10,'abc',100);
insert into cov_t1 values ( 10,'abc',100);
insert into cov_t1 values (11,'ab ',111);
create index idx_covering_t1 on cov_t1 (id1, id2);
create index idx_t1_1_3 on cov_t1 (id1, id3);
create index idx_t1_2_3 on cov_t1 (id2, id3);
create index idx_t1_1_2_3 on cov_t1 (id1, id2, id3);

select id2, id1 from cov_t1 where id1 = 10;
select id2, id1 from cov_t1 where id1 < 100;
select id2, id1 from cov_t1 where id1 = 10 and length(id2) = 4;
select id2, id1 from cov_t1 where id1 = 10 and length(id2) > 3;
select id2 from cov_t1 where id1 < 100 and id2 > 'abc';
select id2 from cov_t1 where id1 = 10;

drop table cov_t1;