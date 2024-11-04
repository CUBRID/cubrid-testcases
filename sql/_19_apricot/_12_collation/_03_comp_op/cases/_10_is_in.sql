create table t1 (s1 string collate utf8_en_ci);
create table t2 (s1 string collate utf8_en_cs);

insert into t1 values ('Ab'),( 'aa');

insert into t2 values ('Ab'),( 'aa');


select * from t1 where s1 in {'AA'}  order by 1;

prepare s from 'select * from t1 where s1 in ?  order by 1';
execute s using {'AA'};
deallocate prepare s;

prepare s from 'select * from t1 where s1 in ?  order by 1';
execute s using {'AA','Ab'};
deallocate prepare s;


select * from t2 where s1 in {'AA'};

prepare s from 'select * from t2 where s1 in ?  order by 1';
execute s using {'AA'};
deallocate prepare s;

prepare s from 'select * from t2 where s1 in ?   order by 1';
execute s using {'AA','Ab'};
deallocate prepare s;

select s1 from t1 where cast (s1 as string collate utf8_en_cs) in {'AA'} order by 1;

select s1 from t2 where cast (s1 as string collate utf8_en_ci) in {'AA'} order by 1;


drop table t1;
drop table t2;
