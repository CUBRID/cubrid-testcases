autocommit off;
create class a(y set(varchar(20)));
create class b(x a);
insert into b values( insert into a values({'aa', 'bb'}));
insert into b values( insert into a values({'aa', 'dd', NULL}));
insert into b values( insert into a values({'aa', NULL, 'ff'}));
select x.y from b where 'aa' in x.y;
select x.y from b where x.y superset {'aa'};
rollback;
