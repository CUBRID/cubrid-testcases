--+ holdcas on;
-- 1
select IF (0 = 0, 'y', 'n') into :expected;

prepare s from 'select IF (? = ?, ? , ?) into :result';
execute s using 0, 0, 'y', 'n';
deallocate prepare s;

select case when (:expected = :result) then 'YES' else 'NO' end as result;

-- 2
evaluate '1' into :expected;

prepare s from 'select IF (? = ?, ? , ?) into :result';
execute s using 0, 0, 1, 0;
deallocate prepare s;

select case when (:expected = :result) then 'YES' else 'NO' end as result;

-- 3
evaluate '1' into :expected;

prepare s from 'select IF (? = ?, ? , ?) into :result';
execute s using 'a', 'a', 1, 0;
deallocate prepare s;

select case when (:expected = :result) then 'YES' else 'NO' end as result;

-- 4
select IF ('a' != 'a', 'y', 'n') into :expected;

prepare s from 'select IF (? != ?, ? , ?) into :result';
execute s using 'a', 'a', 'y', 'n';
deallocate prepare s;

select case when (:expected = :result) then 'YES' else 'NO' end as result;

-- 5
select IF ('a' != 'a', null, 'n') into :expected;

prepare s from 'select IF (? != ?, ? , ?) into :result';
execute s using 'a', 'a', null, 'n';
deallocate prepare s;

select case when (:expected <=> :result) then 'YES' else 'NO' end as result;

-- 6
select IF ('a' != 'a', 'y', null) into :expected;

prepare s from 'select IF (? != ?, ? , ?) into :result';
execute s using 'a', 'a', 'y', null;
deallocate prepare s;

select case when (:expected <=> :result) then 'YES' else 'NO' end as result;

-- 7
select IF ('a' != 'a', null, null) into :expected;

prepare s from 'select IF (? != ?, ? , ?) into :result';
execute s using 'a', 'a', null, null;
deallocate prepare s;

select case when (:expected <=> :result) then 'YES' else 'NO' end as result;


--+ holdcas off;
