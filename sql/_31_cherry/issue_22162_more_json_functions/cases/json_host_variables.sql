--+ holdcas on;
set @ja='[1,2, {"a":1}]';
set @jo='{"a":1, "b":[1,2,3], "c":["a","b","c"]}';
prepare st from 'SELECT JSON_ARRAY(?, ?, ?)';
execute st using @ja,@jo,100000;
execute st using @ja,@jo,100000,1;
select JSON_ARRAY(@ja,@jo,100000);
select JSON_ARRAY(cast(@ja as json),cast(@jo as json),100000);

prepare st from 'SELECT JSON_ARRAY_APPEND(?, ?, ?)';
execute st using @ja,'$[2]',@jo;
select JSON_ARRAY_APPEND(@ja,'$[2]',@jo);
execute st using @ja,'$[1]',@jo;
select JSON_ARRAY_INSERT(@ja,'$[1]',@jo);

prepare st from 'SELECT JSON_ARRAY_INSERT(?, ?, ?)';
execute st using @ja,'$[2]',@jo;
select JSON_ARRAY_INSERT(@ja,'$[2]',@jo);
execute st using @ja,'$[1]',@jo;
select JSON_ARRAY_INSERT(@ja,'$[1]',@jo);

set @ja='[1,2, {"a":1}]';
set @jo='{"a":1, "b":[1,2,3], "c":["a","b","c"]}';
set @p = '$.a';
prepare st from 'SELECT JSON_CONTAINS_PATH(?,?,?)';
execute st using @ja, 'all', @p;
execute st using @ja, @oa , '$[2].a';
execute st using @jo, 'all', @p;
set @oa ='one';
execute st using @jo, @oa , @p;
execute st using @jo, @oa , null;
execute st using null, null , null;
set @p = '$.a';
prepare st from 'SELECT JSON_EXTRACT(?,?)';
set @p = '$.a';
execute st using @ja, @p;
set @p = '$';
execute st using @ja, @p;
set @p = '';
execute st using @ja, @p;
set @p = '/0';
execute st using @ja, @p;

set @ja='[1,2, {"a":1}]';
set @jo='{"a":1, "b":[1,2,3], "c":["a","b","c"]}';
prepare st from 'SELECT JSON_GET_ALL_PATHS(?)';
execute st using @ja;
execute st using @jo;

set @ja='[1,2, {"a":1}]';
set @jo='{"a":1, "b":[1,2,3], "c":["a","b","c"]}';
prepare st from 'SELECT JSON_KEYS(?)';
execute st using @ja;
execute st using @jo;
prepare st from 'SELECT JSON_KEYS(?,?)';
set @p = '$[2].a';
execute st using @ja,@p;
execute st using @ja,'$[2]';
execute st using @jo,'$.c';

SET @j = '{ "a": 1, "b": [2, 3]}';
prepare st from 'SELECT JSON_SET(?,?,?,?,?);';
execute st using @j,'$.a',10, '$.c', '[true, false]';
prepare st from 'SELECT JSON_INSERT(?,?,?,?,?);';
execute st using @j,'$.a',10, '$.c', '[true, false]';
prepare st from 'SELECT JSON_REPLACE(?,?,?,?,?);';
execute st using @j,'$.a',10, '$.c', '[true, false]';

set @ja='[1,2, {"a":100}]';
set @jo='{"a":1, "b":[1,2,3], "c":["a","b","c"]}';
prepare st from 'SELECT JSON_MERGE_PRESERVE(?,?);';
execute st using @ja,@jo;
execute st using @jo,@ja;
prepare st from 'SELECT JSON_MERGE(?,?);';
execute st using @ja,@jo;
execute st using @jo,@ja;
prepare st from 'SELECT JSON_MERGE_PATCH(?,?);';
execute st using @ja,@jo;
execute st using @jo,@ja;
execute st using @jo,@ja,@ja;

set @ja='[1,2, {"a":1}]';
set @jo='{"a":1, "b":[1,2,3], "c":["a","b","c"]}';
prepare st from 'SELECT JSON_REMOVE(?,?);';
execute st using @ja,'$';
execute st using @ja,'$[0]';
execute st using @jo,'$.a';
execute st using @ja,'$[0],$[1].a';
set @p='$[0],$[1].a';
execute st using @jo,@p;
set @p='$[0]';
prepare st from 'SELECT JSON_REMOVE(?,?,?);';
execute st using @ja,@p,@p;
execute st using @ja,'$[0]','$[1].a';

set @ja='[1,2, {"a":1}]';
set @jo='{"a":1, "b":[1,2,3], "c":["a","ab","ca"]}';
prepare st from 'SELECT JSON_SEARCH(?,?,?);';
execute st using @ja,'all','a';
execute st using @jo,'all','a';
execute st using json_array(@ja,@jo),'all','a';
set @j=(select json_merge(@ja,@jo,@jo));
execute st using @j,'all','a';
execute st using @j,'one','%a%';
execute st using @j,'one','%a%',;
prepare st from 'SELECT JSON_SEARCH(?,?,?,?,?);';
execute st using @jo,'all','a',null,'$';
execute st using @jo,'all','a','','$';
execute st using @jo,'all','a_','_','$';

set @ja='[1,2, {"a":1}]';
set @jo='{"a":1, "b":[1,2,3], "c":["a","b","c"]}';
prepare st from 'SELECT JSON_ARRAYAGG(?)';
execute st using @ja;
select JSON_ARRAYAGG(@ja);

drop table if exists t;
create table t (i int , j json);
prepare st from 'insert into t values (?,?)';
execute st using 1,@ja;
execute st using 2,@jo;
insert into t values (1,'1');
insert into t values (3,1);
insert into t values (2,'"A"');
select * from t order by i,j desc;

prepare st from 'SELECT JSON_ARRAYAGG(?) from t group by i+? order by i';
execute st using 'a',1;
SELECT JSON_ARRAYAGG(j) from (select * from t order by 1,2) group by i;
SELECT JSON_objectAGG(j) from (select * from t order by 1,2) group by i;
SELECT JSON_arrayAGG(i,j) from (select * from t order by 1,2) group by i+1 order by i;
--CBRD-22609
SELECT JSON_OBJECTAGG(i,j) from (select * from t order by 1 desc,2 desc) group by i+1 order by i;
prepare st from 'SELECT JSON_OBJECTAGG(i,j) from (select i,j from t order by i,j) group by i order by i';
execute st using '1';
prepare st from 'SELECT JSON_OBJECTAGG(?,j) from (select * from t order by 1,2) group by i order by 1';
execute st using 'a';
prepare st from 'SELECT JSON_OBJECTAGG(?,j) from (select * from t order by 1,2) group by i+? order by 1';
execute st using 'a',1;

prepare st from 'SELECT  i,j from t where i >= json_extract(j, ?)';
execute st using '$.a';

prepare st from 'SELECT JSON_OBJECT(?,?,?,?) ';
execute st using 'a','b','a',1;
execute st using 'a','b','b',1;

set @k='a';
set @v='1';
prepare st from 'SELECT JSON_OBJECT(?,?) ';
execute st using @k,@v;

prepare st from 'SELECT JSON_merge(?,?) ';
execute st using 1,1;


drop table if exists t;
drop variable @j, @jo,@ja,@k,@v,@p,@oa;
drop prepare st;

--+ holdcas off;
