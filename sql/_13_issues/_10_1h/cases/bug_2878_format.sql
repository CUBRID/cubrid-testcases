--+ holdcas on;
evaluate format('12332.123456', 4) into :expected;

prepare s from 'select format(?, ?) into :result' 
execute s using '12332.123456', 4
deallocate prepare s;
select case when :expected = :result then 'YES' else 'NO' end as case1;

prepare s from 'select format(?, ?) into :result' 
execute s using '12332.123456', '4'
deallocate prepare s;
select case when :expected = :result then 'YES' else 'NO' end as case2;

prepare s from 'select format(?, ?) into :result' 
execute s using 12332.123456, 4
deallocate prepare s;
select case when :expected = :result then 'YES' else 'NO' end as case3;

prepare s from 'select format(?, ?) into :result' 
execute s using 12332.123456, '4'
deallocate prepare s;
select case when :expected = :result then 'YES' else 'NO' end as case4;


--+ holdcas off;
