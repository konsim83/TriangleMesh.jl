CC = gcc
LINKER=gcc

CSWITCHES = -fPIC -O2 -g 
LDSWITCHES = -shared

#CSWITCHES = -DLINUX -DSELF_CHECK -I/usr/X11R6/include -L/usr/X11R6/lib 
TRILIBDEFS = -DTRILIBRARY

RM = rm -f

UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S),Linux)
    CSWITCHES += -DLINUX
endif

ifeq ($(UNAME_S),Darwin)
    LDSWITCHES = -dynamiclib -undefined suppress -flat_namespace
endif

# +---------------------------------------+
# | Make rules for julia library on linux |
# +---------------------------------------+
libtesselate: triangle.o allocate.o tesselate.o
				@echo "Linking object files into   $@.so"
				@$(LINKER) $(LDSWITCHES) -shared $(CSWITCHES) -o \
					libtesselate.so \
					tesselate.o \
					allocate.o \
					triangle.o -lm


tesselate.o: tesselate.c allocate.o triangle.o
				@echo "Building object file   $@"
				@$(CC) -fpic $(OPT) $(CSWITCHES) -c -o \
					tesselate.o \
					tesselate.c


triangle.o: triangle.c triangle.h
				@echo "Building object file   $@"
				@$(CC) -fpic $(OPT) $(CSWITCHES) $(TRILIBDEFS) -c -o \
					triangle.o \
					triangle.c

allocate.o: allocate.c allocate.h
				@echo "Building object file   $@"
				@$(CC) -fpic $(OPT) $(CSWITCHES) $(TRILIBDEFS) -c -o \
					allocate.o \
					allocate.c

clean:
	@echo "Clearing obj and lib directory..."
	@$(RM) *.so *.o
