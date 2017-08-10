-- group_concat char, var char  + ORDER BY ;
-- combination of DISTINCT/ALL + ORDER BY col/number + ASC / DESC + SEPARATOR + GROUP BY 

create table tab1 (name char(10), adr char varying);
insert into tab1 values ( 'google','www.google.com');
insert into tab1 values ( 'google','www.google.com');
insert into tab1 values ( 'yahoo','www.yahoo.com');
insert into tab1 values ( NULL ,'www.google.com');
insert into tab1 values ( 'google',NULL);
insert into tab1 values ( 'cnn','www.cnn.com');
insert into tab1 values ( 'google1','www.google.com');
insert into tab1 values ( 'yahoo1','www.yahoo.com');
insert into tab1 values ( 'google','www.google.us');
insert into tab1 values ( 'yahoo','www.yahoo.us');
insert into tab1 values ( 'yahoo','');
insert into tab1 values ( '','www.google.us');

select name,adr from tab1 order by 1, 2;

-- no separator
select group_concat(name order by name) from tab1 order by 1;

select group_concat(all name order by 1) from tab1 order by 1;

select group_concat(distinct name order by name) from tab1 order by 1;

select group_concat(unique name order by 1) from tab1 order by 1;

select adr,group_concat(name order by 1) from tab1 group by adr;

select adr,group_concat(all name order by name) from tab1 group by adr;

select adr,group_concat(distinct name order by 1) from tab1 group by adr;

select adr,group_concat(unique name order by name) from tab1 group by adr;

select name,group_concat(name order by 1) from tab1 group by name;

select name,group_concat(all name order by name) from tab1 group by name;

select name,group_concat(distinct name order by 1) from tab1 group by name;

select name,group_concat(unique name order by name) from tab1 group by name;

select name,group_concat(adr order by 1) from tab1 group by name;

select name,group_concat(all adr order by adr) from tab1 group by name;

select name,group_concat(distinct adr order by 1) from tab1 group by name;

select name,group_concat(unique adr order by adr) from tab1 group by name;


-- SEPARATOR
select group_concat(name  order by name separator ' + ') from tab1 order by 1;

select group_concat(all name  order by 1 separator ' + ') from tab1 order by 1;

select group_concat(distinct name  order by name separator ' + ') from tab1 order by 1;

select group_concat(unique name order by 1 separator ' + ' ) from tab1 order by 1;

select adr,group_concat(name order by 1 separator ' + ') from tab1 group by adr;

select adr,group_concat(all name  order by 1 separator ' + ') from tab1 group by adr;

select adr,group_concat(distinct name  order by 1 separator ' + ') from tab1 group by adr;

select adr,group_concat(unique name  order by 1 separator ' + ') from tab1 group by adr;

select name,group_concat(name order by 1 separator ' + ') from tab1 group by name;

select name,group_concat(all name order by 1 separator ' + ') from tab1 group by name;

select name,group_concat(distinct name order by 1 separator ' + ') from tab1 group by name;

select name,group_concat(unique name order by 1 separator ' + ') from tab1 group by name;

select name,group_concat(adr order by 1 separator ' + ') from tab1 group by name;

select name,group_concat(all adr order by 1 separator ' + ') from tab1 group by name;

select name,group_concat(distinct adr order by 1 separator ' + ') from tab1 group by name;

select name,group_concat(unique adr order by 1 separator ' + ') from tab1 group by name;


-- no separator, ASC
select group_concat(name order by name asc) from tab1 order by 1;

select group_concat(distinct name order by name asc) from tab1 order by 1;


select name,group_concat(adr order by 1 asc ) from tab1 group by name;

select name,group_concat(distinct adr order by 1 asc ) from tab1 group by name;


-- with  separator, ASC
select group_concat(name order by name asc separator ' + ') from tab1;

select group_concat(distinct name order by name asc separator ' + ') from tab1;


select name,group_concat(adr order by 1 asc separator ' + ') from tab1 group by name;

select name,group_concat(distinct adr order by 1 asc separator ' + ') from tab1 group by name;


-- no separator, DESC
select group_concat(name order by name desc) from tab1;

select group_concat(distinct name order by name desc) from tab1;


select name,group_concat(adr order by 1 desc ) from tab1 group by name;

select name,group_concat(distinct adr order by 1 desc ) from tab1 group by name;


-- with  separator, DESC
select group_concat(name order by name desc separator ' + ') from tab1;

select group_concat(distinct name order by name desc separator ' + ') from tab1;


select name,group_concat(adr order by 1 desc separator ' + ') from tab1 group by name;

select name,group_concat(distinct adr order by 1 desc separator ' + ') from tab1 group by name;


drop table tab1;

