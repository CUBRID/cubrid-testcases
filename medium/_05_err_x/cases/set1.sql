autocommit off;
insert into hs(a) values({1,'1'});
select * from hs;
rollback work;
rollback;
