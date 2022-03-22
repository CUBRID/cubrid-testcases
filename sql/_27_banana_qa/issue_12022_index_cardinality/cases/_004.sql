--test the cardinality of filtered index

drop table if exists t;
create table t(a1 int not null, a2 int not null, a3 int not null,
	b1 char(10), b2 int, b3 smallint, b4 varchar(10), b5 date, b6 float, b7 int, b8 string,
	b9 timestamp, b10 double, b11 int, b12 bit(10), b13 enum('a', 'b', 'c'), b14 varchar
);

insert into t values(1, 1, 1, 'a', 1, 1, 'a', '2013-11-11', 1, 1, 'a', '2013-11-11 11:11:11', 1, 1, B'1010', 'a', null);
insert into t values(1, 1, 1, 'a', 1, 1, 'a', '2013-11-11', 1, 1, 'a', '2013-11-11 11:11:11', 1, 1, B'1010', 'a', null);
insert into t values(2, 2, 1, 'a', 1, 1, 'a', '2013-11-11', 1, 1, 'a', '2013-11-11 11:11:11', 1, 1, B'1010', 'a', null);
insert into t values(2, 2, 1, 'a', 1, 1, null, '2013-11-11', 1, 1, 'a', '2013-11-11 11:11:11', 1, 1, B'1010', 'a', null);
insert into t values(3, 1, 1, 'b', 1, 1, 'a', '2013-11-11', 1, 1, 'a', '2013-11-11 11:11:11', 1, 1, B'1010', 'a', null);
insert into t values(3, 1, 1, 'b', 1, 1, 'a', '2013-11-11', 1, 1, 'a', '2013-11-11 11:11:11', 1, 1, B'1010', 'a', null);
insert into t values(4, 1, 1, 'c', 1, 1, 'a', '2013-11-11', 1, 1, 'a', '2013-11-11 11:11:11', 1, 1, B'1010', 'a', null);
insert into t values(4, 1, 1, 'c', 1, 1, 'a', '2013-11-11', 1, 1, 'a', '2013-11-11 11:11:11', 1, 1, B'1010', 'a', null);
insert into t values(9, 1, 1, 'd', 1, 1, 'a', '2013-11-11', 1, 1, 'a', '2013-11-11 11:11:11', 1, 1, B'1010', 'a', null);
insert into t values(10, 1, 1, 'd', 1, 1, 'a', '2013-11-11', 1, 1, 'a', '2013-11-11 11:11:11', 1, 1, B'1010', 'a', null);
insert into t values(11, 1, 1, 'e', 1, 1, 'a', '2013-11-11', 1, 1, 'a', '2013-11-11 11:11:11', 1, 1, B'1010', 'a', null);
insert into t values(12, 1, 1, 'e', 1, 1, 'a', '2013-11-11', 1, 1, 'a', '2013-11-11 11:11:11', 1, 1, B'1010', 'a', null);
insert into t values(13, 1, 1, 'f', 1, 1, 'a', '2013-11-11', 1, 1, 'a', '2013-11-11 11:11:11', 1, 1, B'1010', 'a', null);
insert into t values(14, 1, 1, 'f', 1, 1, 'a', '2013-11-11', 1, null, 'a', '2013-11-11 11:11:11', 1, 1, B'1010', 'a', null);
insert into t values(15, 1, 1, 'g', 1, 1, 'a', '2013-11-11', 1, 1, 'a', '2013-11-11 11:11:11', 1, 1, B'1010', 'a', null);
insert into t values(16, 1, 1, 'g', 1, 1, 'a', '2013-11-11', 1, 1, 'a', '2013-11-11 11:11:11', 1, 1, B'1010', 'a', null);

--create filtered index
create index fidx1 on t(a2, b1, b2, b3, b4, b5) where a1<6 and b4 is not null;
create index fidx2 on t(b2, b5, b7, b8, b9, b10, b14, b12, a2) where b14 is null and b1>'a' and b6=1;
--error
create index fidx3 on t(b2, b5, b7, b8, b9, b10, b14, b12, a2) where b12 is null and b4>'a' and b6=1;
create index fidx3 on t(b14, b13, b12, b11, b10, b9, b8, b7, b6, b5, b4, b3, b2, b1, a2, a3) where b1!='z' and b3<10 and a1<5;


--test: show index
update statistics on t with fullscan;
show index in t;

--test: index_cardinality
select index_cardinality('dba.t', 'fidx1', 0);
select index_cardinality('dba.t', 'fidx1', 2);
select index_cardinality('dba.t', 'fidx1', 4);
select index_cardinality('dba.t', 'fidx2', 0);
select index_cardinality('dba.t', 'fidx2', 3);
select index_cardinality('dba.t', 'fidx2', 5);
select index_cardinality('dba.t', 'fidx2', 7);
select index_cardinality('dba.t', 'fidx2', 9);
select index_cardinality('dba.t', 'fidx3', 1);
select index_cardinality('dba.t', 'fidx3', 4);
select index_cardinality('dba.t', 'fidx3', 6);
select index_cardinality('dba.t', 'fidx3', 9);
select index_cardinality('dba.t', 'fidx3', 11);
select index_cardinality('dba.t', 'fidx3', 13);
select index_cardinality('dba.t', 'fidx3', 14);
select index_cardinality('dba.t', 'fidx3', 15);
select index_cardinality('dba.t', 'fidx3', 16);


drop table t;
