# ============================================================
# MochiOS libc Makefile (libc.ext)
# Forked from FreeBSD libc Makefile
# Identity layer overridden, internals preserved
# ============================================================

PACKAGE=	clibs
SHLIBDIR=	/library/core

.include <src.opts.mk>

LIBC_SRCTOP?= ${.CURDIR}
LIBSYS_SRCTOP?=	${.CURDIR:H}/libsys

# ------------------------------------------------------------
# Architecture selection (unchanged from FreeBSD)
# ------------------------------------------------------------
M=${MACHINE_ARCH:S/powerpc64le/powerpc64/}
.if exists(${LIBC_SRCTOP}/${M})
LIBC_ARCH=${M}
.else
LIBC_ARCH=${MACHINE_CPUARCH}
.endif

CFLAGS+=-D_FORTIFY_SOURCE_read=_read
CFLAGS+=-DNO__SCCSID -DNO__RCSID

# ------------------------------------------------------------
# Library identity (MochiOS override)
# ------------------------------------------------------------
LIB=		c
SHLIB_NAME=	libc.ext
SHLIB_MAJOR=
PRECIOUSLIB=

# ------------------------------------------------------------
# Includes
# ------------------------------------------------------------
WARNS?=	2
CFLAGS+=-I${LIBC_SRCTOP}/include -I${SRCTOP}/include
CFLAGS+=-I${LIBC_SRCTOP}/${LIBC_ARCH}
CFLAGS+=-I${LIBSYS_SRCTOP}/${LIBC_ARCH}

.if ${MK_NLS} != "no"
CFLAGS+=-DNLS
.endif

CLEANFILES+=tags
INSTALL_PIC_ARCHIVE=
BUILD_NOSSP_PIC_ARCHIVE=

# ------------------------------------------------------------
# Thread cancellation / TLS
# ------------------------------------------------------------
.ifndef NO_THREAD_STACK_UNWIND
CANCELPOINTS_CFLAGS=-fexceptions
CFLAGS+=${CANCELPOINTS_CFLAGS}
.endif

CFLAGS+= -ftls-model=initial-exec

# ------------------------------------------------------------
# Linker flags (CRITICAL)
# ------------------------------------------------------------
LDFLAGS+= -nodefaultlibs
LDFLAGS+= -nostdlib
LDFLAGS+= -Wl,-rpath,/library/core
LDFLAGS+= -Wl,--enable-new-dtags
LDFLAGS+= -Wl,--auxiliary,libsys.ext

LIBADD+=	compiler_rt
LIBADD+=	sys

.if ${MK_SSP} != "no" && \
    (${LIBC_ARCH} == "i386" || ${LIBC_ARCH:Mpowerpc*} != "")
LIBADD+=	ssp_nonshared
.endif

# ------------------------------------------------------------
# Runtime loader headers
# ------------------------------------------------------------
RTLD_ELF_DIR=${SRCTOP}/libexec/rtld-elf
.if exists(${RTLD_ELF_DIR}/${MACHINE_ARCH:S/powerpc64le/powerpc64/})
RTLD_ARCH=	${MACHINE_ARCH:S/powerpc64le/powerpc64/}
.else
RTLD_ARCH=	${MACHINE_CPUARCH}
.endif
RTLD_HDRS= -I${RTLD_ELF_DIR}/${RTLD_ARCH} -I${RTLD_ELF_DIR}

# ------------------------------------------------------------
# Source includes (UNCHANGED)
# ------------------------------------------------------------
MDSRCS=
MISRCS=
MDASM=
MIASM=
NOASM=

.include "${LIBC_SRCTOP}/${LIBC_ARCH}/Makefile.inc"
.include "${LIBC_SRCTOP}/csu/Makefile.inc"
.include "${LIBC_SRCTOP}/db/Makefile.inc"
.include "${LIBC_SRCTOP}/compat-43/Makefile.inc"
.include "${LIBC_SRCTOP}/gdtoa/Makefile.inc"
.include "${LIBC_SRCTOP}/gen/Makefile.inc"
.include "${LIBC_SRCTOP}/gmon/Makefile.inc"
.if ${MK_ICONV} != "no"
.include "${LIBC_SRCTOP}/iconv/Makefile.inc"
.endif
.include "${LIBC_SRCTOP}/inet/Makefile.inc"
.include "${LIBC_SRCTOP}/isc/Makefile.inc"
.include "${LIBC_SRCTOP}/locale/Makefile.inc"
.include "${LIBC_SRCTOP}/md/Makefile.inc"
.include "${LIBC_SRCTOP}/nameser/Makefile.inc"
.include "${LIBC_SRCTOP}/net/Makefile.inc"
.include "${LIBC_SRCTOP}/nls/Makefile.inc"
.include "${LIBC_SRCTOP}/posix1e/Makefile.inc"
.if ${MACHINE_ABI:Mlong32}
.include "${LIBC_SRCTOP}/quad/Makefile.inc"
.endif
.include "${LIBC_SRCTOP}/regex/Makefile.inc"
.include "${LIBC_SRCTOP}/resolv/Makefile.inc"
.include "${LIBC_SRCTOP}/stdio/Makefile.inc"
.include "${LIBC_SRCTOP}/stdlib/Makefile.inc"
.include "${LIBC_SRCTOP}/stdtime/Makefile.inc"
.include "${LIBC_SRCTOP}/string/Makefile.inc"
.include "${LIBC_SRCTOP}/sys/Makefile.inc"
.include "${LIBC_SRCTOP}/secure/Makefile.inc"
.include "${LIBC_SRCTOP}/rpc/Makefile.inc"
.include "${LIBC_SRCTOP}/uuid/Makefile.inc"
.include "${LIBC_SRCTOP}/xdr/Makefile.inc"

.if ${LIBC_ARCH} == "i386" || ${LIBC_ARCH} == "amd64"
.include "${LIBC_SRCTOP}/x86/gen/Makefile.inc"
.endif

.if ${MK_NIS} != "no"
CFLAGS+= -DYP
.include "${LIBC_SRCTOP}/yp/Makefile.inc"
.endif

.include "${LIBC_SRCTOP}/capability/Makefile.inc"

# ------------------------------------------------------------
# Final glue
# ------------------------------------------------------------
VERSION_DEF=${LIBC_SRCTOP}/Versions.def
SYMBOL_MAPS=${SYM_MAPS}

.include <bsd.lib.mk>

# ------------------------------------------------------------
# Safety checks
# ------------------------------------------------------------
.if (${LIBC_ARCH} == amd64 || ${LIBC_ARCH} == i386) && \
    ${.TARGETS:Mall} == all && \
    defined(LINKER_FEATURES) && ${LINKER_FEATURES:Mifunc} == ""
.error ${LIBC_ARCH} libc requires linker ifunc support
.endif
