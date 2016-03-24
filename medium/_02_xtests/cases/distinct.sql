autocommit off;
create class one_c ( -- 1 duplicate
ai int,         bi int,         ci int,
an numeric,     bn numeric,     cn numeric,
af float,       bf float,       cf float,
ac char(32),    bc char(32),    cc char(32),
av varchar(32), bv varchar(32), cv varchar(32),
ad date,        bd date,        cd date);
create class two_c ( -- 2 duplicate
ai int,         bi int,         ci int,
an numeric,     bn numeric,     cn numeric,
af float,       bf float,       cf float,
ac char(32),    bc char(32),    cc char(32),
av varchar(32), bv varchar(32), cv varchar(32),
ad date,        bd date,        cd date);
create class four_c ( -- 4 duplicate
ai int,         bi int,         ci int,
an numeric,     bn numeric,     cn numeric,
af float,       bf float,       cf float,
ac char(32),    bc char(32),    cc char(32),
av varchar(32), bv varchar(32), cv varchar(32),
ad date,        bd date,        cd date);
create class eight_c ( -- 8 duplicate
ai int,         bi int,         ci int,
an numeric,     bn numeric,     cn numeric,
af float,       bf float,       cf float,
ac char(32),    bc char(32),    cc char(32),
av varchar(32), bv varchar(32), cv varchar(32),
ad date,        bd date,        cd date);
create class onesix_c ( -- 16 duplicate
ai int,         bi int,         ci int,
an numeric,     bn numeric,     cn numeric,
af float,       bf float,       cf float,
ac char(32),    bc char(32),    cc char(32),
av varchar(32), bv varchar(32), cv varchar(32),
ad date,        bd date,        cd date);
create class threetwo_c ( -- 32 duplicate
ai int,         bi int,         ci int,
an numeric,     bn numeric,     cn numeric,
af float,       bf float,       cf float,
ac char(32),    bc char(32),    cc char(32),
av varchar(32), bv varchar(32), cv varchar(32),
ad date,        bd date,        cd date);
create class sixfour_c ( -- 64 duplicate
ai int,         bi int,         ci int,
an numeric,     bn numeric,     cn numeric,
af float,       bf float,       cf float,
ac char(32),    bc char(32),    cc char(32),
av varchar(32), bv varchar(32), cv varchar(32),
ad date,        bd date,        cd date);
insert into one_c (ai, bi, ci) values (1, 1, 1);
insert into one_c (ai, bi, ci) select ai + 1, bi, ci from one_c; -- 2
insert into one_c (ai, bi, ci) select ai + 2, bi, ci from one_c; -- 4
insert into one_c (ai, bi, ci) select ai + 4, bi, ci from one_c; -- 8
insert into one_c (ai, bi, ci) select ai + 8, bi, ci from one_c; -- 16
insert into one_c (ai, bi, ci) select ai + 16, bi, ci from one_c; -- 32
insert into one_c (ai, bi, ci) select ai + 32, bi, ci from one_c; -- 64
insert into two_c (ai, bi, ci) values (1, 1, 1);
insert into two_c (ai, bi, ci) select ai, bi, ci from two_c; -- 2
insert into two_c (ai, bi, ci) select ai + 1, bi, ci from two_c; -- 4
insert into two_c (ai, bi, ci) select ai + 2, bi, ci from two_c; -- 8
insert into two_c (ai, bi, ci) select ai + 4, bi, ci from two_c; -- 16
insert into two_c (ai, bi, ci) select ai + 8, bi, ci from two_c; -- 32
insert into two_c (ai, bi, ci) select ai + 16, bi, ci from two_c; -- 64
insert into four_c (ai, bi, ci) values (1, 1, 1);
insert into four_c (ai, bi, ci) select ai, bi, ci from four_c; -- 2
insert into four_c (ai, bi, ci) select ai, bi, ci from four_c; -- 4
insert into four_c (ai, bi, ci) select ai + 1, bi, ci from four_c; -- 8
insert into four_c (ai, bi, ci) select ai + 2, bi, ci from four_c; -- 16
insert into four_c (ai, bi, ci) select ai + 4, bi, ci from four_c; -- 32
insert into four_c (ai, bi, ci) select ai + 8, bi, ci from four_c; -- 64
insert into eight_c (ai, bi, ci) values (1, 1, 1);
insert into eight_c (ai, bi, ci) select ai, bi, ci from eight_c; -- 2
insert into eight_c (ai, bi, ci) select ai, bi, ci from eight_c; -- 4
insert into eight_c (ai, bi, ci) select ai, bi, ci from eight_c; -- 8
insert into eight_c (ai, bi, ci) select ai + 1, bi, ci from eight_c; -- 16
insert into eight_c (ai, bi, ci) select ai + 2, bi, ci from eight_c; -- 32
insert into eight_c (ai, bi, ci) select ai + 4, bi, ci from eight_c; -- 64
insert into onesix_c (ai, bi, ci) values (1, 1, 1);
insert into onesix_c (ai, bi, ci) select ai, bi, ci from onesix_c; -- 2
insert into onesix_c (ai, bi, ci) select ai, bi, ci from onesix_c; -- 4
insert into onesix_c (ai, bi, ci) select ai, bi, ci from onesix_c; -- 8
insert into onesix_c (ai, bi, ci) select ai, bi, ci from onesix_c; -- 16
insert into onesix_c (ai, bi, ci) select ai + 1, bi, ci from onesix_c; -- 32
insert into onesix_c (ai, bi, ci) select ai + 2, bi, ci from onesix_c; -- 64
insert into threetwo_c (ai, bi, ci) values (1, 1, 1);
insert into threetwo_c (ai, bi, ci) select ai, bi, ci from threetwo_c; -- 2
insert into threetwo_c (ai, bi, ci) select ai, bi, ci from threetwo_c; -- 4
insert into threetwo_c (ai, bi, ci) select ai, bi, ci from threetwo_c; -- 8
insert into threetwo_c (ai, bi, ci) select ai, bi, ci from threetwo_c; -- 16
insert into threetwo_c (ai, bi, ci) select ai, bi, ci from threetwo_c; -- 32  
insert into threetwo_c (ai, bi, ci) select ai + 1, bi, ci from threetwo_c; -- 64 
insert into sixfour_c (ai, bi, ci) values (1, 1, 1);
insert into sixfour_c (ai, bi, ci) select ai, bi, ci from sixfour_c; -- 2 
insert into sixfour_c (ai, bi, ci) select ai, bi, ci from sixfour_c; -- 4 
insert into sixfour_c (ai, bi, ci) select ai, bi, ci from sixfour_c; -- 8 
insert into sixfour_c (ai, bi, ci) select ai, bi, ci from sixfour_c; -- 16 
insert into sixfour_c (ai, bi, ci) select ai, bi, ci from sixfour_c; -- 32 
insert into sixfour_c (ai, bi, ci) select ai, bi, ci from sixfour_c; -- 64
update one_c
set an = ai, af = ai,
    bn = bi, bf = bi,
    cn = ci, cf = ci,
    ac = 'test_ac', bc = 'test_bc', cc = 'test_cc',
    av = 'test_av', bv = 'test_bv', cv = 'test_cv',
    ad = DATE '09/20/2001', bd = DATE '09/20/2001', cd = DATE '09/20/2001';
update two_c
set an = ai, af = ai,
    bn = bi, bf = bi,
    cn = ci, cf = ci,
    ac = 'test_ac', bc = 'test_bc', cc = 'test_cc',
    av = 'test_av', bv = 'test_bv', cv = 'test_cv',
    ad = DATE '09/20/2001', bd = DATE '09/20/2001', cd = DATE '09/20/2001';
update four_c
set an = ai, af = ai,
    bn = bi, bf = bi,
    cn = ci, cf = ci,
    ac = 'test_ac', bc = 'test_bc', cc = 'test_cc',
    av = 'test_av', bv = 'test_bv', cv = 'test_cv',
    ad = DATE '09/20/2001', bd = DATE '09/20/2001', cd = DATE '09/20/2001';
update eight_c
set an = ai, af = ai,
    bn = bi, bf = bi,
    cn = ci, cf = ci,
    ac = 'test_ac', bc = 'test_bc', cc = 'test_cc',
    av = 'test_av', bv = 'test_bv', cv = 'test_cv',
    ad = DATE '09/20/2001', bd = DATE '09/20/2001', cd = DATE '09/20/2001';
update onesix_c
set an = ai, af = ai,
    bn = bi, bf = bi,
    cn = ci, cf = ci,
    ac = 'test_ac', bc = 'test_bc', cc = 'test_cc',
    av = 'test_av', bv = 'test_bv', cv = 'test_cv',
    ad = DATE '09/20/2001', bd = DATE '09/20/2001', cd = DATE '09/20/2001';
update threetwo_c
set an = ai, af = ai,
    bn = bi, bf = bi,
    cn = ci, cf = ci,
    ac = 'test_ac', bc = 'test_bc', cc = 'test_cc',
    av = 'test_av', bv = 'test_bv', cv = 'test_cv',
    ad = DATE '09/20/2001', bd = DATE '09/20/2001', cd = DATE '09/20/2001';
update sixfour_c
set an = ai, af = ai,
    bn = bi, bf = bi,
    cn = ci, cf = ci,
    ac = 'test_ac', bc = 'test_bc', cc = 'test_cc',
    av = 'test_av', bv = 'test_bv', cv = 'test_cv',
    ad = DATE '09/20/2001', bd = DATE '09/20/2001', cd = DATE '09/20/2001';
SELECT DISTINCT ai FROM one_c;
SELECT DISTINCT ai, bi, ci FROM one_c;
SELECT DISTINCT ai, bi, ci, an, bn, cn, af, bf, cf, ad, bd, cd FROM one_c;
SELECT DISTINCT * FROM one_c;
SELECT DISTINCT ai FROM one_c ORDER BY 1 desc;
SELECT DISTINCT ai, bi, ci FROM one_c ORDER BY 1 desc;
SELECT DISTINCT ai, bi, ci, an, bn, cn, af, bf, cf, ad, bd, cd FROM one_c ORDER BY 1 desc;
SELECT DISTINCT * FROM one_c ORDER BY 1 desc;
SELECT ai FROM one_c 
UNION 
SELECT ai FROM one_c;
SELECT ai, bi, ci FROM one_c 
UNION 
SELECT ai, bi, ci FROM one_c;
SELECT ai, bi, ci, an, bn, cn, af, bf, cf, ad, bd, cd FROM one_c 
UNION 
SELECT ai, bi, ci, an, bn, cn, af, bf, cf, ad, bd, cd FROM one_c;
SELECT * FROM one_c 
UNION 
SELECT * FROM one_c;
SELECT DISTINCT ai FROM one_c 
DIFFERENCE DISTINCT 
SELECT DISTINCT ai FROM one_c;
SELECT DISTINCT ai, bi, ci FROM one_c 
DIFFERENCE DISTINCT 
SELECT DISTINCT ai, bi, ci FROM one_c;
SELECT DISTINCT ai, bi, ci, an, bn, cn, af, bf, cf, ad, bd, cd FROM one_c
DIFFERENCE DISTINCT 
SELECT DISTINCT ai, bi, ci, an, bn, cn, af, bf, cf, ad, bd, cd FROM one_c;
SELECT DISTINCT * FROM one_c 
DIFFERENCE DISTINCT 
SELECT DISTINCT * FROM one_c;
rollback;
