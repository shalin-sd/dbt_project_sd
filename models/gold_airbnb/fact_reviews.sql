{{
  config(
    materialized = 'incremental',
    unique_key = ['listing_id','reviewer_name'],
    cluster_by = ['REVIEW_DATE'],  
    incremental_strategy = 'merge',
    incremental_predicates = [
      "DBT_INTERNAL_DEST.REVIEW_DATE > dateadd(day, -30, '2021-10-28')"
    ]
  )
}}

select * from  {{ref('silver_reviews')}}
{% if is_incremental() %}
where review_date > (select max(review_date) from {{this}})
{% endif %}