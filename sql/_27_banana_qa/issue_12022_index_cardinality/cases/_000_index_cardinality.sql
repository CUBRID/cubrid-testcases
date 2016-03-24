--check cardinality value in index_cardinality function, 15 columns

drop table if exists foo;
create table foo (a1 int, a2 int, a3 int, a4 int, a5 int,
                a6 int, a7 int, a8 int, a9 int, a10 int,
                a11 int, a12 int, a13 int, a14 int, a15 int);
create index idx1 on foo (a1, a2, a3, a4, a5, a6, a7, a8, a9, a10,
                        a11, a12, a13, a14, a15);
insert into foo values (1,1,1,1,1,1,1,1,1,1,1,1,1,1,1);
insert into foo values (1,2,2,2,2,2,2,2,2,2,2,2,2,2,2);
insert into foo values (1,1,3,3,3,3,3,3,3,3,3,3,3,3,3);
insert into foo values (1,1,1,4,4,4,4,4,4,4,4,4,4,4,4);
insert into foo values (1,1,1,1,5,5,5,5,5,5,5,5,5,5,5);
insert into foo values (1,1,1,1,1,6,6,6,6,6,6,6,6,6,6);
insert into foo values (1,1,1,1,1,1,7,7,7,7,7,7,7,7,7);
insert into foo values (1,1,1,1,1,1,1,8,8,8,8,8,8,8,8);
insert into foo values (1,1,1,1,1,1,1,1,9,9,9,9,9,9,9);
insert into foo values (1,1,1,1,1,1,1,1,1,10,10,10,10,10,10);
insert into foo values (1,1,1,1,1,1,1,1,1,1,11,11,11,11,11);
insert into foo values (1,1,1,1,1,1,1,1,1,1,1,12,12,12,12);
insert into foo values (1,1,1,1,1,1,1,1,1,1,1,1,13,13,13);
insert into foo values (1,1,1,1,1,1,1,1,1,1,1,1,1,14,14);
insert into foo values (1,1,1,1,1,1,1,1,1,1,1,1,1,1,15);

--test: show index statement
select index_cardinality('foo', 'idx1', 7);
select index_cardinality('foo', 'idx1', 8);
update statistics on foo;
select index_cardinality('foo', 'idx1', 7);
select index_cardinality('foo', 'idx1', 8);
select index_cardinality('foo', 'idx1', 9);
select index_cardinality('foo', 'idx1', 10);
select index_cardinality('foo', 'idx1', 11);
select index_cardinality('foo', 'idx1', 12);
select index_cardinality('foo', 'idx1', 13);
select index_cardinality('foo', 'idx1', 14);

drop table foo;


