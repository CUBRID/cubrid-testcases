CREATE TABLE tst (i int, s string default current_user);

insert into tst values (1, 'user');

select * from tst;

insert into tst(i) values (2);

insert into tst(i) values (3);

insert into tst(i) values (4);

insert into tst(i) values (5);

select if (lower(substring_index(s,'@',1)) = lower(substring_index(current_user,'@',1)), 'ok', 'nok') from tst where s is not null and i > 1;

insert into tst values (6, DEFAULT);

insert into tst values (7, DEFAULT);

select if (lower(substring_index(s,'@',1)) = lower(substring_index(current_user,'@',1)), 'ok', 'nok') from tst where s is not null and i > 5;

create table test_helper (i int);

insert into test_helper values (11);

insert into test_helper values (12);

insert into test_helper values (13);

insert into tst(i) select i from test_helper;

select if (lower(substring_index(s,'@',1)) = lower(substring_index(current_user,'@',1)), 'ok', 'nok') from tst where s is not null and i > 10;

drop table test_helper;

drop table tst;

CREATE TABLE tst (i int, s string default current_user, d double default 10);

insert into tst values (1, 'user', 10);

select * from tst;

insert into tst(i) values (2);

insert into tst(i) values (3);

insert into tst(i) values (4);

insert into tst(i) values (5);

select if (lower(substring_index(s,'@',1)) = lower(substring_index(current_user,'@',1)), 'ok', 'nok') from tst where s is not null and i > 1;

insert into tst values (6, DEFAULT, DEFAULT);

insert into tst values (7, DEFAULT, DEFAULT);

select if (lower(substring_index(s,'@',1)) = lower(substring_index(current_user,'@',1)), 'ok', 'nok') from tst where s is not null and i > 5;

create table test_helper (i int);

insert into test_helper values (11);

insert into test_helper values (12);

insert into test_helper values (13);

insert into tst(i) select i from test_helper;

select if (lower(substring_index(s,'@',1)) = lower(substring_index(current_user,'@',1)), 'ok', 'nok') from tst where s is not null and i > 10;

drop table test_helper;

drop table tst;

CREATE TABLE tst (i int, s string default current_user, d double default 10, s1 string default current_user);

insert into tst values (1, 'user', 10, 'user2');

select * from tst;

insert into tst(i) values (2);

insert into tst(i) values (3);

insert into tst(i) values (4);

insert into tst(i) values (5);

select if (lower(substring_index(s,'@',1)) = lower(substring_index(current_user,'@',1)) and lower(substring_index(s1,'@',1)) = lower(substring_index(current_user,'@',1)), 'ok', 'nok') from tst where s is not null and s1 is not null and i > 1;

insert into tst values (6, DEFAULT, DEFAULT, DEFAULT);

insert into tst values (7, DEFAULT, DEFAULT, DEFAULT);

select if (lower(substring_index(s,'@',1)) = lower(substring_index(current_user,'@',1)) and lower(substring_index(s1,'@',1)) = lower(substring_index(current_user,'@',1)), 'ok', 'nok') from tst where s is not null and s1 is not null and i > 5;

insert into tst(i,d) values (8,11);

insert into tst(i,s1) values (9, 'string1');

insert into tst(i,s) values (10, 'string2');

insert into tst(i,s,d) values (11, 'string3', 12);

insert into tst(i, s, s1) values (12, 'string4', 'string5');

select if (lower(substring_index(s,'@',1)) = lower(substring_index(current_user,'@',1)) and lower(substring_index(s1,'@',1)) = lower(substring_index(current_user,'@',1)), 'ok', 'nok') from tst where s is not null and s1 is not null and i = 8;

insert into tst(i, d, s) values (13, DEFAULT, DEFAULT);

insert into tst(i, s, s1) values (14, DEFAULT, DEFAULT);

insert into tst(i, d, s1) values (15, DEFAULT, DEFAULT);

insert into tst(i, d) values (16, DEFAULT);

insert into tst(i, s) values (17, DEFAULT);

insert into tst(i, s1) values (18, DEFAULT);

insert into tst set i = 19;

insert into tst set i = 20, s = default;

insert into tst set i = 21, s1 = default;

insert into tst set i = 22, d = default;

insert into tst set i = 23, s = default, d = default;

insert into tst set i = 24, s = default, s1 = default;

select if (lower(substring_index(s,'@',1)) = lower(substring_index(current_user,'@',1)) and lower(substring_index(s1,'@',1)) = lower(substring_index(current_user,'@',1)), 'ok', 'nok') from tst where s is not null and s1 is not null and i > 12;

create table test_helper (i int);

insert into test_helper values (25);

insert into test_helper values (26);

insert into test_helper values (27);

insert into tst(i) select i from test_helper;

select if (lower(substring_index(s,'@',1)) = lower(substring_index(user(),'@',1)) and lower(substring_index(s1,'@',1)) = lower(substring_index(user(),'@',1)), 'ok', 'nok') from tst where s is not null and s1 is not null and i > 24;

drop table test_helper;

drop table tst;


