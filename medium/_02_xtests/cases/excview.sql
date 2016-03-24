autocommit off;
create view eview 
as select * from all accommodations (except all resort);
select * from eview
rollback;
