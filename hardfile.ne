@preprocessor coffee

int -> [0-9]        {% id %}
    | int [0-9]     {% function(d) {return d[0] + d[1]} %}