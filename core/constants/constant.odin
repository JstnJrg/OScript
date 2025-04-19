package OScriptConstant

import variant "oscript:variant"

Value     			:: variant.Value

MAX_CHUNK_CONSTANT 	:: #config(CHUNK_SIZE,1 << 9)//usado pela chunk, delimita o numero de constantes na chunk
MAX_STACK_OPCODE	:: 1 << 8					 //usado pelo compilador, esse numero é mais do que suficiente

MAX_LOCAL			:: #config(LOCAL_SIZE,1 << 8) // número maximo de variaveis locais
MAX_MATCH_CASE      :: 1 << 8
MAX_COURROTINE		:: 1 << 4 // rotinas de loops
MAX_ARGUMENTS		:: 1 << 4 // argumentos de funções
MAX_VARIABLE_NAME   :: 1 << 5
MAX_OPCODE			:: 1 << 4
MAX_JUMP 			:: 1 << 32

// Nota(jstn) : valores de Stack, Janela de frames e de Programas
// Nota(jstn) : tirei 1MB de pilha e coloquei 32Kb de pilha, que corresponde a 1024 Values aomesmo tempo na pilha
MAX_STACK_SIZE		:: #config(STACK_SIZE,(4*32*variant.Kilobyte)/size_of(Value)) //1mb de pilha
MAX_FRAMES 			:: 1 << 8 // 1023
MAX_PROGRAM			:: 1 << 0 // 1
MAX_GLOBAL_FRAME    :: 1 << 2
MAX_GRAY 			:: 1 << 8


// Compiler
OSCRIPT_ALLOW_RUNFILE_SCOPE          :: !false
OSCRIPT_REPORT_TOS			         :: !true
OSCRIPT_DEBUG                        :: !true

// Nota(jstn) : flags que podem ser desativadas para o tempo de execução, por favor não desactive, pois, pode quebrar o programa
OSCRIPT_ALLOW_RUNTIME_WARNINGS 		:: true
OSCRIPT_ALLOW_RUNTIME_CHECK			:: true
OSCRIPT_ALLOW_RUNTIME_CHECK_BOUNDS  :: true
OSCRIPT_ALLOW_RUNTIME_PROFILING     :: true
// OSCRIPT_ALLOW_RUNTIME_PROFILING     :: true

DEBUG_STRESS_GC						:: false
DEBUG_GC 							:: !false
GC_HEAP_GROW_FACTOR					:: 2


// DEBUG_TRACE_EXECUTION 	:: true//#config(DEBUG_TRACE,false)
// DEBUG_TRACE_INSTRUCTION :: true//#config(DEBUG_TRACE,false)
// DEBUG_TRACE_IP 			:: true//#config(DEBUG_TRACE,true)
// DEBUG_WARNING_VM		:: true

// OSCRIPT_DEBUG			:: #config(BUILDIN_CHECK,true)
// OSCRIPT_RUNTIME_CHECK   :: #config(RUNTIME_CHECK,true)