autocommit off;
create view foo 
(name char(25), n_name char(25))
as select name2, 'nonupdatable '+name2 from joe.faculty2;
select * from foo order by 1,2;
update foo set name = 'ok';
select * from foo order by 1,2;

rollback;
