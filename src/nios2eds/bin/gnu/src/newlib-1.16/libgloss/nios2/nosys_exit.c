/* 
   Copyright (c) 2003 Altera Corporation
   All rights reserved.
   
   Redistribution and use in source and binary forms, with or without modification,
   are permitted provided that the following conditions are met:
   
      o Redistributions of source code must retain the above copyright notice, 
        this list of conditions and the following disclaimer. 
      o Redistributions in binary form must reproduce the above copyright notice, 
        this list of conditions and the following disclaimer in the documentation 
        and/or other materials provided with the distribution. 
      o Neither the name of Altera Corporation nor the names of its contributors 
        may be used to endorse or promote products derived from this software 
        without specific prior written permission. 
   
   THIS SOFTWARE IS PROVIDED BY ALTERA CORPORATION, THE COPYRIGHT HOLDER, AND ITS 
   CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT 
   LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A 
   PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR 
   CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, 
   EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, 
   PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; 
   OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, 
   WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT(INCLUDING NEGLIGENCE OR 
   OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED 
   OF THE POSSIBILITY OF SUCH DAMAGE.  */


extern void _do_dtors (void);
void __fake_fini () { /* Do nothing */ }
void _fini () __attribute__ ((weak, alias ("__fake_fini")));

void
_exit (int exit_code)
{
  _fini ();
    
  /* ??? May want a return to germs (or other) here? */
  __asm__ (
	   "mov\tr2, %0\n"
	   "0:\n"
	   "\tbr\t0b" 
	   :  
	   : "r" (exit_code));
}
