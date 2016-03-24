-- 1
prepare s from 'select RIGHT (?, ?) into :result'
execute s using 'foobarbar', 2
deallocate prepare s;

evaluate 'ar' into :expected;
select case when :expected = :result then 'YES' else 'NO' end as case1;

-- 2
prepare s from 'select RIGHT (?, ?) into :result'
execute s using 12345, 2
deallocate prepare s;

evaluate '45' into :expected;
select case when :expected = :result then 'YES' else 'NO' end as case2;

-- 3
prepare s from 'select RIGHT (?, ?) into :result'
execute s using 12345, '2'
deallocate prepare s;

evaluate '45' into :expected;
select case when :expected = :result then 'YES' else 'NO' end as case3;

-- 4
prepare s from 'select RIGHT (?, ?) into :result'
execute s using null, 2
deallocate prepare s;

evaluate null into :expected;
select case when :expected <=> :result then 'YES' else 'NO' end as case4;

-- 5
prepare s from 'select RIGHT (?, ?) into :result'
execute s using 'abcdef', null
deallocate prepare s;

evaluate null into :expected;
select case when :expected <=> :result then 'YES' else 'NO' end as case5;

-- 6
prepare s from 'select RIGHT (?, ?) into :result'
execute s using null, null
deallocate prepare s;

evaluate null into :expected;
select case when :expected <=> :result then 'YES' else 'NO' end as case6;


