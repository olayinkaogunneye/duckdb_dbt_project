{% test valid_lat_lon(model, column_name) %}
    select *
    from {{ model }}
    where {{ column_name }} < -180 or {{ column_name }} > 180
{% endtest %}
