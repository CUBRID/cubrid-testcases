--TEST: Result is inconsistent with Oracle when 'min_value' is equal to 'max_value' in width_bucket() function.

drop table if exists foo;

create table foo(a int, b int);

insert into foo values(1, 1);
insert into foo values(2, 2);
insert into foo values(3, 3);
insert into foo values(4, 4);

--error occurs
select a, b, width_bucket(a, 3, 3, 4) from foo order by 1, 2, 3;
select a, b, width_bucket(a, -1, -1, 4) from foo order by 1, 2, 3;
select a, b, width_bucket(a, 100, 100, 4) from foo order by 1, 2, 3;


drop foo;
