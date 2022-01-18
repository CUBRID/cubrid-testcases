--+ holdcas on;
-- string
-- 1
prepare s from 'select FIELD (?, ?, ?, ?) into :result';
execute s using '0', '0', '1', '2';
deallocate prepare s;

evaluate 1 into :expected;
select case when (:expected = :result) then 'YES' else 'NO' end as result;

-- 2
prepare s from 'select FIELD (?, ?, ?, ?) into :result';
execute s using '1', '0', '1', '2';
deallocate prepare s;

evaluate 2 into :expected;
select case when (:expected = :result) then 'YES' else 'NO' end as result;

-- 3
prepare s from 'select FIELD (?, ?, ?, ?) into :result';
execute s using '2', '0', '1', '2';
deallocate prepare s;

evaluate 3 into :expected;
select case when (:expected = :result) then 'YES' else 'NO' end as result;

-- 4
prepare s from 'select FIELD (?, ?, ?, ?) into :result'; 
execute s using '3', '0', '1', '2';
deallocate prepare s;

evaluate 0 into :expected;
select case when (:expected = :result) then 'YES' else 'NO' end as result;


-- number
-- 5
prepare s from 'select FIELD (?, ?, ?, ?) into :result'; 
execute s using 0, 0, 1, 2;
deallocate prepare s;

evaluate 1 into :expected;
select case when (:expected = :result) then 'YES' else 'NO' end as result;

-- 6
prepare s from 'select FIELD (?, ?, ?, ?) into :result';
execute s using 1, 0, 1, 2;
deallocate prepare s;

evaluate 2 into :expected;
select case when (:expected = :result) then 'YES' else 'NO' end as result;

-- 7
prepare s from 'select FIELD (?, ?, ?, ?) into :result'; 
execute s using 2, 0, 1, 2;
deallocate prepare s;

evaluate 3 into :expected;
select case when (:expected = :result) then 'YES' else 'NO' end as result;

-- 8
prepare s from 'select FIELD (?, ?, ?, ?) into :result';
execute s using 3, 0, 1, 2;
deallocate prepare s;

evaluate 0 into :expected;
select case when (:expected = :result) then 'YES' else 'NO' end as result;

-- mixed
-- 9
prepare s from 'select FIELD (?, ?, ?, ?) into :result';
execute s using '0', 0, 1, 2;
deallocate prepare s;

evaluate 0 into :expected;
select case when (:expected = :result) then 'YES' else 'NO' end as result;

-- 10
prepare s from 'select FIELD (?, ?, ?, ?) into :result'; 
execute s using '1', '0', '1', 2;
deallocate prepare s;

evaluate 2 into :expected;
select case when (:expected = :result) then 'YES' else 'NO' end as result;

-- 11
prepare s from 'select FIELD (?, ?, ?, ?) into :result'; 
execute s using 2, '0', '1', 2;
deallocate prepare s;

evaluate 3 into :expected;
select case when (:expected = :result) then 'YES' else 'NO' end as result;

-- 12
prepare s from 'select FIELD (?, ?, ?, ?) into :result'; 
execute s using 3, '0', '1', '2';
deallocate prepare s;

evaluate 0 into :expected;
select case when (:expected = :result) then 'YES' else 'NO' end as result;

-- null
-- 13
prepare s from 'select FIELD (?, ?, ?, ?) into :result';
execute s using null, 0, 1, 2;
deallocate prepare s;

evaluate 0 into :expected;
select case when (:expected = :result) then 'YES' else 'NO' end as result;

-- 14
prepare s from 'select FIELD (?, ?, ?, ?) into :result'; 
execute s using '1', null, '1', 2;
deallocate prepare s;

evaluate 2 into :expected;
select case when (:expected = :result) then 'YES' else 'NO' end as result;

-- 15
prepare s from 'select FIELD (?, ?, ?, ?) into :result'; 
execute s using 2, null, '1', 2;
deallocate prepare s;

evaluate 3 into :expected;
select case when (:expected = :result) then 'YES' else 'NO' end as result;


--+ holdcas off;
