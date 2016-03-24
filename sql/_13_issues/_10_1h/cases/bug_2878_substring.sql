-- 1
prepare s from 'select SUBSTRING (?, ?) into :result'
execute s using 'Quadratically', 5
deallocate prepare s;

evaluate 'ratically' into :expected;
select case when :expected = :result then 'YES' else 'NO' end as case1;

-- 2
prepare s from 'select SUBSTRING (?, ?, ?) into :result'
execute s using 'Quadratically', 5, 6
deallocate prepare s;

evaluate 'ratica' into :expected;
select case when :expected = :result then 'YES' else 'NO' end as case2;

-- 3
prepare s from 'select SUBSTRING (?, ?, ?) into :result'
execute s using 1234567890, 5, 6
deallocate prepare s;

evaluate '567890' into :expected;
select case when :expected = :result then 'YES' else 'NO' end as case3;

-- 4
prepare s from 'select SUBSTRING (?, ?, ?) into :result'
execute s using 1234567890, '5', '6'
deallocate prepare s;

evaluate '567890' into :expected;
select case when :expected = :result then 'YES' else 'NO' end as case4;

-- 5
prepare s from 'select SUBSTRING (?, ?, ?) into :result'
execute s using null, 5, 6
deallocate prepare s;

evaluate null into :expected;
select case when :expected <=> :result then 'YES' else 'NO' end as case5;

-- 6
prepare s from 'select SUBSTRING (?, ?, ?) into :result'
execute s using 'Quadratically', null, 6
deallocate prepare s;

evaluate null into :expected;
select case when :expected <=> :result then 'YES' else 'NO' end as case6;

-- 7
prepare s from 'select SUBSTRING (?, ?, ?) into :result'
execute s using 'Quadratically', 5, null
deallocate prepare s;

evaluate null into :expected;
select case when :expected <=> :result then 'YES' else 'NO' end as case7;

-- 8
prepare s from 'select SUBSTRING (?, ?, ?) into :result'
execute s using null, null, null
deallocate prepare s;

evaluate null into :expected;
select case when :expected <=> :result then 'YES' else 'NO' end as case8;

