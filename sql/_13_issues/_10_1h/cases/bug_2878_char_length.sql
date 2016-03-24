-- 1
prepare s from 'select char_length (?) into :result'
execute s using 'abc'
deallocate prepare s;

evaluate 3 into :expected;
select case when (:expected = :result) then 'YES' else 'NO' end as result;

-- 2
prepare s from 'select char_length (?) into :result'
execute s using 123
deallocate prepare s;

evaluate 3 into :expected;
select case when (:expected = :result) then 'YES' else 'NO' end as result;

-- 3
prepare s from 'select CHARACTER_LENGTH (?) into :result'
execute s using 'aaa'
deallocate prepare s;

evaluate 3 into :expected;
select case when (:expected = :result) then 'YES' else 'NO' end as result;

-- 4
prepare s from 'select CHARACTER_LENGTH (?) into :result'
execute s using 123
deallocate prepare s;

evaluate 3 into :expected;
select case when (:expected = :result) then 'YES' else 'NO' end as result;

