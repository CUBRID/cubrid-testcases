-- This is a test case to verify the CBRD-24780 issue.
-- Check if an error occurs when casting an empty string to bigint.
drop table if exists test;
create table test(aa bigint, bb int, cc varchar(100));
insert into test(aa, bb, cc) values ('','','');
select * from test;
select cast ('' as bigint);
drop table if exists test;
