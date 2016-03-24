create class foo(
s SHORT,
i INTEGER,
b BIGINT,
n NUMERIC(15,5));

insert into foo(s, i, b, n) values(0, 0, 0, 0);

select INCR(s), INCR(i), INCR(b) from foo;

-- error
select INCR(n) from foo;

drop class foo;

