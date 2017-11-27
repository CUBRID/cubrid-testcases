evaluate 'y' into :a;
evaluate 'n' into :b;

select if (0 = 0, 'y', 'n') into :expected;

-- 1
prepare s from 'select IF (? = ?, :a , :b) into :result'
execute s using 0, 0
deallocate prepare s;

select case when (:expected = :result) then 'YES' else 'NO' end as result;

-- 2
prepare s from 'select IF (? = ?, ? , :b) into :result'
execute s using 0, 0, 'y'
deallocate prepare s;

select case when (:expected = :result) then 'YES' else 'NO' end as result;

-- 3
prepare s from 'select IF (? = ?, :a , ?) into :result'
execute s using 0, 0, 'n'
deallocate prepare s;

select case when (:expected = :result) then 'YES' else 'NO' end as result;

-- 4
prepare s from 'select IF (? = ?, ? , ?) into :result'
execute s using 0, 0, 'y', 'n'
deallocate prepare s;

select case when (:expected = :result) then 'YES' else 'NO' end as result;
drop variable a,b,expected,result;
