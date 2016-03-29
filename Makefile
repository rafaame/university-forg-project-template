ifeq ($(OS),Windows_NT)

	SRCDIR = src
	OBJDIR = obj
	INCDIR = -Isrc -Iinclude
	LIBDIR =
	CFLAGS = -g -Wall $(INCDIR)
	LFLAGS =
	CC = gcc -mwin32

else

	SRCDIR = src
	OBJDIR = obj
	INCDIR = -Isrc -Iinclude
	LIBDIR =
	CFLAGS = -g -Wall $(INCDIR)
	LFLAGS =
	CC = gcc

endif

SOURCES = $(wildcard $(SRCDIR)/*.c)
SRCFILES = $(patsubst $(SRCDIR)/%,%,$(SOURCES))
DEPENDENCIES = $(patsubst %.c,%.o,$(SOURCES))
OBJTEMP = $(patsubst $(SRCDIR)/%,$(OBJDIR)/%,$(SOURCES))
OBJECTS = $(patsubst %.c,%.o,$(OBJTEMP))
TARGET = bin/main

all: depend $(DEPENDENCIES)
	$(CC) $(CFLAGS) $(LIBDIR) $(OBJECTS) $(LFLAGS) -o $(TARGET)

.c.o:
	$(CC) $(CFLAGS) -c -o $(patsubst $(SRCDIR)/%,$(OBJDIR)/%,$*).o $*.c

depend:
	makedepend -fMakefile $(INCDIR) $(SOURCES)

clean:
	@rm -rf $(TARGET) $(TARGET).exe $(OBJDIR)/*.o *.bak *~ *%

memtest:
	valgrind --tool=memcheck --leak-check=full --show-reachable=yes ./$(TARGET)

# DO NOT DELETE

src/main.o: include/common.h
