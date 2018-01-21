/* #define SINGLE */
#ifdef SINGLE
#define REAL float
#else /* not SINGLE */
#define REAL double
#endif /* not SINGLE */


#include <stdio.h>
#include <stdlib.h>

#include "allocate.h"


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////   Allocate Memory   /////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/* =========================================== */
/* real_alloc - Allocate space for REAL array */
/* =========================================== */

REAL* real_alloc(int length, char *array_name)
{
    REAL* result = NULL;
    if (length > 0)
    {
		result = (REAL* ) calloc(length, sizeof(REAL));
		if (!result || Debug)
		{
		    if (!result)
			{
			    printf("*** Out of Memory *** in ");
			    printf("real_alloc: at%10p %6d REAL for %s\n",
				   result,length,array_name);
			}
		}
    }
    
    return(result);
}


/* =========================================== */
/* float_alloc - Allocate space for float array */
/* =========================================== */

float* float_alloc(int length, char *array_name)
{
    float* result = NULL;
    if (length > 0)
    {
		result = (float* ) calloc(length, sizeof(float));
		if (!result || Debug)
		{
		    if (!result) 
	    	{
	    		printf("*** Out of Memory *** in ");
		    	printf("float_alloc: at%10p %6d float for %s\n",
			   			result,length,array_name);
	    	}
		}
    }

    return(result);
}


/* =========================================== */
/* double_alloc - Allocate space for double array */
/* =========================================== */

double* double_alloc(int length, char *array_name)
{
    double* result = NULL;
    if (length > 0)
    {
		result = (double* ) calloc(length, sizeof(double));
		if (!result || Debug)
		{
		    if (!result) 
	    	{
	    		printf("*** Out of Memory *** in ");
		    	printf("double_alloc: at%10p %6d double for %s\n",
			   			result,length,array_name);
		    }
		}
    }

    return(result);
}


/* =========================================== */
/* int_alloc - Allocate space for int array */
/* =========================================== */

int* int_alloc(int length, char *array_name)
{
    int* result = NULL;
    if (length > 0)
    {
		result = (int* ) calloc(length, sizeof(int));
		if (!result || Debug)
		{
		    if (!result)
	    	{
	    		printf("*** Out of Memory *** in ");
		    	printf("int_alloc: at%10p %6d int for %s\n",
			   			result,length,array_name);
		    }
		}
    }

    return(result);
}



//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////   Free Memory   /////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/* =========================================== */
/* REAL_free - Release memory for REAL array */
/* =========================================== */
void real_free(REAL* ptr, char* array_name)
{
    if (Debug)
    {
		printf("*** Memory release *** in ");
		printf("real_free: at%10p for %s .......... ", ptr, array_name);
		free(ptr);
		ptr = NULL;
		printf("SUCCESS. ---> Returning ");
		printf("%6p \n", ptr);
    }
    else
	{
	    free(ptr);
	    ptr = NULL;
	}
}


/* =========================================== */
/* float_free - Release memory for float array */
/* =========================================== */
void float_free(float* ptr, char* array_name)
{    
    if (Debug)
    {
		printf("*** Memory release *** in ");
		printf("real_free: at%10p for %s .......... ", ptr, array_name);
		free(ptr);
		ptr = NULL;
		printf("SUCCESS. ---> Returning ");
		printf("%6p \n", ptr);
    }
    else
	{
	    free(ptr);
	    ptr = NULL;
	}
}


/* =========================================== */
/* double_free - Release memory for double array */
/* =========================================== */

void double_free(double* ptr, char* array_name)
{    
    if (Debug)
    {
		printf("*** Memory release *** in ");
		printf("real_free: at%10p for %s .......... ", ptr, array_name);
		free(ptr);
		ptr = NULL;
		printf("SUCCESS. ---> Returning ");
		printf("%6p \n", ptr);
    }
    else
	{
	    free(ptr);
	    ptr = NULL;
	}
}


/* =========================================== */
/* int_free - Release memory for int array */
/* =========================================== */

void int_free(int* ptr, char* array_name)
{    
    if (Debug)
    {
		printf("*** Memory release *** in ");
		printf("real_free: at%10p for %s .......... ", ptr, array_name);
		free(ptr);
		ptr = NULL;
		printf("SUCCESS. ---> Returning ");
		printf("%6p \n", ptr);
    }
    else
	{
	    free(ptr);
	    ptr = NULL;
	}
}
