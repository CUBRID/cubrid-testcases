drop table if exists s;
create table s(a int);
insert into s values (1), (2), (3), (4), (5), (6), (7), (8), (9), (0);
insert into s select s1.a from s s1, s s2 limit 40;

set @js='{
   "students":
      {
         "name": {"first": "J", "last": "W", "nick": "James"},
         "height": 180,
         "roles": [1,2,3,4,5,6,7,8,9,0],
         "clubs": [1,2,3,4,5,6,7,8,9,0],
         "k1": [1,2,3,4,5,6,7,8,9,0],
         "k2": [1,2,3,4,5,6,7,8,9,0],
         "k3": [1,2,3,4,5,6,7,8,9,0],
         "k4": [1,2,3,4,5,6,7,8,9,0],
         "k5": [1,2,3,4,5,6,7,8,9,0],
         "k6": [1,2,3,4,5,6,7,8,9,0],
         "k7": [1,2,3,4,5,6,7,8,9,0],
         "k8": [1,2,3,4,5,6,7,8,9,0],
         "k9": [1,2,3,4,5,6,7,8,9,0],
         "k10": [1,2,3,4,5,6,7,8,9,0]
      }
}';
drop table if exists t1;
create table t1(a json);
insert into t1 select @js from s s1, s s2, s s3 limit 20000;

--CBRD-22710 Performance issue: hope execution time of below query is less then 1 second.
select count(*)  from t1 where a->'$.students.name.nick'='James';
select if (benchmark(1000,(select count(*)  from t1 where a->'$.students.name.nick'='James'))>0,'ok','nok');

drop table if exists t1,s;
drop variable @js;

