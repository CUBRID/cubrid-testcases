autocommit off;
--set optimization: level 257
select f.name from faculty1 f, faculty1 g where f.name='joe' and f.name=g.name
select f.name from faculty1 f, faculty1 g, faculty1 h
where h.name=f.name and f.name='joe' and f.name=g.name
select f.name from faculty1 f, faculty1 g, faculty1 h
where h.name=g.name and f.name='joe' and f.name=g.name
select f.name from faculty1 f, faculty1 g, faculty1 h
where h.name=g.name and f.name=g.name and f.name='joe' 
rollback;
