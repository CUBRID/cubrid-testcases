-- 1
prepare s from 'select LOCATE (?, ?) into :result';
execute s using 'bar', 'foobarbar';
deallocate prepare s;

evaluate 4 into :expected;
select case when :expected = :result then 'YES' else 'NO' end as case1;

-- 2
prepare s from 'select LOCATE (?, ?) into :result';
execute s using 456, 123456789;
deallocate prepare s;

evaluate 4 into :expected;
select case when :expected = :result then 'YES' else 'NO' end as case2;

-- 3
prepare s from 'select LOCATE (?, ?, ?) into :result';
execute s using 'bar', 'foobarbar', 5;
deallocate prepare s;

evaluate 7 into :expected;
select case when :expected = :result then 'YES' else 'NO' end as case3;

-- 4
prepare s from 'select LOCATE (?, ?, ?) into :result';
execute s using 456, 123456456, 5;
deallocate prepare s;

evaluate 7 into :expected;
select case when :expected = :result then 'YES' else 'NO' end as case4;

-- 5
prepare s from 'select LOCATE (?, ?) into :result';
execute s using null, 'foobarbar';
deallocate prepare s;

evaluate null into :expected;
select case when :expected <=> :result then 'YES' else 'NO' end as case5;

-- 6
prepare s from 'select LOCATE (?, ?) into :result';
execute s using 'bar', null;
deallocate prepare s;

evaluate null into :expected;
select case when :expected <=> :result then 'YES' else 'NO' end as case6;

-- 7
prepare s from 'select LOCATE (?, ?, ?) into :result';
execute s using null, 'foobarbar', 5;
deallocate prepare s;

evaluate null into :expected;
select case when :expected <=> :result then 'YES' else 'NO' end as case7;

-- 8
prepare s from 'select LOCATE (?, ?, ?) into :result';
execute s using 'bar', null, 5;
deallocate prepare s;

evaluate null into :expected;
select case when :expected <=> :result then 'YES' else 'NO' end as case8;

-- 9
prepare s from 'select LOCATE (?, ?, ?) into :result';
execute s using 'bar', 'foobarbar', null;
deallocate prepare s;

evaluate null into :expected;
select case when :expected <=> :result then 'YES' else 'NO' end as case9;

