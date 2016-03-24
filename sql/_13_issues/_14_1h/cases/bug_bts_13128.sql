drop table if exists foo;
create table foo(num numeric(38,10));
insert into foo values(1);
insert into foo values(9999999999999999999999999999.0123456789);
select avg(num) from foo;
drop foo;

create table foo(num numeric(38,10));
insert into foo values(0);
insert into foo values(9999999999999999999999999999.0123456789);
select avg(num) from foo;
drop foo;


create table foo(num numeric(38,10));
insert into foo values(1);
insert into foo values(999999999999999999999999999.0123456789);
select avg(num) from foo;
drop foo;

create table foo(num numeric(38,10));
insert into foo values(0.0000000001);
insert into foo values(9999999999999999999999999999.9999999999);
select avg(num) from foo;
drop foo;

create table foo(num numeric(38,10));
insert into foo values(0.0000000001);
insert into foo values(999999999999999999999999999.9999999999);
select avg(num) from foo;
drop foo;

create table foo(num numeric(38,10));
insert into foo values(0), (9876543210987654321012345678.0123456789);
select avg(num) from foo;
drop foo;

create table foo(num numeric(38,10));
insert into foo values(3), (-9876543210987654321012345678.0123456789);
select avg(num) from foo;
drop foo;

create table foo(num numeric(38,10));
insert into foo values(0), (-9876543210987654321012345678.0123456789);
select avg(num) from foo;
drop foo;
create table foo(num numeric(38,10));
insert into foo values(-6), (-9876543210987654321012345678.0123456789);
select avg(num) from foo;
drop foo;

create table foo(num numeric(38,10));
insert into foo values(-1);
insert into foo values(-999999999999999999999999999.0123456789);
select avg(num) from foo;
drop foo;
create table foo(num numeric(38,10));
insert into foo values(-1);
insert into foo values(-9999999999999999999999999999.0123456789);
select avg(num) from foo;
drop foo;
create table foo(num numeric(38,10));
insert into foo values(-5678);
insert into foo values(-999999999999999999999999999.0123456789);
select avg(num) from foo;
drop foo;

create table foo(num numeric(38,10));
insert into foo values(-0.0000000001);
insert into foo values(-9999999999999999999999999999.9999999999);
select avg(num) from foo;
drop foo;

create table foo(num numeric(38,10));
insert into foo values(-0.0000000001);
insert into foo values(-999999999999999999999999999.9999999999);
select avg(num) from foo;
drop foo;
