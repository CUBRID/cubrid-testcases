autocommit off;
CREATE CLASS co7234_3_1(
       co7234_3_1_mlt multiset(integer,float,monetary),
       co7234_3_1_dub double,
       co7234_3_1_ref1 co7234_3_1);
insert into co7234_3_1 values({1,2,3}, 1, NULL) to :a1;
update object :a1 set co7234_3_1_ref1 = :a1;
CREATE CLASS co7234_4_1 under co7234_3_1(
       co7234_4_1_dte date);
insert into co7234_4_1 values({4,5,6}, 2, :a1, date'01/31/1996');
select x, x.co7234_3_1_dub, y, x.co7234_3_1_ref1{y}.co7234_3_1_dub
from only co7234_3_1 x, (co7234_3_1, co7234_4_1) y;
create class a7234 (n char(5), x a7234, y int);
create class b7234 under a7234(b int);
create class c7234 under b7234(c real);
create class d7234 under c7234(d bit);
create class e7234 under d7234(e numeric(19,2));
create class f7234 under e7234(f smallint);
insert into a7234 values('a', NULL, 1) to :a1;
insert into b7234 values('b', NULL, 2, 20) to :b1;
insert into c7234 values('c', NULL, 3, 30, 300) to :c1;
insert into d7234 values('d', NULL, 4, 40, 400, b'1') to :d1;
insert into e7234 values('e', NULL, 5, 50, 500, b'0', 5.5) to :e1;
insert into f7234 values('f', NULL, 6, 60, 600, b'0', 6.6, 6) to :f1;
update object :a1 set x = :a1;
update object :b1 set x = :b1;
update object :c1 set x = :c1;
update object :d1 set x = :d1;
update object :e1 set x = :e1;
update object :f1 set x = :f1;
select * from f7234, (all a7234 (except b7234,c7234), d7234) z
where f7234.x{z}.y > 0;
select x.country from (public.accommodations, public.location) x;
select accommodations.country from only public.accommodations, public.location;
select name from all public.accommodations (except public.hotel) order by name;
select name from (public.bed_and_breakfast, public.motel) order by name;
select name from all public.accommodations (except (public.resort, public.hotel)) order by name;
rollback;
