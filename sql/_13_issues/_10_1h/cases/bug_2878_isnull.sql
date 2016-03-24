select isnull (null), isnull (0), isnull (1);

prepare s from 'select isnull(?), isnull (?), isnull (?)'
execute s using null, 0, 1
deallocate prepare s;

select a, isnull (a) from (select null union all select 0 union all select 1) tbisnull(a) order by 1;
select a, isnull (a + 1) from (select null union all select 0 union all select 1) tbisnull(a) order by 1;

--select a from (select null union all select 0 union all select 1) tbisnull(a) where isnull (a) <> 1 order by 1;
