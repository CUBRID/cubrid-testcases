autocommit off;
create vclass vc(aye int shared 1) as select i from c;
select * from vc;
rollback work;
rollback;
