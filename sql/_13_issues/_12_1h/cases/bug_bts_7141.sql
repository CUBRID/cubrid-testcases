select a, b from (select 1 a, 2 b union all select 2 a, 2 b) t where t.a <> t.b;
