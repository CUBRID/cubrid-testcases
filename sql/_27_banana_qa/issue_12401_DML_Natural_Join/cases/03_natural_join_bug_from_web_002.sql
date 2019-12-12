

--03_natural_join_bug_from_web_002.sql
drop table if exists a,b;
create table a( id int,  id_e int,fe int,id_u int);
create table b( id int,  id_e int,fe int,id_u int);
insert into a values(1, 2, -1,1);
insert into a values(2, 2, -2,1);
insert into a values(4, 2, -3,2);
insert into b values(1, 2, -4,1);
insert into b values(2, 2, -5,2);
insert into b values(3, 3, -6,1);
SELECT `a`.`id`,`a`.`id_e`,`a__id_e`.`id`,`a__id_e`.`id_e`
FROM `a`
   INNER JOIN `b` AS `a__id_e`
   ON `a`.`id_e` = `a__id_e`.`id_e` and `a`.`id` = `a__id_e`.`id` 
   and `a`.`fe` = `a__id_e`.`fe` and `a`.`id_u` = `a__id_e`.`id_u` 
   order by 1,2;

SELECT `a`.`id`,`a`.`id_e`,`a__id_e`.`id`,`a__id_e`.`id_e`
FROM `a`
   NATURAL JOIN `b` AS `a__id_e`
   order by 1,2;


SELECT `a`.`id`,`a`.`id_e`,`a__id_e`.`id`,`a__id_e`.`id_e`
FROM `a`
   INNER JOIN `b` AS `a__id_e`
   ON `a`.`id_e` = `a__id_e`.`id_e` 
WHERE (`a__id_e`.`id_u` = '1')
ORDER BY `a__id_e`.`fe` ASC, 1;

SELECT `a`.`id`,`a`.`id_e`,`a__id_e`.`id`,`a__id_e`.`id_e`
FROM `a`
   NATURAL JOIN `b` AS `a__id_e`
WHERE (`a__id_e`.`id_u` = '1')
ORDER BY `a__id_e`.`fe` ASC;

drop table if exists a,b;

drop table if exists a,b;
create table a( id int,  id_e int,fe int,id_u int);
create table b( id int,  id_e int,fe int,id_u int);
insert into a values(1, 2, -1,1);
insert into a values(2, 2, -2,1);
insert into a values(4, 2, -3,2);
insert into b values(1, 2, -4,1);
insert into b values(2, 2, -5,2);
insert into b values(3, 3, -6,1);


SELECT a.id,a.id_e,a__id_e.id,a__id_e.id_e
FROM a
   INNER JOIN b AS a__id_e
   ON a.id_e = a__id_e.id_e order by 1,2,3;

SELECT a.id,a.id_e,a__id_e.id,a__id_e.id_e
FROM a
   NATURAL JOIN b AS a__id_e
   order by 1,2,3;

SELECT a.id,a.id_e,a__id_e.id,a__id_e.id_e
FROM a
   INNER JOIN b AS a__id_e
   ON a.id_e = a__id_e.id_e 
WHERE (a__id_e.id_u = '1')
ORDER BY a__id_e.fe ASC,1;

SELECT a.id,a.id_e,a__id_e.id,a__id_e.id_e
FROM a
   NATURAL JOIN b AS a__id_e
   ON a.id_e = a__id_e.id_e 
WHERE (a__id_e.id_u = '1')
ORDER BY a__id_e.fe ASC;

drop table if exists a,b;


drop table if exists a,b;
create table a( id int,  id_e int,fe int,id_u int);
create table b( id int,  id_e int,fe int,id_u int);
insert into a values(1, 2, -1,1);
insert into a values(2, 2, -2,1);
insert into a values(4, 2, -3,2);
insert into b values(1, 2, -4,1);
insert into b values(2, 2, -5,2);
insert into b values(3, 3, -6,1);
delete from a inner join b on a.id = b.tid;
delete from a natural join b;
update a ,b set a.id_e=1 from a inner join b on a.id = b.id;
select * from a order by 1,2,3,4;
select * from b order by 1,2,3,4;
drop table if exists a,b;
