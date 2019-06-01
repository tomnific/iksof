/*
 * Copyright (c) 2019 Tom. All Rights Reserved.
 *
 * @TOM_LICENSE_HEADER_START@
 *
 * 1) Credit would be sick, but I really can't control what you do ¯\_(ツ)_/¯
 * 2) I'm not responsible for what you do with this AND I'm not responsible for any damage you cause ("THIS SOFTWARE IS PROVIDED AS IS", etc)
 * 3) I'm under no obligation to provide support. (But if you reach out I'll gladly take a look if I have time)
 *
 * @TOM_LICENSE_HEADER_END@
 */
/*
 * A collection of useful functions, particularly with obscure usecases
 * Since this is Objective-C++, the cross-platform ifdefs have been removed (I know there is some Objective-C for Linux project out there, but I don't know what it does/doesn't support.
 */

#ifndef stdtom_h
#define stdtom_h

#import <Foundation/Foundation.h>



#include <string>




#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgnu-zero-variadic-macro-arguments"

// just in case a more explicit name is desired
//#define log(format, ...) lprintf(format, ##__VA_ARGS__) // uncomment at your own risk, may cause conflicts with log math function

// TODO
//// alt name for dgblprintf
//#define dbglog(format, ...) dbglprintf(format, ##__VA_ARGS__)
//
//// for debugging with normal printf
//#define dbgprintf(format, ...) printf(__FILE__, __LINE__, format, ##__VA_ARGS__)
#pragma clang diagnostic pop


// do nothing - primarily for use to get rid of the 'variable not used' warning when warnings are treated as errors
#define NOTUSED(x) (void)(x)




// unsigned
#define BYTE   unsigned char           // 1 Byte
#define WORD   unsigned short int      // 2 Bytes
#define DWORD  unsigned int            // 4 Bytes
#define QWORD  unsigned long long int  // 8 Bytes




using namespace std;





// selects bits `from` through `to` from `source`.
short select_bit_range_from_word(WORD source, int from, int through);


// converts hex string to an integer
int hexToDecimal(NSString *hexString);
int hextodec(string hex_string);
int hextodec(char* hex_string);

// converts a string to an integer - unlike atoi & friends, it tells you if and why it fails
int strtonum(string numstr, int minval, int maxval, string *errstrp);
int cstrtonum(char *numstr, int minval, int maxval, char **errstrp);


// creates a string from a format
string string_with_format(string filename);
char* cstring_with_format(char* format, ...);

// appends s2 to s1 and returns the result
char* cstrapp(const char *s1, const char *s2);

// appends char to string (one small caveat:  if the string isn't big enough this will break)
void cstr_append_char(char* str, char character);

// trims strings down to their real size. Also removes newline characters.
char* cstrtrim (char* str);

// zeros out string - apprently there's a thing called bzero also does this?
void zero_cstr(char** str);

// checks if a string contains all 0's (as it won't be equal to NULL)
bool cstr_is_0d(char* str);


// reads the contents of a file into a string
string str_from_file_contents(string filename);
char* cstr_from_file_contents(char* filename);

// returns path extension of path
string path_extension(string path);
char* path_extension(char* path);

// checks if a path is a directory
bool isdir(string path);
bool isdir(char* path);

// gets the file size for a file
size_t filesize(NSString *filePath);
size_t filesize(char* file_path);


// run a shell command and get its output
NSString *systemCommand(NSString *commandString);
string system_cmd(string command_string);
char* system_cmd(char* command_string);


/*
 	gets the path to the executable belonging the the handle given by dlopen()
 	Warning: this is not a thread safe function
 */
NSString *pathFromHandle(void *handle);
string path_from_handle(void* handle);
char* path_from_handle_cstr(void* handle);


// retruns the path to the executable that calls it
NSString *pathToCurrentExecutable(void);
string path_to_current_executable(void);
char* path_to_current_executable_cstr(void);


// getopt - but actually resonable to use
// no use overloading argv[], its basically always a c string
NSString *getArg(int argc, char* argv[], NSString *argName);
NSString *getArg(int argc, char* argv[], string argname);
NSString *getArg(int argc, char* argv[], char* argname);
string getarg(int argc, char* argv[], string argname);
string getarg(int argc, char* argv[], char* argname);
char* getarg_cstr(int argc, char* argv[], char* argname);

// checks if arg is present
bool argIsPresent(int argc, char* argv[], NSString *argName);
bool arg_is_present(int argc, char* argv[], string argname);
bool arg_is_present(int argc, char* argv[], char* argname);


// set the logging prefix
void set_lprefix(char* new_prefix);

// printf, but with a prefix and ending newling - 'l' for 'log'
void lprintf(const char* format, ...);


// sets the logging prefix
void setLogPrefix(NSString *newPrefix);

// NSLog replacement - essentially the same as lprintf, but with more info
void TMLog(NSString *format, ...) NS_FORMAT_FUNCTION(1,2);

// clears the console
void printclr(void);


#endif /* stdtom_h */
