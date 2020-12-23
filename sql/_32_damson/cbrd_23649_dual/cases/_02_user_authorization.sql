---- ok
select * from dual;

---- should fail
insert into dual values ('Y');
delete from dual;
update dual set dummy = 'Y';
drop table dual;

