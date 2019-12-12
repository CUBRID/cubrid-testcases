--+ holdcas on;
-- http://jira.cubrid.org/browse/CBRD-22623

-------------------------------- JSON_INSERT      (json_doc, path, val[, path, val] ...) -------------------------------- 
set @jobj      = '{"a":{"b":["1"], "c":["2", "3"]}}';
set @jarr     = '["d":"4"]';
set @jarr1     = '["e","f"]';
-- ends with name, parent does not exist : error
select @jobj, json_insert(@jobj, '$.aa.c', '999');
-- ends with name, parent is object, Name does exist : no op 
select @jobj, json_insert(@jobj, '$.a.c', '999');
-- ends with name, parent is object, Name does NOT exist : insert value
select @jobj, json_insert(@jobj, '$.a.club', '999');
-- ends with name, parent is array : error
select @jarr, json_insert(@jarr, '$.d', '999');
-- ends with name, parent is scalar : error
select @jarr1, json_insert(@jarr1, '$[1].e', '999');

set @jobj      = '{"a":{"b":["1"], "c":["2", "3"]}}';
set @jobj1     = '{"d":"4"}';
set @jarr1     = '["e","f"]';
set @scalar  = '1';
-- ends with index, parent does not exist : error
select @jobj, json_insert(@jobj, '$.a.d[0]', '999');
-- ends with index, parent is object, Name does exist, index==0 : no op 
select @jobj1, json_insert(@jobj1, '$.d[0]', '999');
-- ends with index, parent is object, Name does exist, index>0 : insert nulls followed by val on index
select @jobj1, json_insert(@jobj1, '$.d[4]', '999');
-- ends with index, parent is array, index<=last: NO_OP
select @jarr1, json_insert(@jarr1, '$[1]', '999');
-- ends with index, parent is array, index>last: insert nulls followed by val on index
select @jarr1, json_insert(@jarr1, '$[3]', '999');
-- ends with index, parent is scalar ,index==0 : NO_OP
select @scalar, json_insert(@scalar, '$[0]', '999');
-- ends with index, parent is scalar ,index>0 : insert nulls followed by val on index
select @scalar, json_insert(@scalar, '$[2]', '999');


-------------------------------- JSON_SET(json_doc, path, val[, path, val] ...) -------------------------------- 
set @jobj      = '{"a":{"b":["1"], "c":["2", "3"]}}';
set @jarr     = '["d":"4"]';
set @jarr1     = '["e","f"]';
-- ends with name, parent does not exist : error
select @jobj, json_set(@jobj, '$.aa.c', '999');
-- ends with name, parent is object, Name does exist : replace value
select @jobj, json_set(@jobj, '$.a.c', '999');
-- ends with name, parent is object, Name does NOT exist : insert value
select @jobj, json_set(@jobj, '$.a.club', '999');
-- ends with name, parent is array : error
select @jarr, json_set(@jarr, '$.d', '999');
-- ends with name, parent is scalar : error
select @jarr1, json_set(@jarr1, '$[1].e', '999');

set @jobj      = '{"a":{"b":["1"], "c":["2", "3"]}}';
set @jobj1     = '{"d":"4"}';
set @jarr1     = '["e","f"]';
set @scalar  = '1';
-- ends with index, parent does not exist : error
select @jobj, json_set(@jobj, '$.a.d[0]', '999');
-- ends with index, parent is object, Name does exist, index==0 : Replace parent object with value 
select @jobj1, json_set(@jobj1, '$.d[0]', '999');
-- ends with index, parent is object, Name does exist, index>0 : wrap in an array insert nulls followed by val on index
select @jobj1, json_set(@jobj1, '$.d[4]', '999');
-- ends with index, parent is array, index<=last: replace the pointed val
select @jarr1, json_set(@jarr1, '$[1]', '999');
-- ends with index, parent is array, index>last:  insert nulls followed by val on index
select @jarr1, json_set(@jarr1, '$[3]', '999');
-- ends with index, parent is scalar ,index==0 : Replace parent object with value
select @scalar, json_set(@scalar, '$[0]', '999');
-- ends with index, parent is scalar ,index>0 : wrap in an array and insert nulls followed by val on index
select @scalar, json_set(@scalar, '$[2]', '999');



-------------------------------- JSON_REPLACE(json_doc, path, val[, path, val] ...) -------------------------------- 
set @jobj      = '{"a":{"b":["1"], "c":["2", "3"]}}';
set @jarr     = '["d":"4"]';
set @jarr1     = '["e","f"]';
-- ends with name, parent does not exist : error
select @jobj, JSON_REPLACE(@jobj, '$.aa.c', '999');
-- ends with name, parent is object, Name does exist : replace value
select @jobj, JSON_REPLACE(@jobj, '$.a.c', '999');
-- ends with name, parent is object, Name does NOT exist : NO_OP
select @jobj, JSON_REPLACE(@jobj, '$.a.club', '999');  
select JSON_REPLACE('{"a":{"b":1}}', '$.a.c', '999');
-- ends with name, parent is array : error
select @jarr, JSON_REPLACE(@jarr, '$.d', '999');
-- ends with name, parent is scalar : error
select @jarr1, JSON_REPLACE(@jarr1, '$[1].e', '999');

set @jobj      = '{"a":{"b":["1"], "c":["2", "3"]}}';
set @jobj1     = '{"d":"4"}';
set @jarr1     = '["e","f"]';
set @scalar  = '1';
-- ends with index, parent does not exist : error
select @jobj, JSON_REPLACE(@jobj, '$.a.d[0]', '999');
-- ends with index, parent is object, Name does exist, index==0 : Replace parent object with value 
select @jobj1, JSON_REPLACE(@jobj1, '$.d[0]', '999');
-- ends with index, parent is object, Name does exist, index>0 : NO_OP
select @jobj1, JSON_REPLACE(@jobj1, '$.d[3]', '999'); 
-- ends with index, parent is array, index<=last: replace the pointed val
select @jarr1, JSON_REPLACE(@jarr1, '$[1]', '999');
-- ends with index, parent is array, index>last:  NO_OP
select @jarr1, JSON_REPLACE(@jarr1, '$[3]', '999'); 
-- ends with index, parent is scalar ,index==0 : Replace parent object with value
select @scalar, JSON_REPLACE(@scalar, '$[0]', '999');
-- ends with index, parent is scalar ,index>0 : NO_OP
select @scalar, JSON_REPLACE(@scalar, '$[2]', '999');  



-------------------------------- JSON_ARRAY_INSERT(json_doc, path, val[, path, val] ...) -------------------------------- 
set @jobj      = '{"a":{"b":["1"], "c":["2", "3"]}}';
set @jarr     = '["d":"4"]';
set @jarr1     = '["e","f"]';
-- ends with name, parent does not exist : error
select @jobj, JSON_ARRAY_INSERT(@jobj, '$.aa.c', '999');
-- ends with name, parent is object, Name does exist : error
select @jobj, JSON_ARRAY_INSERT(@jobj, '$.a.c', '999');
-- ends with name, parent is object, Name does NOT exist : error
select @jobj, JSON_ARRAY_INSERT(@jobj, '$.a.club', '999');  
-- ends with name, parent is array : error
select @jarr, JSON_ARRAY_INSERT(@jarr, '$.d', '999');
-- ends with name, parent is scalar : error
select @jarr1, JSON_ARRAY_INSERT(@jarr1, '$[1].e', '999');

set @jobj      = '{"a":{"b":["1"], "c":["2", "3"]}}';
set @jobj1     = '{"d":"4"}';
set @jarr1     = '["e","f"]';
set @scalar  = '1';
-- ends with index, parent does not exist : error
select @jobj, JSON_ARRAY_INSERT(@jobj, '$.a.d[0]', '999');
-- ends with index, parent is object, Name does exist, index==0 : wrap in array, insert value at 0 and object at index 1
select @jobj1, JSON_ARRAY_INSERT(@jobj1, '$.d[0]', '999');
select @jobj1, JSON_ARRAY_INSERT(@jobj1, '$.d[0]', '{"g":9}');  
-- ends with index, parent is object, Name does exist, index>0 : insert nulls followed by val on index
select @jobj1, JSON_ARRAY_INSERT(@jobj1, '$.d[3]', '999');  
-- ends with index, parent is array, index<=last:  insert val at index, shift following values
select @jarr1, JSON_ARRAY_INSERT(@jarr1, '$[1]', '999');
-- ends with index, parent is array, index>last:  insert nulls followed by val on index
select @jarr1, JSON_ARRAY_INSERT(@jarr1, '$[3]', '999'); 
-- ends with index, parent is scalar ,index==0 : wrap in array, insert value at 0 and scalar at index 1 
select @scalar, JSON_ARRAY_INSERT(@scalar, '$[0]', '999');
select @scalar, JSON_ARRAY_INSERT(@scalar, '$[0]', 888);
-- ends with index, parent is scalar ,index>0 :  insert nulls followed by val on index
select @scalar, JSON_ARRAY_INSERT(@scalar, '$[2]', '999');  



-------------------------------- JSON_ARRAY_APPEND(json_doc, path, val[, path, val] ...) ----------------------------------
set @jobj      = '{"a":{"b":["1"], "c":["2", "3"]}}';
set @jarr     = '["d":"4"]';
set @jarr1     = '["e","f"]';
-- ends with name, parent does not exist : error
select @jobj, JSON_ARRAY_APPEND(@jobj, '$.aa.c', '999');
-- ends with name, parent is object, Name does exist :  wrap pointed value in array and insert at the end of array 
select @jobj, JSON_ARRAY_APPEND(@jobj, '$.a.c', '999');
select @jobj, JSON_ARRAY_APPEND(@jobj, '$.a', '999');
-- ends with name, parent is object, Name does NOT exist : error
select @jobj, JSON_ARRAY_APPEND(@jobj, '$.a.club', '999');  
-- ends with name, parent is array : error
select @jarr, JSON_ARRAY_APPEND(@jarr, '$.d', '999');
-- ends with name, parent is scalar : error
select @jarr1, JSON_ARRAY_APPEND(@jarr1, '$[1].e', '999');

set @jobj      = '{"a":{"b":["1"], "c":["2", "3"]}}';
set @jobj1     = '{"d":"4"}';
set @jarr1     = '["e","f"]';
set @scalar  = '1';
-- ends with index, parent does not exist : error
select @jobj, JSON_ARRAY_APPEND(@jobj, '$.a.d[0]', '999');
-- ends with index, parent is object, Name does exist, index==0 : wrap in array and insert at the end
select @jobj1, JSON_ARRAY_APPEND(@jobj1, '$.d[0]', '999');
select @jobj1, JSON_ARRAY_APPEND(@jobj1, '$.d[0]', '{"g":9}');  
-- ends with index, parent is object, Name does exist, index>0 : error
select @jobj1, JSON_ARRAY_APPEND(@jobj1, '$.d[3]', '999');  
-- ends with index, parent is array, index does exist: wrap in array and insert at the end
select @jarr1, JSON_ARRAY_APPEND(@jarr1, '$[1]', '999');
-- ends with index, parent is array, index does Not exist: error
select @jarr1, JSON_ARRAY_APPEND(@jarr1, '$[3]', '999'); 
-- ends with index, parent is scalar ,index==0 : wrap in array and insert at the end
select @scalar, JSON_ARRAY_APPEND(@scalar, '$[0]', '999');
select @scalar, JSON_ARRAY_APPEND(@scalar, '$[0]', 888);
-- ends with index, parent is scalar ,index>0 :  error
select @scalar, JSON_ARRAY_APPEND(@scalar, '$[2]', '999');  



-------------------------------- JSON_REMOVE(json_doc, path[, path] ...) ----------------------------------
-- json_remove on root path results in an error
set @jobj1     = '{"d":"4"}';
set @jarr1     = '["e","f"]';
set @scalar  = '1';
select json_remove(@jobj1, '$');
select json_remove(@jarr1, '$');
select json_remove(@scalar, '$');


drop variable @jobj, @jarr, @jarr1, @jobj1,  @scalar;




--+ holdcas off;
