{% snapshot hosts_snapshot %}
{{
 config(
 schema='snapshots',
 unique_key='host_id',
 strategy='timestamp',
 updated_at='updated_at',
 invalidate_hard_deletes=True
 )
}}
select * FROM  {{ref('silver_hosts')}}
{% endsnapshot %}