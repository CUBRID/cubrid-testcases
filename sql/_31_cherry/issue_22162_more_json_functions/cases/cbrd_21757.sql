drop table if exists t5;
create table t5(id int , name json);

$varchar, $1, $varchar, $1
insert into t5 values(?,?);

$varchar, $2, $varchar, $json_array('aa')
insert into t5 values(?,?);

$varchar, $2, $varchar, $["aa"]
insert into t5 values(?,?);

$varchar, $3, $varchar, ${"loop":1}
insert into t5 values(?,?);

$varchar, $4, $varchar, $json_object('loop-1', 'data-1')
insert into t5 values(?,?);

$varchar, $4, $varchar, ${"loop-1":"data-1"}
insert into t5 values(?,?);

select * from t5 order by 1;
drop table if exists t5;
