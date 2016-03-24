-- regular expression syntax errors
select ('' rlike 'a{5,3}');
select ('' rlike '((a)');
