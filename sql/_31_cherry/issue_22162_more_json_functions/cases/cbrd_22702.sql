drop view if exists v1;

--good
SELECT a FROM JSON_TABLE('{"a": [1,2,3]}', '$' COLUMNS (
     NESTED PATH '$.a[*]' COLUMNS (a INT PATH '$')
  )
) as t;

create view v1 as 
  SELECT a FROM JSON_TABLE('{"a": [1,2,3]}', '$' COLUMNS (
       NESTED PATH '$.a[*]' COLUMNS (a INT PATH '$')
    )
  ) as t;

--test: expect to be good. actually failed.
select * from v1;

show create view v1;

drop view if exists v1;
