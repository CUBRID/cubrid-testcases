-- Verification for CBRD-26240
-- Core dump occurs(only debug mode) when using like_match_upper_bound(empty-string) in a query

drop table if exists t;
create table t (s varchar(200));
insert into t values ('abc');

-- Empty-string input (should not crash)
select /*+ RECOMPILE */ like_match_upper_bound('') from t;
select /*+ RECOMPILE */ like_match_upper_bound('') from dual; 
select /*+ RECOMPILE */ like_match_upper_bound('abf') from dual;  
select /*+ RECOMPILE */ like_match_upper_bound('') from dual;

drop table if exists t;
