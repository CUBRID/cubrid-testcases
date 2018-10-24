-- CBRD-22444
select jt.* from json_table( '[{"A":1},{"B":2}]' , '$[*]' 
    columns(
        col1 json path '$',
        col2 int path '$.A' DEFAULT '999' ON ERROR DEFAULT '111' ON EMPTY,
        col3 int path '$.b' DEFAULT '999' ON ERROR DEFAULT '111' ON EMPTY,
        col4 int path '$.B' DEFAULT '999' ON ERROR DEFAULT '111' ON EMPTY
    )
) as jt;  

select jt.* from json_table( '[{"A":1},{"B":2}]' , '$[*]' 
    columns(
        col1 json path '$',
        col2 int path '$.A' DEFAULT '999' ON ERROR DEFAULT '111' ON EMPTY,
        col3 int path '$.b' DEFAULT '999' ON ERROR DEFAULT '111' ON EMPTY,
        col4 int path '$.B' DEFAULT '999' ON ERROR DEFAULT '111' ON EMPTY
    )
) as jt order by 1 desc;  

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
  ) AS tt order by 1 desc;
  
  
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
    '$[*]' COLUMNS(
      xval VARCHAR(100) PATH '$.x',
      yval VARCHAR(100) PATH '$.y'
    )
  ) AS  jt1 order by 1 desc;

SELECT *
FROM
  JSON_TABLE(
    '[ {"a": 1, "b": [11,111]}, {"a": 2, "b": [22,222]}, {"a":3}]',
    '$[*]' COLUMNS(
            a INT PATH '$.a',
            NESTED PATH '$.b[*]' COLUMNS (b INT PATH '$')
           )
   ) AS jt
WHERE b IS NOT NULL order by 1,b;
  
SELECT *
FROM
  JSON_TABLE(
    '[ {"a": 1, "b": [11,111]}, {"a": 2, "b": [22,222]}, {"a":3}]',
    '$[*]' COLUMNS(
            a INT PATH '$.a',
            NESTED PATH '$.b[*]' COLUMNS (b INT PATH '$')
           )
   ) AS jt
WHERE b IS NOT NULL order by 1 desc, b;

SELECT *
FROM
  JSON_TABLE(
    '[{"a": 1, "b": [11,111]}, {"a": 2, "b": [22,222]}]',
    '$[*]' COLUMNS(
        a INT PATH '$.a',
        NESTED PATH '$.b[*]' COLUMNS (b1 INT PATH '$'),
        NESTED PATH '$.b[*]' COLUMNS (b2 INT PATH '$')
    )
) AS jt order by 1, 2, 3;

SELECT *
FROM
  JSON_TABLE(
    '[{"a": 1, "b": [11,111]}, {"a": 2, "b": [22,222]}]',
    '$[*]' COLUMNS(
        a INT PATH '$.a',
        NESTED PATH '$.b[*]' COLUMNS (b1 INT PATH '$'),
        NESTED PATH '$.b[*]' COLUMNS (b2 INT PATH '$')
    )
) AS jt order by 1 desc, 2, 3 desc;

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
) as jt order by 1, 2, 3, 4;

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
) as jt order by 1 desc , 2,3, 4, 5 desc;
