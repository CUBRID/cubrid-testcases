set timezone 'Asia/Shanghai';

select if((SELECT current_timestamp - utc_timestamp())='28800','ok','nok');

set timezone 'Asia/Seoul';