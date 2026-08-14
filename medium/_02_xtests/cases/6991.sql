autocommit off;
create class a(y set(varchar(20)));
create class b(x a);
insert into b values( insert into a values({'aa', 'bb'}));
insert into b values( insert into a values({'aa', 'dd', NULL}));
insert into b values( insert into a values({'aa', NULL, 'ff'}));
select x.y from b where 'aa' in x.y
order by case when 'bb' in x.y then 1 when 'dd' in x.y then 2 else 3 end;
select x.y from b where x.y superset {'aa'}
order by case when 'bb' in x.y then 1 when 'dd' in x.y then 2 else 3 end;
rollback;
