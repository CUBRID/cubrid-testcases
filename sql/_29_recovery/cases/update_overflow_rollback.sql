autocommit off;
create table foo (a int, b varchar(50000));
insert into foo values (1, 'a');
commit;
update foo set b=rpad('a',20000,'b') where a=1;
update foo set b=rpad('a',40000,'b') where a=1;
rollback;
drop table foo;
autocommit on;
