autocommit off;
create class bowwow (arf int);
insert into bowwow values (10);
insert into bowwow values (NULL);
select count(*) from bowwow;
select count(arf) from bowwow;
rollback;
