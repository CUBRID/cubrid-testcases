--Create index with keyword asc/desc on partition class
create class test (
testno           char(10) not null,       
testname         varchar(20) not null,
pname        varchar(20), 
testdate        date, primary key(testdate) 

)
partition by range (extract (year from testdate)) (
partition h2000 values less than (2000),
partition h2003 values less than (2003),
partition hmax values less than  maxvalue);

INSERT INTO test VALUES ('00001', 'Junghee', 'planning', TO_DATE('19991115', 'YYYYMMDD'));
INSERT INTO test VALUES ('00002', 'Sungsoo', 'public_information', TO_DATE('20001115', 'YYYYMMDD'));
INSERT INTO test VALUES ('00003', 'Junho', 'account', TO_DATE('20021115', 'YYYYMMDD'));
INSERT INTO test VALUES ('00004', 'Daejung', 'R&D', TO_DATE('20011115', 'YYYYMMDD'));
INSERT INTO test VALUES ('00005', 'Dongho', 'sales', TO_DATE('20031115', 'YYYYMMDD'));
INSERT INTO test VALUES ('00006', 'Oakhyun', 'sales', TO_DATE('20030601', 'YYYYMMDD'));
INSERT INTO test VALUES ('00007', 'Dongyoung', 'account', TO_DATE('20040301', 'YYYYMMDD'));
INSERT INTO test VALUES ('00008', 'Byungmo', 'public_information', TO_DATE('20050601', 'YYYYMMDD'));
INSERT INTO test VALUES ('00009', 'Aeran', 'planning', TO_DATE('20060601', 'YYYYMMDD'));
INSERT INTO test VALUES ('00010', 'Yoonjung', 'R&D', TO_DATE('20070601', 'YYYYMMDD'));

create index idx_test_1 on test(testno desc); 
create index idx_test_2 on test(testname asc); 
create index idx_test_3 on test(pname desc); 
create index idx_test_4 on test(testdate asc); 
create index idx_test_5 on test(testno desc, testname asc, pname desc, testdate asc); 
create index idx_test_6 on test(testname asc, pname desc, testdate asc); 
create index idx_test_7 on test(pname desc, testdate asc); 
create index idx_test_8 on test(testdate asc, testno desc, testname asc, pname desc); 
select * from db_index where class_name = 'test' order by 1,2,3;
update test set testno = '00011' where testno='00001' ;
delete from test;
drop class test;


