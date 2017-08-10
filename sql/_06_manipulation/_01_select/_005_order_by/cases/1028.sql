--[er]Test order by out of number range
create class t1 (
empno           char(10) not null,       
empname         varchar(20) not null,
deptname        varchar(20), 
testdate        date, primary key(testdate) 
)
partition by range (extract (year from testdate)) (
partition h2000 values less than (2000),
partition h2003 values less than (2003),
partition hmax values less than  maxvalue);

INSERT INTO t1 VALUES ('00001', 'Junghee', 'planning', TO_DATE('19991115', 'YYYYMMDD'));
INSERT INTO t1 VALUES ('00002', 'Sungsoo', 'public_information', TO_DATE('20001115', 'YYYYMMDD'));
INSERT INTO t1 VALUES ('00003', 'Junho', 'account', TO_DATE('20021115', 'YYYYMMDD'));
INSERT INTO t1 VALUES ('00004', 'Daejung', 'R&D', TO_DATE('20011115', 'YYYYMMDD'));
INSERT INTO t1 VALUES ('00005', 'Dongho', 'sales', TO_DATE('20031115', 'YYYYMMDD'));
INSERT INTO t1 VALUES ('00006', 'Oakhyun', 'sales', TO_DATE('20030601', 'YYYYMMDD'));
INSERT INTO t1 VALUES ('00007', 'Dongyoung', 'account', TO_DATE('20040301', 'YYYYMMDD'));
INSERT INTO t1 VALUES ('00008', 'Byungmo', 'public_information', TO_DATE('20050601', 'YYYYMMDD'));
INSERT INTO t1 VALUES ('00009', 'Aeran', 'planning', TO_DATE('20060601', 'YYYYMMDD'));
INSERT INTO t1 VALUES ('00010', 'Yoonjung', 'R&D', TO_DATE('20070601', 'YYYYMMDD'));

select empno, empname, deptname, testdate
from   t1
order by 1,4;

select empname, deptname, testdate
from   t1
order by 1,3,4;
drop class t1;


