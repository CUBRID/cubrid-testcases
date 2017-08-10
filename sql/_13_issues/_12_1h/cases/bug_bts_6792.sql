CREATE TABLE blogtopic (topicId INTEGER, postDate DATE, closedDate DATE);
CREATE INDEX i_blogtopic_topicId ON blogtopic (topicId) WHERE postDate>'2010-01-01' ;
drop index i_blogtopic_topicId ON blogtopic (topicId) WHERE postDate='2010-01-01' ;
drop index i_blogtopic_topicId ON blogtopic (topicId);
CREATE INDEX i_blogtopic_topicId ON blogtopic (topicId) WHERE postDate>'2010-01-01' ;
drop index i_blogtopic_topicid on blogtopic;
CREATE INDEX idx ON blogtopic (topicId) WHERE postDate>'2010-01-01' ;
drop index idx on blogtopic;
drop table blogtopic ;

