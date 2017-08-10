create table u (i int);

create index idx  on u(i desc);

insert into u values (1), (2), (3), (4), (5), (6), (7), (8), (9);

select i from u where (i < 3) or (i > 7) order by i desc;

drop table u;
