set names utf8;

SHOW /*+ HERE IS COMMENT */ COLLATION;   
SHOW /*+ HERE IS COMMENT */ COLLATION like '%ci%';
SHOW /*+ HERE IS COMMENT */ COLLATION where charset='utf8';
SHOW /*+ RECOMPILE */ COLLATION;
SHOW /*+ RECOMPILE */ COLLATION like '%ci%';
SHOW /*+ RECOMPILE */ COLLATION where charset='utf8';

set names iso88591;
