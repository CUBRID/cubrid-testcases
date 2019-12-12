--+ holdcas on;
-- 1
prepare s from 'select REVERSE (?) into :result'
execute s using 'abc'
deallocate prepare s;

evaluate 'cba' into :expected;
select case when (:expected = :result) then 'YES' else 'NO' end as result;

-- 2
prepare s from 'select REVERSE (?) into :result'
execute s using 123
deallocate prepare s;

evaluate '321' into :expected;
select case when (:expected = :result) then 'YES' else 'NO' end as result;

-- 3
prepare s from 'select REVERSE (?) into :result'
execute s using null
deallocate prepare s;

evaluate null into :expected;
select case when (:expected <=> :result) then 'YES' else 'NO' end as result;

--+ holdcas off;
