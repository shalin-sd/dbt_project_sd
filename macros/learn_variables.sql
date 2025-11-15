{% macro learn_variables()%}
    {% set your_name_jinja = 'Ankur' %}
    {{log("Hello! " ~ your_name_jinja ~ " from jinja variable ", info = True )}}
    {{log("Hello! " ~ var("dbt_user_name", "no user name is sent") ~ " from dbt variable ", info = True )}}
{% endmacro %}
