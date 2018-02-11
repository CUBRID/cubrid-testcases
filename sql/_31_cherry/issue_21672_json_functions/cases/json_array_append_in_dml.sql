set names utf8;
drop table if exists t10;
create table t10(id int primary key auto_increment, name varchar collate utf8_en_ci, de json default json_array_append('{"bar": "baz", "balance": 7.77, "active":"false"}' collate utf8_en_ci, '$.balance', '{"ratio":"77%"}'));
insert into t10(id, name) values(1, '{"bar": "baz", "balance": 7.77, "active":"false"}'); 
insert into t10(id) values(2);
select * from t10 order by id;
update t10 set name = default(de) where id =2;
select * from t10 order by id;
delete from t10 where exists (select json_array_append(name, '$.balance', '{"a":"c"}') from t10)  
select * from t10;
set @j='
{
    "name": "BeJson",
    "url": "http://www.bejson.com",
    "page": 88,
    "isNonProfit": true,
    "address": {
        "street": "????.",
        "city": "????",
        "country": "??"
    },
    "links": [
        {
            "name": "Google",
            "url": "http://www.google.com"
        },
        {
            "name": "Baidu",
            "url": "http://www.baidu.com"
        },
        {
            "name": "SoSo",
            "url": "http://www.SoSo.com"
        }
    ]
}';
insert into t10 select rownum, json_array_append('{}', '$', @j), json_array_append('{}', '$', @j);
select * from t10;
select json_merge(json_array_append(name, '$[0]', '1'), json_array_append(de, '$[1]', '22')) from t10;
replace into t10 values(2, (select json_array_append(name, '$[0]', '1') from t10), json_array_append(@j, '$.url', '2') ); 
select * from t10 order by id;
select json_array_append(name, '$[1]', json_array_append(de, '$[1]', '2')) from t10;
drop VARIABLE @j;
drop table if exists t10;
