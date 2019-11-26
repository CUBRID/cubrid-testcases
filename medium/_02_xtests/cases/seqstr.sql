--+ holdcas on;
autocommit off;
create class seqstr (i int, s sequence of string);
insert into seqstr values(1, sequence{'abc', 'def'});
insert into seqstr values(2, sequence{'xyz', '123'});
select s into p1 from seqstr where i = 1;
select * from seqstr where s = p1;
select * from seqstr where p1 = s;
rollback;

--+ holdcas off;
