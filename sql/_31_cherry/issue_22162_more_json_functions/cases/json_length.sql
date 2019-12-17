--+ holdcas on;

--CBRD-22500 JSON_LENGTH support the path argument.
SET @jv = '{  
    "Person": {    
       "Name": "Homer", 
       "Age": 39,
       "Hobbies": ["Eating", "Sleeping"]  
    }
 }';
 
SELECT JSON_LENGTH(@jv) ;
SELECT JSON_LENGTH(@jv, '$') ;
-- String '' is a valid JSON pointer, equivalent to '$' JSON SQL PATH.
SELECT JSON_LENGTH(@jv, '') ;
SELECT JSON_LENGTH(json_extract(@jv, '$.Person')) ;
SELECT JSON_LENGTH(@jv, '$.Person') ;
SELECT JSON_LENGTH(@jv, '$.Person.Name');
SELECT JSON_LENGTH(@jv, '$.Person.Hobbies');
SELECT JSON_LENGTH(@jv, '/Person');
SELECT JSON_LENGTH(@jv, '/Person/Name');
SELECT JSON_LENGTH(@jv, '/Person/Hobbies/0');

SET @jv = '';
SELECT JSON_LENGTH(@jv);
SELECT JSON_LENGTH(@jv, '$.Person');
SELECT JSON_LENGTH(@jv, '$.Person.Name');
SELECT JSON_LENGTH(@jv, '$.Person.Hobbies');

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

SELECT JSON_LENGTH('{"a": 1, "b": {"c": 30}}', '$');
SELECT JSON_LENGTH('{"a": 1, "b": {"c": 30}}', '/');
SELECT JSON_LENGTH('{"a": 1, "b": {"c": 30}}', '$', '$');
SELECT JSON_LENGTH('{"a": 1, "b": {"c": 30}}', '');
select json_length('{"a": NULL, "b": {"c": 30}}', '$.a' );
select json_length('{"a": null, "b": {"c": 30}}', '$.a' );

select json_length(null, '$.a' );
select json_length(NULL, '$.a' );
select json_length(@j, '$' );
SELECT JSON_LENGTH( NULL, NULL );
SELECT JSON_LENGTH('[]');
SELECT JSON_LENGTH('', '');
SELECT JSON_LENGTH('', '$');
SELECT JSON_LENGTH('{"Name": "Homer"}');
SELECT JSON_LENGTH('{"Name": "Homer", "Stupid": true}');
SELECT JSON_LENGTH('[1, 2, 3]');
SELECT JSON_LENGTH('[1, 2, [3, 4]]');


--+ holdcas off;
