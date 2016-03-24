--TEST: Result is incorrect when passing an out-of-range value to the 'min_value' parameter of width_bucket() function.

drop if exists foo;
create table foo(a double, b double);
insert into foo values(1, 1);
insert into foo values(2, 2);
insert into foo values(3, 3);
insert into foo values(4, 4);
insert into foo values(-1.7976931348623157E+309, 4);
insert into foo values(1.7976931348623157E+309, 4);

select a, b, width_bucket(a, -1.7976931348623157E+309, 1, 1) from foo;
select a, b, width_bucket(a, 1.7976931348623157E+309, 1, 1) from foo;
select a, b, width_bucket(a, 1, -1.7976931348623157E+309, 1) from foo;
select a, b, width_bucket(a, 1, 1.7976931348623157E+309, 1) from foo;

drop if exists foo;

select width_bucket (9223372036854775806, 1, 9223372036854775807, 1);
select width_bucket (9223372036854775808, 1, 9223372036854775807, 1);
select width_bucket (9223372036854775809, 1, 9223372036854775807, 1);

select width_bucket (9223372036854775806, 1, 9223372036854775807, 2147483646);
select width_bucket (9223372036854775808, 1, 9223372036854775807, 2147483646);
select width_bucket (9223372036854775809, 1, 9223372036854775807, 2147483646);



