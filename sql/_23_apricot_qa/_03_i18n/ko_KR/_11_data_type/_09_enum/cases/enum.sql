--+ holdcas on;
set names binary;
CREATE TABLE t (
    a ENUM('Á', 'Ê', 'ð')
);
create index idx on t(log10(a));
INSERT into t values ('Á'), ('Ê'), (2), ('ð');
select /*+ recompile*/* from t where  log10(a)>0;
drop table t;
set names iso88591;
commit;
--+ holdcas off;
