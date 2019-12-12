CREATE TABLE bug_6796 (topicId INTEGER, postDate DATE, closedDate DATE);
--expected error
CREATE INDEX idx1 ON bug_6796 (topicId) WHERE false;
CREATE INDEX idx2 ON bug_6796 (topicId) WHERE 0;
CREATE INDEX idx3 ON bug_6796 (topicId) WHERE false and true;
CREATE INDEX idx4 ON bug_6796 (topicId) WHERE false or false;
CREATE INDEX idx5 ON bug_6796 (topicId) WHERE (false and true) or (false and true);
CREATE INDEX idx6 ON bug_6796 (topicId) WHERE (false and true) and (false and true);
CREATE INDEX idx7 ON bug_6796(topicId) WHERE 1=2;
CREATE INDEX idx8 ON bug_6796(topicId) WHERE UCASE('c') < 'A';

--expected right
CREATE INDEX idx1 ON bug_6796(topicId) WHERE 1;
drop index idx1 on bug_6796(topicId);
CREATE INDEX idx1 ON bug_6796(topicId) WHERE (true or false) and (true or false);
drop index idx1 on bug_6796(topicId);
CREATE INDEX idx1 ON bug_6796(topicId) WHERE (true and false) or (true or false);
drop index idx1 on bug_6796(topicId);
CREATE INDEX idx1 ON bug_6796 (postDate) WHERE true or false;
drop index idx1 on bug_6796 (postDate);
CREATE INDEX idx1 ON bug_6796 (closedDate) WHERE false or true;
drop index idx1 on bug_6796 (closedDate);


CREATE INDEX idx1 ON bug_6796(topicId) WHERE 2=2;
drop index idx1 on bug_6796(topicId);
--it is false for ever,but expected right
CREATE INDEX idx1 ON bug_6796(topicId) WHERE postDate >'2010-01-01' and postDate <'2010-01-01';
drop index idx1 on bug_6796(topicId);
create index idx1 on bug_6796(topicId) where abs(topicId) <0;
drop index idx1 on bug_6796(topicId);
drop table  bug_6796;

