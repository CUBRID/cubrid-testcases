autocommit off;
create class s1 (s set(string));
insert into s1 values(NULL);
select * from s1 where s not in {};
rollback;
