create table foo ( a varchar(100));
insert into foo values ('aaa');
insert into foo values ('Aaa');
insert into foo values ('Ass');
insert into foo values ('ABa');
insert into foo values ('aAa');
insert into foo values ('Baa');
insert into foo values ('bAaa');


select /*+ RECOMPILE */ * from foo where (a like 'A%' or a like 'a%') order by 1;



select /*+ RECOMPILE */ * from foo where lower(a) like 'a%' order by 1;


create table cnf (a varchar(20));
insert into cnf values ('a'), ('A');

select /*+ recompile */ * from cnf where a = 'a' or a = 'A' order by 1; 
select /*+ recompile */ * from cnf where a = 'a' or A = 'A' order by 1; 
select /*+ recompile */ * from cnf where a = 'a' or a = 'a' order by 1; 
select /*+ recompile */ * from cnf where a = 'a' or A = 'a' order by 1;


drop foo;
drop cnf;


