-- 1
prepare s from 'select CONCAT (?, ?, ?) into :result'
execute s using 'aaa', 'bbb', 'ccc'
deallocate prepare s;

evaluate 'aaabbbccc' into :expected;
select case when (:expected = :result) then 'YES' else 'NO' end as result;

-- 2
prepare s from 'select CONCAT (?, ?, ?) into :result'
execute s using 123, 456, 789
deallocate prepare s;

evaluate '123456789' into :expected;
select case when (:expected = :result) then 'YES' else 'NO' end as result;

-- 2
prepare s from 'select CONCAT_WS (?, ?, ?, ?) into :result'
execute s using ',', 'aaa', 'bbb', 'ccc'
deallocate prepare s;

evaluate 'aaa,bbb,ccc' into :expected;
select case when (:expected = :result) then 'YES' else 'NO' end as result;

-- 4
prepare s from 'select CONCAT_WS (?, ?, ?, ?) into :result'
execute s using ',', 123, 456, 789
deallocate prepare s;

evaluate '123,456,789' into :expected;
select case when (:expected = :result) then 'YES' else 'NO' end as result;

