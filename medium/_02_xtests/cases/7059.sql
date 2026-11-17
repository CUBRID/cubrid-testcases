autocommit off;
create class xxx (description char varying(25));
create class main (id integer, name xxx);
insert into xxx values ('Problem Report') into :x;
insert into main values (1, :x);
insert into xxx values (NULL) into :y;
insert into main values (2, :y);
select id, name.description from main order by main.id;
select main.id, description from xxx, main where main.name = xxx order by main.id;
select main.id, description from main , xxx where main.name = xxx order by main.id;
select main.id, description from xxx, main where xxx = main.name order by main.id;
insert into main values (3,NULL);
select main.id, description from xxx, main where xxx = main.name order by main.id;
select main.id, description from main, xxx where xxx = main.name order by main.id;
select main.id, description
  from xxx, main
 where main.name = (select xxx from class db_user)
 order by main.id;
select main.id, description
  from xxx, main
 where main.name in (select xxx from class db_user)
 order by main.id;
--set optimization: level 257;
select description
  from xxx x1
 where x1 in {(select x2 from xxx x2 where x2 = x1)}
 order by description desc nulls last;
rollback;
