autocommit off;
create view eview 
as select * from all public.accommodations (except all public.resort);
select * from eview;
rollback;
