autocommit off;
create class a (a_i set(int));
create class b (a_i set(int));
insert into a values({1,1});
insert into a values({1,2});
insert into b values({1,1,3});
insert into b values({2,2});
select count(*) from a,b where a.a_i subset(b.a_i);
rollback;
