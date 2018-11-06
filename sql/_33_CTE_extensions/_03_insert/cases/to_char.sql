drop if exists tbl;
CREATE TABLE tbl(id int auto_increment,a TIME default '12:00:00', b DATE default '1988-10-10', c TIMESTAMP default '1988-10-10 10:10:00', d DATETIME default '1988-10-10 10:10:00.0');
INSERT INTO tbl VALUES(1,'10:00:00', '2000-10-1', '2000-10-1 10:00:00:35', '2000-10-1 10:00:00:358');

insert into tbl(c) 
with mycte as
(
 SELECT TO_CHAR(c, 'HH:MI:SS AM MM/DD/YYYY') FROM tbl
) select * from mycte; 
select c from tbl where id=2;

insert into tbl(d)
with mycte as
(
 SELECT TO_CHAR(d, 'HH:MI:SS AM MM/DD/YYYY') FROM tbl
) select * from mycte;
select d from tbl where id>2;

insert into tbl(b)
with mycte as
(
 SELECT TO_CHAR(b, ' MM/DD/YYYY') FROM tbl
) select * from mycte;
select b from tbl where id>4

insert into tbl(a)
with mycte as
(
 SELECT TO_CHAR(a, 'HH:MI:SS AM') FROM tbl
) select * from mycte;
select a from tbl where id>8;
drop table tbl;
