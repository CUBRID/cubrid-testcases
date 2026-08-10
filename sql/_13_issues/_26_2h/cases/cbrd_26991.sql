/**
 * This test case verifies CBRD-26991: call add_member() returns no result on NULL target.
 *
 * Pre-fix, calling add_member() on a NULL target silently succeeds with
 * "Execute OK" and no result set or error. Post-fix, the parser rejects
 * literal NULL targets and the runtime rejects NULL bind-variable targets
 * with an error ("Methods require an object as their target.").
 *
 * Coverage:
 * 1. add_member with valid user on valid group target - returns result (NULL)
 * 2. add_member with nonexistent user on valid group target - Error:-165
 * 3. call add_member on literal NULL target - parser error (Error:-493)
 * 4. call drop_member on literal NULL target - parser error (Error:-493)
 * 5. find_user for nonexistent group returns NULL, add_member on that - runtime error (Error:-495)
 * 6. add_member with valid user on runtime-NULL target - runtime error (Error:-495)
 * 7. drop_member on runtime-NULL target - runtime error (Error:-495)
 */

autocommit off;

call login('dba','') on class db_user;

-- Setup: create test users
create user test_user_26991;
create user test_group_26991 groups dba;

evaluate 'Case 1. add_member with valid user on valid group target';
call find_user('test_group_26991') on class db_user to grp;
call add_member('test_user_26991') on grp;

evaluate 'Case 2. add_member with nonexistent user on valid group target';
call add_member('no_such_user_26991') on grp;

evaluate 'Case 3. call add_member on literal NULL target (parser path)';
call add_member('test_user_26991') on null;

evaluate 'Case 4. call drop_member on literal NULL target (parser path)';
call drop_member('test_user_26991') on null;

evaluate 'Case 5. find_user for nonexistent group returns NULL, add_member on that (runtime path)';
call find_user('no_such_group_26991') on class db_user to nullgrp;
call add_member('test_user_26991') on nullgrp;

evaluate 'Case 6. add_member with valid user on runtime-NULL target (runtime path)';
call add_member('test_user_26991') on nullgrp;

evaluate 'Case 7. drop_member on runtime-NULL target (runtime path)';
call drop_member('test_user_26991') on nullgrp;

-- Cleanup
drop user test_user_26991;
drop user test_group_26991;

rollback;

autocommit on;
