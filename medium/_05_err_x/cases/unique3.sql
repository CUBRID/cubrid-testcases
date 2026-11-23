autocommit off;
create class u(i string unique not null);
insert into u values('one');
insert into u values('two');
select * from u order by i;
update u set i='one' where i='two';
select * from u order by i;
rollback;
