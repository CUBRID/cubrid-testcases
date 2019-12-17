--+ holdcas on;
-- 1
prepare s from 'select bit_and (?) into :result'
execute s using 1
deallocate prepare s;

select bit_and(1) into :expected;
select case when (:expected = :result) then 'YES' else 'NO' end as result;

-- 2
prepare s from 'select bit_and (a+?) into :result from (select 1 union select 2) t(a)'
execute s using 1
deallocate prepare s;

select bit_and(a+1) into :expected from (select 1 union select 2) t(a);
select case when (:expected = :result) then 'YES' else 'NO' end as result;

-- 3
prepare s from 'select bit_or (a+?) into :result from (select 1 union select 2) t(a)'
execute s using 1
deallocate prepare s;

select bit_or(a+1) into :expected from (select 1 union select 2) t(a);
select case when (:expected = :result) then 'YES' else 'NO' end as result;

-- 4
prepare s from 'select bit_xor (a+?) into :result from (select 1 union select 2) t(a)'
execute s using 1
deallocate prepare s;

select bit_xor(a+1) into :expected from (select 1 union select 2) t(a);
select case when (:expected = :result) then 'YES' else 'NO' end as result;

-- 5
prepare s from 'select bit_count (a+?) into :result from (select 1) t(a)'
execute s using 1
deallocate prepare s;

select bit_count(a+1) into :expected from (select 1) t(a);
select case when (:expected = :result) then 'YES' else 'NO' end as result;


--+ holdcas off;
