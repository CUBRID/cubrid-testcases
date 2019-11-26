--+ holdcas on;
-- 1
prepare s from 'select LEFT (?, ?) into :result';
execute s using 'abcdef', 2;
deallocate prepare s;

evaluate 'ab' into :expected;
select case when :expected = :result then 'YES' else 'NO' end as case1;

-- 2
prepare s from 'select LEFT (?, ?) into :result';
execute s using 12345, 2;
deallocate prepare s;

evaluate '12' into :expected;
select case when :expected = :result then 'YES' else 'NO' end as case2;

-- 3
prepare s from 'select LEFT (?, ?) into :result';
execute s using 12345, '2';
deallocate prepare s;

evaluate '12' into :expected;
select case when :expected = :result then 'YES' else 'NO' end as case3;

-- 4
prepare s from 'select LEFT (?, ?) into :result';
execute s using null, 2;
deallocate prepare s;

evaluate null into :expected;
select case when :expected <=> :result then 'YES' else 'NO' end as case4;

-- 5
prepare s from 'select LEFT (?, ?) into :result';
execute s using 'abcdef', null;
deallocate prepare s;

evaluate null into :expected;
select case when :expected <=> :result then 'YES' else 'NO' end as case5;

-- 6
prepare s from 'select LEFT (?, ?) into :result';
execute s using null, null;
deallocate prepare s;

evaluate null into :expected;
select case when :expected <=> :result then 'YES' else 'NO' end as case6;



--+ holdcas off;
