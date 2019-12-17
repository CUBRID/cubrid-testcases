set names utf8 collate utf8_en_cs;
SELECT JSON_SEARCH('{"Name": "Bart", "Age": 10}', 'one', 'Bart') ;

set names iso88591;
commit;
