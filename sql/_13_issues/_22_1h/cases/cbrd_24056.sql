drop table if exists tbl;
drop table if exists tbl_a;
drop table if exists tbl_b;
drop table if exists tbl_c;

create table tbl (id varchar);
create index i_tbl on tbl(id);
insert into tbl values ('T'), ('X');

create table tbl_a (a varchar, aaa varchar);
create index i_tbl_a on tbl_a(a);
insert into tbl_a values ('TA', 'Y');

create table tbl_b (b varchar);
insert into tbl_b values ('TB');

create table tbl_c (c varchar);
insert into tbl_c values ('TC');

select /*++RECOMPILE */ id from tbl;

select /*++ RECOMPILE() */ id from tbl;

select /*++RECOMPILE ORDERED */ id from tbl;

select /*++ NO_INDEX_LS  NO_INDEX_SS */ id from tbl;

select /*++ ORDERED NO_INDEX_SSKIP_UPDATE_NULL */ id from tbl;

select /*++ QUERY_CACHE(T) */ id from tbl;

select /*++ USE_NL( tbl_a    .     tbl_b  ) */ id from tbl;

select /*++ USE_NL("tbl_a.tbl_b") */ id from tbl;

select /*++ USE_NL( "tbl_a   .   tbl_b" ) */ id from tbl;

select /*++ USE_NL("   tbl_a.tbl_b    ") */ id from tbl;

select /*++ USE_NL("tbl_a , tbl_b") */ id from tbl;

select /*++ USE_NL() USE_NL(tbl) */ id from tbl;

select /*++ USE_NL(tbl) USE_NL() */ id from tbl;
 
select /*++ USE_NL() */ /*++ USE_NL(tbl) */ id from tbl;

select /*++ USE_NL(tbl) */ /*++ USE_NL() */ id from tbl;

select /*++ USE_NL(tbl_a) USE_NL(tbl_b) USE_MERGE(tbl_c) */ *
from tbl_a , tbl_b, tbl_c
where tbl_a.a = tbl_b.b and tbl_a.a = tbl_c.c;

select /*++ INDEX_LS() */ a as TEST from tbl_a
union
select /*++ INDEX_LS(tbl_a) */ aaa as TEST from tbl_a;

select /*++ INDEX_LS() RECOMPILE */ a as TEST from tbl_a
union
select /*++ INDEX_LS(tbl_a) */ aaa as TEST from tbl_a;

select //++ INDEX_LS()
          /*++ INDEX_LS(tbl_a) */ a as TEST from tbl_a;

select //++ INDEX_LS() RECOMPILE
          /*++ INDEX_LS(tbl_a) */ a as TEST from tbl_a;

select /*++ INDEX_LS() */   /*++ INDEX_LS(tbl_a) */ a as TEST from tbl_a;

select /*++ INDEX_LS() RECOMPILE */  /*++ INDEX_LS(tbl_a) */  a as TEST from tbl_a;

-- need to revise answer sheet after CBRD-24112 issue creation
select /*++ INDEX_LS() */ a as TEST from tbl_a;   select /*++ INDEX_LS(tbl_a) */ a as TEST from tbl_a;

select /*++ INDEX_LS() */ id as TEST from tbl;   select /*++ INDEX_LS(tbl_a) */ a as TEST from tbl_a;

select /*++ INDEX_LS() RECOMPILE */ aaa as TEST from tbl_a;   select /*++ INDEX_LS(tbl_a) */ aaa as TEST from tbl_a;

select /*++ INDEX_LS() RECOMPILE */ id as TEST from tbl;   select /*++ INDEX_LS(tbl_a) */ aaa as TEST from tbl_a;

select /*++ recompile index_ls use_nl(tbl_a,tbl_b,tbl_c) */ id from tbl;

drop table tbl;
drop table tbl_a;
drop table tbl_b;
drop table tbl_c;