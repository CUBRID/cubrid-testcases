CREATE TABLE tst (i int, d datetime default sys_datetime);

insert into tst values (1, datetime'2011-01-01 12:34:56.789');
insert into tst values (2, datetime'2011-02-02 12:34:56.789');
insert into tst values (3, datetime'2011-03-03 12:34:56.789');
insert into tst values (4, datetime'2011-04-04 12:34:56.789');

select * from tst order by 1,2;

update tst set d = default where i > 2;

select if (abs(d - SYS_DATETIME) <= 86400 , 'ok', 'nok') from tst where i > 2;

update tst set d = default, i = i + 10 where i <= 2;

select if (abs(d - SYS_DATETIME) <= 86400 , 'ok', 'nok') from tst where i > 10;

drop table tst;

CREATE TABLE tst (i int, d datetime default sys_datetime, dc double default 10);

insert into tst values (1, datetime'2011-01-01 12:34:56.789', 11);
insert into tst values (2, datetime'2011-02-02 12:34:56.789', 12);
insert into tst values (3, datetime'2011-03-03 12:34:56.789', 13);
insert into tst values (4, datetime'2011-04-04 12:34:56.789', 14);

select * from tst order by 1,2;

update tst set d = default, dc = default where i > 2;

select if (abs(d - SYS_DATETIME) <= 86400 and dc = 10, 'ok', 'nok') from tst where i > 2;

update tst set d = default, dc = default, i = i + 10 where i <= 2;

select if (abs(d - SYS_DATETIME) <= 86400 and dc = 10, 'ok', 'nok') from tst where i > 10;

drop table tst;
