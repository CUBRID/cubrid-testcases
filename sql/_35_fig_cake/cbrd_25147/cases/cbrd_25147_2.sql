-- This scenario varifies CBRD-25147 issue.
-- Add SQL syntax to add users as members of the group.

-- 2. If DBA and DBA group members add general users, verify that the general users have DBA privileges

CREATE USER test_user1;
CREATE USER test_user2;

ALTER USER dba ADD MEMBERS test_user1;
SELECT u.name, x.name as groups FROM db_user AS u, TABLE(u.direct_groups) AS g(x);

CALL login ('test_user1', '') ON CLASS db_user;
-- Attempt to add DBA as a member by a general user: should raise an error:-142
ALTER USER test_user1 ADD MEMBERS dba;

ALTER USER test_user1 ADD MEMBERS test_user2;
SELECT u.name, x.name as groups FROM db_user AS u, TABLE(u.direct_groups) AS g(x);

CALL login ('test_user2', '') ON CLASS db_user;
-- Attempt to add DBA as a member by a general user: should raise an error:-142
ALTER USER test_user2 ADD MEMBERS DBA;

-- Drop multiple users at once
ALTER USER public DROP MEMBERS test_user1, test_user2;
SELECT u.name, x.name as groups FROM db_user AS u, TABLE(u.direct_groups) AS g(x);

CALL login ('dba', '') ON CLASS db_user;
-- Add multiple users at once
ALTER USER public ADD MEMBERS test_user1, test_user2;
SELECT u.name, x.name as groups FROM db_user AS u, TABLE(u.direct_groups) AS g(x);

ALTER USER test_user1 DROP MEMBERS test_user2;
ALTER USER dba DROP MEMBERS test_user1;

DROP USER test_user1;
DROP USER test_user2;
