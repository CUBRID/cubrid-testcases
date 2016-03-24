autocommit off;
evaluate 'fred' to :p1
create view facv as select * from faculty where fname=:p1;
select * from facv;
evaluate 'joe' to :p1;
select * from facv;
rollback;
