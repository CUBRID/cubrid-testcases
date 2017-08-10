--insert with object domain

create class insert11_t1(name varchar(20), age integer,c clob, b blob);
create class insert11_emp (insert11_empno integer, attr insert11_t1, c clob, b blob);
create class insert11_company (id int, attr insert11_emp, image blob);

insert into insert11_t1 values('xxx', 26,char_to_clob('ttinsert11_t1') ,bit_to_blob(B'11011') ) into :f1;
insert into insert11_emp values(1001, :f1 ,char_to_clob('ettinsert11_t1') ,bit_to_blob(X'11011')) into :e1;
insert into insert11_company values(11, :e1, bit_to_blob(B'1100'));

insert into insert11_t1 values('yyy', 27,char_to_clob('ttt2') ,bit_to_blob(B'11011') ) into :f2;
insert into insert11_emp values(1002, :f2 ,char_to_clob('eettt2') ,bit_to_blob(X'11011')) into :e2;
insert into insert11_company values(22, :e2, bit_to_blob(B'010011'));

insert into insert11_t1 values('zzz', 28,char_to_clob('ttt3') ,bit_to_blob(B'11011') ) into :f3;
insert into insert11_emp values(1001, :f1 ,char_to_clob('ettt3') ,bit_to_blob(X'11011')) into :e3;
insert into insert11_company values(33, :e2, bit_to_blob(B'1010110'));
insert into insert11_company values(33, :e4, bit_to_blob(B'1010111'));

select name, age, clob_to_char(c), blob_to_bit(b) from insert11_t1 order by name;
select insert11_empno, attr.name, attr.age, clob_to_char(attr.c), blob_to_bit(attr.b), clob_to_char(c), blob_to_bit(b) from insert11_emp order by 1,6;
select id, attr.insert11_empno, attr.attr.name, clob_to_char(attr.attr.c),blob_to_bit(attr.b), blob_to_bit(image) from insert11_company order by id;

delete from insert11_emp
delete from insert11_t1;
delete from insert11_company;
drop class insert11_emp;
drop class insert11_t1;
drop insert11_company;
