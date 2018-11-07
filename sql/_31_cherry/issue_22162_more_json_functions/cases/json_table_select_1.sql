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
    ) ;

select jt.* from json_table( cast( '"a"' as json), '$' 
    columns(
        col1 char(1) path '$',
        col2 int path '$'
    )
) as jt;  

select jt.* from json_table( cast( '1' as json), '$' 
    columns(
        col1 char(1) path '$',
        col2 int path '$'
    )
) as jt;  

select jt.* from json_table( cast( 11 as json), '$' 
    columns(
        col1 char(1) path '$',
        col2 int path '$'
    )
) as jt;  

--CBRD-22442
select jt.* from json_table( cast( 11 as json), '$'
    columns(
        col1 char(2) path '$',
        col2 int path '$'
    )
) as jt;

select jt.* from json_table( cast( 'AAAAA' as json), '$' 
    columns(
        col1 char(1) path '$',
        col2 int path '$'
    )
) as jt;  

select jt.* from json_table( cast( 'AAAAA' as json), '$'
    columns(
        col1 char(10) path '$',
        col2 int path '$'
    )
) as jt;

select jt.* from json_table( cast( '"AAAAA"' as json), '$'
columns( col1 char(1) path '$')) as jt;

select jt.* from json_table( cast( '"AAAAA"' as json), '$'
    columns(
        col1 char(1) path '$',
        col2 int path '$'
    )
) as jt;

--CBRD-22442
select jt.* from json_table( cast( '"AAAAA"' as json), '$'
    columns(
        col1 char(10) path '$',
        col2 int path '$'
    )
) as jt;

--CBRD-22442
select jt.* from json_table( cast( '"AAAAA"' as json), '$'
    columns(
        col1 char(1) path '$',
        col2 int path '$'
    )
) as jt;

select jt.* from json_table( '{"A":1}' , '$' 
    columns(
        col1 char(1) path '$',
        col2 int path '$'
    )
) as jt;  

select jt.* from json_table( 1 , '$' 
    columns(
        col1 char(1) path '$',
        col2 int path '$'
    )
) as jt;  

select jt.* from json_table( cast(json_pretty('{"a":1}') as json) , '$' 
    columns(
        col1 char(1) path '$',  
        col2 int path '$', 
        col3 json path '$'
    )
) as jt;

select jt.* from json_table( '{"a":1}' , '$'
    columns(
        col1 char(1) path '$',
        col2 int path '$',
        col3 json path '$'
    )
) as jt;

select jt.* from json_table( '{"a":1}' , '$'
    columns(
        col1 char(1) path '$',
        col2 int path '$.a',
        col3 json path '$'
    )
) as jt;

select jt.*, json_pretty(col3) from json_table( '{"a":1}' , '$'
    columns(
        col1 char(1) path '$',
        col2 int path '$',
        col3 json path '$'
    )
) as jt;

--CBRD-22442
select jt.*, json_pretty(col3) from json_table( '{"a":1}' , '$' 
    columns(
        col1 char(10) path '$',
        col2 int path '$',
        col3 json path '$'
    )
) as jt;

select jt.* from json_table( '' , '$'
    columns(
        col4 int  path '$'  
    )
) as jt;


