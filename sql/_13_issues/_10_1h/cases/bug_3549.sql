--+ holdcas on;
prepare s from 'select power(?, ?) into :result'
execute s using 2, 3;

evaluate power(2, 3) into :expected; 

select case when :expected = :result then 'YES' else 'NO' end as case1;

prepare s from 'select power(2, ?) into :result'
execute s using 3;

evaluate power(2, 3) into :expected; 

select case when :expected = :result then 'YES' else 'NO' end as case2;

prepare s from 'select power(2, ?) into :result'
execute s using 3;

evaluate power(2, 3) into :expected; 

select case when :expected = :result then 'YES' else 'NO' end as case3;

prepare s from 'select power(?, ?) into :result'
execute s using 2.0f, 3.0f;

evaluate power(2.0f, 3.0f) into :expected; 

select case when :expected = :result then 'YES' else 'NO' end as case4;

prepare s from 'select power(?, ?) * PI() into :result'
execute s using 2.0f, 3.0f;

evaluate power(2.0f, 3.0f) * PI() into :expected; 

select case when :expected = :result then 'YES' else 'NO' end as case5;

prepare s from 'select power(?, ?) into :result'
execute s using NULL, NULL;

evaluate power(NULL, NULL) into :expected; 

select case when :expected <=> :result then 'YES' else 'NO' end as case6;
drop prepare s;

--+ holdcas off;
