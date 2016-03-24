autocommit off;
create class dd(s sequence smallint);
insert into dd(s) values({});
insert into dd(s) values({NULL});
insert into dd(s) values({1});
insert into dd(s) values({1,2,3});
select * from dd a, dd b where a.s=b.s;
rollback;
