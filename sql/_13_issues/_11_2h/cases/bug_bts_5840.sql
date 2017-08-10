create table t (c char(10), vc varchar(10));

insert into t select rownum, rownum from db_class where rownum < 15;

create index i_t_c on t(c);
create index i_t_vc on t(vc);

select /*+ recompile */ c from t where c between '1' and '9';

select /*+ recompile */ c from t where c between to_char(1) and to_char (9);

select /*+ recompile */ vc from t where vc between to_char(1) and to_char (9);

select /*+ recompile */ vc from t where vc between '1' and '9';

select /*+ recompile */ c from t where c between cast(1 as varchar(1)) and cast(9 as varchar(1));

select /*+ recompile */ c, vc from t where c = vc order by c;

drop table t;

create table t (c nchar(10), vc nchar varying(10));

insert into t select rownum, rownum from db_class where rownum < 15;

create index i_t_c on t(c);
create index i_t_vc on t(vc);

select /*+ recompile */ c from t where c between n'1' and n'9';

select /*+ recompile */ c from t where c between to_char(1) and to_char (9);

select /*+ recompile */ vc from t where vc between to_char(1) and to_char (9);

select /*+ recompile */ vc from t where vc between n'1' and n'9';

select /*+ recompile */ c from t where c between cast(1 as nchar varying(1)) and cast(9 as nchar varying(1));

select /*+ recompile */ c, vc from t where c = vc order by c;

select /*+ recompile */ vc from t where vc between '1' and '9';

select /*+ recompile */ c from t where c between '1' and '9';

drop table t;
