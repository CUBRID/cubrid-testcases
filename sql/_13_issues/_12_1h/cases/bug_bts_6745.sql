CREATE TABLE blogtopic (topicId INTEGER, postDate DATE, closedDate DATE);
insert into blogtopic value(1,DATE '2010-01-01',DATE '2010-01-02');
insert into blogtopic value(2,DATE '2010-01-03',DATE '2010-01-04');
CREATE INDEX my_filter_index1 ON blogtopic (topicId) WHERE topicId>1;
SELECT /*+ recompile */* FROM blogtopic WHERE topicId =1 using index my_filter_index1(+);
Drop table blogtopic;

