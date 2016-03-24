-- add member to public, dba, group user, member, member of dba, others
autocommit off;
call login('dba','') on class db_user;

CREATE USER smith GROUPs dba; 
CREATE USER brown GROUPs public; 
CREATE USER jones; 
CREATE USER engineering MEMBERS dba; 
CREATE USER marketing MEMBERS smith, jones;

create user working members brown;
drop USER working;
DROP USER engineering;
drop user marketing;
DROP user smith;
DROP USER brown;
DROP USER jones; 

rollback;

autocommit on;
