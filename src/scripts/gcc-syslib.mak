# Makefile for OptiPNG
# gcc (generic) -- using the system-supplied zlib
#
# Use this makefile if you have a reason to use the system-supplied zlib
# (e.g. if you want to link zlib in dynamically)
# Be aware that compression might be weaker by a tiny fraction!
#
# Otherwise, just use the regular makefile (gcc.mak)
#
# Sorry, right now, there's no easy way to use the system-supplied libpng!
# (email the author if you wish to comment on this issue)
#
# Type "optipng -v" to see what libraries are used by an already-built program
#
# Usage: make -f scripts/gcc-syslib.mak


CC = gcc
LD = $(CC)
RM = rm -f
CFLAGS  = -O2 -Wall
LDFLAGS = -s

OPTIPNG  = optipng$(EXE)
#ZLIB     = libz.a
PNGLIB   = libpng.a
PNGXLIB  = pngxtern.a
#ZMAK     = Makefile
PNGMAK   = scripts/makefile.gcc
PNGXMAK  = scripts/gcc.mak
#ZDIR     = ../lib/zlib
PNGDIR   = ../lib/libpng
PNGXDIR  = ../lib/pngxtern
BACKHERE = ../../src

OBJS = optipng.o opngio.o opngreduc.o cbitset.o osys.o
#LIBS = $(PNGXDIR)/$(PNGXLIB) $(PNGDIR)/$(PNGLIB) $(ZDIR)/$(ZLIB)
LIBS = $(PNGXDIR)/$(PNGXLIB) $(PNGDIR)/$(PNGLIB) -lz


$(OPTIPNG): $(OBJS) $(LIBS)
	$(LD) -o $(OPTIPNG) $(LDFLAGS) $(OBJS) $(LIBS)


.c.o:
#	$(CC) -c $(CFLAGS) -I$(ZDIR) -I$(PNGDIR) -I$(PNGXDIR) $*.c
	$(CC) -c $(CFLAGS) -I$(PNGDIR) -I$(PNGXDIR) $*.c

optipng.o  : optipng.c   opng.h osys.h cbitset.h cexcept.h
opngio.o   : opngio.c    opng.h
opngreduc.o: opngreduc.c opng.h
cbitset.o  : cbitset.c   cbitset.h
osys.o     : osys.c      osys.h


$(PNGXDIR)/$(PNGXLIB): $(ZDIR)/$(ZLIB) $(PNGDIR)/$(PNGLIB)
	cd $(PNGXDIR); \
	$(MAKE) -f $(PNGXMAK) $(PNGXLIB); \
	cd $(BACKHERE)

$(PNGDIR)/$(PNGLIB): $(ZDIR)/$(ZLIB)
	cd $(PNGDIR); \
	$(MAKE) -f $(PNGMAK) $(PNGLIB); \
	cd $(BACKHERE)

#$(ZDIR)/$(ZLIB):
#	cd $(ZDIR); \
#	./configure; \
#	$(MAKE) -f $(ZMAK) $(ZLIB); \
#	cd $(BACKHERE)


clean:
	$(RM) $(OPTIPNG) $(OBJS)
	cd $(PNGXDIR); \
	$(MAKE) -f $(PNGXMAK) clean; \
	cd $(BACKHERE)
	cd $(PNGDIR); \
	$(MAKE) -f $(PNGMAK) clean; \
	cd $(BACKHERE)
#	cd $(ZDIR); \
#	$(MAKE) -f $(ZMAK) clean; \
#	cd $(BACKHERE)
