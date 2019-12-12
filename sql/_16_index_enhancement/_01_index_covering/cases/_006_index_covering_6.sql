create table cov_t6 (id1 int, id2 varchar(30), id3 int);
insert into cov_t6 values (5,'mnpqrt',55);
insert into cov_t6 values (10,'abcd',100);
insert into cov_t6 values ( 11,'abmnp',111);
insert into cov_t6 values ( 15,'mnpde',111);
insert into cov_t6 values ( 5,'abcde',55);
insert into cov_t6 values ( 10,'abc',100);
insert into cov_t6 values ( 10,'abc',100);
insert into cov_t6 values (11,'ab ',111);

create index idx_covering_t6 on cov_t6 (id2);
create index idx_t6_1_3 on cov_t6 (id1, id3);
create index idx_t6_2_3 on cov_t6 (id2, id3);
create index idx_t6_2_1 on cov_t6 (id2, id1);
create index idx_t6_1_2_3 on cov_t6 (id1, id2, id3);

select id2 from cov_t6 where id2 = 'abc';
select id2 from cov_t6 where id2 > 'abmn';
select id2 from cov_t6 where id2 > 'abmn' and id2 < 'fgh';
select id2 from cov_t6 where id2 > 'abc' and length(id2) > 3;

drop table cov_t6;