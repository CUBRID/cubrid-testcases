
create table t1 (s1 string collate utf8_en_ci);
create table t2 (s1 string collate utf8_en_cs);

insert into t1 values ('Ab'), ('aa');

insert into t2 values ('Ab'), ('aa'); 


-- error
select * from t1 where s1= (select max(s1) from t2) order by 1;

-- cast to workaround error
select * from t1 where cast (s1 as string collate utf8_en_cs) = (select max(s1) from t2) order by 1;

select * from t1 where 'aa'= (select max(s1) from t2) order by 1;


drop table t1;
drop table t2;
