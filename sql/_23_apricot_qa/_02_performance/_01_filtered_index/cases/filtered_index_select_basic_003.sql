--+ holdcas on;
CREATE TABLE blogtopic (topicId INTEGER not null, postDate DATE, closedDate DATE);
insert into blogtopic value(1,DATE '2010-01-01',DATE '2010-01-02');
insert into blogtopic value(2,DATE '2010-01-03',DATE '2010-01-04');
CREATE INDEX my_filter_index1 ON blogtopic (topicId) WHERE topicId>1;
SELECT /*+ recompile */* FROM blogtopic WHERE topicId >1 using index my_filter_index1(+);

CREATE INDEX my_filter_index2 ON blogtopic (topicId,postDate) WHERE postDate>'2010-01-01' AND closedDate IS NULL;

SELECT /*+ recompile */* FROM blogtopic WHERE topicId >1 OR (topicId < 1 and postDate>'2010-01-01' AND closedDate IS NULL) using index my_filter_index2(+),my_filter_index1(+);
Drop INDEX my_filter_index2 on blogtopic;
Drop INDEX my_filter_index1 on blogtopic;

CREATE INDEX my_filter_index ON blogtopic (topicId,postDate) WHERE topicId>1 AND postDate>'2010-01-01';
SELECT /*+ recompile */* FROM blogtopic WHERE topicId>1 AND postDate>'2010-01-01' using index my_filter_index(+);
SELECT /*+ recompile */* FROM blogtopic WHERE topicId>1 AND postDate>'2010-01-01' AND postDate>'2010-01-01'using index my_filter_index(+);
SELECT /*+ recompile */* FROM blogtopic WHERE topicId>1 OR postDate>'2010-01-01'using index my_filter_index(+);
SELECT /*+ recompile */* FROM blogtopic WHERE topicId>1 using index my_filter_index(+);
SELECT /*+ recompile */* FROM blogtopic WHERE postDate>'2010-01-01'using index my_filter_index(+);
SELECT /*+ recompile */* FROM blogtopic WHERE (topicId>1 AND postDate>'2010-01-01') OR postDate>'2010-01-01'using index my_filter_index(+);

SELECT /*+ recompile */* FROM blogtopic WHERE 1=1 OR (topicId>1 AND postDate>'2010-01-01') using index my_filter_index(+);
SELECT /*+ recompile */* FROM blogtopic WHERE 1=0 OR (topicId>1 AND postDate>'2010-01-01') using index my_filter_index(+);
SELECT /*+ recompile */ topicId FROM blogtopic WHERE topicId>1 AND postDate>'2010-01-01' using index my_filter_index(+);
SELECT /*+ recompile */ closedDate FROM blogtopic WHERE topicId>1 AND postDate>'2010-01-01' using index my_filter_index(+);
SELECT /*+ recompile */* FROM blogtopic WHERE topicId>1 AND postDate>'2010-01-01' AND 1=0 using index my_filter_index(+);

Drop table blogtopic;
commit;
--+ holdcas off;
