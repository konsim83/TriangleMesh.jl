#ifndef ALLOCATE_H
#define ALLOCATE_H

/* If SINGLE is defined when triangle.o is compiled, it should also be       */
/*   defined here.  If not, it should not be defined here.                   */

/* #define SINGLE */

#ifdef SINGLE
#define REAL float
#else /* not SINGLE */
#define REAL double
#endif /* not SINGLE */


extern const int Debug;


REAL* real_alloc(int length, char* array_name);
float* float_alloc(int length, char* array_name);
double* double_alloc(int length, char* array_name);
int* int_alloc(int length, char* array_name);


void real_free(REAL* ptr, char* array_name);
void float_free(float* ptr, char* array_name);
void double_free(double* ptr, char* array_name);
void int_free(int* ptr, char* array_name);

#endif // ALLOCATE_H
