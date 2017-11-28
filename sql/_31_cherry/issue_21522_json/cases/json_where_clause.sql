drop table if exists t;
create table t(a int, b json, c json);
insert into t values(1, json_object('a','b'), '["c", "d"]');
select * from t where json_extract(b,'/a') like '%b%';

drop table if exists t1;
create table t1(id int primary key, name json);
insert into t1 values(1, '{ "Id": "12345", "FinanceProductResults": [ { "Term": 12, "AnnualMileage": 5000, "Deposits": 0, "ProductResults": [] }, {"Term": 18, "AnnualMileage": 30000, "Deposits": 15000, "ProductResults": [] }, { "Term": 24, "AnnualMileage":5000, "Deposits": 0, "ProductResults": [ { "Key": "HP", "Payment": 460.28 } ] }, { "Term": 24, "AnnualMileage": 10000, "Deposits": 0, "ProductResults": [ { "Key": "HP", "Payment": 500.32 } ] }]}');
select * from t1 join t where t.a = t1.id;
select * from t1 join t where json_extract(t.b, '/a') is not null and json_extract(t1.name, '/Id') is not null;
select * from t1 join t where json_extract(t.b, '/a') =json_extract(json_object('id', 'b'), '/id'); 
select * from t join t1 on json_extract(t.b, '/a') !=json_extract(json_object('id', 'b'), '/id');
select json_merge(json_extract(t1.name, '/FinanceProductResults/0'), t.c) from t join t1 on json_extract(t.b, '/a') = json_extract(json_object('id', 'b'), '/id');
select json_array(json_extract(t1.name, '/FinanceProductResults/0'), t.c) from t join t1 on json_extract(t.b, '/a') = json_extract(json_object('id', 'b'), '/id')
select json_insert(json_extract(t1.name, '/FinanceProductResults/0'), '/ProductResults/-', t.c) from t join t1 on json_extract(t.b, '/a') = json_extract(json_object('id', 'b'), '/id');
select json_insert(json_extract(t1.name, '/FinanceProductResults/0'), '/ProductResults/1/-', t.c) from t join t1 on json_extract(t.b, '/a') = json_extract(json_object('id', 'b'), '/id') where json_type(json_extract(json_insert( json_extract(t1.name, '/FinanceProductResults/0'), '/ProductResults/-', t.c), '/ProductResults')) = 'JSON_ARRAY';


drop table if exists t;
drop table if exists t1;
