/**
 *  This test case verifies CBRD-25542 : Problem with Partition Pruning When Using Multi-Column Indexes with IN and Range Predicates
 */

drop table if exists ta;
create table ta(col1 int, col2 int,index i1(col1, col2))
    partition by range(col1)
    (
        partition pa values less than (1),
        partition pb values less than (2),
        partition pc values less than MAXVALUE
    );

insert into ta values (1, 1), (2, 2), (3, 3);

set trace on;

evaluate concat ('1. multi column index, where_range');

select /*+ recompile */ count(*) from ta use index(i1) where col1 in (1) and col2 > 0;
show trace;
--select trace_stats ();

select /*+ recompile */ count(*) from ta use index(i1) where col1 = 1 and col2 > 0;
show trace;
--select trace_stats ();

evaluate concat ('2. multi column index, where_key, where_range');

select /*+ recompile */ count(*) from ta use index(i1) where col1 > 0 and col2 = 1;
show trace;
--select trace_stats ();

evaluate concat ('3. ignore index, where_pred');

select /*+ recompile */ count(*) from ta ignore index(i1) where col1 = 0 and col2 > 1;
show trace;
--select trace_stats ();

evaluate concat ('4. ignore index, no predicate expression');

select /*+ recompile */ count(*) from ta;
show trace;
--select trace_stats ();

drop table if exists tb;
create table tb(col1 int, index i2(abs(col1))) 
    partition by range(abs(col1)) 
    (
        partition pa values less than (1), 
        partition pb values less than (2),
        partition pc values less than (3),
        partition pd values less than MAXVALUE
    );

insert into tb values (-1), (1), (-2), (2), (-3), (3), (-4);

evaluate concat ('5. function index, where_range');

select /*+ recompile */ * from tb use index(i2) where abs(col1) >= 2;
show trace;
--select trace_stats ();

evaluate concat ('6. ignore function index, no predicate expression');

select  /*+ recompile */ * from tb ignore index(i2) where abs(col1) >= 2;
show trace;
--select trace_stats ();

drop table if exists ta;
