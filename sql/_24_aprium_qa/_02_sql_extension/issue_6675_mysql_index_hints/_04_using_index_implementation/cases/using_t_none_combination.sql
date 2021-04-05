--USING INDEX t.NONE combined with other hints

--+ holdcas on;


create table ui(i1 int primary key, i2 float, i3 varchar(1073741823), i4 date);

create unique index idx_i2 on ui(i2);
create index idx_i3 on ui(i3);
create index idx_i4 on ui(to_date(i4));
create index idx_i1_i2 on ui(i1, i2);
create index idx_i2_i3 on ui(i2, i3) where i2 > 10;
create index idx_i4_i3 on ui(i4, i3);
create index idx_i3_i4_i2 on ui(i3, i4, i2);
create index idx_all on ui(i2, i3, i4, i1);


insert into ui values(1, 8, 'ccc', '1999-1-1');
insert into ui values(3, 18, 'bbb', '1996-1-1');
insert into ui values(5, 28, null, '1992-1-1');
insert into ui values(8, 100, 'aaa', '1998-1-1');
insert into ui values(9, -10, 'ddd', '1998-1-1');
insert into ui values(2, null, 'bbb', '1991-1-1');
insert into ui values(4, 10, 'ccc', '1994-1-1');
insert into ui values(7, null, 'aaa', '1995-1-1');
insert into ui values(6, 3.3, 'ccc', '1999-1-1');
insert into ui values(10, 11.1, 'ddd', '1997-1-1');

update statistics on ui;


--TEST: [er] with use index 
select /*+ recompile */ * from ui use index(pk_ui_i1) where i1 < 5 USING INDEX ui.NONE;
select /*+ recompile */ * from ui use index(ui.none) where i1 < 5;
--TEST: [er] with force index
select /*+ recompile */ * from ui force index(idx_i1_i2, idx_all) where i1 < 5 USING INDEX ui.NONE;
select /*+ recompile */ * from ui force index(ui.none) where i1 < 5;
--TEST: with ignore index
select /*+ recompile */ * from ui ignore index(idx_i2_i3) where i1 < 5 USING INDEX ui.NONE order by 1;
select /*+ recompile */ * from ui ignore index(idx_i2_i3, ui.none) where i1 < 5 order by 1;

--TEST: [er] with using index
select /*+ recompile */ * from ui where i2 > 9 USING INDEX ui.NONE, idx_i2 order by 1;
--TEST: with index(-)
select /*+ recompile */ * from ui where i2 > 10 or i2 is null USING INDEX ui.NONE, idx_i3(-), idx_i2(-);
--TEST: [er] with index(+)
select /*+ recompile */ * from ui where i2 < 10 USING INDEX ui.NONE, idx_i2_i3(+) order by 1;

--TEST: [er] with USING INDEX ALL EXPECT
 select /*+ recompile */ * from ui where i2 < 10 USING INDEX ALL EXCEPT ui.NONE;

--TEST: [er] mix
select /*+ recompile */ * from ui use index(idx_i3, idx_i4_i3), ignore index(idx_i3) where i3 < 'ddd' USING INDEX ui.NONE;
select /*+ recompile */ * from ui ignore index(idx_i2_i3) where i3 < 'ddd' and i3 is not null USING INDEX ui.NONE, idx_i3(-) order by 1;
select /*+ recompile */ * from ui use index(idx_i3), ignore index(idx_i2, idx_i2_i3, idx_i1_i2), ignore index(idx_i3) where i3 < 'ddd' and i3 USING INDEX ui.NONE;
select /*+ recompile */ * from ui where i1 > 5 and i2 > 12 USING INDEX idx_i2, idx_i2(-), ui.NONE;
select /*+ recompile */ * from ui where i3 in ('aaa', 'ddd') and i4 = '1998-1-1' USING INDEX idx_i2_i3(-), ui.NONE, idx_all(+);
select /*+ recompile */ * from ui ignore index(pk_ui_i1, idx_i2, idx_i1_i2, idx_i3, idx_i3_i4_i2, idx_i4, idx_i4_i3, idx_all), use index(idx_i4, idx_all), use index(idx_i2, idx_i3_i4_i2, idx_i4) where i1 < 4 and i2 > 5 and i3 is not null and to_date(i4) > '1995-1-1' USING INDEX ui.NONE, idx_all(-);



drop table ui;
commit;


--+ holdcas off;
