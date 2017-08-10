create table testt(id int,v varchar(20),f float, c varchar(10));
insert into testt values(NULL,'abc',5.64,'45d');
insert into testt values(NULL,'45d',-3.44,'df');

select /*+ recompile */ * from testt where (select ('aaa' regexp 'a{6,}')) order by 2;
select /*+ recompile */ * from testt where (select (not 'aaa' regexp 'a{6,}')) order by 2;
select /*+ recompile */ * from testt where (select ('aaa' not regexp 'a{6,}')) order by 2;
select /*+ recompile */ * from testt where (select 0) order by 2;
select /*+ recompile */ * from testt where (select 1) order by 2;
select /*+ recompile */ * from testt where (select ('aaa' like 'bbb')) order by 2;
select /*+ recompile */ * from testt where (select ('aaa' like 'aaa')) order by 2;
select /*+ recompile */ * from testt where (select ('aaa' not like 'aaa')) order by 2;
select /*+ recompile */ * from testt where id = 0 order by 2;
select /*+ recompile */ * from testt where (NULL) order by 2;

drop testt;

