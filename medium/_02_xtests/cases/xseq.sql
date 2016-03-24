autocommit off;
create class dd(s sequence int);
insert into dd(s) values({});
insert into dd(s) values({NULL});
select * from dd a, dd b where a.s=b.s;
drop dd;
rollback;
