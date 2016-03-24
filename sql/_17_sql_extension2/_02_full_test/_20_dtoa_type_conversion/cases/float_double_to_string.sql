select 1.234 + '76843';
select concat(98343.22343, 12.34);
select cast(578029342.74342 as varchar);
select strcmp(123.987, '123.987');


create table foo(a float, b double);
insert into foo values(123.678, 12938492384.239429034);

select a + '8734.23' from foo;
select b + '8734.23' from foo;

select concat(a, '100') from foo;
select concat(b, '987') from foo;

select cast(a as char(10)) from foo;
select cast(b as varchar) from foo;

select strcmp(a, '123.678') from foo;
select strcmp(b, '12938492384.239429034') from foo;

drop foo;
