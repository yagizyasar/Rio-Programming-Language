%{
#include <stdio.h>
#include <stdlib.h>
int yylex(void);
int yyerror(char* s);
extern int yylineno;
%}

%token MAIN

%token TYPE
%token FUNC_DEF
%token FUNC_IDENT
%token INPUT
%token OUTPUT
%token RETURN

%token DRONE_FUNC_GET_HEADING
%token DRONE_FUNC_GET_ALTITUDE
%token DRONE_FUNC_GET_TEMPERATURE
%token DRONE_FUNC_GET_TIME
%token DRONE_FUNC_TURN
%token DRONE_ENUM_LEFT
%token DRONE_ENUM_RIGHT
%token DRONE_FUNC_CLIMB
%token DRONE_ENUM_STOP
%token DRONE_ENUM_UP
%token DRONE_ENUM_DOWN
%token DRONE_FUNC_MOVE
%token DRONE_ENUM_FORWARD
%token DRONE_ENUM_BACKWARD
%token DRONE_FUNC_TOGGLE_SPRAY
%token DRONE_ENUM_ON
%token DRONE_ENUM_OFF
%token DRONE_FUNC_CONNECT_TO
%token DRONE_IP

%token FOR
%token WHILE
%token IF
%token ELSE_IF
%token ELSE

%token ASSIGNMENT_OP
%token SEMICOLON
%token COMMA

%token PLUS_OP
%token MINUS_OP
%token MULT_OP 
%token DIV_OP
%token EXP_OP

%token NOT_OP
%token AND_OP
%token OR_OP
%token EQUAL_OP
%token NOT_EQUAL_OP
%token SMALLER_THAN_OP
%token GREATER_THAN_OP
%token SMALLER_OR_EQ_OP
%token GREATER_OR_EQ_OP

%token CURLY_L
%token CURLY_R
%token PAREN_L
%token PAREN_R

%token IDENT
%token CHAR
%token STRING
%token INT
%token REAL
%token BOOL
%token COMMENT

%start start
%%

start: stmts; {printf("Program parsed successfully\n"); return 0;}
stmts: stmt | stmts stmt;
stmt: conditional_stmt 
      | declare SEMICOLON 
	  | assign SEMICOLON 
	  | func_call SEMICOLON 
	  | for_loop 
	  | while_loop 
	  | func_def 
	  | input_func SEMICOLON 
	  | output_func SEMICOLON 
	  | drone_func SEMICOLON 
	  | return_stmt SEMICOLON
	  | COMMENT;
stmts_block: CURLY_L stmts CURLY_R;

conditional_stmt: IF PAREN_L bool_expr PAREN_R stmts_block elses_list;
				  
elses_list: 
			| ELSE stmts_block
			| ELSE_IF PAREN_L bool_expr PAREN_R stmts_block elses_list;

declare: TYPE IDENT | TYPE assign;
		 
assign: IDENT ASSIGNMENT_OP bool_expr // includes func calls and arithmetic expressions
	     | IDENT ASSIGNMENT_OP CHAR
	     | IDENT ASSIGNMENT_OP STRING
	     | IDENT ASSIGNMENT_OP drone_enum;

// boolean expressions
bool_expr: comparison_expr
		   | bool_expr EQUAL_OP comparison_expr
		   | bool_expr NOT_EQUAL_OP comparison_expr;
		   
comparison_expr: comparison_first
				 | comparison_first SMALLER_THAN_OP comparison_second
				 | comparison_first SMALLER_OR_EQ_OP comparison_second
				 | comparison_first GREATER_THAN_OP comparison_second
				 | comparison_first GREATER_OR_EQ_OP comparison_second;
				 
comparison_first: logic_or;
comparison_second: logic_or;
			 
logic_or: logic_and | logic_or OR_OP logic_and;

logic_and: logic_not | logic_and AND_OP logic_not;

logic_not: bool_term | NOT_OP logic_not;

bool_term: BOOL | arith_expr;

// arithmetic expressions
// note that arithmetic expressions in our language are a subset of boolean expressions
// because rio, like c++, considers 0 to be false and other numbers to be true in boolean calculations
// and false is equal to 0 and true is equal to 1 in arithmetic expressions
arith_expr: arith_term | arith_expr PLUS_OP arith_term | arith_expr MINUS_OP arith_term;

arith_term: exponent | arith_term MULT_OP exponent | arith_term DIV_OP exponent;
			  
exponent: factor | factor EXP_OP exponent;

factor: IDENT | INT | REAL | func_call | drone_func | PAREN_L bool_expr PAREN_R;

// loops
for_loop: FOR PAREN_L for_cond PAREN_R stmts_block;
for_cond: declare SEMICOLON bool_expr SEMICOLON assign | assign SEMICOLON bool_expr SEMICOLON assign;
while_loop: WHILE PAREN_L bool_expr PAREN_R stmts_block;

// i/o
input_func: INPUT PAREN_L IDENT PAREN_R;
//output_func: OUTPUT PAREN_L bool_expr PAREN_R | OUTPUT PAREN_L arith_expr PAREN_R | OUTPUT PAREN_L STRING PAREN_R | OUTPUT PAREN_L CHAR PAREN_R;
output_func: OUTPUT PAREN_L bool_expr PAREN_R | OUTPUT PAREN_L STRING PAREN_R | OUTPUT PAREN_L CHAR PAREN_R;

// general functions
func_def: FUNC_DEF FUNC_IDENT PAREN_L ident_list PAREN_R TYPE stmts_block
		 | FUNC_DEF FUNC_IDENT PAREN_L ident_list PAREN_R stmts_block;
		 | MAIN PAREN_L PAREN_R stmts_block;
ident_list: | TYPE IDENT | TYPE IDENT COMMA ident_list;
return_stmt: RETURN | RETURN bool_expr | RETURN STRING | RETURN CHAR | RETURN drone_enum;

func_call: FUNC_IDENT PAREN_L param_list PAREN_R;
param_list: | param | param COMMA param_list;	  
param: bool_expr | CHAR | STRING | drone_enum;

// primitive drone functions
drone_func: get_heading | get_altitude | get_temperature | get_time | turn | climb | move | spray_toggle | connect;
drone_enum: turn_dir | climb_dir | move_dir | DRONE_ENUM_STOP | spray_status | DRONE_IP;

get_heading: DRONE_FUNC_GET_HEADING PAREN_L PAREN_R; 
get_altitude: DRONE_FUNC_GET_ALTITUDE PAREN_L PAREN_R;
get_temperature: DRONE_FUNC_GET_TEMPERATURE PAREN_L PAREN_R; // returns temperature in celcius as real
get_time: DRONE_FUNC_GET_TIME PAREN_L PAREN_R; // returns bios time in seconds as an int

turn: DRONE_FUNC_TURN PAREN_L turn_dir PAREN_R | DRONE_FUNC_TURN PAREN_L IDENT PAREN_R;
turn_dir: DRONE_ENUM_LEFT | DRONE_ENUM_RIGHT;

climb: DRONE_FUNC_CLIMB PAREN_L climb_dir PAREN_R | DRONE_FUNC_CLIMB PAREN_L DRONE_ENUM_STOP PAREN_R | DRONE_FUNC_CLIMB PAREN_L IDENT PAREN_R;
climb_dir: DRONE_ENUM_UP | DRONE_ENUM_DOWN;

move: DRONE_FUNC_MOVE PAREN_L move_dir PAREN_R | DRONE_FUNC_MOVE PAREN_L DRONE_ENUM_STOP PAREN_R | DRONE_FUNC_MOVE PAREN_L IDENT PAREN_R;
move_dir: DRONE_ENUM_FORWARD | DRONE_ENUM_BACKWARD;

spray_toggle: DRONE_FUNC_TOGGLE_SPRAY PAREN_L spray_status PAREN_R | DRONE_FUNC_TOGGLE_SPRAY PAREN_L IDENT PAREN_R;
spray_status: DRONE_ENUM_ON | DRONE_ENUM_OFF;

connect: DRONE_FUNC_CONNECT_TO PAREN_L DRONE_IP PAREN_R | DRONE_FUNC_CONNECT_TO PAREN_L IDENT PAREN_R;
%%
#include "lex.yy.c"
int lineno = 1;
main() {
	return yyparse();
}
int yyerror (char *s)
{
    printf("%d : %s %s\n", lineno, s, yytext);
    return 0;
}