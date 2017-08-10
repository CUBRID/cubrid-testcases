-- test coverage

create table tab1 (s set(integer), n national char varying(10), n1 varchar(10));
insert into tab1 values({1},n'123','123');
insert into tab1 values({1},n'123','123');

-- should fail
select group_concat(s) from tab1 group by s;

-- should fail
select group_concat(n separator '+') from tab1 group by s;

-- should fail
select group_concat(n1 separator n'+') from tab1 group by s;

drop table tab1;

