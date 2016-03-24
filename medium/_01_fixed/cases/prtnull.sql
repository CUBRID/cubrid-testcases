autocommit off;
create class temp1 (at1 int);
create class temp2 (at1 temp1);
insert into temp2 (at1) values (insert into temp1 (at1) values (123));
select * from temp2;
drop class temp1;
select * from temp2;
rollback work;
rollback;
