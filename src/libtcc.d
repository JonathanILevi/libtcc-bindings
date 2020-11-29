extern(C):

struct TCCState;

alias TCCErrorFunc = void function(void* opaque, const char* msg);

/* create a new TCC compilation context */
TCCState* tcc_new();

/* free a TCC compilation context */
void tcc_delete(TCCState* s);

/* set CONFIG_TCCDIR at runtime */
void tcc_set_lib_path(TCCState* s, const char* path);

/* set error/warning display callback */
void tcc_set_error_func(TCCState* s, void* error_opaque, TCCErrorFunc error_func);

/* return error/warning callback */
////TCCErrorFunc tcc_get_error_func(TCCState* s);

/* return error/warning callback opaque pointer */
////void* tcc_get_error_opaque(TCCState* s);

/* set options as from command line (multiple supported) */
void tcc_set_options(TCCState* s, const char* str);

/*****************************/
/* preprocessor */

/* add include path */
int tcc_add_include_path(TCCState* s, const char* pathname);

/* add in system include path */
int tcc_add_sysinclude_path(TCCState* s, const char* pathname);

/* define preprocessor symbol 'sym'. value can be NULL, sym can be "sym=val" */
void tcc_define_symbol(TCCState* s, const char* sym, const char* value);

/* undefine preprocess symbol 'sym' */
void tcc_undefine_symbol(TCCState* s, const char* sym);

/*****************************/
/* compiling */

/* add a file (C file, dll, object, library, ld script). Return -1 if error. */
int tcc_add_file(TCCState* s, const char* filename);

/* compile a string containing a C source. Return -1 if error. */
int tcc_compile_string(TCCState* s, const char* buf);

/*****************************/
/* linking commands */

/* set output type. MUST BE CALLED before any compilation */
int tcc_set_output_type(TCCState* s, int output_type);
enum : int {
	TCC_OUTPUT_MEMORY	= 1, /* output will be run in memory (default) */
	TCC_OUTPUT_EXE	= 2, /* executable file */
	TCC_OUTPUT_DLL	= 3, /* dynamic library */
	TCC_OUTPUT_OBJ	= 4, /* object file */
	TCC_OUTPUT_PREPROCESS	= 5, /* only preprocess (used internally) */
}
enum TCCOutput : int {
	memory	= 1, /* output will be run in memory (default) */
	exe	= 2, /* executable file */
	dll	= 3, /* dynamic library */
	obj	= 4, /* object file */
	preprocess	= 5, /* only preprocess (used internally) */
}

/* equivalent to -Lpath option */
int tcc_add_library_path(TCCState* s, const char* pathname);

/* the library name is the same as the argument of the '-l' option */
int tcc_add_library(TCCState* s, const char* libraryname);

/* add a symbol to the compiled program */
int tcc_add_symbol(TCCState* s, const char* name, const void* val);

/* output an executable, library or object file. DO NOT call
   tcc_relocate() before. */
int tcc_output_file(TCCState* s, const char* filename);

/* link and run main() function and return its value. DO NOT call
   tcc_relocate() before. */
int tcc_run(TCCState* s, int argc, char **argv);

/* do all relocations (needed before using tcc_get_symbol()) */
int tcc_relocate(TCCState* s1, void* ptr);
/* possible values for 'ptr':
   - TCC_RELOCATE_AUTO : Allocate and manage memory internally
   - NULL              : return required memory size for the step below
   - memory address    : copy code to memory passed by the caller
   returns -1 if error. */
enum TCC_RELOCATE_AUTO = cast(void*) 1;
enum TCCRelocate : void* {
	auto_ = TCC_RELOCATE_AUTO,
}

/* return symbol value or NULL if not found */
void* tcc_get_symbol(TCCState* s, const char* name);

/* return symbol value or NULL if not found */
////void tcc_list_symbols(TCCState* s, void* ctx, void function(void* ctx, const char* name, const void* val) symbol_cb);

