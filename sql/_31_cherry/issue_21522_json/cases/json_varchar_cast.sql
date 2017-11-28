drop table if exists t5;
create table t5(vals varchar(1000));
insert into t5 values('{\"period\":90,\"amount\":5.45}');
insert into t5 values('{\"period\":90,\"amount\":3.99}');
select vals from t5;
select json_extract(vals, '/period') from t5; 
select json_extract(replace(vals, '\'), '/period') from t5;
select * from t5 where json_extract(replace(vals, '\'), '/period') >0;
select json_extract(replace(vals, '\'), '/period') from t5 order by 1;
select distinct json_extract(replace(vals, '\'), '/period') from t5 order by 1;
select sum(json_extract(replace(vals, '\'), '/period')) from t5 order by 1;
--invalid json path
select json_extract(replace(vals, '\'), '$.period') from t5;
select * from t5 where cast(json_extract(replace(vals, '\'), '/period') as integer) > cast(json_extract(replace(vals, '\'), '/amount')as integer);

drop table if exists t5;
