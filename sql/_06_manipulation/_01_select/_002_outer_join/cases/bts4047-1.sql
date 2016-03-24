--Verify CUBRIDSUS4047 bug

create table foo (i int);
create table bar (i int);

insert into foo values (1); 
insert into foo values (1);
insert into foo values (1);
insert into foo values (null);

insert into bar values (1);
insert into bar values (null);

--set optimization level 513;
select //+ RECOMPILE USE_MERGE 
* from foo right outer join bar on foo.i = bar.i order by 1;

select //+ RECOMPILE USE_MERGE
* from foo right outer join bar on bar.i = foo.i order by 1;

select * from foo right outer join bar on bar.i = foo.i order by 1;

select //+ RECOMPILE USE_NL 
* from foo right outer join bar on foo.i = bar.i order by 1;

drop foo;
drop bar;


