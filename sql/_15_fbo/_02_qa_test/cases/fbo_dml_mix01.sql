--do insert/update/delete operations randomly in 2 tables.
create table mix1_xxx(a int auto_increment, b blob, c clob);
create table mix1_yyy(aa int, bb char(10), cc clob);

insert into mix1_xxx(b, c) values(bit_to_blob(X'3931'), char_to_clob('aaaaaaaaaaa'));
insert into mix1_yyy values(1, 'dfs1', char_to_clob('kejoa);lsdfasl'));
insert into mix1_xxx(b, c) values(bit_to_blob(X'3932'), char_to_clob('aaaaaaaaaaa'));
insert into mix1_xxx(b, c) values(bit_to_blob(X'3933'), char_to_clob('aaaaaaaaaaa'));
insert into mix1_xxx(b, c) values(bit_to_blob(X'3934'), char_to_clob('aaaaaaaaaaa'));
insert into mix1_yyy values(2, 'dfs2', char_to_clob('kejoalsdfasl'));
insert into mix1_yyy values(3, 'dfs3', char_to_clob('kejoasdfasl'));
update mix1_yyy set cc=char_to_clob('bbbbbbbbbbbbbbb');
insert into mix1_xxx(b, c) values(bit_to_blob(X'12312312'), char_to_clob('axdfssdfad'));
insert into mix1_yyy values(4, 'dfs4', char_to_clob('kejoasdfae4343543-089-435l'));
insert into mix1_yyy values(5, 'dfs5', char_to_clob('kejoalsdfasl'));
delete from mix1_xxx where a=3;
insert into mix1_xxx(b, c) (select b, c from mix1_xxx order by a);
insert into mix1_yyy (select * from mix1_yyy order by aa);
update mix1_xxx set b=bit_to_blob(B'1001010') where a=6;
update mix1_yyy set cc=char_to_clob('changechange') where aa=8;
delete from mix1_yyy where clob_to_char(cc)='kejoasdfae4343543-089-435l';


select a, blob_to_bit(b), clob_to_char(c) from mix1_xxx order by a;
select aa, bb, clob_to_char(cc) from mix1_yyy order by aa;

delete from mix1_xxx;
delete from mix1_yyy;
drop table mix1_xxx;
drop table mix1_yyy;
