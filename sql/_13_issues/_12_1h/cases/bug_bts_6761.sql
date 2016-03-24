create table foo (a timestamp default SYSTIMESTAMP - 99999999999999999999);
desc foo;
drop foo;

create table foo (a timestamp default SYSTIMESTAMP - 12345678999);
desc foo;
drop foo;

create table foo (a int default 99999999999999999999 - 9999999999999999998);
desc foo;
drop foo;

create table foo (a numeric default 99999999999999999999 - 9999999999999999998);
desc foo;
drop foo;
