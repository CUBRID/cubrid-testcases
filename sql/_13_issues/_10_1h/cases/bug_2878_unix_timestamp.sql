-- null
prepare s from 'select unix_timestamp (?) into :result'
execute s using null
deallocate prepare s;

evaluate unix_timestamp (null) into :expected;
select case when :expected <=> :result then 'YES' else 'NO' end as case1;

-- na
prepare s from 'select unix_timestamp (?) into :result'
execute s using na
deallocate prepare s;

evaluate unix_timestamp (na) into :expected;
select case when :expected <=> :result then 'YES' else 'NO' end as case2;

