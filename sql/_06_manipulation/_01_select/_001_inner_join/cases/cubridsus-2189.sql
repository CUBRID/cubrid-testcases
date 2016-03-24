--this cases was added for cubridsus-2189
create table foo (i int primary key, j int);
create unique index u_idx on foo (i, j);
create index idx on foo (i, j desc); 
insert into foo values (1,1);
insert into foo values (2,2);
insert into foo values (3,3);
select * from foo order by 1,2;
drop table foo;
