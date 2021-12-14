--+ holdcas on;
set @a='{"title":"hello"}';
select json_set(@a,  '$."title"[10000000000]', 'world') ;
select json_insert(@a,  '$."title"[10000000000]', 'world') ;
select json_array_insert(@a,  '$."title"[10000000000]', 'world') ;

-- default: json_max_array_idx = 64*1024 
select @a, 
json_length(json_set(@a, '$."title"[65535]', 'world'), '$.title') as length, 
json_extract(json_set(@a, '$."title"[65535]', 'world'), '$.title[65535]') as "title[65535]", 
json_extract(json_set(@a, '$."title"[65535]', 'world'), '$.title[65534]') as "title[65534]"; 
select @a, json_length(json_set(@a, '$."title"[65537]', 'world'), '$.title');

-- lower: json_max_array_idx = 1024
SET SYSTEM PARAMETERS 'json_max_array_idx = 50';
SET SYSTEM PARAMETERS 'json_max_array_idx = 1023';
SET SYSTEM PARAMETERS 'json_max_array_idx = 1024';
select @a, json_length(json_set(@a, '$."title"[1024]', 'a'), '$.title');
select @a, json_length(json_set(@a, '$."title"[1025]', 'a'), '$.title');

drop table if exists t;
create table t as select 1 a from db_class;         
insert into t  select a from t limit 45;
insert into t  select a from t limit 90;
insert into t  select a from t limit 180;
insert into t  select a from t limit 360;
select count(*), json_length(json_arrayagg(a)) from t;

insert into t  select a from t limit 720;
select count(*), json_length(json_arrayagg(a)) from t;
select json_set(json_arrayagg(a) , '$[1400]', '9999') from t;
drop table if exists t;

-- max: json_max_array_idx = 1048576 (1024*1024)
SET SYSTEM PARAMETERS 'json_max_array_idx = 1048576';
select @a, json_length(json_set(@a, '$."title"[1048576]', 'world'), '$.title');
select @a, json_length(json_set(@a, '$."title"[1048577]', 'world'), '$.title');
select @a, json_length(json_set(@a, '$."title"[104857i]', 'world'), '$.title');
SET SYSTEM PARAMETERS 'json_max_array_idx = 1048577';
SET SYSTEM PARAMETERS 'json_max_array_idx = 10000000000';

-- other: 
SET SYSTEM PARAMETERS 'json_max_array_idx = -1';
SET SYSTEM PARAMETERS 'json_max_array_idx = 0';
SET SYSTEM PARAMETERS 'json_max_array_idx = -1024';

-- set default: json_max_array_idx = 65536 (64*1024)
SET SYSTEM PARAMETERS 'json_max_array_idx = 65536';
drop variable @a;


--+ holdcas off;
