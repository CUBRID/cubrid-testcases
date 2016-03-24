set optimization level 513;

drop table if exists foo;
create table foo (i int, k int);
insert into foo values (1,1);
 
select /*+ recompile */ *
from    foo p
        join foo q on p.i=q.i
        join foo r on q.i=r.i
        join foo s on r.i=s.i
        right join foo t on s.i=t.i
where p.k+q.k=r.k;
drop table foo;
