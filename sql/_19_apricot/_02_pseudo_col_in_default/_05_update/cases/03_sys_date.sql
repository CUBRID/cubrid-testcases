CREATE TABLE tst (i int, d date default sys_date);

insert into tst values (1, date'2011-01-01');
insert into tst values (2, date'2011-02-02');
insert into tst values (3, date'2011-03-03');
insert into tst values (4, date'2011-04-04');

select * from tst order by 1,2;

update tst set d = default where i > 2;

select if (abs(d - SYS_DATE) <= 1 , 'ok', 'nok') from tst where i > 2;

update tst set d = default, i = i + 10 where i <= 2;

select if (abs(d - SYS_DATE) <= 1 , 'ok', 'nok') from tst where i > 10;

drop table tst;

CREATE TABLE tst (i int, d date default sys_date, dc double default 10);

insert into tst values (1, date'2011-01-01', 11);
insert into tst values (2, date'2011-02-02', 12);
insert into tst values (3, date'2011-03-03', 13);
insert into tst values (4, date'2011-04-04', 14);

select * from tst order by 1,2;

update tst set d = default, dc = default where i > 2;

select if (abs(d - SYS_DATE) <= 1 and dc = 10, 'ok', 'nok') from tst where i > 2;

update tst set d = default, dc = default, i = i + 10 where i <= 2;

select if (abs(d - SYS_DATE) <= 1 and dc = 10, 'ok', 'nok') from tst where i > 10;

drop table tst;
