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
) update tbl set d=add_months(d,1) where c=(select c from mycte);
with mycte as
(
 SELECT c from tbl where c=timestamp'1988-10-10 10:10:00'
) delete from tbl;


INSERT INTO tbl VALUES(1,'10:00:00', '2000-10-1', '2000-10-1 10:00:00:35', '2000-10-1 10:00:00:358');
insert into tbl(d)
with mycte as
(
 SELECT TO_CHAR(d, 'HH:MI:SS AM MM/DD/YYYY') FROM tbl
) select * from mycte;
with mycte as
(
 SELECT d from tbl where d>datetime'1988-10-10 10:10:00.0'
) update tbl set c=add_months(c,1) where d=any(select d from mycte);

with mycte as
(
 SELECT d from tbl where d=datetime'1988-10-10 10:10:00.0'
) delete from tbl;


INSERT INTO tbl VALUES(1,'10:00:00', '2000-10-1', '2000-10-1 10:00:00:35', '2000-10-1 10:00:00:358');
insert into tbl(b)
with mycte as
(
 SELECT TO_CHAR(b, 'MM/DD/YYYY ') FROM tbl
) select * from mycte;

with mycte as
(
 SELECT b from tbl where b>date'1988-10-10'
) update tbl set c=add_months(c,1),d=add_months(d,1) where b=some(select b from mycte);

with mycte as
(
 SELECT b from tbl where b=date'1988-10-10'
) delete from tbl;


INSERT INTO tbl VALUES(1,'10:00:00', '2000-10-1', '2000-10-1 10:00:00:35', '2000-10-1 10:00:00:358');
insert into tbl(a)
with mycte as
(
 SELECT TO_CHAR(a, 'HH:MI:SS AM ') FROM tbl
) select * from mycte;

with mycte as
(
 SELECT a from tbl
) update tbl set c=addtime(c,time'1:1:1'),d=addtime(d,time'1:1:1'),a=addtime(a,time'1:1:1') where a=all(select a from mycte);;


with mycte as
(
 SELECT a from tbl where a=time'12:00:00'
) delete from tbl ;



drop table tbl;
