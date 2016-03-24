-- ifnull

-- 1
prepare s from 'select ifnull (null , ? ) into :result' 
execute s using 0
deallocate prepare s;

evaluate '0' into :expected;
select case when (:result = :expected) then 'YES' else 'NO' end as result;

-- 2
prepare s from 'select ifnull (1 , ?) into :result'
execute s using 0
deallocate prepare s;

evaluate '1' into :expected;
select case when (:result = :expected) then 'YES' else 'NO' end as result;

-- 3
prepare s from 'select ifnull (? , 0) into :result'
execute s using null
deallocate prepare s;

evaluate '0' into :expected;
select case when (:result = :expected) then 'YES' else 'NO' end as result;

-- 4
prepare s from 'select ifnull (? , null) into :result'
execute s using null
deallocate prepare s;

evaluate null into :expected;
select case when (:result <=> :expected) then 'YES' else 'NO' end as result;

-- 5
prepare s from 'select ifnull (? , ?) into :result' 
execute s using null, 0
deallocate prepare s;

evaluate '0' into :expected;
select case when (:result = :expected) then 'YES' else 'NO' end as result;

