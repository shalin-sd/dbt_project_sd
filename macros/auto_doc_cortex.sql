{% macro auto_doc_cortex(relation) %}
    {%- do log("Starting AI documentation for " ~ relation, info=True) -%}
    {%- set database = relation.database -%}
    {%- set schema = relation.schema -%}
    {%- set table = relation.identifier -%}
    {%- set columns = adapter.get_columns_in_relation(relation) -%}

    {% for col in columns %}
        {% set col_name = col.name %}
        {% set col_type = col.data_type %}

        {%- do log(" Generating AI description for column " ~ col_name, info=True) -%}

        {% set prompt %}
            You are a data analyst. Write a concise, business-friendly description for column "{{ col_name }}"
            (type: {{ col_type }}) in table {{ database }}.{{ schema }}.{{ table }}.
            Do not repeat the column name.
        {% endset %}

        {% set sql %}
            SELECT SNOWFLAKE.CORTEX.COMPLETE('snowflake-arctic', '{{ prompt | replace("'", "''") }}') AS AI_TEXT
        {% endset %}

        {% set results = run_query(sql) %}
        {% if execute %}
            {% set ai_text = results.columns[0].values()[0] %}
            {%- do log(" " ~ col_name ~ " → " ~ ai_text, info=True) -%}

            {% set comment_sql %}
                COMMENT ON COLUMN {{ database }}.{{ schema }}.{{ table }}.{{ col_name }} 
                IS '{{ ai_text | replace("'", "''") }}';
            {% endset %}
            {%- do run_query(comment_sql) -%}
        {% endif %}
    {% endfor %}
{% endmacro %}
