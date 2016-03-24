select (not '4@Y' regexp '^[XuyY1@]$'), (not 'vXuy' rlike '[^Xu-yY1@]+$'), (not 'W' rlike '^[^Xu-yY1@]$'), (not 'failabcabcabc' not regexp 'fail.(abc)+$'), (not '3333' not rlike '(33){3,}$'), (not 'xxx' not regexp '^xx?$'), (not 'xxa' not rlike 'x*X?(xX)?$');
select (not '@ul' regexp '^[XuyY1@]$'), (not 'vAb' rlike '[^Xu-yY1@]+$'), (not 'a' rlike '^[^Xu-yY1@]$'), (not 'FailaABC' not regexp 'fail.(abc)+$'), (not '333433333333' not rlike '(33){2,}$'), (not 'X' not regexp '^xx?$'), (not 'xxa' not rlike 'x*X?(xX)+$');
select (not '@ul' regexp '^([XuyY1@]|ul)$'), (not 'vAb' rlike '[^Xu-yY1@]|Abv+$'), (not 'u' rlike '^u|^[^Xu-yY1@]$'), (not 'FailABC' not regexp 'fail(abc)+|fail.(abc)+$'), (not '33343' not rlike '33{2,}|(33){2,}$'), (not 'Xxxxxxxxxx' not regexp '^xxx$|^xx?$'),(not 'xxa' not rlike '^f+|(xX)+$');
select (not NULL regexp '^[XuyY1@]$'), (not NULL rlike '[^Xu-yY1@]+$'), (not 'W' rlike NULL), (not NULL not regexp 'fail.(abc)+$'), (not NULL not rlike '(33){3,}$'), (not NULL not regexp '^xx?$'), (not 'xxa' not rlike NULL);

select ('ab' regexp 'ab{3,2}');
select ('aabbb' rlike 'ab{2,2}$');
select ('aabbb' rlike 'ab{2,255}$');
select ('aabbb' rlike 'ab{2,256}$');
select ('aabbb' rlike 'ab{0,3}$');
select ('aabbb' rlike 'ab{-1,3}$');
