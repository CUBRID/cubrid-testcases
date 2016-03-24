--128 rows of same data: exceptional cases

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

select index_cardinality('foo', 'i_foo_a', 1);
select index_cardinality('foo', 'i_foo_b', -1);
select index_cardinality('too', 'i_foo_c', 0);
select index_cardinality('foo', 'i_foo_e', 0);

select index_cardinality('foo', 'i_foo_a_b', 2);
select index_cardinality('foo', 'i_foo_a_b', -100);
select index_cardinality('too', 'i_foo_b_c', 0);
select index_cardinality('foo', 'i_foo_d_c', 1);
select index_cardinality('foo', 'i_foo_c_d', 200000);
select index_cardinality('foo', 'i_foo_c_d_e', 1);

select index_cardinality('foo', 'i_foo_a_b_c', 3);
select index_cardinality('foo', 'i_foo_a_b_c', -555);
select index_cardinality('foo', 'i_coo_a_b_c', 2);

select index_cardinality('foo', 'i_foo_a_b_c_d', 4);
select index_cardinality('foo', 'i_foo_a_b_c_d', -11);
select index_cardinality('goo', 'i_foo_a_b_c_d', 2);
select index_cardinality('foo', 'i_foo_a_b_c_e', 3);

drop table foo;
