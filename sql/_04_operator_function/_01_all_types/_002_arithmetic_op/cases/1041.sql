--+ holdcas on;
--test concatenation operators "||"

create table cc (attr2 char(15));
insert into cc values ('BAAAAAAAABD');

create table dd (attr2 char(15));
insert into dd values ('BAAAAAAAABD');


--+ ORDERED USE_NL
select count(*)
from cc a, dd b
where 1=1
  and a.attr2 = b.attr2 
  and a.attr2 || 'a' = b.attr2 || 'a'
  and a.attr2 || 'b' = b.attr2 || 'b'
  and a.attr2 || 'c' = b.attr2 || 'c'
  and a.attr2 || 'd' = b.attr2 || 'd'
  and a.attr2 || 'e' = b.attr2 || 'e'
  and a.attr2 || 'f' = b.attr2 || 'f'
  and a.attr2 || 'g' = b.attr2 || 'g'
  and a.attr2 || 'h' = b.attr2 || 'h'
  and a.attr2 || 'j' = b.attr2 || 'j'
  and a.attr2 || 'k' = b.attr2 || 'k';
set system parameters 'compat_mode=mysql';
select count(*)
from cc a, dd b
where 1=1
  and a.attr2 = b.attr2 
  and concat(a.attr2, 'a') = concat(b.attr2, 'a')
  and concat(a.attr2, 'b') = concat(b.attr2, 'b')
  and concat(a.attr2, 'c') = concat(b.attr2, 'c')
  and concat(a.attr2, 'd') = concat(b.attr2, 'd')
  and concat(a.attr2, 'e') = concat(b.attr2, 'e')
  and concat(a.attr2, 'f') = concat(b.attr2, 'f')
  and concat(a.attr2, 'g') = concat(b.attr2, 'g')
  and concat(a.attr2, 'h') = concat(b.attr2, 'h')
  and concat(a.attr2, 'j') = concat(b.attr2, 'j')
  and concat(a.attr2, 'k') = concat(b.attr2, 'k');
set system parameters 'compat_mode=cubrid';


drop table cc;
drop table dd;
commit;
--+ holdcas off;
