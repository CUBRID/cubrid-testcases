--+ holdcas on;
set  system parameters 'dont_reuse_heap_file=yes';
CREATE TABLE blogtopic (topicId INTEGER, postDate DATE, closedDate DATE);
insert into blogtopic value(1,DATE '2010-01-01',DATE '2010-01-02');
CREATE INDEX my_filter_index1 ON blogtopic (topicId) WHERE topicId>1;
--TEST: See change after insert
SELECT /*+ recompile */* FROM blogtopic WHERE topicId > 1 using index my_filter_index1(+);
insert into blogtopic values(2,DATE '2010-01-01',DATE '2010-01-03');
SELECT /*+ recompile */* FROM blogtopic WHERE topicId > 1 using index my_filter_index1(+);
--TEST: See change after delete
delete  from blogtopic where topicId=0;
SELECT /*+ recompile */* FROM blogtopic WHERE topicId > 1 using index my_filter_index1(+);
--TEST: See change after delete
delete  from blogtopic where topicId=2;
SELECT /*+ recompile */* FROM blogtopic WHERE topicId > 1 using index my_filter_index1(+);
--TEST: See change after insert
insert into blogtopic values(2,DATE '2010-01-01',DATE '2010-01-03');
SELECT /*+ recompile */* FROM blogtopic WHERE topicId > 1 using index my_filter_index1(+);
Drop table blogtopic;
set  system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;
