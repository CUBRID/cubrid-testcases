--+ holdcas on;
--normal escape cases

set system parameters 'no_backslash_escapes=yes';
select '\abc';
select '\a\d\e';
select '\'\"';
select '\\';
select '\\\\';

set system parameters 'no_backslash_escapes=no';
select '\abc';
select '\a\d\e';
select '\'\"';
select '\\';
select '\\\\';
commit;
--+ holdcas off;
