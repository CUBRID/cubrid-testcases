
--+ holdcas on;
drop view test;
--good
create view test(score int,score1 set) as
(
    select 40,set{80,90,100}
    UNION ALL
    select 40,set{80,90,100}
);

drop view test;
--bug
create view test(score int,score1 set) as
(
    select 40,set{80,90,100}
    UNION ALL
    select 40,set{80,90,100}
    UNION ALL
    select 40,set{80,90,100}
);
drop view test;
--+ holdcas off;
commit;
