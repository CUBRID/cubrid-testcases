--+ holdcas on;

SET @jv = '{"a": 1, "b": 2, "c": 3}';
SELECT JSON_PRETTY(@jv) ;
SELECT JSON_PRETTY('{"a": 1, "b": 2, "c": 3}') ;

SET @jv = '[1, 2, 3]';
SELECT JSON_PRETTY(@jv) ;
SELECT JSON_PRETTY('[1, 2, 3]') ;

SET @jv = '[1, 2, [3, 4, 5]]';
SELECT JSON_PRETTY(@jv) ;
SELECT JSON_PRETTY('[1, 2, [3, 4, 5]]') ;

SET @jv = '[1, 2, [], {}]';
SELECT JSON_PRETTY(@jv) ;
SELECT JSON_PRETTY('[1, 2, [], {}]') ;

SET @jv = '[    1    ,  
 
2  ,   

3]';
SELECT JSON_PRETTY(@jv) ;
SELECT JSON_PRETTY('[    1    ,  
 
2  ,   

3]') as a ;

SET @jv = '{"Person": {"Name": "Bart", "Age": 10, "Friends": ["Bart", "Milhouse"]}}';
SELECT JSON_PRETTY(@jv) ;

SET @jv = '123';
SELECT JSON_PRETTY(@jv) ;
SELECT JSON_PRETTY('123');

SET @jv = '[1,3,5]';
SELECT JSON_PRETTY(@jv) ;
SELECT JSON_PRETTY('[1,3,5]');

SET @jv = '{"a":"10","x":"25","b":"15"}';
SELECT JSON_PRETTY(@jv) ;
SELECT JSON_PRETTY('{"a":"10","x":"25","b":"15"}');

SET @jv = '["a",1,{"key1":
   "value1"},"5",     "77" ,
      {"key2":["value3","valueX",
	  "valueY"]},"j", "2"   ]';
SELECT JSON_PRETTY(@jv) ;
SELECT JSON_PRETTY('["a",1,{"key1":
   "value1"},"5",     "77" ,
      {"key2":["value3","valueX",
	  "valueY"]},"j", "2"   ]') as a;
	  
drop variable @jv;

--+ holdcas off;
