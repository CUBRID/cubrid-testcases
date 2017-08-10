--test with constant filter predicate, with delete clause


autocommit off;


--target table
create table target(
        col1 int auto_increment primary key,
        col2 smallint,
        col3 char(30) default 'abc',
        col4 date default SYSDATE,
        col5 clob
);


--insert 14 rows
insert into target(col2, col3, col4, col5) values(500, 'cubrid', '1990-10-10', 'aello@domainname.com');
insert into target(col2, col3, col4, col5) values(500, 'cubrid', '1990-11-10', 'bello@domainname.com');
insert into target(col2, col3, col4, col5) values(500, 'mysql', '1990-10-11', 'cello@domainname.com');
insert into target(col2, col3, col4, col5) values(500, 'cubrid', '1990-10-10', 'dello@domainname.com');
insert into target(col2, col3, col4, col5) values(500, 'cubrid', '1991-10-10', 'eello@domainname.com');
insert into target(col2, col3, col4, col5) values(501, 'oracle', '1990-10-10', 'fello@domainname.com');
insert into target(col2, col3, col4, col5) values(501, 'cubrid', '1992-10-10', 'gello@domainname.com');
insert into target(col2, col3, col4, col5) values(501, 'oracle', '1990-11-10', 'hello@domainname.com');
insert into target(col2, col3, col4, col5) values(501, 'mysql', '1990-10-10', 'iello@domainname.com');
insert into target(col2, col3, col4, col5) values(501, 'cubrid', '1990-10-10', 'jello@domainname.com');
insert into target(col2, col3, col4, col5) values(501, 'mysql', '1991-11-10', 'kello@domainname.com');
insert into target(col2, col3, col4, col5) values(502, 'cubrid', '1990-10-10', 'lello@domainname.com');
insert into target(col2, col3, col4, col5) values(502, 'mysql', '1990-10-10', 'mello@domainname.com');
insert into target(col2, col3, col4, col5) values(502, 'mysql', '1992-10-10', 'nello@domainname.com');



--source table
create table source(
        col1 int auto_increment primary key,
        col2 smallint,
        col3 char(30) default 'abc',
        col4 date default SYSDATE,
        col5 clob
);


--insert 15 rows
insert into source(col2, col3, col4, col5) values(503, 'mysql', '1992-10-10', 'oello@domainname.com');
insert into source(col2, col3, col4, col5) values(503, 'cubrid', '1990-10-10', 'pello@domainname.com');
insert into source(col2, col3, col4, col5) values(503, 'cubrid', '1990-10-10', 'qello@domainname.com');
insert into source(col2, col3, col4, col5) values(503, 'oracle', '1993-11-10', 'rello@domainname.com');
insert into source(col2, col3, col4, col5) values(503, 'oracle', '1993-10-10', 'sello@domainname.com');
insert into source(col2, col3, col4, col5) values(503, 'cubrid', '1993-11-10', 'tello@domainname.com');
insert into source(col2, col3, col4, col5) values(503, 'cubrid', '1992-10-10', 'uello@domainname.com');
insert into source(col2, col3, col4, col5) values(504, 'mysql', '1994-10-10', 'vello@domainname.com');
insert into source(col2, col3, col4, col5) values(504, 'mysql', '1990-10-10', null);
insert into source(col2, col3, col4, col5) values(504, 'cubrid', '1995-11-10', 'wello@domainname.com');
insert into source(col2, col3, col4, col5) values(505, 'cubrid', '1991-10-10', '');
insert into source(col2, col3, col4, col5) values(505, 'cubrid', '1996-10-10', 'xello@domainname.com');
insert into source(col2, col3, col4, col5) values(505, 'mysql', '1990-10-10', 'yello@domainname.com');
insert into source(col2, col3, col4, col5) values(505, 'cubrid', '1995-10-10', null);
insert into source(col2, col3, col4, col5) values(505, 'cubrid', '1990-10-10', 'zello@domainname.com');

commit;


--TEST: insert with no condition + update + delete, 15 rows inserted
merge into target t
using source s
on (date'1999-12-12' = date'12/13/1999')
when matched then
update
set t.col1 = s.col1, t.col2 = s.col2
delete where t.col1=s.col1
when not matched then
insert(t.col2, t.col3, t.col4, t.col5)
values(s.col2, s.col3, s.col4, s.col5);
--TEST: check merge result
select col1, col2, col3, col4, clob_to_char(col5) from target order by 1;
select count(*), if(count(*) = 29, 'ok', 'nok') from target;
rollback;


--#################### CUBRID BUG: CUBRIDSUS-8271 ##############################
--TEST: error, update with no condition
merge into target t
using source s
on (12 = 12)
when matched then
update
set t.col1 = s.col1, t.col2 = s.col2, t.col3='updated'
delete where year(t.col4)=1990;
--TEST: check merge result
select if(col2 in (select col2 from source), 'nok', 'ok') from target;
select col1, col2, col3, col4, clob_to_char(col5) from target order by 1;
rollback;


--#################### CUBRID BUG: CUBRIDSUS-8271 ##############################
--TEST: error, update with no condition
merge into target t
using source s
on (date'1999-12-12' = date'12/12/1999')
when matched then
update
set t.col2 = 555, t.col3='cubrid'
where t.col1 < 10
delete where t.col2=555
when not matched then
insert(t.col2, t.col3, t.col4, t.col5)
values(s.col2, s.col3, s.col4, s.col5);
--TEST: check merge result
select if(col2 in (select col2 from source), 'nok', 'ok') from target;
select if(count(*)=14, 'ok', 'nok') from target;
rollback;



delete t, s from target t, source s;
drop table target, source;
commit;


autocommit on;












