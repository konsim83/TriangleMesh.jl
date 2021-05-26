#ifndef COMMONDEFINE_H
    #define REAL double
    #define _NDIM 2

    #define TRIANGULATEIO_NAME "triangulateio"
    #define ANSI_DECLARATORS 1
	#define VOID int
    
    #ifdef _MSC_VER // Visual Studio specific macro
        #define DLLEXPORT __declspec(dllexport)
        #define DLLLOCAL
        #define ANSILOCALDECL 
    #else 
        #define DLLEXPORT __attribute__ ((visibility("default")))
        #define DLLLOCAL __attribute__ ((visibility("hidden")))
        #define ANSILOCALDECL 
    #endif 

	#define COMMONDEFINE_H
#endif