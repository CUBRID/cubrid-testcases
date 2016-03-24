autocommit off;
create class detest
(arg1 real, arg2 int, foo char(1));
insert into detest (foo) values ('y');
create class argtest
class attribute (args sequence ()
default {(select detest from detest where foo = 'y')});
select * from detest;
select args into :p1 from class argtest;
select a.arg1, a.arg2, a.foo from table(:p1) as t(a);
rollback;
