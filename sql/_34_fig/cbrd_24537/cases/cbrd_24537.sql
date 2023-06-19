-- This is a test case to verify the CBRD-24537 issue.
-- When performing a NOT MATCHED check, use the NOT EXISTS query instead of the COUNT query.

drop table if exists src;
drop table if exists tt;

create table src (s int);
create table tt (t int, str varchar);
insert into src values (1), (2), (3);

--@queryplan
merge /*+ recompile */ into tt using src d on 'a' = 'a'  when not matched then insert values (999, 'abcd') where d.s = 3;

drop table if exists src;
drop table if exists tt;

