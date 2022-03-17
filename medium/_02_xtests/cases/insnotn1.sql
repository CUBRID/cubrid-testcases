autocommit off;
create class y (n int not null);
insert into y default values;
drop y;
rollback;
