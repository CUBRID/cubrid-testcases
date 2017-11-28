drop table if exists t;
create table t ( a json);
insert into t values ('   {
      "foo": ["bar", "baz"],
      "": 0,
      "a/b": 1,
      "c%d": 2,
      "e^f": 3,
      "g|h": 4,
      "i\\j": 5,
      "k\"l": 6,
      " ": 7,
      "m~n": 8
   }');

select * from t;

select json_extract(a, '') from t;
select json_extract(a, '/foo') from t;
select json_extract(a, '/foo/0') from t;
select json_extract(a, '/') from t;
select json_extract(a, '/a~1b') from t;
select json_extract(a, '/c%d') from t;
select json_extract(a, '/e^f') from t;
select json_extract(a, '/g|h') from t;
select json_extract(a, '/i\j') from t;
select json_extract(a, '/k"l') from t;
select json_extract(a, '/ ') from t;
select json_extract(a, '/m~0n') from t;

drop table if exists t;
