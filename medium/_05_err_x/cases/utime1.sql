autocommit off;
insert into oo (b) values (9);
select * from oo;
rollback work;
rollback;
