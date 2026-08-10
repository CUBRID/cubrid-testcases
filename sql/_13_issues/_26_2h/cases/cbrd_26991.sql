/**
 * This test case verifies CBRD-26991: call add_member() returns no result on NULL target.
 *
 * Pre-fix, calling add_member() on a NULL target silently succeeds with
 * "Execute OK" and no result set or error. Post-fix, the parser rejects
 * literal NULL targets and the runtime rejects NULL bind-variable targets
 * with an error ("Methods require an object as their target.").
 *
 * Coverage:
 * 1. add_member with valid user on valid group target
 * 2. add_member with nonexistent user on valid group target
 * 3. call add_member on literal NULL target
 * 4. call drop_member on literal NULL target
 * 5. find_user for nonexistent group returns NULL, add_member on that
 * 6. set_password on runtime-NULL target
 * 7. drop_member on runtime-NULL target
 * 8. set_password on literal NULL target
 */

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

evaluate 'Case 6. set_password on runtime-NULL target (runtime path)';
call set_password('newpw') on nullgrp;

evaluate 'Case 7. drop_member on runtime-NULL target (runtime path)';
call drop_member('test_user_26991') on nullgrp;

evaluate 'Case 8. set_password on literal NULL target (parser path)';
call set_password('newpw') on null;

-- Cleanup
drop user test_user_26991;
drop user test_group_26991;
