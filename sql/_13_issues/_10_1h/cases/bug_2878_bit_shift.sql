-- <<
select 1 << 2 into :expected;

prepare s from 'select ? << ? into :result'
execute s using 1, 2
deallocate prepare s;

select case when (:expected = :result) then 'YES' else 'NO' end as result;

-- >>
select 4 >> 2 into :expected;

prepare s from 'select ? >> ? into :result'
execute s using 4, 2
deallocate prepare s;

select case when (:expected = :result) then 'YES' else 'NO' end as result;

