--+ holdcas on;
--full scan problem
set  system parameters 'dont_reuse_heap_file=yes';
create table foo (
c char(10), v varchar(10), s string, nc nchar(10), vnc nchar varying(10),
b bit(10), vb bit varying(10),
i int, sm smallint, n numeric, f float, d double, m monetary,
da date, ti time, ts timestamp,
se set(int), mu multiset(int), li list(int));

insert into foo values (
'a', 'a', 'a', N'a', N'a',
X'a', X'a',
1, 1, 1, 1, 1, 1,
'2009-01-01', '01:01:01', '2009-01-01 11:11:11',
{1}, {1}, {1}
);

insert into foo values (
'b', 'b', 'b', N'b', N'b',
X'b', X'b',
2, 2, 2, 2, 2, 2,
'2009-01-02', '01:01:02', '2009-01-01 11:11:12',
{2}, {2}, {2}
);

insert into foo values (
'c', 'c', 'c', N'c', N'c',
X'c', X'c',
3, 3, 3, 3, 3, 3,
'2009-01-03', '01:01:03', '2009-01-01 11:11:13',
{3}, {3}, {3}
);


select
min(c), min(v), min(s), min(nc), min(vnc),
min(b), min(vb),
min(i), min(sm), min(n), min(f), min(d), min(m),
min(da), min(ti), min(ts)
from foo
--where i < 0 and i > 10
;

select
max(c), max(v), max(s), max(nc), max(vnc),
max(b), max(vb),
max(i), max(sm), max(n), max(f), max(d), max(m),
max(da), max(ti), max(ts)
from foo
--where i < 0 and i > 10
;

select
sum({c}), sum({v}), sum({s}), sum({nc}), sum({vnc}),
sum({b}), sum({vb}),
sum(i), sum(sm), sum(n), sum(f), sum(d), sum(m),
sum({da}), sum({ti}), sum({ts}),
sum(se), sum(mu), sum(li)
from foo
--where i < 0 and i > 10
;

select
avg(i), avg(sm), avg(n), avg(f), avg(d), avg(m)
from foo
--where i < 0 and i > 10
;

select
variance(i), variance(sm), variance(n), variance(f), variance(d), variance(m)
from foo
--where i < 0 and i > 10
;

select
stddev(i), stddev(sm), stddev(n), stddev(f), stddev(d), stddev(m)
from foo
--where i < 0 and i > 10


select
min(c), min(v), min(s), min(nc), min(vnc),
min(b), min(vb),
min(i), min(sm), min(n), min(f), min(d), min(m),
min(da), min(ti), min(ts)
from foo
where i < 0 and i > 10
;

select
max(c), max(v), max(s), max(nc), max(vnc),
max(b), max(vb),
max(i), max(sm), max(n), max(f), max(d), max(m),
max(da), max(ti), max(ts)
from foo
where i < 0 and i > 10
;

select
sum({c}), sum({v}), sum({s}), sum({nc}), sum({vnc}),
sum({b}), sum({vb}),
sum(i), sum(sm), sum(n), sum(f), sum(d), sum(m),
sum({da}), sum({ti}), sum({ts}),
sum(se), sum(mu), sum(li)
from foo
where i < 0 and i > 10
;

select
avg(i), avg(sm), avg(n), avg(f), avg(d), avg(m)
from foo
where i < 0 and i > 10
;

select
variance(i), variance(sm), variance(n), variance(f), variance(d), variance(m)
from foo
where i < 0 and i > 10
;

select
stddev(i), stddev(sm), stddev(n), stddev(f), stddev(d), stddev(m)
from foo
where i < 0 and i > 10

drop foo;
set  system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;
