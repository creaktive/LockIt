int ReadCMOS(char unsigned Func)
{
   outportb(0x70, Func);
   return inportb(0x71);
}

int WriteCMOS(char unsigned Func, char unsigned Value)
{
   outportb(0x70, Func);
   outportb(0x71, Value);
   return 0;
}

int ChecksumUpdate(void)
{
   int i, Checksum;
   char unsigned HByte, LByte;
   Checksum = 0;

   for (i = 0x10; i <= 0x2D; i++)Checksum += ReadCMOS(i);

   asm mov ax, word ptr [Checksum]
   asm mov byte ptr [HByte], ah
   asm mov byte ptr [LByte], al

   WriteCMOS(0x2E, HByte);
   WriteCMOS(0x2F, LByte);

   return 0;
}
