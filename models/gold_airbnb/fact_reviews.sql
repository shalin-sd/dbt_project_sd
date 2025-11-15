{{
  config(
    materialized = 'incremental',
    unique_key = ['listing_id','reviewer_name'],
    cluster_by = ['REVIEW_DATE'],  
    incremental_strategy = 'merge',
    incremental_predicates = [
      "DBT_INTERNAL_DEST.REVIEW_DATE > dateadd(day, -30, '2021-10-28')"
    ],
    on_schema_change = 'fail'
  )
}}

select 
{{
  generate_hash_key_args(['listing_id','review_date', 'reviewer_name', 'review_text','review_sentiment'])
}} as review_id,
* 
from  {{ref('silver_reviews')}}
{% if is_incremental() %}
    {% if var("start_date", False) and var("end_date", False) %}
        {{ log('Loading ' ~ this ~ ' incrementally (start_date: ' ~ var("start_date") ~ ', end_date: ' ~ var("end_date") ~ ')', info=True) }}
        where review_date >= '{{ var("start_date") }}'
        AND review_date < '{{ var("end_date") }}'
    {% else %}
        where review_date > (select max(review_date) from {{ this }})
        {{ log('Loading ' ~ this ~ ' incrementally (all missing dates)', info=True)}}
    {% endif %}
{% endif %}
