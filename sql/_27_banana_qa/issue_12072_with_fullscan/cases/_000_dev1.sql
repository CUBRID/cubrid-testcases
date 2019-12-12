create table fullscan (a int);

desc fullscan;
drop table fullscan;

create table fullscan (fullscan int);
desc fullscan;

create index fullscan on fullscan(fullscan);
update statistics on fullscan with fullscan;
show index in fullscan;

drop table fullscan;


