select power(cast(2 as short), cast(-1 as short));
select power(cast(2 as short), cast(-1 as int));
select power(cast(2 as short), cast(-1 as bigint));
select power(cast(2 as short), cast(-1 as numeric(10,5)));
select power(cast(2 as short), cast(-1 as float));
select power(cast(2 as short), cast(-1 as double));
select power(cast(2 as short), cast(-1 as monetary));
select power(cast(2 as short), cast('-1' as varchar(10)));
select power(cast(2 as short), cast(n'-1' as nchar varying(10)));

select power(cast(2 as int), cast(-1 as short));
select power(cast(2 as int), cast(-1 as int));
select power(cast(2 as int), cast(-1 as bigint));
select power(cast(2 as int), cast(-1 as numeric(10,5)));
select power(cast(2 as int), cast(-1 as float));
select power(cast(2 as int), cast(-1 as double));
select power(cast(2 as int), cast(-1 as monetary));
select power(cast(2 as int), cast('-1' as varchar(10)));
select power(cast(2 as int), cast(n'-1' as nchar varying(10)));

select power(cast(2 as bigint), cast(-1 as short));
select power(cast(2 as bigint), cast(-1 as int));
select power(cast(2 as bigint), cast(-1 as bigint));
select power(cast(2 as bigint), cast(-1 as numeric(10,5)));
select power(cast(2 as bigint), cast(-1 as float));
select power(cast(2 as bigint), cast(-1 as double));
select power(cast(2 as bigint), cast(-1 as monetary));
select power(cast(2 as bigint), cast('-1' as varchar(10)));
select power(cast(2 as bigint), cast(n'-1' as nchar varying(10)));

select power(cast(2 as numeric(10,5)), cast(-1 as short));
select power(cast(2 as numeric(10,5)), cast(-1 as int));
select power(cast(2 as numeric(10,5)), cast(-1 as bigint));
select power(cast(2 as numeric(10,5)), cast(-1 as numeric(10,5)));
select power(cast(2 as numeric(10,5)), cast(-1 as float));
select power(cast(2 as numeric(10,5)), cast(-1 as double));
select power(cast(2 as numeric(10,5)), cast(-1 as monetary));
select power(cast(2 as numeric(10,5)), cast('-1' as varchar(10)));
select power(cast(2 as numeric(10,5)), cast(n'-1' as nchar varying(10)))

select power(cast(2 as float), cast(-1 as short));
select power(cast(2 as float), cast(-1 as int));
select power(cast(2 as float), cast(-1 as bigint));
select power(cast(2 as float), cast(-1 as numeric(10,5)));
select power(cast(2 as float), cast(-1 as float));
select power(cast(2 as float), cast(-1 as double));
select power(cast(2 as float), cast(-1 as monetary));
select power(cast(2 as float), cast('-1' as varchar(10)));
select power(cast(2 as float), cast(n'-1' as nchar varying(10)));

select power(cast(2 as double), cast(-1 as short));
select power(cast(2 as double), cast(-1 as int));
select power(cast(2 as double), cast(-1 as bigint));
select power(cast(2 as double), cast(-1 as numeric(10,5)));
select power(cast(2 as double), cast(-1 as float));
select power(cast(2 as double), cast(-1 as double));
select power(cast(2 as double), cast(-1 as monetary));
select power(cast(2 as double), cast('-1' as varchar(10)));
select power(cast(2 as double), cast(n'-1' as nchar varying(10)));

select power(cast(2 as monetary), cast(-1 as short));
select power(cast(2 as monetary), cast(-1 as int));
select power(cast(2 as monetary), cast(-1 as bigint));
select power(cast(2 as monetary), cast(-1 as numeric(10,5)));
select power(cast(2 as monetary), cast(-1 as float));
select power(cast(2 as monetary), cast(-1 as double));
select power(cast(2 as monetary), cast(-1 as monetary));
select power(cast(2 as monetary), cast('-1' as varchar(10)));
select power(cast(2 as monetary), cast(n'-1' as nchar varying(10)));

select power(cast('2' as varchar(10)), cast(-1 as short));
select power(cast('2' as varchar(10)), cast(-1 as int));
select power(cast('2' as varchar(10)), cast(-1 as bigint));
select power(cast('2' as varchar(10)), cast(-1 as numeric(10,5)));
select power(cast('2' as varchar(10)), cast(-1 as float));
select power(cast('2' as varchar(10)), cast(-1 as double));
select power(cast('2' as varchar(10)), cast(-1 as monetary));
select power(cast('2' as varchar(10)), cast('-1' as varchar(10)));
select power(cast('2' as varchar(10)), cast(n'-1' as nchar varying(10)));

select power(cast(n'2' as nchar varying(10)), cast(-1 as short));
select power(cast(n'2' as nchar varying(10)), cast(-1 as int));
select power(cast(n'2' as nchar varying(10)), cast(-1 as bigint));
select power(cast(n'2' as nchar varying(10)), cast(-1 as numeric(10,5)));
select power(cast(n'2' as nchar varying(10)), cast(-1 as float));
select power(cast(n'2' as nchar varying(10)), cast(-1 as double));
select power(cast(n'2' as nchar varying(10)), cast(-1 as monetary));
select power(cast(n'2' as nchar varying(10)), cast('-1' as varchar(10)));
select power(cast(n'2' as nchar varying(10)), cast(n'-1' as nchar varying(10)));

create table x(
	s short,
	i int,
	b bigint,
	n numeric(10,5),
	f float,
	d double,
	m monetary,
	c varchar(10),
	nc nchar varying(10)
);
create table y like x;

insert into x values(2, 2, 2, 2, 2, 2, 2, '2', n'2');
insert into y values(-1, -1, -1, -1, -1, -1, -1, '-1', n'-1');

select power(x.s, y.s) from x, y;
select power(x.s, y.i) from x, y;
select power(x.s, y.b) from x, y;
select power(x.s, y.n) from x, y;
select power(x.s, y.f) from x, y;
select power(x.s, y.d) from x, y;
select power(x.s, y.m) from x, y;
select power(x.s, y.c) from x, y;
select power(x.s, y.nc) from x, y;

select power(x.i, y.s) from x, y;
select power(x.i, y.i) from x, y;
select power(x.i, y.b) from x, y;
select power(x.i, y.n) from x, y;
select power(x.i, y.f) from x, y;
select power(x.i, y.d) from x, y;
select power(x.i, y.m) from x, y;
select power(x.i, y.c) from x, y;
select power(x.i, y.nc) from x, y;

select power(x.b, y.s) from x, y;
select power(x.b, y.i) from x, y;
select power(x.b, y.b) from x, y;
select power(x.b, y.n) from x, y;
select power(x.b, y.f) from x, y;
select power(x.b, y.d) from x, y;
select power(x.b, y.m) from x, y;
select power(x.b, y.c) from x, y;
select power(x.b, y.nc) from x, y;

select power(x.n, y.s) from x, y;
select power(x.n, y.i) from x, y;
select power(x.n, y.b) from x, y;
select power(x.n, y.n) from x, y;
select power(x.n, y.f) from x, y;
select power(x.n, y.d) from x, y;
select power(x.n, y.m) from x, y;
select power(x.n, y.c) from x, y;
select power(x.n, y.nc) from x, y;

select power(x.f, y.s) from x, y;
select power(x.f, y.i) from x, y;
select power(x.f, y.b) from x, y;
select power(x.f, y.n) from x, y;
select power(x.f, y.f) from x, y;
select power(x.f, y.d) from x, y;
select power(x.f, y.m) from x, y;
select power(x.f, y.c) from x, y;
select power(x.f, y.nc) from x, y;

select power(x.d, y.s) from x, y;
select power(x.d, y.i) from x, y;
select power(x.d, y.b) from x, y;
select power(x.d, y.n) from x, y;
select power(x.d, y.f) from x, y;
select power(x.d, y.d) from x, y;
select power(x.d, y.m) from x, y;
select power(x.d, y.c) from x, y;
select power(x.d, y.nc) from x, y;

select power(x.m, y.s) from x, y;
select power(x.m, y.i) from x, y;
select power(x.m, y.b) from x, y;
select power(x.m, y.n) from x, y;
select power(x.m, y.f) from x, y;
select power(x.m, y.d) from x, y;
select power(x.m, y.m) from x, y;
select power(x.m, y.c) from x, y;
select power(x.m, y.nc) from x, y;

select power(x.c, y.s) from x, y;
select power(x.c, y.i) from x, y;
select power(x.c, y.b) from x, y;
select power(x.c, y.n) from x, y;
select power(x.c, y.f) from x, y;
select power(x.c, y.d) from x, y;
select power(x.c, y.m) from x, y;
select power(x.c, y.c) from x, y;
select power(x.c, y.nc) from x, y;

select power(x.nc, y.s) from x, y;
select power(x.nc, y.i) from x, y;
select power(x.nc, y.b) from x, y;
select power(x.nc, y.n) from x, y;
select power(x.nc, y.f) from x, y;
select power(x.nc, y.d) from x, y;
select power(x.nc, y.m) from x, y;
select power(x.nc, y.c) from x, y;
select power(x.nc, y.nc) from x, y;

drop table x, y;

select if(power(2, null) is null, 'OK', 'NOK');
select if(power(null, 2) is null, 'OK', 'NOK');
select if(power(null, null) is null, 'OK', 'NOK');

create table x (i int);
insert into x values(null);
select if(power(2, i) is null, 'OK', 'NOK') from x;
select if(power(i, 2) is null, 'OK', 'NOK') from x;
select if(power(i, i) is null, 'OK', 'NOK') from x;
drop table x;

--return error.
--ERROR: Argument of power() is out of range.
select power(-1, 0.1);


