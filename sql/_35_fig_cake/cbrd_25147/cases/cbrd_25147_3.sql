-- This scenario varifies CBRD-25147 issue.
-- Add SQL syntax to add users as members of the group.

-- 3. General users can only add or drop members in their own groups

CREATE USER test_user1;
CREATE USER test_user2;
CREATE USER test_user3;

CALL login ('test_user1', '') ON CLASS db_user;
-- error:-167
ALTER USER public DROP MEMBERS test_user1;
-- error:-167
ALTER USER dba ADD MEMBERS test_user1;
ALTER USER test_user1 ADD MEMBERS dba, test_user2;
SELECT u.name, x.name as groups FROM db_user AS u, TABLE(u.direct_groups) AS g(x);
ALTER USER test_user1 DROP MEMBERS dba;
SELECT u.name, x.name as groups FROM db_user AS u, TABLE(u.direct_groups) AS g(x);

CALL login ('test_user2', '') ON CLASS db_user;
-- error:-167
ALTER USER test_user1 ADD MEMBERS test_user2;
-- error:-167
ALTER USER test_user3 ADD MEMBERS test_user1;
-- error:-142
ALTER USER test_user2 ADD MEMBERS test_user1;
-- Attempt to add both valid(test_user3) and invalid users as members : error:-142
ALTER USER test_user2 ADD MEMBERS test_user3, test_user2, test_user1;
ALTER USER test_user2 ADD MEMBERS test_user3;
SELECT u.name, x.name as groups FROM db_user AS u, TABLE(u.direct_groups) AS g(x);
-- Attempt to drop a mix of existing and non-existing users : error:-168
ALTER USER test_user2 DROP MEMBERS test_user3, test_user2, test_user1;
ALTER USER test_user2 DROP MEMBERS test_user3;
SELECT u.name, x.name as groups FROM db_user AS u, TABLE(u.direct_groups) AS g(x);

-- If a user adds members of the same group, it will perform normally without errors.
CALL login ('test_user1', '') ON CLASS db_user;
ALTER USER TEST_USER1 ADD MEMBERS TEST_USER2;
SELECT u.name, x.name as groups FROM db_user AS u, TABLE(u.direct_groups) AS g(x);

CALL login ('dba', '') ON CLASS db_user;
ALTER USER test_user1 DROP MEMBERS test_user2;

DROP USER test_user1;
DROP USER test_user2;
DROP USER test_user3;
