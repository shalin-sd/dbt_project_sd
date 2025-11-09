{% test string_not_empty(model, column_name) %}
select * from
 {{model}}
 where {{column_name}} = ''
{% endtest %}