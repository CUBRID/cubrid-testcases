CREATE TABLE blogtopic (topicId INTEGER, postDate DATE, closedDate DATE);
insert into blogtopic value(1,DATE '2010-01-01',DATE '2010-01-02');
insert into blogtopic value(2,DATE '2010-01-03',DATE '2010-01-04');
CREATE INDEX my_filter_index1 ON blogtopic (topicId) WHERE topicId>1;
CREATE INDEX my_filter_index2 ON blogtopic (topicId,postDate) WHERE postDate>'2010-01-01' AND closedDate IS NULL;
SELECT /*+ recompile */* FROM blogtopic WHERE topicId >1 OR (topicId < 1 and postDate>'2010-01-01' AND closedDate IS NULL) using index my_filter_index2(+),my_filter_index1(+);
Drop table blogtopic;
