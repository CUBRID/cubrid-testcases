--+ holdcas on;
autocommit off;
create class c(i string);
insert into c values('humpty dumpty');
select i into me from c;
select i, me from c;
select * from c;
savepoint :me;
delete from c;
select * from c;
rollback work to savepoint :me;
select * from c;
select i, me from c;
rollback work;
rollback;

--+ holdcas off;
