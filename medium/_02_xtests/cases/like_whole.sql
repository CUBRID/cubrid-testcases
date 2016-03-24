autocommit off;
create table like_test(c char(5), v varchar(5));
insert into like_test values('12345', '12345');
select * from like_test where c like '12345%';
select * from like_test where v like '12345%';
rollback;
