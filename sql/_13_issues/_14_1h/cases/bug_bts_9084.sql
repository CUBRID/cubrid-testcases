
--+ holdcas on;

-- note:correct:
select level from (select 1 as dual) as duall connect by level <= 2 group by level;

--note: wrong:
select level from (select 1 as dual) as dual group by level connect by level <= 2;

--+ holdcas off;
commit;
