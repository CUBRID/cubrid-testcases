
--CBRD-22500 JSON_LENGTH is undefined or given wrong number of parameter.
SET @jv = '{  
    "Person": {    
       "Name": "Homer", 
       "Age": 39,
       "Hobbies": ["Eating", "Sleeping"]  
    }
 }';
 
SELECT JSON_LENGTH(@jv) ;
SELECT JSON_LENGTH(@jv, '$') ;
SELECT JSON_LENGTH(@jv, '') ;
SELECT JSON_LENGTH(json_extract(@jv, '$.Person')) ;
SELECT JSON_LENGTH(@jv, '$.Person') ;

drop variable @jv;

select json_length(json_extract( '[ 1, [ 2, 3, 4 ], 5 ]', '/1' ));
select json_length( '[ 1, [ 2, 3, 4 ], 5 ]', '/1' );
select json_length( '[ 1, [ 2, 3, 4 ], 5 ]', '$[1]' );

select json_length(json_extract( '[ 1, [ 2, 3, 4 ], 5 ]', '/1/0' )); 
select json_length( '[ 1, [ 2, 3, 4 ], 5 ]', '/1/0' ); 
select json_length( '[ 1, [ 2, 3, 4 ], 5 ]', '$[1][0]' ); 

select json_length(json_extract( '[ 1, [ 2, 3, 4 ], 5 ]', '/2/0/0/' ));
select json_length( '[ 1, [ 2, 3, 4 ], 5 ]', '/2/0/0/' );
select json_length( '[ 1, [ 2, 3, 4 ], 5 ]', '$[2][0][0]' );

select json_length(json_extract( '[ 1, [ 2, 3, 4 ], {"a":5, "b":6} ]', '/1' )); 
select json_length( '[ 1, [ 2, 3, 4 ], {"a":5, "b":6} ]', '/1' ); 
select json_length( '[ 1, [ 2, 3, 4 ], {"a":5, "b":6} ]', '$[1]' ); 

select json_length(json_extract( '[ 1, [ 2, 3, 4 ], {"a":5, "b":6} ]', '/1/0' )); 
select json_length( '[ 1, [ 2, 3, 4 ], {"a":5, "b":6} ]', '/1/0' ); 
select json_length( '[ 1, [ 2, 3, 4 ], {"a":5, "b":6} ]', '$[1][0]' ); 

select json_length(json_extract( '[ 1, [ 2, 3, 4 ], {"a":5, "b":6} ]', '/2' ));
select json_length( '[ 1, [ 2, 3, 4 ], {"a":5, "b":6} ]', '/2' );
select json_length( '[ 1, [ 2, 3, 4 ], {"a":5, "b":6} ]', '$[2]' );

select json_length(json_extract( '[ 1, [ 2, 3, 4 ], {"a":5, "b":6} ]', '/2/a' ));
select json_length( '[ 1, [ 2, 3, 4 ], {"a":5, "b":6} ]', '/2/a' );
select json_length( '[ 1, [ 2, 3, 4 ], {"a":5, "b":6} ]', '$[2].a' );

-- CBRD-22579 by design
select json_length(json_extract( '[ 1, [ 2, 3, 4 ], {"a":5, "b":6} ]', '/2/a/0/0' ));
select json_length( '[ 1, [ 2, 3, 4 ], {"a":5, "b":6} ]', '/2/a/0/0' );
select json_length( '[ 1, [ 2, 3, 4 ], {"a":5, "b":6} ]', '$[2].a[0][0]' );

select json_length(json_extract( '{"a":{"b":{"d":1}}, "a":{"c":{"d":1, "j":2}}}', '/a/0/0/0/c' ));
select json_length( '{"a":{"b":{"d":1}}, "a":{"c":{"d":1, "j":2}}}', '/a/0/0/0/c' );
select json_length( '{"a":{"b":{"d":1}}, "a":{"c":{"d":1, "j":2}}}', '$.a[0][0][0].c' );

select json_length(json_extract('{"a": 1, "b": {"c": 30}}', '/b'));
select json_length('{"a": 1, "b": {"c": 30}}', '/b');
select json_length('{"a": 1, "b": {"c": 30}}', '$.b');

select json_length('{"a": 1, "b": {"c": 30}}', );
select json_length('{"a": 1, "b": {"c": 30}}', '-' );
select json_length('{"a": 1, "b": {"c": 30}}', '$.*' );
select json_length('["a", 1, "b", {"c": 30}]', '$[*]' );
select json_length('{"a": 1, "b": {"c": 30}}', NULL );
select json_length('{"a": NULL, "b": {"c": 30}}', '$.a' );
select json_length('{"a": null, "b": {"c": 30}}', '$.a' );

select json_length(null, '$.a' );
select json_length(NULL, '$.a' );
select json_length(@j, '$' );


