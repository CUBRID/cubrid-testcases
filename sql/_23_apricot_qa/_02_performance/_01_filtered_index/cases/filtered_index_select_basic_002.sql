--+ holdcas on;
set  system parameters 'dont_reuse_heap_file=yes';
CREATE TABLE blogtopic (topicId INTEGER not null, postDate DATE, closedDate DATE);
insert into blogtopic value(1,DATE '2010-01-01',DATE '2010-01-02');
insert into blogtopic value(2,DATE '2010-01-03',DATE '2010-01-04');
--CREATE INDEX my_filter_index ON blogtopic (topicId);
CREATE INDEX my_filter_index1 ON blogtopic (topicId) WHERE topicId>1;
--TEST: Selecte not using my_filter_index1 
SELECT /*+ recompile */* FROM blogtopic WHERE topicId > 1;
--TEST: Selecte  using my_filter_index1 
SELECT /*+ recompile */* FROM blogtopic WHERE topicId > 1 using index my_filter_index1(+);
--TEST: Selecte not using my_filter_index 
SELECT /*+ recompile */* FROM blogtopic WHERE topicId = 1 using index my_filter_index1(+);
Drop table blogtopic;
CREATE TABLE blogtopic (topicId INTEGER not null, postDate DATE, closedDate DATE);
insert into blogtopic value(1,DATE '2010-01-01',DATE '2010-01-02');
insert into blogtopic value(2,DATE '2010-01-03',DATE '2010-01-04');
CREATE INDEX my_filter_index2 ON blogtopic (topicId) WHERE postDate>'2010-01-01' AND closedDate IS NULL;
--TEST: Selecte without index 
SELECT /*+ recompile */* FROM blogtopic WHERE postDate>'2010-01-01'using index my_filter_index2(+);
--TEST: Selecte without index 
SELECT /*+ recompile */* FROM blogtopic WHERE closedDate IS NULL using index my_filter_index2(+);
--TEST: Selecte without index 
SELECT /*+ recompile */* FROM blogtopic WHERE postDate>'2010-01-01' or closedDate IS NULL using index my_filter_index2(+);
--TEST: Selecte without my_filter_index2
SELECT /*+ recompile */* FROM blogtopic WHERE postDate>'2010-01-01' AND closedDate IS NULL using index my_filter_index2(+);
--TEST: Selecte using my_filter_index2
SELECT /*+ recompile */* FROM blogtopic WHERE postDate>'2010-01-01' AND closedDate IS NULL AND topicId = 1 using index my_filter_index2(+);
--TEST: Selecte using my_filter_index2 
SELECT /*+ recompile */* FROM blogtopic WHERE postDate>'2010-01-01' AND closedDate IS NULL AND topicId > 1 using index my_filter_index2(+);
--TEST: Selecte using my_filter_index2 
SELECT /*+ recompile */* FROM blogtopic WHERE topicId >1 AND postDate>'2010-01-01' AND closedDate IS NULL using index my_filter_index2(+);
--TEST: Selecte without index 
SELECT /*+ recompile */* FROM blogtopic WHERE topicId >1 or (postDate>'2010-01-01' AND closedDate IS NULL) using index my_filter_index2(+);
Drop table blogtopic;
set  system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;
