-- constraints, primary key not on blob/clob column.
create class update1_pk3 (a int primary key, b blob , c clob); 

insert into update1_pk3 values (1,bit_to_blob(B'101'),char_to_clob('test fbo1'));
insert into update1_pk3 values (2,bit_to_blob(B'110'),char_to_clob('test fbo2'));
insert into update1_pk3 values (3,bit_to_blob(B'111'),char_to_clob('test fbo3'));

update update1_pk3 set a=3 , b=bit_to_blob(X'aaabbbccc') where clob_to_char(c)='test fbo1';
update update1_pk3 set a=4 , b=bit_to_blob(X'aaabbbccc') where clob_to_char(c)='test fbo1';
update update1_pk3 set a=4 , b=bit_to_blob(X'aaabbbccc') where clob_to_char(c)='test fbo1';

select a,blob_to_bit(b),clob_to_char(c) from update1_pk3 order by a; 
delete from update1_pk3;
drop update1_pk3;


