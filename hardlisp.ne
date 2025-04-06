@preprocessor coffee

@{%
const moo = require("moo");

const lexer = moo.compile({
  ws:     /[ \t]+/,
  number: /[0-9]+/,
  word: { match: /[a-z]+/, type: moo.keywords({ times: "x" }) },
  times:  /\*/
});

const tokenPrint = { literal: "print" };
const tokenNumber = { test: x => Number.isInteger(x) };
%}

@lexer lexer

expression ->
    number "+" number {% ([fst, _, snd]) => fst + snd %}
  | number "-" number {% ([fst, _, snd]) => fst - snd %}
  | number "*" number {% ([fst, _, snd]) => fst * snd %}
  | number "/" number {% ([fst, _, snd]) => fst / snd %}

expr -> multiplication {% id %} | trig {% id %}
multiplication -> %number %ws %times %ws %number {% ([first, , , , second]) => first * second %}
trig -> "sin" %ws %number {% ([, , x]) => Math.sin(x) %}


expression -> number "+" number {%
    function(data) {
        return {
            operator: "sum",
            leftOperand:  data[0],
            rightOperand: data[2] // data[1] is "+"
        };
    }
%}
number -> [0-9]:+ {% d => parseInt(d[0].join("")) %}
variable -> [a-z]:+ {%
    function(d,l, reject) {
        const name = d[0].join('');
        if (name === 'if') {
            return reject;
        } else {
            return { name };
        }
    }
%}
not_a_letter -> [^a-zA-Z]
ifStatement -> "if" condition "then" statement "else" statement "endif"
functionDec -> "func" name ":" "->" statement "end"
operationDecla -> "ope" name type "=>" statement "end" 
envDeclare ->
    envName "*" name {% function inject(data) { ([fst, _, snd]) => fst }%}
    | envType "type%=>" name
    | envSize number