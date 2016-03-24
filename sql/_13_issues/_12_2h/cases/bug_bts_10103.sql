--TEST: Core dumped when passing blob/clob value to the 'max_value' parameter of width_bucket() function.


drop table if exists foo;

create table foo(a int, b clob);
insert into foo values(1, '1');

--core dumped
select width_bucket(a, 1, b, 3) from foo order by 1;


drop table foo;

