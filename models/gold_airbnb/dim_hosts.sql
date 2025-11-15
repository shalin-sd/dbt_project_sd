{# config(
    post_hook = "{{ auto_doc_cortex(this) }}"
) #}
SELECT
    a.host_id,
    NVL( a.host_name, 'Anonymous') AS host_name,
    a.is_superhost,
    a.created_at,
    a.updated_at
FROM
    {{ ref('silver_hosts') }} a inner join  {{ ref('hosts_snapshot') }} b
    on a.host_id = b.host_id
    and current_date() between b.DBT_VALID_FROM::date and nvl(b.DBT_VALID_TO::date,'9999-12-31')