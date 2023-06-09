--128 rows of same data: normal

create table foo(a int, b char(20), c bit varying, d short);

insert into foo values(100, 'abc', B'10101', 123);
insert into foo select * from foo;
insert into foo select * from foo;
insert into foo select * from foo;
insert into foo select * from foo;
insert into foo select * from foo;
insert into foo select * from foo;
insert into foo select * from foo;

create index i_foo_a on foo(a);
create index i_foo_b on foo(b);
create index i_foo_c on foo(c desc);
create index i_foo_d on foo(d);
create index i_foo_a_b on foo(a, b);
create index i_foo_b_c on foo(b, c);
create index i_foo_c_d on foo(c, d);
create index i_foo_a_b_c on foo(a, b, c);
create index i_foo_a_b_c_d on foo(a, b, c, d);

select count(*) from foo;
update statistics on foo;
show index in foo;

select index_cardinality('foo', 'i_foo_a', 0);
select index_cardinality('foo', 'i_foo_b', 0);
select index_cardinality('foo', 'i_foo_c', 0);
select index_cardinality('foo', 'i_foo_d', 0);

select index_cardinality('foo', 'i_foo_a_b', 0);
select index_cardinality('foo', 'i_foo_a_b', 1);
select index_cardinality('foo', 'i_foo_b_c', 0);
select index_cardinality('foo', 'i_foo_b_c', 1);
select index_cardinality('foo', 'i_foo_c_d', 0);
select index_cardinality('foo', 'i_foo_c_d', 1);

select index_cardinality('foo', 'i_foo_a_b_c', 0);
select index_cardinality('foo', 'i_foo_a_b_c', 1);
select index_cardinality('foo', 'i_foo_a_b_c', 2);

select index_cardinality('foo', 'i_foo_a_b_c_d', 0);
select index_cardinality('foo', 'i_foo_a_b_c_d', 1);
select index_cardinality('foo', 'i_foo_a_b_c_d', 2);
select index_cardinality('foo', 'i_foo_a_b_c_d', 3);

drop table foo;
