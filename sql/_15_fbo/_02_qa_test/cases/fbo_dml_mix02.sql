-- need change answer file, bug 3738
--do insert/update/delete operations in the table with more than 1 blob/clob column.
create table mix2_xxx(a int auto_increment, b blob, c clob, d string, e clob, f blob, g float, h blob, i clob);
create table mix2_yyy(aa int, bb string, cc clob);

insert into mix2_xxx(b, c, d, e, f, g, h, i) values(bit_to_blob(X'0001'), char_to_clob('aaa'), 'hello', char_to_clob('aaaa'), bit_to_blob(B'0001'), 1.2, bit_to_blob(X'1001'), char_to_clob('aaaaa'));
insert into mix2_xxx(b, c, d, e, f, g, h, i) values(bit_to_blob(X'1001'), char_to_clob('bbb'), 'hello', char_to_clob('bbbb'), bit_to_blob(B'1001'), 1.33, bit_to_blob(X'1000'), char_to_clob('bbbbb'));
insert into mix2_xxx(b, c, d, e, f, g, h, i) values(bit_to_blob(X'0011'), char_to_clob('ccc'), 'hello', char_to_clob('cccc'), bit_to_blob(B'0101'), 1.444, bit_to_blob(X'1011'), char_to_clob('ccccc'));
insert into mix2_xxx(b, c, d, e, f, g, h, i) values(bit_to_blob(X'0101'), char_to_clob('ddd'), 'hello', char_to_clob('dddd'), bit_to_blob(B'0011'), 1.5555, bit_to_blob(X'11001'), char_to_clob('ddddd'));
insert into mix2_xxx(b, c, d, e, f, g, h, i) values(bit_to_blob(X'1101'), char_to_clob('eee'), 'hello', char_to_clob('eeee'), bit_to_blob(B'0111'), 1.66666, bit_to_blob(X'100011'), char_to_clob('eeeee'));
insert into mix2_yyy values(1, 'dfs', char_to_clob('kejoalsdfasl'));
insert into mix2_yyy values(1, 'dfs', char_to_clob('kejoalsdfasl'));
select a, blob_to_bit(b), clob_to_char(c), d, clob_to_char(e), blob_to_bit(f), g, blob_to_bit(h), clob_to_char(i) from mix2_xxx order by a,2,3;
select aa, bb, clob_to_char(cc) from mix2_yyy order by aa,2,3;

update mix2_yyy set cc=char_to_clob('bbbbbbbbbbbbbbb');
insert into mix2_xxx(b, c) values(bit_to_blob(X'12312312'), char_to_clob('axdfssdfad'));
insert into mix2_yyy values(1, 'dfs', char_to_clob('kejoasdfae4343543-089-435l'));
insert into mix2_yyy values(2, 'dfs', char_to_clob('kejoalsdfasl'));
delete from mix2_xxx where a=3;
select a, blob_to_bit(b), clob_to_char(c), d, clob_to_char(e), blob_to_bit(f), g, blob_to_bit(h), clob_to_char(i) from mix2_xxx order by a,2,3;
select aa, bb, clob_to_char(cc) from mix2_yyy order by aa, 2,3;

insert into mix2_yyy (select * from mix2_yyy);
update mix2_xxx set b=bit_to_blob(B'1001010') where a>6;
update mix2_yyy set cc=char_to_clob('changechange') where aa=8;
delete from mix2_yyy where clob_to_char(cc)='kejoasdfae4343543-089-435l';


select a, blob_to_bit(b), clob_to_char(c), d, clob_to_char(e), blob_to_bit(f), g, blob_to_bit(h), clob_to_char(i) from mix2_xxx order by a,2,3;
select aa, bb, clob_to_char(cc) from mix2_yyy order by aa, 2,3;

delete from mix2_xxx;
delete from mix2_yyy;
drop table mix2_xxx;
drop table mix2_yyy;
