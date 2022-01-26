--+ holdcas on;
set  system parameters 'dont_reuse_heap_file=yes';
CREATE TABLE bugs (bugID BIGINT not null ,CreationDate TIMESTAMP,Author VARCHAR(255),Subject VARCHAR(255),CurrentStatus INTEGER, Closed SMALLINT);
insert into bugs values(1,TIMESTAMP '2010-10-31 01:15:45','yin','test',1,0);
CREATE INDEX open_bugs ON bugs(bugID) WHERE Closed = 0;
Drop INDEX open_bugs on bugs;
CREATE INDEX open_bugs ON bugs(bugID) WHERE Closed = 0;
CREATE REVERSE INDEX close_bugs ON bugs(bugID) WHERE Closed <> 0;
CREATE UNIQUE INDEX bugs_per_dev ON bugs(Author) WHERE Closed = 0;
CREATE INDEX open_bugs1 ON bugs(bugID) WHERE Closed > 0;
drop table bugs ;

CREATE TABLE blogtopic (topicId INTEGER not null, postDate DATE, closedDate DATE);
insert into blogtopic value(1,DATE '2010-01-01',DATE '2010-01-02');
CREATE INDEX my_filter_index ON blogtopic (topicId);
CREATE INDEX my_filter_index1 ON blogtopic (topicId) WHERE topicId IS NOT NULL;
CREATE INDEX my_filter_index1 ON blogtopic (topicId) WHERE closedDate IS NULL;
Drop INDEX my_filter_index on blogtopic; 
CREATE INDEX my_filter_index ON blogtopic (topicId) WHERE postDate>='2010-01-01' AND closedDate IS NULL;
CREATE INDEX my_filter_index1 ON blogtopic (topicId) WHERE closedDate IS NOT NULL;
Drop INDEX my_filter_index on blogtopic; 
CREATE INDEX my_filter_index ON blogtopic (topicId) WHERE postDate<closedDate;
CREATE INDEX my_filter_index ON blogtopic (topicId,postDate) WHERE postDate>'2010-01-01' AND closedDate<='2011-01-01';
CREATE INDEX my_filter_index1 ON blogtopic (topicId,postDate) WHERE postDate>'2010-01-01' AND closedDate<='2011-01-01';
Drop INDEX my_filter_index on blogtopic;
Drop INDEX my_filter_index1 on blogtopic;
CREATE INDEX my_filter_index ON blogtopic (topicId) WHERE months_between(closedDate, postDate)>3;
Drop INDEX my_filter_index on blogtopic;
CREATE INDEX my_filter_index  ON blogtopic (topicId) WHERE postDate>'2010-01-01' OR closedDate IS NULL;
Drop INDEX my_filter_index on blogtopic;
CREATE INDEX my_filter_index ON blogtopic (topicId,postDate,closedDate) WHERE postDate>='2010-01-01' AND closedDate IS NOT NULL;

CREATE INDEX my_filter_index1 ON blogtopic (topicId,postDate,closedDate);
Drop INDEX my_filter_index on blogtopic;
CREATE INDEX my_filter_index ON blogtopic (topicId,postDate,closedDate) WHERE topicId<>0;
select /*+ recompile */* from blogtopic WHERE topicId<>0 using index my_filter_index(+);

drop table blogtopic;

set  system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;
