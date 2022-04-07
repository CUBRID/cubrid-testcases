autocommit off;
--set optimization: level 257
select f.name from joe.faculty1 f, joe.faculty1 g where f.name='joe' and f.name=g.name;
select f.name from joe.faculty1 f, joe.faculty1 g, joe.faculty1 h
where h.name=f.name and f.name='joe' and f.name=g.name;
select f.name from joe.faculty1 f, joe.faculty1 g, joe.faculty1 h
where h.name=g.name and f.name='joe' and f.name=g.name;
select f.name from joe.faculty1 f, joe.faculty1 g, joe.faculty1 h
where h.name=g.name and f.name=g.name and f.name='joe';
rollback;
