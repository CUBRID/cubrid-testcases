autocommit off;
evaluate 'fred' to :p1;
create view facv as select * from joe.faculty where fname=:p1;
select * from facv;
evaluate 'joe' to :p1;
select * from facv;
rollback;
