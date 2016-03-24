--+ holdcas on;
set names utf8;
set system parameters 'intl_number_lang = de_DE';
set system parameters 'intl_date_lang = de_DE';
-- DATE_FORMAT
SELECT DATE_FORMAT('2011-5-1 22:23:24', '%D %W %y %a %d %m %M %b %j');
SELECT DATE_FORMAT('2011-5-2 22:23:24', '%D %W %y %a %d %m %M %b %j');
SELECT DATE_FORMAT('2011-5-3 22:23:24', '%D %W %y %a %d %m %M %b %j');
SELECT DATE_FORMAT('2011-5-4 22:23:24', '%D %W %y %a %d %m %M %b %j');
SELECT DATE_FORMAT('2011-5-5 22:23:24', '%D %W %y %a %d %m %M %b %j');
SELECT DATE_FORMAT('2011-5-6 22:23:24', '%D %W %y %a %d %m %M %b %j');
SELECT DATE_FORMAT('2011-5-7 22:23:24', '%D %W %y %a %d %m %M %b %j');


SELECT DATE_FORMAT('2011-1-1 22:23:24', '%D %W %y %a %d %m %M %b %j');
SELECT DATE_FORMAT('2011-2-1 22:23:24', '%D %W %y %a %d %m %M %b %j');
SELECT DATE_FORMAT('2011-3-1 22:23:24', '%D %W %y %a %d %m %M %b %j');
SELECT DATE_FORMAT('2011-4-1 22:23:24', '%D %W %y %a %d %m %M %b %j');
SELECT DATE_FORMAT('2011-5-1 22:23:24', '%D %W %y %a %d %m %M %b %j');
SELECT DATE_FORMAT('2011-6-1 22:23:24', '%D %W %y %a %d %m %M %b %j');
SELECT DATE_FORMAT('2011-7-1 22:23:24', '%D %W %y %a %d %m %M %b %j');
SELECT DATE_FORMAT('2011-8-1 22:23:24', '%D %W %y %a %d %m %M %b %j');
SELECT DATE_FORMAT('2011-9-1 22:23:24', '%D %W %y %a %d %m %M %b %j');
SELECT DATE_FORMAT('2011-10-1 22:23:24', '%D %W %y %a %d %m %M %b %j');
SELECT DATE_FORMAT('2011-11-1 22:23:24', '%D %W %y %a %d %m %M %b %j');
SELECT DATE_FORMAT('2011-12-1 22:23:24', '%D %W %y %a %d %m %M %b %j');
set system parameters 'intl_date_lang = en_US';
set system parameters 'intl_number_lang = en_US';
set names iso88591;
commit;
--+ holdcas off;

