--+ holdcas on;
DROP TABLE IF EXISTS test_table;

create table test_table ( id varchar(4000), mseq varchar(4000), mslabel varchar(4000), sy varchar(4000), rfentry varchar(4000), mlabel1 varchar(4000), mlabel2 varchar(4000), mlabel3 varchar(4000), mcnt varchar(4000) );
insert into test_table values( '200000', '0', NULL, NULL, NULL, '(\uc218\ud559)', NULL, NULL, 'addition and subtraction');
insert into test_table values( '200001', '0', NULL, NULL, NULL, '', '', '', 'the four rules of arithmetic');
insert into test_table values( '200002', '0', '(\uc601)', NULL, NULL, '', '', '\u3010\uc0c1\uc810\u3011', 'a shop');
insert into test_table values( '200004', '2', '', NULL, NULL, '', '', '\u3010\uacf5\uaca9\uc744 \ud568\u3011', 'an attack');
insert into test_table values( '200005', '0', '', NULL, NULL, '', '', '\u3010\uac00\uce58\u3011', 'value');
insert into test_table values( '200006', '0', '', NULL, NULL, '', '', '', 'a price list[tag]');
insert into test_table values( '200007', '0', '', NULL, NULL, '', '', '', 'passage');
commit;
SELECT DISTINCT aa.id, aa.mseq, (select d.mcnt From (select level lv , substr(sys_connect_by_path(c.mcnt,','),2) as mcnt from (select rownum rn, b.* from (SELECT id, mseq, mslabel, sy, rfentry, NVL(mlabel1,'')||NVL(mlabel2,'')||NVL(mlabel3,'')||mcnt as mcnt FROM test_table A WHERE id IS NOT NULL AND (mcnt IS NOT NULL AND mcnt<>'') AND id=aa.id ORDER BY mseq desc) b) c start with C.rn=1 connect by prior C.rn+1=C.rn order by level desc) D where rownum=1) as disp_mcnt FROM test_table aa WHERE (id IS NOT NULL AND id <> '') AND (mcnt IS NOT NULL AND mcnt <> '') and (mseq is not null and mseq <>'') ;

DROP TABLE IF EXISTS test_table;
--+ holdcas off;
commit;