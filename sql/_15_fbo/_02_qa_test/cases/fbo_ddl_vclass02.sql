-- bug 3703, need change answer file.
-- create view using UNION ALL
create table vc_tb1(a int, b blob,c clob);

insert into vc_tb1 values (1, bit_to_blob(B'10010'), char_to_clob('1abcdef'));
insert into vc_tb1 values (2, bit_to_blob(B'10011'), char_to_clob('2cefabc'));


create table vc_tb2(a int, b blob,c clob);

insert into vc_tb2 values (1, bit_to_blob(B'10010'), char_to_clob('1abcdef'));
insert into vc_tb2 values (4, bit_to_blob(B'10011'), char_to_clob('4cefabc'));


create vclass vtb1(
	a int,
	b blob,
	c clob
) as select * from vc_tb1 where a>=1 union select * from vc_tb2 where a<=4;

create vclass vtb2(
	a int,
	b blob,
	c clob
) as select * from vc_tb1 where a>=1 union all select * from vc_tb2 where a<4;

select a,blob_to_bit(b),clob_to_char(c) from vtb1 order by 1;
select a,blob_to_bit(b),clob_to_char(c) from vtb2 order by 2;


drop vtb1;
drop vtb2;

delete from vc_tb1;
delete from vc_tb2;
drop vc_tb1;
drop vc_tb2;