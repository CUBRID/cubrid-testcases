--+ holdcas on;
evaluate '01,5,2013' into :a;

prepare s from 'select str_to_date(?,''%d,%m,%Y'') into :result';
execute s using '01,5,2013';
deallocate prepare s;
evaluate str_to_date ('01,5,2013','%d,%m,%Y') into :expected;
select case when :expected = :result then 'YES' else 'NO' end as case1;

prepare s from 'select str_to_date(?, ''%d,%m,%Y'') into :result';
execute s using :a;
deallocate prepare s;
evaluate str_to_date (:a, '%d,%m,%Y') into :expected;
select case when :expected = :result then 'YES' else 'NO' end as case2;
drop variable a,result,expected;

--+ holdcas off;
