--this case was write for bts cubridsus-1168

create table foo(j int);

insert into foo values(3);
insert into foo values(4);

select j from foo order by j for orderby_num()=1;

select * from (select j from foo order by j for orderby_num()=1) a where j <>3; 

drop table foo;