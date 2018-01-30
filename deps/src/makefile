# C compiler and linker
CC = gcc
LINKER = gcc

# rm command
RM = rm -f

CSWITCHES = -fpic -O2
TRILIBDEFS = -DTRILIBRARY -DNO_TIMER -DNDEBUG

UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S),Linux)
    CFLAGS += -DLINUX
endif


# linking flags
LDFLAGS = -shared
ifeq ($(UNAME_S),Darwin)
    LDFLAGS = -dynamiclib -undefined suppress -flat_namespace
endif

libtesselate: triangle.o tesselate.o
				@echo "Linking object files into   $@"
				@$(LINKER) $(LDFLAGS) -o \
					libtesselate.so \
					tesselate.o \
					triangle.o -lm

tesselate.o: tesselate.c tesselate.h
				@echo "Building object file   $@"
				@$(CC) $(CSWITCHES) -c -o \
					tesselate.o \
					tesselate.c


triangle.o: triangle.c triangle.h
				@echo "Building object file   $@"
				@$(CC) $(CSWITCHES) $(TRILIBDEFS) -c -o \
					triangle.o \
					triangle.c


clean:
	@echo "Clearing obj and lib directory..."
	@$(RM) *.so *.o