{{config
(severity = "warn")
}}
select length(nvl(review_text,'')) as length_of_column, * 
from {{ref('fact_reviews')}}
where  length(nvl(review_text,'')) <4