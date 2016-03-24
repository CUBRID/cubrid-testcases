autocommit off;
create class bat (bt int);
create class baz1 (bz1 int);
create class baz2 (bz2 int, sb bat);
create class bar (bn int, fz1 baz1, fz2 baz2);
create class foo (fn int, fb bar);
select fn, fb.bn from foo where fb.bn is null;
select fn, fb.fz1.bz1 from foo where fb.fz1.bz1 is null;
select fn, fb.fz1.bz1, fb.fz2.bz2 from foo 
where fb.fz1.bz1 is null and fb.fz2.bz2 is null;
select fn, fb.fz1.bz1, fb.fz2.bz2 from foo 
where fb.fz1.bz1 is null;
select fn, fb.fz1.bz1, fb.fz2.bz2 from foo 
where fb.fz2.bz2 is null;
select x.fn, x.fb.fz1.bz1, y.fb.fz2.bz2 from foo x, foo y
where x.fb.fz1.bz1 is null and y.fb.fz2.bz2 is null;
select fn from foo x
where fb.fz2.sb.bt is null;
select fn from foo x
where fn = 1 and fb.fz2.sb.bt is null;
select fn from foo x
where fb.fz2.sb.bt is null and fn = 1;
select fn from foo x
where fn = 1 or fb.fz2.sb.bt is null;
select fn from foo x
where fb.fz2.sb.bt is null or fn = 1;
select fn from foo x
where fn = 1 and fb.fz2.sb.bt is null and fn <> 20 ;
select fn from foo x
where fn = 2 or fb.fz2.sb.bt is null or fn = 1;
select fn from foo where fb is null;
delete from foo
where fn = 2 or fb.fz2.sb.bt is null or fn = 1;
update foo
set fn = 4
where fn = 2 or fb.fz2.sb.bt is null or fn = 1;
drop bat, baz1, baz2, bar, foo;
rollback;
