/* create serial - check if the identifier name includes a dot(.). */

create user u1;
call login ('u1') on class db_user;
create serial u1.s1;

create serial u1.s1.s1;
create serial [s2.s2];
create serial "s3.s3";
create serial `s4.s4`;

call login ('u1') on class db_user;
drop serial s1;
call login ('dba') on class db_user;
drop user u1;
