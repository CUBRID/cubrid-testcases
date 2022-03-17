--test cardinality of PK on 2 columns

create table foo(a bigint, b varchar(20), c bit(20), d monetary, primary key(a, b));

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


select index_cardinality('dba.foo', 'pk_foo_a_b', 0);
select index_cardinality('dba.foo', 'pk_foo_a_b', 1);
select index_cardinality('dba.foo', 'pk_foo_a_b', 2);
select index_cardinality('dba.foo', 'pk_foo_a_b', -1);
update statistics on foo;
show index in foo;

alter table foo drop primary key;
alter table foo add constraint primary key(b, a); 
update statistics on foo;
show index in foo;

select index_cardinality('dba.foo', 'pk_foo_b_a', 0);
select index_cardinality('dba.foo', 'pk_foo_b_a', 1);
select index_cardinality('dba.foo', 'pk_foo_b_a', 2);
select index_cardinality('dba.foo', 'pk_foo_b_a', -1);

drop table foo;
