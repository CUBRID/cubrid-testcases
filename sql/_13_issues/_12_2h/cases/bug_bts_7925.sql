--TEST: [Merge Statement] 'Invalid XASL tree node content.' error occurs when using a constant filter predicate in a merge statement


create table target(
        col1 int auto_increment primary key,
        col2 smallint,
        col3 char(30) default 'abc',
        col4 date default SYSDATE
);

insert into target(col2, col3, col4) values(500, 'cubrid', '1990-10-10');
insert into target(col2, col3, col4) values(500, 'cubrid', '1990-11-10');
insert into target(col2, col3, col4) values(500, 'mysql', '1990-10-11' );


create table source(
        col1 int auto_increment primary key,
        col2 smallint,
        col3 char(30) default 'abc',
        col4 date default SYSDATE
);

insert into source(col2, col3, col4) values(503, 'mysql', '1992-10-10' );
insert into source(col2, col3, col4) values(503, 'cubrid', '1990-10-10');
insert into source(col2, col3, col4) values(503, 'cubrid', '1990-10-10');


merge into target t
using source s
on (1 = 2)
when matched then
update
set t.col1 = s.col1;


merge into target t
using source s
on false
when matched then
update
set s.col1 = t.col1;


drop table target, source;

