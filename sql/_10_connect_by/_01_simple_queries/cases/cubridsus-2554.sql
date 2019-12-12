--+ holdcas on;
--this cases was added for cubridsus-2554

create table test_table (
test_id varchar(4000),
test_seq varchar(4000),
test_s_label varchar(4000),
synonym varchar(4000),
refer_entry varchar(4000),
test_label1 varchar(4000),
test_label2 varchar(4000),
test_label3 varchar(4000),
test_cont varchar(4000)
);

insert into test_table values(
'200000', '0', NULL, NULL, NULL, '<MD>(\uc218\ud559)</MD>', NULL, NULL, '<EQUIV>addition and subtraction</EQUIV>');

insert into test_table values(
'200001', '0', NULL, NULL, NULL, '', '', '', '<EQUIV>the four rules of arithmetic</EQUIV>');

insert into test_table values(
'200002', '0', '<Label>(\uc601)</Label>', NULL, NULL, '', '', '<SIGNPOST>\u3010\uc0c1\uc810\u3011</SIGNPOST>', '<EQUIV>a shop</EQUIV>');

insert into test_table values(
'200004', '2', '', NULL, NULL, '', '', '<SIGNPOST>\u3010\uacf5\uaca9\uc744 \ud568\u3011</SIGNPOST>', '<EQUIV>an attack</EQUIV>');

insert into test_table values(
'200005', '0', '', NULL, NULL, '', '', '<SIGNPOST>\u3010\uac00\uce58\u3011</SIGNPOST>', '<EQUIV>value</EQUIV>');

insert into test_table values(
'200006', '0', '', NULL, NULL, '', '', '', '<EQUIV>a price list[tag]</EQUIV>');

insert into test_table values(
'200007', '0', '', NULL, NULL, '', '', '', '<EQUIV>passage</EQUIV>');

commit;

SELECT DISTINCT aa.test_id, aa.test_seq,
(select d.test_cont
From (select level lv ,
substr(sys_connect_by_path(c.test_cont,','),2) as test_cont
from (select rownum rn, b.*
from (SELECT test_ID, test_SEQ, test_S_LABEL,
SYNONYM, REFER_ENTRY,
NVL(test_LABEL1,'')||NVL(test_LABEL2,'')||NVL(test_LABEL3,'')||test_CONT as test_cont
FROM test_table A
WHERE test_ID IS NOT NULL AND
(test_CONT IS NOT NULL AND test_CONT<>'') AND
test_id=aa.test_id
ORDER BY test_seq desc) b) c
start with C.rn=1
connect by prior C.rn+1=C.rn
order by level desc) D
where rownum=1) as disp_test_cont
FROM test_table aa
WHERE (test_ID IS NOT NULL AND test_ID <> '') AND
(test_CONT IS NOT NULL AND test_CONT <> '') and
(test_seq is not null and test_seq <>'')
;

set system parameters 'compat_mode=mysql';
set system parameters 'ansi_quotes=yes';

SELECT DISTINCT aa.test_id, aa.test_seq,
(select d.test_cont
From (select level lv ,
substr(sys_connect_by_path(c.test_cont,','),2) as test_cont
from (select rownum rn, b.*
from (SELECT test_ID, test_SEQ, test_S_LABEL,
SYNONYM, REFER_ENTRY,
concat(NVL(test_LABEL1,''), NVL(test_LABEL2,''), NVL(test_LABEL3,''), test_CONT) as test_cont
FROM test_table A
WHERE test_ID IS NOT NULL AND
(test_CONT IS NOT NULL AND test_CONT<>'') AND
test_id=aa.test_id
ORDER BY test_seq desc) b) c
start with C.rn=1
connect by prior C.rn+1=C.rn
order by level desc) D
where rownum=1) as disp_test_cont
FROM test_table aa
WHERE (test_ID IS NOT NULL AND test_ID <> '') AND
(test_CONT IS NOT NULL AND test_CONT <> '') and
(test_seq is not null and test_seq <>'')
;

set system parameters 'ansi_quotes=no';
set system parameters 'compat_mode=cubrid';

drop test_table;
commit;
--+ holdcas off;
