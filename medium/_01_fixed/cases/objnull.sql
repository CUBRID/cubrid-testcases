autocommit off;
create class par (name string);
insert into par values('one') to o1;
create class u(c par);
insert into u values(o1);
select * from u where c is null;
select * from u where c is not null;
rollback;
