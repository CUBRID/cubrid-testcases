CREATE TABLE blogtopic (topicId INTEGER, postDate DATE, closedDate DATE);
insert into blogtopic value(1,DATE '2010-01-01',DATE '2010-01-02');
insert into blogtopic value(2,DATE '2010-01-03',DATE '2010-01-04');
CREATE INDEX my_filter_index ON blogtopic (topicId,postDate) WHERE topicId>1 AND postDate>'2010-01-01';
SELECT /*+ recompile */* FROM blogtopic WHERE 1=0 OR (topicId>1 AND postDate>'2010-01-01') using index my_filter_index(+);
SELECT /*+ recompile */* FROM blogtopic WHERE 1=1 OR (topicId>1 AND postDate>'2010-01-01') using index my_filter_index(+);
Drop table blogtopic;

CREATE TABLE blogtopic (topicId INTEGER, postDate DATE, closedDate DATE);
insert into blogtopic value(1,DATE '2010-01-01',DATE '2010-01-02');
insert into blogtopic value(2,DATE '2010-01-03',DATE '2010-01-04');
CREATE INDEX my_filter_index ON blogtopic (topicId,postDate) WHERE 1=0 OR (topicId>1 AND postDate>'2010-01-01') ;
CREATE INDEX my_filter_index ON blogtopic (topicId,postDate) WHERE 1=1 OR (topicId>1 AND postDate>'2010-01-01') ;
Drop table blogtopic;

