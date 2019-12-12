set names utf8;
SELECT '韩国', JSON_ARRAY('中国', '韩国') AS json_data;
SELECT '首尔', JSON_OBJECT('city','首尔') as json_data;