-- Verified for CBRD-25352
-- check to system method

CREATE USER test_user1;
CALL find_user( CLASS db_user, 'DBA' ) to x;

evaluate 'add member test_user1 to dba group';
CALL add_member('TEST_USER1') ON x;

SELECT u.name, x.name as groups FROM db_user AS u, TABLE(u.direct_groups) AS g(x) order by u.name;

CALL find_user('DBA') ON CLASS db_user TO x;

evaluate 'drop member test_user1 from dba group';
CALL drop_member('TEST_USER1') ON x;

SELECT u.name, x.name as groups FROM db_user AS u, TABLE(u.direct_groups) AS g(x) order by u.name;


evaluate 'connect to public user';
CALL login('public', '') ON CLASS db_user;

CALL find_user(CLASS db_user, 'public') TO x;

evaluate 'set password on public user';
CALL set_password('cubrid123') on x;

evaluate 'ERROR: Incorrect or missing password';
CALL login(CLASS db_user, 'public', '');

evaluate 'connect to public user';
CALL login(CLASS db_user, 'public', 'cubrid123');


evaluate 'Test done & connect to dba';
CALL login(CLASS db_user, 'dba', '');
CALL find_user(CLASS db_user, 'public') TO x;
CALL set_password('') on x;
DROP USER test_user1;
