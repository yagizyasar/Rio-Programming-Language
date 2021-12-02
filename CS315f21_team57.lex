ident [a-zA-Z]+[a-zA-Z0-9]*
int [\+\-]?[0-9]+
real {int}(\.[0-9]+)?
string \"[^\"\n]*\"
char \'(.|\\n)\'
ip [0-9]+\.[0-9]+\.[0-9]+\.[0-9]+
type (int|real|string|char|bool|drone_enum)
%%
\n {extern int lineno; lineno++;}

main {return (MAIN);}

{type} {return (TYPE);}
{char} {return (CHAR);}
{string} {return (STRING);}

func {return (FUNC_DEF);}
\_{ident} {return (FUNC_IDENT );}
\$input {return (INPUT);}
\$output {return (OUTPUT);}
return {return (RETURN);}

\&getHeading {return (DRONE_FUNC_GET_HEADING);}
\&getAltitude {return (DRONE_FUNC_GET_ALTITUDE);}
\&getTemperature {return (DRONE_FUNC_GET_TEMPERATURE);}
\&getTime {return (DRONE_FUNC_GET_TIME);}
\&turn {return (DRONE_FUNC_TURN);}
LEFT {return (DRONE_ENUM_LEFT);}
RIGHT {return (DRONE_ENUM_RIGHT);}
\&climb {return (DRONE_FUNC_CLIMB);}
STOP {return (DRONE_ENUM_STOP);}
UP {return (DRONE_ENUM_UP);}
DOWN {return (DRONE_ENUM_DOWN);}
\&move {return (DRONE_FUNC_MOVE);}
FORWARD {return (DRONE_ENUM_FORWARD);}
BACKWARD {return (DRONE_ENUM_BACKWARD);}
\&toggleSpray {return (DRONE_FUNC_TOGGLE_SPRAY);}
ON {return (DRONE_ENUM_ON);}
OFF {return (DRONE_ENUM_OFF);}
\&connectTo {return (DRONE_FUNC_CONNECT_TO);}
{ip} {return (DRONE_IP);}

for {return (FOR);}
while {return (WHILE);}
if {return (IF);}
elseif {return (ELSE_IF);}
else {return (ELSE);}

\= {return (ASSIGNMENT_OP);}
\; {return (SEMICOLON);}
\, {return (COMMA);}

\+ {return (PLUS_OP);}
\- {return (MINUS_OP);}
\* {return (MULT_OP);}
\/ {return (DIV_OP);}
\^ {return (EXP_OP);}

not {return (NOT_OP);}
and {return (AND_OP);}
or {return (OR_OP);}

\=\= {return (EQUAL_OP);}
\=\/\= {return (NOT_EQUAL_OP);}
\< {return (SMALLER_THAN_OP);}
\> {return (GREATER_THAN_OP);}
\<\= {return (SMALLER_OR_EQ_OP);}
\>\= {return (GREATER_OR_EQ_OP);}

\{ {return (CURLY_L);}
\} {return (CURLY_R);}
\( {return (PAREN_L);}
\) {return (PAREN_R);}

(true|false) {return (BOOL);}
{int} {return (INT);}
{real} {return (REAL);}
{ident} {return (IDENT);}

#.*\n {extern int lineno; lineno++; return (COMMENT);} 

. ;

%%
int yywrap() {return 1;}