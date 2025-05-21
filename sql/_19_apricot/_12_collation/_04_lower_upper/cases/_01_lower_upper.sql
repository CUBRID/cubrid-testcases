create table t1 (s1 string collate utf8_en_cs);
create table t2 (s1 string collate utf8_tr_cs);

insert into t1 values ('Abi'), ('aBI');

insert into t2 values ('Abi'), ('aBI');


select lower (s1) from t1 order by 1;
select lower (s1) from t2 order by 1;

select lower (cast (s1 as string collate utf8_tr_cs)) from t1 order by 1;
select lower (cast (s1 as string collate utf8_en_cs)) from t2 order by 1;

-- error : incompatible collation
select lower (cast (s1 as string collate iso_en_cs)) from t2 order by 1;
select lower (cast (s1 as string collate iso_en_cs)) from t2 order by 1;


select upper (s1) from t1 order by 1;
select upper (s1) from t2 order by 1;


select upper (cast (s1 as string collate utf8_tr_cs)) from t1 order by 1;
select upper (cast (s1 as string collate utf8_en_cs)) from t2 order by 1;


-- late binding
prepare s from 'select lower(s1 + ?) from t1 order by 1';
execute s using 'A';
deallocate prepare s;

prepare s from 'select lower(s1 + ?) from t2 order by 1';
execute s using 'A';
deallocate prepare s;


prepare s from 'select lower(cast ((s1 + ?) as string collate utf8_tr_cs)) from t2 order by 1';
execute s using 'A';
deallocate prepare s;



prepare s from 'select ? + upper(s1) from t1 order by 1';
execute s using 'A';
deallocate prepare s;

prepare s from 'select ? + upper(s1) from t2 order by 1';
execute s using 'A';
deallocate prepare s;


drop table t1;
drop table t2;
