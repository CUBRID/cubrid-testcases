autocommit off;
create class dd( a monetary, b time, c timestamp);

select * from dd;
drop class dd;

create class dd;

rollback;
