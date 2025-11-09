select length(review_text), * 
from {{ref('fact_reviews')}}
where  length(review_text) <4