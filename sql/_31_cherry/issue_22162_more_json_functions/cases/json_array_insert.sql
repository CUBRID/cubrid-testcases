
--CBRD-22469
SELECT JSON_ARRAY_INSERT('[1, 2, 3]', '$[1]', '4');
SELECT JSON_ARRAY_INSERT('[1, 2, 3]', '$[1]', 4);
SELECT JSON_ARRAY_APPEND('[1, 2, 3]', '$'   , 4) ;
SELECT JSON_ARRAY_APPEND('[1, 2, 3]', '$[2]', 4) ;

SELECT JSON_ARRAY_INSERT('[1, 2, [3, 4]]', '$[2][1]', '5');
SELECT JSON_ARRAY_INSERT('[1, 2, [3, 4]]', '$[2][1]', 5);
SELECT JSON_ARRAY_APPEND('[1, 2, [3, 4]]', '$[2]'   , 5) ;
SELECT JSON_ARRAY_INSERT('{  
    "Person": {    
       "Name": "Homer", 
       "Hobbies": ["Eating", "Sleeping"]  
    }
}', '$.Person.Hobbies[1]', 'Base Jumping') ;

SELECT JSON_ARRAY_INSERT('{  
    "Person": {    
       "Name": "Homer", 
       "Hobbies": ["Eating", "Sleeping"]  
    }
}', '$.Person.Hobbies[1]', '"Base Jumping"') ;


SET @jv = '{  
    "Person": {    
       "Name": "Homer", 
       "Hobbies": ["Eating", "Sleeping"]  
    }
}';

--CBRD-22469
SELECT JSON_ARRAY_INSERT(@jv, '$.Person.Hobbies[1]', 'Base Jumping') ;
SELECT JSON_ARRAY_INSERT(@jv, '$.Person.Hobbies[1]', "Base Jumping") ;
SELECT JSON_ARRAY_INSERT(@jv, '$.Person.Hobbies[1]', '"Base Jumping"') ;
SELECT JSON_ARRAY_INSERT(@jv, '$.Person.Hobbies[1]', '""Base Jumping""') ;
SELECT JSON_ARRAY_APPEND(@jv, '$.Person.Hobbies', 'Base Jumping') ;
SELECT JSON_ARRAY_APPEND(@jv, '$.Person.Hobbies[0]', 'Drinking') ;
SELECT JSON_INSERT(@jv, '$.Person.Hobbies[2]', 'Base Jumping') ;


SELECT JSON_INSERT('{"a": 1, "b": 2}', '$.c', 3) ;
SELECT JSON_INSERT('{"Name": "Homer", "Gender": "Male"}', '$.Age', 39) ;
SELECT JSON_INSERT('{"Name": "Homer", "Gender": "Male"}', '$.Name', 'Bart') ;
SELECT JSON_INSERT('[1, 2, 3]', '$[3]', 4) ;
SELECT JSON_INSERT('[1, 2, 3]', '$[1]', 4) ;
--Different behavior with MySQL, See CBRD-21887 for reference.
SELECT JSON_INSERT('{"a": 1, "b": 2}', '$[2]', 3) ;
SELECT JSON_INSERT('{"a": 1, "b": 2}', '$[0]', 3) ;


drop variable @jv;

select json_array_insert('[true]', '$[0]', 10);
select json_array_insert('[true]', '$[0]', '10');
select json_array_insert('[true]', '$[0]', '"a"');
select json_array_insert('[true]', '$[0]', '{"a":"b"}');
select json_array_insert('[true]', '$[0]', cast('{"a":"b"}' as json));
select json_array_insert('[true]', '$[0]',  json_object('a', 'b'));
select json_extract(json_array_insert('[true]', '$[0]',  json_object('a', 'b')), '$[0]');      
select json_object('a', 'b');
select json_extract(json_array_insert('[true]', '$[0]', '{"a":"b"}'), '$[0]');


