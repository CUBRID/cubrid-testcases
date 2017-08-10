--TEST: Inappropriate filtered index has been used and data result is incorrect when selecting with using index idx(-) hint.

drop table if exists ui;

create table ui(i1 int, i2 int, i3 int);

create index idx_i1_i2 on ui(i1, i2);
--create a filtered index 
create index idx_i2_i3 on ui(i2, i3) where i2 > 10;

insert into ui values(1, 8, 100);
insert into ui values(3, 18, 100);
insert into ui values(5, 28, null);


--filtered index has been used without being specified in using index clause
select /*+ recompile */ * from ui where i1 < 4 and i2 > 5 using index idx_i1_i2(-) order by 1;
select /*+ recompile */ * from ui ignore index(idx_i1_i2) where i1 < 4 and i2 > 5 order by 1;


drop table ui;







