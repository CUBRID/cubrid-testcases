--special input
SELECT JSON_PRETTY('{}');
SELECT JSON_PRETTY(NULL);
SELECT JSON_PRETTY('NULL');


--invalid input
SELECT JSON_PRETTY('[1:2]'); 
SELECT JSON_PRETTY('{"a","10","b","15","x","25"}');   

--select from table
drop if exists t1;
create table t1(id int auto_increment primary key, c json);
insert into t1(c) values('{"id": "101", "name": "aaa"}');
insert into t1(c) values(json_object('id','102','name','bbb'));
insert into t1(c) values('{"id": "103", "name": ["ccc1", "ccc2"]}');
set @j = '{"id": "104", "name": ["ddd1", "ddd2"]}';
insert into t1(c) values(@j);
insert into t1(c) values(json_object('id','105','name', json_array('eee1','eee2')));
insert into t1(c) values(json_object('id','106','name', '[eee1, eee2]'));
insert into t1(c) values(json_object('id','107','name', '["eee1","eee2"]'));

insert into t1(c) values(json_object('id','108','name', json_object('name', 'fff1', 'name_old', 'fff2')));

set @j = '{"id":109,"name":{"name":"ggg1", "name_old":["old1", "old2"]},"city":["city1","city2","city3"]}';
insert into t1(c) values(@j);

set @j = '["a",1,{"key1":
   "value1"},"5",     "798\b" 
   ,
      {"key2":["value3","valueX",


"valueY"]},"joke1\t", "joke2	","2"   ]';
insert into t1(c) values(@j);


select id, c from t1 where id<100 order by 1,2;
SELECT id, JSON_PRETTY(c) from t1 where id>0 order by 1,2;

drop t1;

