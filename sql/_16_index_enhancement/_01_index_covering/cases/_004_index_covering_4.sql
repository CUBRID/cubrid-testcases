create table cov_t4 (id1 int, id2 varchar(30), id3 int);
insert into cov_t4 values (5,'mnpqrt',55);
insert into cov_t4 values (10,'abcd',100);
insert into cov_t4 values ( 11,'abmnp',111);
insert into cov_t4 values ( 15,'mnpde',111);
insert into cov_t4 values ( 5,'abcde',55);
insert into cov_t4 values ( 10,'abc',100);
insert into cov_t4 values ( 10,'abc',100);
insert into cov_t4 values (11,'ab ',111);

create index idx_covering_t4 on cov_t4 (id1, id3);
create index idx_t4_3_1 on cov_t4(id3, id1);
create index idx_t4_1 on cov_t4 (id1);
create index idx_t4_3 on cov_t4 (id3);

select id3 from cov_t4 where id1 = 10;
select id3 from cov_t4 where id1 = 10 and id3 = 100;
select id3 from cov_t4 where id1 = 10 and id3 > 15;
select id3 from cov_t4 where id1 > 10;

drop table cov_t4;