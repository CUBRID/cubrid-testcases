/*
 * This test case verifies CBRD-28371 : a UNION ALL view member checked the
 * range derived from a bound LIKE twice on every row before the LIKE.
 *
 * Bug: a LIKE on a non-constant pattern (host variable, session variable)
 * gets a range derived from it (col >= like_match_lower_bound (p) AND
 * col < like_match_upper_bound (p)). mq_copypush_sargable_terms () pushes the
 * LIKE and that range into each UNION ALL member as two terms, and the
 * member's own qo_rewrite_like_terms () derived the range from the LIKE a
 * second time, so a member reading the column without a cast carried the
 * range twice. Since CBRD-27855 the duplicate's selectivity is 1 and it is
 * evaluated ahead of the LIKE, on every row.
 *
 * Fix: qo_rewrite_like_terms () does not derive the range again when the
 * range derived from the same LIKE is already among the terms.
 *
 * The plan statement below lists each member's WHERE: after the fix every
 * member carries the LIKE and one range. Before the fix the members without
 * a cast show the range twice.
 *   Case 1: LIKE @p on a view whose members read the column without a cast
 *   Case 2: LIKE '%' || @w || '%' on the same view
 *   Case 3: prefix pattern with an index on two members: the pushed range
 *           still gives the key range (iscan on i_kc_g_nm, i_kc_e_nm)
 *   Case 4: the first member casts the column (VARCHAR(150) -> VARCHAR(180)),
 *           it already had one range and keeps it
 */
drop view if exists kc_v180;
drop view if exists kc_v;
drop table if exists kc_g, kc_g150, kc_e, kc_u;

create table kc_g (esntl_id char(20) primary key, mber_id varchar(60) not null, mber_nm varchar(180));
create table kc_g150 (esntl_id char(20) primary key, mber_id varchar(60) not null, mber_nm varchar(150));
create table kc_e (esntl_id char(20) primary key, entrprs_mber_id varchar(60) not null, cmpny_nm varchar(180));
create table kc_u (esntl_id char(20) primary key, emplyr_id varchar(60) not null, user_nm varchar(180));

insert into kc_g select 'G' || lpad(rownum, 19, '0'), 'id' || rownum, 'nm' || mod(rownum, 500) from db_class a, db_class b, db_class c limit 20000;
insert into kc_g150 select esntl_id, mber_id, mber_nm from kc_g;
insert into kc_e select 'E' || lpad(rownum, 19, '0'), 'eid' || rownum, 'nm' || mod(rownum, 500) from db_class a, db_class b, db_class c limit 20000;
insert into kc_u select 'U' || lpad(rownum, 19, '0'), 'uid' || rownum, 'nm' || mod(rownum, 500) from db_class a, db_class b limit 2000;

create view kc_v180 (esntl_id, user_id, user_nm, user_se) as
  select esntl_id, mber_id, mber_nm, 'GNR' from kc_g
  union all select esntl_id, entrprs_mber_id, cmpny_nm, 'ENT' from kc_e
  union all select esntl_id, emplyr_id, user_nm, 'USR' from kc_u;
create view kc_v (esntl_id, user_id, user_nm, user_se) as
  select esntl_id, mber_id, mber_nm, 'GNR' from kc_g150
  union all select esntl_id, entrprs_mber_id, cmpny_nm, 'ENT' from kc_e
  union all select esntl_id, emplyr_id, user_nm, 'USR' from kc_u;

update statistics on kc_g, kc_g150, kc_e, kc_u with fullscan;

set @p = '%nm17%';
set @w = 'nm17';
set @x = 'nm17%';

-- Case 1: LIKE on a session variable, members without a cast: one range per member
--@queryplan
select count(*) from kc_v180 where user_nm like @p;

-- Case 2: LIKE '%' || @w || '%': one range per member
--@queryplan
select count(*) from kc_v180 where user_nm like '%' || @w || '%';

-- Case 3: prefix pattern, the members with an index keep the key range
create index i_kc_g_nm on kc_g (mber_nm);
create index i_kc_e_nm on kc_e (cmpny_nm);
update statistics on kc_g, kc_e with fullscan;
--@queryplan
select count(*) from kc_v180 where user_nm like @x;
drop index i_kc_g_nm on kc_g;
drop index i_kc_e_nm on kc_e;

-- Case 4: the first member casts the column: one range in every member
--@queryplan
select count(*) from kc_v where user_nm like @p;

-- the same rows without the view
select (select count(*) from kc_g where mber_nm like '%nm17%')
     + (select count(*) from kc_e where cmpny_nm like '%nm17%')
     + (select count(*) from kc_u where user_nm like '%nm17%') as cnt_any,
       (select count(*) from kc_g where mber_nm like 'nm17%')
     + (select count(*) from kc_e where cmpny_nm like 'nm17%')
     + (select count(*) from kc_u where user_nm like 'nm17%') as cnt_prefix;

drop variable @p, @w, @x;
drop view kc_v180;
drop view kc_v;
drop table kc_g, kc_g150, kc_e, kc_u;
