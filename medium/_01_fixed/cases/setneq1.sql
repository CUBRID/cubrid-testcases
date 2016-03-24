autocommit off;
create class s1(set1 set(string));
insert into s1 values({});
insert into s1 values({NULL});
select * from s1 where set1 setneq {};
rollback;
