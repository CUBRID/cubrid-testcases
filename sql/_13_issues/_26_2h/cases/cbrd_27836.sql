/**
 *  This test case verifies CBRD-27836: UPDATE STATISTICS ON ALL CLASSES WITH FULLSCAN keeps the requested mode.
 *  The run used to update the class statistics of every class in that mode and then build the histograms, and the
 *  histogram pass updated the class statistics once more, always with sampling. Now each class is done once, the
 *  way UPDATE STATISTICS ON <class> does it: db_class.statistics_strategy says how the class statistics were
 *  collected, and db_histogram.scan_type says how each histogram was, also when a later run collects an existing
 *  histogram again in the other mode.
 *
 *  Coverage:
 *    Case 1: ALL CLASSES WITH FULLSCAN on classes without histograms: FULLSCAN, and the new histograms FULL SCAN
 *    Case 2: ALL CLASSES (sampling) collects the same histograms again: SAMPLING and SAMPLING SCAN
 *    Case 3: one class WITH FULLSCAN collects its histograms again: FULLSCAN and FULL SCAN for that class only
 *    Case 4: ALL CLASSES WITH FULLSCAN, NO HISTOGRAM: FULLSCAN, and the histograms are left as they are
 *    Case 5: ALL CLASSES WITH FULLSCAN on a class without a histogrammable column (its statistics come from the
 *            histogram pass all the same) and on a partitioned class and its partitions: FULLSCAN for each
 */

drop table if exists t_27836_1, t_27836_2, t_27836_3, t_27836_4;

create table t_27836_1 (a int, b int);
create index i_27836_1 on t_27836_1 (a, b);
insert into t_27836_1 select level mod 7, level from db_root connect by level <= 100;
create table t_27836_2 (c varchar (10));
insert into t_27836_2 select 'v' || (level mod 3) from db_root connect by level <= 20;

evaluate 'Case 1: ALL CLASSES WITH FULLSCAN';
update statistics on all classes with fullscan;
select class_name, statistics_strategy from db_class where class_name in ('t_27836_1', 't_27836_2') order by 1;
select class_name, attr_name, scan_type from db_histogram where class_name in ('t_27836_1', 't_27836_2') order by 1, 2;

evaluate 'Case 2: ALL CLASSES collects the histograms again with sampling';
update statistics on all classes;
select class_name, statistics_strategy from db_class where class_name in ('t_27836_1', 't_27836_2') order by 1;
select class_name, attr_name, scan_type from db_histogram where class_name in ('t_27836_1', 't_27836_2') order by 1, 2;

evaluate 'Case 3: one class WITH FULLSCAN collects its histograms again';
update statistics on t_27836_1 with fullscan;
select class_name, statistics_strategy from db_class where class_name in ('t_27836_1', 't_27836_2') order by 1;
select class_name, attr_name, scan_type from db_histogram where class_name in ('t_27836_1', 't_27836_2') order by 1, 2;

evaluate 'Case 4: ALL CLASSES WITH FULLSCAN, NO HISTOGRAM';
update statistics on all classes with fullscan, no histogram;
select class_name, statistics_strategy from db_class where class_name in ('t_27836_1', 't_27836_2') order by 1;
select class_name, attr_name, scan_type from db_histogram where class_name in ('t_27836_1', 't_27836_2') order by 1, 2;

evaluate 'Case 5: ALL CLASSES WITH FULLSCAN, a class without a histogrammable column and a partitioned class';
create table t_27836_3 (j json);
insert into t_27836_3 values ('{"a": 1}');
create table t_27836_4 (a int) partition by hash (a) partitions 2;
insert into t_27836_4 select level from db_root connect by level <= 10;
update statistics on all classes with fullscan;
select class_name, statistics_strategy from db_class
 where class_name in ('t_27836_3', 't_27836_4', 't_27836_4__p__p0', 't_27836_4__p__p1') order by 1;

drop table t_27836_1, t_27836_2, t_27836_3, t_27836_4;
