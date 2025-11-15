{% macro generate_hash_key_args(args) %}
      md5(
	  concat('-', 
				{% for arg in args %}
					{{ arg }}
                    {% if not loop.last %}
							, 
					{% endif %}
				{% endfor %}
			)
	)
{% endmacro %}