autocommit off;
create class lostdata
(a int);
insert into lostdata values (2);
commit work;
select * from lostdata;
update lostdata set a = 3;
select * from lostdata;

select * from lostdata;
drop class lostdata;

commit;
