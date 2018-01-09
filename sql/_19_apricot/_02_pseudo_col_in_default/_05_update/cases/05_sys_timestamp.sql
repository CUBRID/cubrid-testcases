CREATE TABLE tst (i int, ts timestamp default sys_timestamp);

insert into tst values (1, timestamp'2011-01-01 12:34:56');
insert into tst values (2, timestamp'2011-02-02 12:34:56');
insert into tst values (3, timestamp'2011-03-03 12:34:56');
insert into tst values (4, timestamp'2011-04-04 12:34:56');

select * from tst order by 1,2;

update tst set ts = default where i > 2;

select if (abs(ts - SYS_TIMESTAMP) <= 86400 , 'ok', 'nok') from tst where i > 2;

update tst set ts = default, i = i + 10 where i <= 2;

select if (abs(ts - SYS_TIMESTAMP) <= 86400 , 'ok', 'nok') from tst where i > 10;

drop table tst;

CREATE TABLE tst (i int, ts datetime default sys_timestamp, dc double default 10);

insert into tst values (1, timestamp'2011-01-01 12:34:56', 11);
insert into tst values (2, timestamp'2011-02-02 12:34:56', 12);
insert into tst values (3, timestamp'2011-03-03 12:34:56', 13);
insert into tst values (4, timestamp'2011-04-04 12:34:56', 14);

select * from tst order by 1,2;

update tst set ts = default, dc = default where i > 2;

select if (abs(ts - SYS_TIMESTAMP) <= 86400  and dc = 10, 'ok', 'nok') from tst where i > 2;

update tst set ts = default, dc = default, i = i + 10 where i <= 2;

select if (abs(ts - SYS_TIMESTAMP) <= 86400 and dc = 10, 'ok', 'nok') from tst where i > 10;


drop table tst;
