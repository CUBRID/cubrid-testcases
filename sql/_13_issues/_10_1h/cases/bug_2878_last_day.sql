--+ holdcas on;
prepare s from 'select last_day (?) into :result'
execute s using '05/17/2010'
deallocate prepare s;
evaluate last_day (date'05/17/2010') into :expected;
select case when :expected = :result then 'YES' else 'NO' end as case1;

prepare s from 'select last_day (?) into :result'
execute s using '2010-05-17'
deallocate prepare s;
evaluate last_day (date'2010-05-17') into :expected;
select case when :expected = :result then 'YES' else 'NO' end as case1;


--+ holdcas off;
