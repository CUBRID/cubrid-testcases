--TEST: [Analytic Functions] The select results of blob and clob columns are incorrect when they are selected together with row_number() analytic function.

--+ holdcas on;

create table foo(col1 blob, col2 clob);
insert into foo values(B'1011', 'aaa');
insert into foo values(B'1100', 'bbb');
insert into foo values(B'1111', 'ccc');

select blob_to_bit(col1), clob_to_char(col2) from foo order by 1;
select blob_to_bit(col1), clob_to_char(col2), row_number() over() row_num from foo order by 1;

drop table foo;


create table foo(a int, b char(10));
insert into foo values(1, 'a');
insert into foo values(2, 'b');
insert into foo values(3, 'c');

select round(a), row_number() over() rn from foo order by 1;
select abs(a), upper(b), max(a) over(order by b) m from foo order by 1;
select log10(a), count(*) over() cnt, left(b, 3) from foo order by 1;

drop table foo;

commit;
--+ holdcas off;

