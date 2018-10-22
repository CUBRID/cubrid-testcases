-- Examples from https://dev.mysql.com/doc/refman/8.0/en/json-table-functions.html#function_json-table

--CBRD-22415, by design
SELECT *
FROM
  JSON_TABLE(
    '[{"a":"3"},{"a":2},{"b":1},{"a":0},{"a":[1,2]}]',
    '$[*]'
    COLUMNS(
      rowid FOR ORDINALITY,
      ac VARCHAR(100) PATH '$.a' DEFAULT '999' ON ERROR DEFAULT '111' ON EMPTY,
      aj JSON PATH '$.a' DEFAULT '{"x": 333}' ON EMPTY,
      bx INT EXISTS PATH '$.b'
    )
  ) AS tt order by 1;

--CBRD-22415 extend test
drop table if exists t1;
set @sj='[{"a":"3"},{"a":2},{"b":1},{"a":0},{"a":[1,2]}]';
create table t1 (id int, ac VARCHAR(100), aj JSON);
insert into t1 values (1, json_extract( json_extract(@sj, '$[0]'), '$.a'), json_extract( json_extract(@sj, '$[0]'), '$.a'));
insert into t1 values (2, json_extract( json_extract(@sj, '$[1]'), '$.a'), json_extract( json_extract(@sj, '$[1]'), '$.a'));
insert into t1 values (3, json_extract( json_extract(@sj, '$[2]'), '$.a'), json_extract( json_extract(@sj, '$[2]'), '$.a'));
insert into t1 values (4, json_extract( json_extract(@sj, '$[3]'), '$.a'), json_extract( json_extract(@sj, '$[3]'), '$.a'));
insert into t1 values (5, json_extract( json_extract(@sj, '$[4]'), '$.a'), json_extract( json_extract(@sj, '$[4]'), '$.a'));
select * from t1 order by 1;
drop variable @sj;
drop table if exists t1;

  
SELECT *
FROM
  JSON_TABLE(
    '[{"x":2,"y":"8"},{"x":"3","y":"7"},{"x":"4","y":6}]',
    '$[*]' COLUMNS(
      xval VARCHAR(100) PATH '$.x',
      yval VARCHAR(100) PATH '$.y'
    )
  ) AS  jt1 order by 1;
  
SELECT *
FROM
  JSON_TABLE(
    '[{"x":2,"y":"8"},{"x":"3","y":"7"},{"x":"4","y":6}]',
    '$[1]' COLUMNS(
      xval VARCHAR(100) PATH '$.x',
      yval VARCHAR(100) PATH '$.y'
    )
  ) AS  jt1 order by 1;
  
SELECT *
FROM
  JSON_TABLE(
    '[ {"a": 1, "b": [11,111]}, {"a": 2, "b": [22,222]}, {"a":3}]',
    '$[*]' COLUMNS(
            a INT PATH '$.a',
            NESTED PATH '$.b[*]' COLUMNS (b INT PATH '$')
           )
   ) AS jt
WHERE b IS NOT NULL order by 1;

SELECT *
FROM
  JSON_TABLE(
    '[{"a": 1, "b": [11,111]}, {"a": 2, "b": [22,222]}]',
    '$[*]' COLUMNS(
        a INT PATH '$.a',
        NESTED PATH '$.b[*]' COLUMNS (b1 INT PATH '$'),
        NESTED PATH '$.b[*]' COLUMNS (b2 INT PATH '$')
    )
) AS jt order by 1;

SELECT *
FROM
  JSON_TABLE(
    '[{"a": "a_val",
      "b": [{"c": "c_val", "l": [1,2]}]},
    {"a": "a_val",
      "b": [{"c": "c_val","l": [11]}, {"c": "c_val", "l": [22]}]}]',
    '$[*]' COLUMNS(
      top_ord FOR ORDINALITY,
      apath VARCHAR(10) PATH '$.a',
      NESTED PATH '$.b[*]' COLUMNS (
        bpath VARCHAR(10) PATH '$.c',
        ord FOR ORDINALITY,
        NESTED PATH '$.l[*]' COLUMNS (lpath varchar(10) PATH '$')
        )
    )
) as jt order by 1;

	
