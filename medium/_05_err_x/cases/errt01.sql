autocommit off;

create class cxs (s char(7));
insert into cxs values('1234567'); 
select * from cxs;
insert into cxs values('abcdefgh'); 
rollback;
