--CBRD-22701
SELECT c1 FROM JSON_TABLE('{"a": 1111}',  '$'
    columns(
          c1 CHAR(10) PATH '$.x' DEFAULT '{}' ON EMPTY
     )
  ) as t;

SELECT c1 FROM JSON_TABLE('{"a": 1111}',  '$'
    columns(
          c1 CHAR(10) PATH '$.x' DEFAULT '{' ON EMPTY
     )
  ) as t;

SELECT c1 FROM JSON_TABLE('{"a": 1111}',  '$'
    columns(
          c1 CHAR(10) PATH '$.x' DEFAULT '}' ON EMPTY
     )
  ) as t;

SELECT c1 FROM JSON_TABLE('{"a": 1111}',  '$'
    columns(
          c1 CHAR(10) PATH '$.x' DEFAULT '[]' ON EMPTY
     )
  ) as t;

SELECT c1 FROM JSON_TABLE('{"a": 1111}',  '$'
    columns(
          c1 CHAR(10) PATH '$.x' DEFAULT '[' ON EMPTY
     )
  ) as t;

SELECT c1 FROM JSON_TABLE('{"a": 1111}',  '$'
    columns(
          c1 CHAR(10) PATH '$.x' DEFAULT ']' ON EMPTY
     )
  ) as t;

SELECT c1 FROM JSON_TABLE('{"a": 1111}',  '$'
    columns(
          c1 char(10) PATH '$.x' DEFAULT '' ON EMPTY
     )
  ) as t;

SELECT c1 FROM JSON_TABLE('{"a": 1111}',  '$'
    columns(
          c1 json PATH '$.x' DEFAULT '{}' ON EMPTY
     )
  ) as t;

SELECT c1 FROM JSON_TABLE('{"a": 1111}',  '$'
    columns(
          c1 json PATH '$.x' DEFAULT '{' ON EMPTY
     )
  ) as t;

SELECT c1 FROM JSON_TABLE('{"a": 1111}',  '$'
    columns(
          c1 json PATH '$.x' DEFAULT '}' ON EMPTY
     )
  ) as t;

SELECT c1 FROM JSON_TABLE('{"a": 1111}',  '$'
    columns(
          c1 json PATH '$.x' DEFAULT '[]' ON EMPTY
     )
  ) as t;

SELECT c1 FROM JSON_TABLE('{"a": 1111}',  '$'
    columns(
          c1 json PATH '$.x' DEFAULT '[' ON EMPTY
     )
  ) as t;

SELECT c1 FROM JSON_TABLE('{"a": 1111}',  '$'
    columns(
          c1 json PATH '$.x' DEFAULT ']' ON EMPTY
     )
  ) as t;

SELECT c1 FROM JSON_TABLE('{"a": 1111}',  '$'
    columns(
          c1 json PATH '$.x' DEFAULT '' ON EMPTY
     )
  ) as t;

SELECT c1 FROM JSON_TABLE('{"a": 1111}',  '$'
    columns(
          c1 date PATH '$.x' DEFAULT current_date ON EMPTY
     )
  ) as t;

--CBRD-22700
SELECT length(a), a FROM JSON_TABLE('{"a": 1111}',  '$'
    columns(
        a CHAR(10) PATH '$.x' DEFAULT 1 ON EMPTY
     )
) as t;

SELECT length(a), a FROM JSON_TABLE('{"a": 1111}',  '$'
    columns(
        a CHAR(10) PATH '$.x' DEFAULT true ON EMPTY
     )
) as t;

SELECT length(a), a FROM JSON_TABLE('{"a": 1111}',  '$'
    columns(
        a CHAR(10) PATH '$.x' DEFAULT False ON EMPTY
     )
) as t;

SELECT length(a), a FROM JSON_TABLE('{"a": 1111}',  '$'
    columns(
        a CHAR(10) PATH '$.x' DEFAULT False ON EMPTY
     )
) as t;

SELECT length(a), a FROM JSON_TABLE('{"a": 1111}',  '$'
    columns(
       a json PATH '$.a' DEFAULT 1 ON ERROR
     )
) as t;




