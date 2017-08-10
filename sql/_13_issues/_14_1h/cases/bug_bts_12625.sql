
--+ holdcas on;
drop table if exists sgby;

create class sgby (m int, n int);
insert into sgby values (0, 0);
insert into sgby values (1, 1);
insert into sgby values (2, 2);
insert into sgby values (3, 3);
insert into sgby select m+4, n+4 from sgby;
insert into sgby select m+8, n+8 from sgby;
insert into sgby select m, n+16 from sgby;
insert into sgby select m, n+32 from sgby;
insert into sgby select m, n+64 from sgby;
insert into sgby select m, n+128 from sgby;
insert into sgby select m, n+256 from sgby;
select sum(set
{n}
) from (select * from sgby order by 1,2)sgby group by m;

drop table if exists sgby;

--+ holdcas off;
commit;
