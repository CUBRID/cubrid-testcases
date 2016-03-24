autocommit off;
create view boo as select * from faculty where ssn > 5 with check option;
insert into boo(ssn) values(1);
rollback;
