--+ holdcas on;
evaluate NULL into :expected;

select atan(null, 2) into :result;
select case when :expected <=> :result then 'YES' else 'NO' end as case1;

select atan(2, null);
select case when :expected <=> :result then 'YES' else 'NO' end as case2;

select atan(null, null);
select case when :expected <=> :result then 'YES' else 'NO' end as case3;

select atan2(null, 2);
select case when :expected <=> :result then 'YES' else 'NO' end as case4;

select atan2(2, null);
select case when :expected <=> :result then 'YES' else 'NO' end as case5;

select atan2(null, null);
select case when :expected <=> :result then 'YES' else 'NO' end as case6;

select power(null, 10);
select case when :expected <=> :result then 'YES' else 'NO' end as case7;

select power(10, null);
select case when :expected <=> :result then 'YES' else 'NO' end as case8;

select power(null, null);
select case when :expected <=> :result then 'YES' else 'NO' end as case9;


--+ holdcas off;
