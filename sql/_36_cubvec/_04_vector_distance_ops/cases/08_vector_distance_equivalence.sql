select
  vector_distance('[1, 2, 3]', '[2, 3, 4]', COSINE),
  '[1, 2, 3]' <=> '[2, 3, 4]';

select
  vector_distance('[1, 2, 3]', '[2, 3, 4]', DOT),
  '[1, 2, 3]' <#> '[2, 3, 4]';

select
  vector_distance('[1, 2, 3]', '[2, 3, 4]', EUCLIDEAN),
  '[1, 2, 3]' <-> '[2, 3, 4]';

select
  vector_distance('[1, 2, 3]', '[2, 3, 4]', MANHATTAN),
  '[1, 2, 3]' <+> '[2, 3, 4]';
