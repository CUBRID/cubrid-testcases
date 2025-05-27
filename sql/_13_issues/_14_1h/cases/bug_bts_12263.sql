--[I18N] Result of '+' operation is incorrect with host variables.

set names iso88591 collate iso88591_en_cs;

drop table if exists t1;

create table t1 (s1 string collate utf8_en_ci);
insert into t1 values ('Ab'),( 'aa');

select * from t1 where 'aa' > s1 + '0' order by 1;
select * from t1 where 'aa' > s1 || '0' order by 1;
select * from t1 where 'aa' + '0' > s1 order by 1;
select * from t1 where 'aa' || '0' > s1 order by 1;

prepare s from 'select * from t1 where ? > s1 + ? order by 1' ;
execute s using 'aa','0';
deallocate prepare s;
prepare s from 'select * from t1 where ? > s1 || ? order by 1' ;
execute s using 'aa','0';
deallocate prepare s;
prepare s from 'select * from t1 where ? + ? > s1 order by 1' ;
execute s using 'aa','0';
deallocate prepare s;
prepare s from 'select * from t1 where ? + ? > s1 order by 1' ;
execute s using 'aa','0';
deallocate prepare s;

drop table t1;

set names iso88591;
