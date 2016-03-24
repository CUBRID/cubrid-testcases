autocommit off;
create class c(s char(10), v varchar(10));
insert into c values('', '');
select s+s from c;
select '' + '' from c;
select v + v from c;
rollback;
