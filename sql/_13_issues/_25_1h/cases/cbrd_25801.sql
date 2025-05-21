-- This issue verified CBRD-25801
-- This issue was regression of CBRD-24181.
-- Before fix :
-- Hidden columns were redundantly added, causing the rewriting process to run twice.
-- After fix :
-- If the original select list has no hidden attribute, remove the hidden property so that the rewriting process runs only once.

drop table if exists ta, tb;

create table ta (ca int, cb int);
create table tb (ca int, cb int, cc int);

insert into ta values (1, 2);
insert into tb values (1, 2, 3);

set trace on;
update /*+ recompile */ ta set cb = 1 where ca = (select ca from tb order by cb, cc limit 1);
show trace;
set trace off;

drop table if exists ta, tb;
