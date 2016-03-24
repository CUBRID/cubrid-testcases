--+ holdcas on;
set system parameters 'compat_mode=mysql';
select substring ('abcdef', 2, null) into :result;
evaluate NULL into :expected;
select case when :result <=> :expected then 'YES' else 'NO' end as case1; 
select substring (s, 2, null) into :result from (select 'abcdef' from db_root) t(s);
evaluate NULL into :expected;
select case when :result <=> :expected then 'YES' else 'NO' end as case2;

select substring (s, f, l) into :result from (select 'abcdef', 2, null from db_root) t(s, f, l);
evaluate NULL into :expected;
select case when :result <=> :expected then 'YES' else 'NO' end as case3;

select substring ('abcdef', 2) into :result;
evaluate 'bcdef' into :expected;
select case when :result = :expected then 'YES' else 'NO' end as case4;

select substring (s, 2) into :result from (select 'abcdef' from db_root) t(s);
evaluate 'bcdef' into :expected;
select case when :result = :expected then 'YES' else 'NO' end as case5;

select substring (s, f) into :result from (select 'abcdef', 2 from db_root) t(s, f);
evaluate 'bcdef' into :expected;
select case when :result = :expected then 'YES' else 'NO' end as case6;

select substring ('abc', null, 10) into :result;
evaluate NULL into :expected;
select case when :result <=> :expected then 'YES' else 'NO' end as case7;

select substring (null, 1, 10) into :result;
evaluate NULL into :expected;
select case when :result <=> :expected then 'YES' else 'NO' end as case8;

set system parameters 'compat_mode=cubrid';
select substring ('abcdef', 2, null) into :result;
evaluate NULL into :expected;
select case when :result <=> :expected then 'YES' else 'NO' end as case1; 
select substring (s, 2, null) into :result from (select 'abcdef' from db_root) t(s);
evaluate NULL into :expected;
select case when :result <=> :expected then 'YES' else 'NO' end as case2;

select substring (s, f, l) into :result from (select 'abcdef', 2, null from db_root) t(s, f, l);
evaluate NULL into :expected;
select case when :result <=> :expected then 'YES' else 'NO' end as case3;

select substring ('abcdef', 2) into :result;
evaluate 'bcdef' into :expected;
select case when :result = :expected then 'YES' else 'NO' end as case4;

select substring (s, 2) into :result from (select 'abcdef' from db_root) t(s);
evaluate 'bcdef' into :expected;
select case when :result = :expected then 'YES' else 'NO' end as case5;

select substring (s, f) into :result from (select 'abcdef', 2 from db_root) t(s, f);
evaluate 'bcdef' into :expected;
select case when :result = :expected then 'YES' else 'NO' end as case6;

select substring ('abc', null, 10) into :result;
evaluate NULL into :expected;
select case when :result <=> :expected then 'YES' else 'NO' end as case7;

select substring (null, 1, 10) into :result;
evaluate NULL into :expected;
select case when :result <=> :expected then 'YES' else 'NO' end as case8;
commit;
--+ holdcas off;
