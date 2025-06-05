/**
 *  This test case verifies CBRD-25542 : Problem with Partition Pruning When Using Multi-Column Indexes with IN and Range Predicates
 */

drop table if exists ta;
create table ta(cola int, colb int,index idx(cola, colb))
    partition by range(cola)
    (
        partition pa values less than (1),
        partition pb values less than (2),
        partition pc values less than MAXVALUE
    );

insert into ta values (1, 1), (2, 2), (3, 3);

set trace on;

evaluate concat ('1. multi column index, where_range');

select /*+ recompile */ count(*) from ta use index(idx) where cola in (1) and colb > 0;
show trace;
--select trace_stats ();

select /*+ recompile */ count(*) from ta use index(idx) where cola = 1 and colb > 0;
show trace;
--select trace_stats ();

evaluate concat ('2. multi column index, where_key, where_range');

select /*+ recompile */ count(*) from ta use index(idx) where cola > 0 and colb = 1;
show trace;
--select trace_stats ();

evaluate concat ('3. ignore index, where_pred');

select /*+ recompile */ count(*) from ta ignore index(idx) where cola = 0 and colb > 1;
show trace;
--select trace_stats ();

evaluate concat ('4. ignore index, no predicate expression');

select /*+ recompile */ count(*) from ta;
show trace;
--select trace_stats ();

drop table if exists tb;
create table tb(cola int, index iidx(abs(cola))) 
    partition by range(abs(cola)) 
    (
        partition pa values less than (1), 
        partition pb values less than (2),
        partition pc values less than (3),
        partition pd values less than MAXVALUE
    );

insert into tb values (-1), (1), (-2), (2), (-3), (3), (-4);

evaluate concat ('5. function index, where_range');

select /*+ recompile */ * from tb use index(iidx) where abs(cola) >= 2;
show trace;
--select trace_stats ();

evaluate concat ('6. ignore function index, no predicate expression');

select  /*+ recompile */ * from tb ignore index(iidx) where abs(cola) >= 2;
show trace;
--select trace_stats ();

drop table if exists ta;
