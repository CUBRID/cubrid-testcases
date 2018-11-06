drop if exists tbl;
CREATE TABLE tbl(id int auto_increment,a TIME default '12:00:00', b DATE default '1988-10-10', c TIMESTAMP default '1988-10-10 10:10:00', d DATETIME default '1988-10-10 10:10:00.0');
INSERT INTO tbl VALUES(1,'10:00:00', '2000-10-1', '2000-10-1 10:00:00:35', '2000-10-1 10:00:00:358');

insert into tbl(c) 
with mycte as
(
 SELECT TO_CHAR(c, 'HH:MI:SS AM MM/DD/YYYY') FROM tbl
) select * from mycte; 
with mycte as
(
 SELECT c from tbl where c=timestamp'1988-10-10 10:10:00'
) delete from tbl where c=(select c from mycte);

insert into tbl(d)
with mycte as
(
 SELECT TO_CHAR(d, 'HH:MI:SS AM MM/DD/YYYY') FROM tbl
) select * from mycte;

with mycte as
(
 SELECT d from tbl where d=datetime'1988-10-10 10:10:00.0'
) delete from tbl where d=any(select d from mycte);


INSERT INTO tbl VALUES(1,'10:00:00', '2000-10-1', '2000-10-1 10:00:00:35', '2000-10-1 10:00:00:358');
insert into tbl(b)
with mycte as
(
 SELECT TO_CHAR(b, 'MM/DD/YYYY ') FROM tbl
) select * from mycte;
with mycte as
(
 SELECT b from tbl where b=date'1988-10-10'
) delete from tbl where b=some(select b from mycte);;


INSERT INTO tbl VALUES(1,'10:00:00', '2000-10-1', '2000-10-1 10:00:00:35', '2000-10-1 10:00:00:358');
insert into tbl(a)
with mycte as
(
 SELECT TO_CHAR(a, 'HH:MI:SS AM ') FROM tbl
) select * from mycte;
with mycte as
(
 SELECT a from tbl where a=time'12:00:00'
) delete from tbl where a=all(select a from mycte);;



drop table tbl;
