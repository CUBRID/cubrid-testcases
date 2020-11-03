--+ holdcas on;
--delete from x;
--drop x;

-- several blob/clob columns  at a class
create class x (id int primary key, a clob, b char(4), c blob, d bit(80));
insert into x(id,a,b,c,d) values (1, NULL, '0f0f', NULL, x'0f0f');
insert into x(id,a,b,c,d) values (2, NULL, '', NULL, x'');
insert into x(id,a,b,c,d) values (3, NULL, NULL, NULL, NULL);

insert into x 
select id+4, cast(b as clob), b, cast(d as blob), d from x;

insert into x 
select id+8, cast(b as clob), b, cast(d as blob), d from x;

select id, clob_to_char(a), b, blob_to_bit(c), d from x order by id;

select count(*) from x where a = '0f0f';
select count(*) from x where cast(a as string) = '0f0f';
select count(*) from x where c = x'0f0f';
select count(*) from x where cast(c as bit varying) = X'0f0f0000000000000000';

delete from x;
drop x;
commit;
--+ holdcas off;
