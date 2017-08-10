--TEST: [Merge Statement] Core file dumped when inserting data into the source table in a merge statement.


create table target(
        col1 smallint primary key,
        col2 string not null
);

insert into target values(100, 'aaa');
insert into target values(200, 'bbb');


create table source(
        col1 double,
        col2 varchar not null
);

insert into source values(100, 'ggg');
insert into source values(200, 'hhh');

--core dumped, error expected
merge into target t
using source s
on (t.col1=s.col1)
when matched then
update set t.col2=s.col2
when not matched then
insert(s.col1, s.col2)
values(s.col1, 'inserted');


drop table target, source;
