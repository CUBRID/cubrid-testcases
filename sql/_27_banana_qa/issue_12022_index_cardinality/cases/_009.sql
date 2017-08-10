--test with large data

drop table if exists t;
create table t(id int primary key auto_increment, a1 bigint not null, a2 int, a3 int,
	b1 char(10), b2 int, b3 smallint, b4 varchar(10), b5 date, b6 float, b7 int, b8 string,
	b9 timestamp, b10 double, b11 int, b12 bit(10), b13 enum('a', 'b', 'c'), b14 varchar
);

insert into t(a1, a2, a3, b1, b2, b3, b4, b5, b6, b7, b8, b9, b10, b11, b12, b13, b14) values(1000000, 1000, 1, 'a', 1, 1, 'a', '2013-11-11', 1, 1, 'a', '2013-11-11 11:11:11', 1, 1, B'1010', 'a', null);
insert into t(a1, a2, a3, b1, b2, b3, b4, b5, b6, b7, b8, b9, b10, b11, b12, b13, b14) values(2000000, 1000, 1, 'a', 1, 1, 'a', '2013-11-11', 1, 1, 'a', '2013-11-11 11:11:11', 1, 1, B'1010', 'a', null);
insert into t(a1, a2, a3, b1, b2, b3, b4, b5, b6, b7, b8, b9, b10, b11, b12, b13, b14) values(3000000, 2000, 2, 'a', 1, 1, 'a', '2013-11-11', 1, 1, 'a', '2013-11-11 11:11:11', 1, 1, B'1010', 'a', null);
insert into t(a1, a2, a3, b1, b2, b3, b4, b5, b6, b7, b8, b9, b10, b11, b12, b13, b14) values(4000000, 2000, 2, 'a', 1, 1, null, '2013-11-11', 1, 1, 'a', '2013-11-11 11:11:11', 1, 1, B'1010', 'a', null);
insert into t(a1, a2, a3, b1, b2, b3, b4, b5, b6, b7, b8, b9, b10, b11, b12, b13, b14) values(5000000, 1000, 3, 'b', 1, 1, 'a', '2013-11-11', 1, 1, 'a', '2013-11-11 11:11:11', 1, 1, B'1010', 'a', null);
insert into t(a1, a2, a3, b1, b2, b3, b4, b5, b6, b7, b8, b9, b10, b11, b12, b13, b14) values(6000000, 1000, 3, 'b', 1, 1, 'a', '2013-11-11', 1, 1, 'a', '2013-11-11 11:11:11', 1, 1, B'1010', 'a', null);
insert into t(a1, a2, a3, b1, b2, b3, b4, b5, b6, b7, b8, b9, b10, b11, b12, b13, b14) values(7000000, 2000, 4, 'c', 1, 1, 'a', '2013-11-11', 1, 1, 'a', '2013-11-11 11:11:11', 1, 1, B'1010', 'a', null);
insert into t(a1, a2, a3, b1, b2, b3, b4, b5, b6, b7, b8, b9, b10, b11, b12, b13, b14) values(8000000, 2000, 4, 'c', 1, 1, 'a', '2013-11-11', 1, 1, 'a', '2013-11-11 11:11:11', 1, 1, B'1010', 'a', null);
insert into t(a1, a2, a3, b1, b2, b3, b4, b5, b6, b7, b8, b9, b10, b11, b12, b13, b14) values(9000000, 1000, 5, 'd', 1, 1, 'a', '2013-11-11', 1, 1, 'a', '2013-11-11 11:11:11', 1, 1, B'1010', 'a', null);
insert into t(a1, a2, a3, b1, b2, b3, b4, b5, b6, b7, b8, b9, b10, b11, b12, b13, b14) values(1000000, 1000, 5, 'd', 1, 1, 'a', '2013-11-11', 1, 1, 'a', '2013-11-11 11:11:11', 1, 1, B'1010', 'a', null);

create index idx1 on t(a3, b2, b3, b4, b7, b8, b10, b12, b14);
create index idx2 on t(a2, b3, b4, b5, b6, b7, b8, b9, b10, b11, b12);
create index idx3 on t(a1, b3, b4, b5, b6, b7, b8, b9, b10, b11, b12, b14) where a3<4;

update statistics on t with fullscan;

--test: show index
show index in t;

insert into t(a1, a2, a3, b1, b2, b3, b4, b5, b6, b7, b8, b9, b10, b11, b12, b13, b14) select a1+1, a2+1, a3, b1, b2, b3, b4, b5, b6, b7, b8, b9, b10, b11, b12, b13, b14 from t;
insert into t(a1, a2, a3, b1, b2, b3, b4, b5, b6, b7, b8, b9, b10, b11, b12, b13, b14) select a1+1, a2+1, a3, b1, b2, b3, b4, b5, b6, b7, b8, b9, b10, b11, b12, b13, b14 from t;
insert into t(a1, a2, a3, b1, b2, b3, b4, b5, b6, b7, b8, b9, b10, b11, b12, b13, b14) select a1+1, a2+1, a3, b1, b2, b3, b4, b5, b6, b7, b8, b9, b10, b11, b12, b13, b14 from t;
insert into t(a1, a2, a3, b1, b2, b3, b4, b5, b6, b7, b8, b9, b10, b11, b12, b13, b14) select a1+1, a2+1, a3, b1, b2, b3, b4, b5, b6, b7, b8, b9, b10, b11, b12, b13, b14 from t;
insert into t(a1, a2, a3, b1, b2, b3, b4, b5, b6, b7, b8, b9, b10, b11, b12, b13, b14) select a1+1, a2+1, a3, b1, b2, b3, b4, b5, b6, b7, b8, b9, b10, b11, b12, b13, b14 from t;
insert into t(a1, a2, a3, b1, b2, b3, b4, b5, b6, b7, b8, b9, b10, b11, b12, b13, b14) select a1+1, a2+1, a3, b1, b2, b3, b4, b5, b6, b7, b8, b9, b10, b11, b12, b13, b14 from t;
insert into t(a1, a2, a3, b1, b2, b3, b4, b5, b6, b7, b8, b9, b10, b11, b12, b13, b14) select a1+1, a2+1, a3, b1, b2, b3, b4, b5, b6, b7, b8, b9, b10, b11, b12, b13, b14 from t;
insert into t(a1, a2, a3, b1, b2, b3, b4, b5, b6, b7, b8, b9, b10, b11, b12, b13, b14) select a1+1, a2+1, a3, b1, b2, b3, b4, b5, b6, b7, b8, b9, b10, b11, b12, b13, b14 from t;
insert into t(a1, a2, a3, b1, b2, b3, b4, b5, b6, b7, b8, b9, b10, b11, b12, b13, b14) select a1+1, a2+1, a3, b1, b2, b3, b4, b5, b6, b7, b8, b9, b10, b11, b12, b13, b14 from t;
insert into t(a1, a2, a3, b1, b2, b3, b4, b5, b6, b7, b8, b9, b10, b11, b12, b13, b14) select a1+1, a2+1, a3, b1, b2, b3, b4, b5, b6, b7, b8, b9, b10, b11, b12, b13, b14 from t;
insert into t(a1, a2, a3, b1, b2, b3, b4, b5, b6, b7, b8, b9, b10, b11, b12, b13, b14) select a1+1, a2+1, a3, b1, b2, b3, b4, b5, b6, b7, b8, b9, b10, b11, b12, b13, b14 from t;
insert into t(a1, a2, a3, b1, b2, b3, b4, b5, b6, b7, b8, b9, b10, b11, b12, b13, b14) select a1+1, a2+1, a3, b1, b2, b3, b4, b5, b6, b7, b8, b9, b10, b11, b12, b13, b14 from t;
insert into t(a1, a2, a3, b1, b2, b3, b4, b5, b6, b7, b8, b9, b10, b11, b12, b13, b14) select a1+1, a2+1, a3, b1, b2, b3, b4, b5, b6, b7, b8, b9, b10, b11, b12, b13, b14 from t;


create index idx4 on t(a1, a2, b1, b2, b3, b4, b5, b6, b7, b8, b10, b11, b12, b13, trim(b14), b9, a3); 
--test: show index
update statistics on t with fullscan;
show index from t;

--test: index_cardinality
select index_cardinality('t', 'idx1', 0);
select index_cardinality('t', 'idx2', 1);
select index_cardinality('t', 'idx3', 2);
select index_cardinality('t', 'idx1', 3);
select index_cardinality('t', 'idx2', 4);
select index_cardinality('t', 'idx3', 5);
select index_cardinality('t', 'idx4', 6);
select index_cardinality('t', 'idx1', 7);
select index_cardinality('t', 'idx2', 8);
select index_cardinality('t', 'idx3', 9);
select index_cardinality('t', 'idx4', 10);
select index_cardinality('t', 'idx1', 11);
select index_cardinality('t', 'idx2', 12);
select index_cardinality('t', 'idx3', 13);
select index_cardinality('t', 'idx4', 14);
select index_cardinality('t', 'idx4', 15);
select index_cardinality('t', 'idx4', 16);
select index_cardinality('t', 'idx4', 17);


drop table t;
