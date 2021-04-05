--TEST: Appropriate index cannot be selected when using ignore index(idx). (BY DESIGN)	


drop table if exists ui;

create table ui(i1 int primary key, i2 int, i3 char(10), i4 date);

create index idx_i2 on ui(i2);
create index idx_i3_i2 on ui(i3, i2);
create index idx_i2_i3_i4 on ui(i2, i3, i4);

insert into ui values(1, 8, 'ccc', '1999-1-1');

update statistics on ui;

select /*+ recompile */ * from ui ignore index(idx_i2) where i2 = 18;

drop table ui;



create table ui(i1 int primary key, i2 int, i3 char(10), i4 date);

insert into ui values(3, 18, 'bbb', '1996-1-1');

create index idx_i2 on ui(i2);
create index idx_i3_i2 on ui(i3, i2);
create index idx_i2_i3_i4 on ui(i2, i3, i4);

select /*+ recompile */ * from ui ignore index(idx_i2) where i2 = 18;

drop table ui;



