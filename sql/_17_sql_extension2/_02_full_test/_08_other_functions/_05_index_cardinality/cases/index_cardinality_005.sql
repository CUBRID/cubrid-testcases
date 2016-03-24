--test cardinality of FK on 1 column

create table foo(a bigint, b varchar(20), c bit(20), d monetary, primary key(a, b));
create table coo(a bigint, b varchar(20), c float,
	constraint pk_a_b primary key(a, b),
	constraint fk_a_b foreign key(a, b) references foo(a, b) on delete cascade on update restrict);

insert into foo values(1, 'aaa', B'10101', 12);
insert into foo values(1, 'bbb', B'10101', 12);
insert into foo values(1, 'ccc', B'10101', 12);
insert into foo values(2, 'aaa', B'10101', 12);
insert into foo values(2, 'bbb', B'10101', 12);
insert into foo values(2, 'ddd', B'10101', 12);
insert into foo values(3, 'aaa', B'10101', 12);
insert into foo values(3, 'ccc', B'10101', 12);
insert into foo values(3, 'ddd', B'10101', 12);
insert into foo values(4, 'bbb', B'10101', 12);
insert into foo values(4, 'ddd', B'10101', 12);
insert into foo values(4, 'ccc', B'10101', 12);
insert into foo values(5, 'aaa', B'10101', 12);
insert into foo values(5, 'ccc', B'10101', 12);
insert into foo values(5, 'bbb', B'10101', 12);

insert into coo values(1, 'aaa', 12.12);
insert into coo values(1, 'bbb', 12.12);
insert into coo values(2, 'aaa', 12.12);
insert into coo values(2, 'ddd', 12.12);
insert into coo values(3, 'ccc', 12.12);
insert into coo values(4, 'bbb', 12.12);
insert into coo values(5, 'aaa', 12.12);

show index in foo;
show index in coo;

select index_cardinality('foo', 'pk_foo_a_b', 0);
select index_cardinality('foo', 'pk_foo_a_b', 1);
select index_cardinality('foo', 'pk_foo_a_b', 2);
select index_cardinality('foo', 'pk_foo_a_b', -1);

select index_cardinality('coo', 'pk_a_b', 0);
select index_cardinality('coo', 'pk_a_b', 1);
select index_cardinality('coo', 'fk_a_b', 0);
select index_cardinality('coo', 'fk_a_b', 1);

drop table coo;
drop table foo;
