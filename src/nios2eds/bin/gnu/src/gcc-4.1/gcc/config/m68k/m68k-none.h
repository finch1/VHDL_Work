/* Definitions of target machine for GNU compiler.  "naked" 68020.
   Copyright (C) 1994, 1996, 2003 Free Software Foundation, Inc.

This file is part of GCC.

GCC is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2, or (at your option)
any later version.

GCC is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with GCC; see the file COPYING.  If not, write to
the Free Software Foundation, 51 Franklin Street, Fifth Floor,
Boston, MA 02110-1301, USA.  */

#undef SUBTARGET_ASM_SPEC
#define SUBTARGET_ASM_SPEC "%{fPIC:--pcrel} %{fpic:--pcrel} \
 %{msep-data:--pcrel} %{mid-shared-library:--pcrel}"

/* cc1/cc1plus always receives all the -m flags. If the specs strings above 
   are consistent with the flags in m68k.opt, there should be no need for
   any further cc1/cc1plus specs.  */

#undef CC1_SPEC
#define CC1_SPEC ""
