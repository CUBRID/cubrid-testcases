autocommit off;
call login('dba','') on class db_user;
CREATE CLASS tbibrs;
call change_owner('tbibrs', 'public') on class db_authorizations;
ALTER CLASS tbibrs ADD ATTRIBUTE
       ibrs_yymm string,
       ibrs_sevcd string,
       ibrs_sevid string,
       ibrs_itemcd string,
       ibrs_gsid string,
       ibrs_appcd string,
       ibrs_subcd string,
       ibrs_qty integer,
       ibrs_amt integer;
drop tbibrs;
rollback WORK;
