CREATE TABLE tst (i int, s datetime default sys_datetime);

insert into tst values (1, datetime'2011-01-01 12:34:56.789');

select i,s from tst;

insert into tst(i) values (2);

insert into tst(i) values (3);

insert into tst(i) values (4);

insert into tst(i) values (5);

select if (abs(s - SYS_DATETIME) <= 86400 , 'ok', 'nok') from tst where i > 1;

insert into tst values (6, DEFAULT);

insert into tst values (7, DEFAULT);

select if (abs(s - SYS_DATETIME) <= 86400 , 'ok', 'nok') from tst where i > 5;

create table test_helper (i int);

insert into test_helper values (11);

insert into test_helper values (12);

insert into test_helper values (13);

insert into tst(i) select i from test_helper;

select if (abs(s - SYS_DATETIME) <= 86400 , 'ok', 'nok') from tst where i > 10;

drop table test_helper;

drop table tst;

CREATE TABLE tst (i int, s datetime default sys_datetime, d double default 10);

insert into tst values (1, datetime'2011-01-01 12:34:56.789', 10);

select * from tst;

insert into tst(i) values (2);

insert into tst(i) values (3);

insert into tst(i) values (4);

insert into tst(i) values (5);

select if (abs(s - SYS_DATETIME) <= 86400 and d = 10, 'ok', 'nok') from tst where i > 1;

insert into tst values (6, DEFAULT, DEFAULT);

insert into tst values (7, DEFAULT, DEFAULT);

select if (abs(s - SYS_DATETIME) <= 86400 and d = 10, 'ok', 'nok') from tst where i > 5;

create table test_helper (i int);

insert into test_helper values (11);

insert into test_helper values (12);

insert into test_helper values (13);

insert into tst(i) select i from test_helper;

select if (abs(s - SYS_DATETIME) <= 86400 , 'ok', 'nok') from tst where i > 10;

drop table test_helper;

drop table tst;

CREATE TABLE tst (i int, s datetime default sys_datetime, d double default 10, s1 datetime default sys_datetime);

insert into tst values (1, datetime'2011-01-01 01:01:01', 10, datetime'2011-01-01 02:02:02');

select * from tst;

insert into tst(i) values (2);

insert into tst(i) values (3);

insert into tst(i) values (4);

insert into tst(i) values (5);

select if (abs(s - SYS_DATETIME) <= 86400 and s = s1 and d = 10 , 'ok', 'nok') from tst where i > 1;

insert into tst values (6, DEFAULT, DEFAULT, DEFAULT);

insert into tst values (7, DEFAULT, DEFAULT, DEFAULT);

select if (abs(s - SYS_DATETIME) <= 86400 and s = s1 and d = 10 , 'ok', 'nok') from tst where i > 5;

insert into tst(i,d) values (8,11);

insert into tst(i,s1) values (9, datetime'2011-02-02 02:02:02');

insert into tst(i,s) values (10, datetime'2021-02-02 02:02:02');

insert into tst(i,s,d) values (11, datetime'2031-02-02 02:02:02', 12);

insert into tst(i, s, s1) values (12, datetime'2041-02-02 02:02:02', datetime'2051-02-02 02:02:02');

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

select if (abs(s - SYS_DATETIME) <= 86400 and s = s1 and d = 10 , 'ok', 'nok') from tst where i > 12;

create table test_helper (i int);

insert into test_helper values (25);

insert into test_helper values (26);

insert into test_helper values (27);

insert into tst(i) select i from test_helper;

select if (abs(s - SYS_DATETIME) <= 86400 and s = s1 and d = 10 , 'ok', 'nok') from tst where i > 24;

drop table test_helper;

drop table tst;


