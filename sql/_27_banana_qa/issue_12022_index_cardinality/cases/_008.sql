--create composed index on more than 50 columns

drop table if exists t;
create table t(a1 int, a2 int, a3 int, a4 int, a5 int, a6 int, a7 int, a8 int, a9 int, a10 int, 
	b1 char(10), b2 int, b3 smallint, b4 varchar(10), b5 date, b6 float, b7 int, b8 string,
	b9 timestamp, b10 double, b11 int, b12 bit(10), b13 enum('a', 'b', 'c'), b14 varchar, b15 int,
	c1 char(10), c2 int, c3 smallint, c4 varchar(10), c5 date, c6 float, c7 int, c8 string,
	d1 int, d2 int, d3 int, d4 int, d5 int, d6 int, d7 int, d8 int, d9 int, d10 int,
	e1 int, e2 int, e3 int, e4 int, e5 int, e6 int, e7 int, e8 int, e9 int, e10 int
);

--test: create index on 20 columns
create index idx on t(a1, a2, a3, a4, a5, b14, b6, b3, b9, b4, b5, b12, b11, b8, b10, b1, b2, b13, b7, b15, a6, a7, a8, a9, a10, c1, c2, c3, c4, c5, c6, c7, c8, d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, e1, e2, e3, e4, e5, e6, e7, e8, e9, e10);

show index from t;

insert into t values(1, 1, 1, 2, 3, 4, 5, 6, 7, 8, 'a', 1, 1, 'a', '2013-11-11', 1, 1, 'a', '2013-11-11 11:11:11', 1, 1, B'1010', 'a', null, 100, 'a', 1, 1, 'a', '2013-11-11', 1, 1, 'a', 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10);
insert into t values(2, 1, 1, 2, 3, 4, 5, 6, 7, 8, 'a', 1, 1, 'a', '2013-11-11', 1, 1, 'a', '2013-11-11 11:11:11', 1, 1, B'1010', 'a', null, 100, 'a', 1, 1, 'a', '2013-11-11', 1, 1, 'a', 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10);
insert into t values(3, 2, 1, 2, 3, 4, 5, 6, 7, 8, 'a', 1, 1, 'a', '2013-11-11', 1, 1, 'a', '2013-11-11 11:11:11', 1, 1, B'1010', 'a', null, 100, 'a', 1, 1, 'a', '2013-11-11', 1, 1, 'a', 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10);
insert into t values(4, 2, 1, 2, 3, 4, 5, 6, 7, 8, 'a', 1, 1, null, '2013-11-11', 1, 1, 'a', '2013-11-11 11:11:11', 1, 1, B'1010', 'a', null, 100, 'a', 1, 1, 'a', '2013-11-11', 1, 1, 'a', 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10);
insert into t values(5, 1, 1, 2, 3, 4, 5, 6, 7, 8, 'b', 1, 1, 'a', '2013-11-11', 1, 1, 'a', '2013-11-11 11:11:11', 1, 1, B'1010', 'a', null, 100, 'a', 1, 1, 'a', '2013-11-11', 1, 1, 'a', 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10);
insert into t values(6, 1, 1, 2, 3, 4, 5, 6, 7, 8, 'b', 1, 1, 'a', '2013-11-11', 1, 1, 'a', '2013-11-11 11:11:11', 1, 1, B'1010', 'a', null, 100, 'a', 1, 1, 'a', '2013-11-11', 1, 1, 'a', 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10);
insert into t values(7, 1, 1, 2, 3, 4, 5, 6, 7, 8, 'c', 1, 1, 'a', '2013-11-11', 1, 1, 'a', '2013-11-11 11:11:11', 1, 1, B'1010', 'a', null, 100, 'a', 1, 1, 'a', '2013-11-11', 1, 1, 'a', 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10);
insert into t values(8, 1, 1, 2, 3, 4, 5, 6, 7, 8, 'c', 1, 1, 'a', '2013-11-11', 1, 1, 'a', '2013-11-11 11:11:11', 1, 1, B'1010', 'a', null, 100, 'a', 1, 1, 'a', '2013-11-11', 1, 1, 'a', 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10);
insert into t values(9, 1, 1, 2, 3, 4, 5, 6, 7, 8, 'd', 1, 1, 'a', '2013-11-11', 1, 1, 'a', '2013-11-11 11:11:11', 1, 1, B'1010', 'a', null, 100, 'a', 1, 1, 'a', '2013-11-11', 1, 1, 'a', 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10);
insert into t values(10, 1, 1, 2, 3, 4, 5, 6, 7, 8, 'd', 1, 1, 'a', '2013-11-11', 1, 1, 'a', '2013-11-11 11:11:11', 1, 1, B'1010', 'a', null, 100, 'a', 1, 1, 'a', '2013-11-11', 1, 1, 'a', 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10);
insert into t values(11, 1, 1, 2, 3, 4, 5, 6, 7, 8, 'e', 1, 1, 'a', '2013-11-11', 1, 1, 'a', '2013-11-11 11:11:11', 1, 1, B'1010', 'a', null, 100, 'a', 1, 1, 'a', '2013-11-11', 1, 1, 'a', 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10);
insert into t values(12, 1, 1, 2, 3, 4, 5, 6, 7, 8, 'e', 1, 1, 'a', '2013-11-11', 1, 1, 'a', '2013-11-11 11:11:11', 1, 1, B'1010', 'a', null, 100, 'a', 1, 1, 'a', '2013-11-11', 1, 1, 'a', 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10);
insert into t values(13, 1, 1, 2, 3, 4, 5, 6, 7, 8, 'f', 1, 1, 'a', '2013-11-11', 1, 1, 'a', '2013-11-11 11:11:11', 1, 1, B'1010', 'a', null, 100, 'a', 1, 1, 'a', '2013-11-11', 1, 1, 'a', 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10);
insert into t values(14, 1, 1, 2, 3, 4, 5, 6, 7, 8, 'f', 1, 1, 'a', '2013-11-11', 1, 1, 'a', '2013-11-11 11:11:11', 1, 1, B'1010', 'a', null, 100, 'a', 1, 1, 'a', '2013-11-11', 1, 1, 'a', 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10);
insert into t values(15, 1, 1, 2, 3, 4, 5, 6, 7, 8, 'g', 1, 1, 'a', '2013-11-11', 1, 1, 'a', '2013-11-11 11:11:11', 1, 1, B'1010', 'a', null, 100, 'a', 1, 1, 'a', '2013-11-11', 1, 1, 'a', 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10);
insert into t values(16, 1, 1, 2, 3, 4, 5, 6, 7, 8, 'g', 1, 1, 'a', '2013-11-11', 1, 1, 'a', '2013-11-11 11:11:11', 1, 1, B'1010', 'a', null, 100, 'a', 1, 1, 'a', '2013-11-11', 1, 1, 'a', 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10);


update statistics on t with fullscan;

--test: show index
show index in t;

--test: index_cardinality
select index_cardinality('dba.t', 'idx', 0);
select index_cardinality('dba.t', 'idx', 1);
select index_cardinality('dba.t', 'idx', 2);
select index_cardinality('dba.t', 'idx', 3);
select index_cardinality('dba.t', 'idx', 4);
select index_cardinality('dba.t', 'idx', 5);
select index_cardinality('dba.t', 'idx', 6);
select index_cardinality('dba.t', 'idx', 7);
select index_cardinality('dba.t', 'idx', 8);
select index_cardinality('dba.t', 'idx', 9);
select index_cardinality('dba.t', 'idx', 10);
select index_cardinality('dba.t', 'idx', 11);
select index_cardinality('dba.t', 'idx', 12);
select index_cardinality('dba.t', 'idx', 13);
select index_cardinality('dba.t', 'idx', 14);
select index_cardinality('dba.t', 'idx', 33);
select index_cardinality('dba.t', 'idx', 42);
select index_cardinality('dba.t', 'idx', 52);


drop table t;
