--test cardinality of PK on 1 column

create table foo(a bigint primary key auto_increment, b varchar(20), c bit(20), d monetary);

insert into foo(b, c, d) values('abc', B'10101', 123);
insert into foo(b, c, d) select b, c, d from foo;
insert into foo(b, c, d) select b, c, d from foo;
insert into foo(b, c, d) select b, c, d from foo;
insert into foo(b, c, d) select b, c, d from foo;
insert into foo(b, c, d) select b, c, d from foo;
insert into foo(b, c, d) select b, c, d from foo;
insert into foo(b, c, d) select b, c, d from foo;

select count(*) from foo;

select index_cardinality('foo', 'pk_foo_a', 0);
select index_cardinality('foo', 'pk_foo_a', 1);
select index_cardinality('foo', 'pk_foo_a', -1);


drop table foo;
