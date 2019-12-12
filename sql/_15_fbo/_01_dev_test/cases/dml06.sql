--+ holdcas on;
--delete from x;
--drop x;

-- several blob/clob columns  at a class
create class x (id int primary key, a clob, b varchar(10), c blob, d bit(80));
insert into x (id,a,b,c,d) values (1, NULL, '0f0f', NULL, x'0f0f');

insert into x (id,a,b,c,d)
select id+4, char_to_clob (b), null, bit_to_blob(b), null from x;

select blob_to_bit(c) from x where id=4;

insert into x (id,a,b,c,d)
values (5, char_to_clob('hello'), null, bit_to_blob('hello'), null);

select blob_to_bit(c) from x where id=5;

insert into x (id,a) values (6, char_to_clob(''));
select clob_to_char(a) from x where id=6;

delete from x;
drop x;
commit;
--+ holdcas off;
