LOCKIT 2.x -- Multi-purpose BIOS Password Locker
Coded by Stas,
(C)opyright by SysD Destructive Labs, 1997-2000


==============================================================================
INDEX
==============================================================================

i.   Intro
ii.  Uses
      a) Who/Where/When/Why
      b) Parameters
iii. The Idea
      a) BIOS
      b) CMOS
iv.  References/Disclaimer/Thanx
v.   Contact
vi.  For Developers

==============================================================================
I. INTRO
==============================================================================

	Well... This little program was done to make possible remote lock of
PC computer. There are different manners to do it; LOCKIT uses denial of
BIOS Password to make computer _really_ non-usable. How?! It efectues "manual"
(not applied by BIOS) password setting, and if victim don't know this
password, it will be difficult to unlock computer... Without correct
BIOS Password (if it's set) system don't even boot. I'll try to explain you
how all it shit works.


==============================================================================
II. USES
==============================================================================

a) This program can be used as not-so-heavy trojan, or as security
resource. I think, trojan part mustn't be explained: just send configured
"lockit.exe" to victim, and when it's executed, victim will have her ass
kicked. Now, "pacific" use: you can use LOCKIT to make emergency lock of
your computer when you aren't near. For example, if your Windows has multiple
accounts (Win 98/2000), and all accounts are protected (except 'default',
it's unprotectable...), just copy pre-configured "lockit.exe" to
"C:\WINDOWS\Start Menu\Programs\Startup". So, when someone tries to "hack"
your computer by 'default' account, your computer kicks hacker's ass: it
restarts, and when it's back, BIOS has new shiny password (I hope you'll
remember it ;). Nice joke to scare your hacky friends!!! LOCKIT is projected
to be flexible, so, there are lots of applies of it... If you find some
creative, email me ;)

b) "Flexibility" means that LOCKIT can be used with different BIOSes, store
passwords that YOU wand, not pre-defined, and terminate your job as YOU wand.
Just take a look to "fluxogram":

Start | Store Password     | Exit
>--->--->--->--->--->--->--->--->--->--->--->--->--->--->
                             /- Just leave
       /- AWARD BIOS -\     /
Run __/                \___/__  Secure shut down
^^^   \                /   \
       \-  AMI BIOS  -/     \
                             \- Hang OS (forces reset)

As you can see (I hope, you CAN see ;), password storage and exit mode can
be changed. Use SETDOWN.EXE to do it. Just type "SETDOWN", and it will be used
to configure LOCKIT.EXE. Other way:

C:\LOCKIT>copy lockit.exe photos.exe
         1 file(s) copied
C:\LOCKIT>setdown photos.exe

SETDOWN's interface is self-explatatory...

*** VERY IMPORTANT ***
Default settings that comes with shiny new LOCKIT.EXE are:
o Password 'unlock'
o Exit mode 'Just leave'


==============================================================================
III. THE IDEA
==============================================================================

	At first, know a bit about BIOS/CMOS...
a) BIOS (Basic Input/Output System) is a set of standardized calls giving
low-level access to the hardware.  The BIOS is the lowest software layer
above the actual hardware and serves to insulate programs (and operating
systems) which use it from the details of accessing the hardware directly.
So, BIOS is essencial for computers: without it, computer becomes hi-tech
trash... BIOS's code is located at segment F000h of real conventional
memory (these damn 640KB ;), and generally is ROM. Sometimes, it's some
fuck like "flash memory", and can be updated by software. Viruses like CIH
does this. As BIOS is very important, someone thought: "Well, if BIOS should
contained any lock, no one could access locked computer, it's data or
software...". Actually, almost all BIOSes contains this lock: a famous
BIOS Password. This really sucks to "invade" locked computer: if it's BIOS
have no "universal password", you must open computer to do it... Even to
crack this passwords, you must first log in ;) As there exists lots of
BIOSes, they uses many different algorithms to store/use passwords, but
_all_ they have common thing:

b) CMOS (Complementary Metal Oxide Semiconductor) memory is a small data
block (generally 128 bytes) that contains BIOS configuration even when
computer is off. It uses a small 1.5V baterry, sometimes rechareged when
computer is on. Without CMOS memory, you should enter all your hardware
parameters and set system clock (time clock, _not_ CPU clock!) every time
you on computer. CMOS contains your HD profile, clock, keyboard speed, and
lots of shit. Well, BIOS password is there, too :) It's stored somewhere
in CMOS chip, with all settins that inhibit/activate/manage it. Generally,
all these operations are performed by BIOS internal software, but... Why
not to do it from external code?!

(parts extracted and edited from Interrupt List by Ralph Brown,
see references)

	Oh, yeah... If BIOS routines read/write CMOS, any code can do it.
Even a Windoze code (I tested 16 bit-coded program, it works, but I think
that 32 bit programs will report errors). Currently, there are lots of
programs to backup/restore/damage/configure CMOS. Backup/restore ones are
very stupid, they just get/put raw data to CMOS... They don't even "know"
what are they doing... Damage programs are primitive, but smarter then last
two. They frequently makes "selective damage": they destroys CMOS Checksums
that BIOSes uses to identify valid CMOS configuration. When computer is
restarted, BIOS checks if CMOS Checksums matters, if not, error message is
displayed and sometime CMOS is erased... Well, configure programs are much
more interesting: they uses BIOS-similar code to provide "external"
configuration of BIOS. But almost all they are made by BIOS manufacturers,
and these guys never releases their code. But some other guys makes
"unofficial" documentation of all this paranoic shit, the most famous is
someone called Ralph Brown (see references). Using "unofficial" docs as base,
many programmers tries to make programs to manipulate CMOS from within BIOS
setup. LOCKIT, originally based on Norton Rescue (!), belongs to this class
of programs. It's _not_ unique program that sets passwords to BIOSes; there
are many similar programs, Bluefish (see references) created one similar, as
he said, for testing purposes only. Most of extra-BIOS-configurators are
unsecure beta-level programs. I hope that LOCKIT may have most widest use,
as it was adapted to work with more than one BIOS type.


==============================================================================
IV. References/Disclaimer/Thanx
==============================================================================

References/Thanx:
o "Interrupt List" by Ralph Brown,
o Inumerous AWARD password bruteforcers (I don't know, WHO was first to
  discover algorythm, but thanks to everybody who made his own crack ;)
o AMI Decrypt code by Eduardo Motta Buhrnheim (Mingo)
  P.S. - Damn, dude, stop using Pascal!!!
o Personal checksum explanation by Bluefish, creator of !BIOS
o Sample Win32 Shutdown code by Pardal
o All pages containing _free_ TASM50/TC30
o Well, Borland team who created TASM/TC

DISCLAIMER:
        LockIt is distributed under "Artistic License". Read ARTISTIC.TXT for
more information. If you got LockIt without this file, CONTACT ME AND I'LL
KICK ASS OF DAMN LAMMER THAT STRIPPED IT OUT!!!

==============================================================================
V. CONTACT ME
==============================================================================

(Preferency order:)
Homepage:	http://sysd.hypermart.net/
E-Mail:		stas@linuxbr.com.br
ICQ UIN:	11979567

==============================================================================
VI. FOR DEVELOPERS
==============================================================================

	Huh... If you are reading this, I hope that you are interested in
developing of LockIt. What can I say? LockIt is too dificult to be developed
_ONLY_ by someone as lazy as I ;) Any kind of help (from coding and algorythm
developing to LockIt documentation) is very welcome!!! And, if you _REALLY_
wanna do it, just read DEVELOP.TXT and TODO.TXT files in same directory where
you found README.TXT (this shit you are reading now).
