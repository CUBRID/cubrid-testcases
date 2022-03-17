--+ holdcas on;
prepare s from 'select rand (?) into :result';
execute s using 123;
deallocate prepare s;
evaluate rand(123) into :expected;
select case when :expected = :result then 'YES' else 'NO' end as case1;

prepare s from 'select substr(to_char(drand (?)), 0, 10) into :result';
execute s using 123;
deallocate prepare s;
evaluate substr(to_char(drand(123)), 0, 10) into :expected;
select case when :expected = :result then 'YES' else 'NO' end as case2;

prepare s from 'select random (?) into :result';
execute s using 123;
deallocate prepare s;
evaluate random(123) into :expected;
select case when :expected = :result then 'YES' else 'NO' end as case3;

prepare s from 'select substr(to_char(drandom (?)), 0, 10) into :result';
execute s using 123;
deallocate prepare s;
evaluate substr(to_char(drandom(123)), 0, 10) into :expected;
select case when :expected = :result then 'YES' else 'NO' end as case4;


--+ holdcas off;
