#include <stdio.h>
#include <values.h>


long offs[2];
unsigned long size;
char *buffer;

static char Signature[] = {
   0x0B, 0xAD, 0x5E, 0xED
};

struct
{
   unsigned char        Maj_ver;
   unsigned char        Min_ver;
   unsigned char        Config_Size;
} Version;

struct
{
   unsigned char	Halt_mode;
   unsigned int		AWARD_Passwd;
   char                 AMI_Passwd[7];
} Config;

#define MAJ_VER 2
#define MIN_VER 3


long scan4sign(long from)
{
   long i, scan_range = size - sizeof(Signature);
   for (i = from; i < scan_range; i++)
      if (memcmp(buffer + i, Signature, sizeof(Signature)) == 0)
         return i;

   printf("LockIt Signature not found!\n");
   exit(-1);
   return -1;
}

void AMI_Crypt (char *encrypted, char *password)
{
   unsigned int i, byte, tmpa, tmpb, last;

   last = 0xF0;
   i = 0;

   do
   {
      encrypted[i] = last;
      byte = 0;

      while (byte != password[i])
      {
         byte++;
         tmpa = 0;
         tmpb = 0;

         if ((last & 0x80) > 0)
            tmpa++;
         if ((last & 0x40) > 0)
            tmpa++;
         if ((last & 0x02) > 0)
            tmpa++;
         if ((last & 0x01) > 0)
            tmpa++;

         while (tmpb < tmpa)
            tmpb += 2;

         last = last / 2;
         tmpb -= tmpa;

         if (tmpb == 1)
            last += 0x80;
      }

      i++;
   } while (i <= 6 && password[i - 1] != NULL);

   encrypted[i] = NULL;
}


void WinBIOS_PreCrypt (char *encrypted, char *password)
{
static char table[] =
{
// 0     1     2     3     4     5     6     7     8     9
0x0B, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0A,
// Unmatched buffer
0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
// A     B     C     D     E     F     G     H     I     J     K     L     M
0x1E, 0x30, 0x2E, 0x20, 0x12, 0x21, 0x22, 0x23, 0x17, 0x24, 0x25, 0x26, 0x32,
// N     O     P     Q     R     S     T     U     V     W     X     Y     Z
0x31, 0x18, 0x19, 0x10, 0x13, 0x1F, 0x14, 0x16, 0x2F, 0x11, 0x2D, 0x15, 0x2C
};

   unsigned char i;
   for (i = 0; i < strlen (password); i++)
      encrypted[i] = table[password[i] - 0x30];
}


void NewAMI_PreCrypt (char *encrypted, char *password)
{
   WinBIOS_PreCrypt (encrypted, password);
   encrypted[0] += 123;
}


unsigned int AWARD_Hash (char *password)
{
   unsigned int hash = 0;
   unsigned char i = 0;

   while (password[i] != NULL)
   {
      asm {
         rol    [hash], 1;
         rol    [hash], 1;
      }

      hash += password[i++];
   }

   return hash;
}

int main(int argc, char* argv[])
{
   FILE *LockIt;
   char *filename = "LOCKIT.EXE", *version;
   char string[80];
   int i, len = 0;

   sprintf(version, "%d.%d", MAJ_VER, MIN_VER);

   printf("SETDOWN(R) v%s -- LockIt(R) v%s Configuration Tool\n",
          version, version);
   printf("Coded by Stas,\n");
   printf("(C)opyLeft by SysD Destructive Labs, 1997-2000\n\n");

   if (argc == 2)
      filename = argv[1];
   else if (argc > 2)
   {
      printf("Usage: SETDOWN <LockIt file>\n");
      return 0;
   }

   printf("Operating on \"%s\"...\n", filename);
   if ((LockIt = fopen(filename, "r+b")) == NULL)
   {
      printf("Can't open file for read/write!\n");
      return -1;
   }

   if ((size = filelength(fileno(LockIt))) > MAXINT)
   {
      printf("LockIt file is too big!\n");
      return -1;
   }

   fseek(LockIt, 0, SEEK_SET);
   buffer = (char *) malloc(size);
   fread(buffer, size, 1, LockIt);
   offs[0] = scan4sign(0);
   offs[1] = scan4sign(offs[0]+1);
   free(buffer);

   printf("Signature found at [%04X] and [%04X]!\n",
          (long *)offs[0], (long *)offs[1]);

   /* Read/parse first data block */
   fseek(LockIt, offs[0] + sizeof(Signature), SEEK_SET);
   fread(&Version, sizeof(Version), 1, LockIt);
   printf("\"%s\" is LockIt(R) v%d.%d\n", filename, Version.Maj_ver, Version.Min_ver);
   if ((Version.Maj_ver > MAJ_VER) ||
       ((Version.Maj_ver == MAJ_VER) && (Version.Min_ver > MIN_VER)))
      printf(" * WARNING: it's better you get newer SETDOWN... (%d.%d > %d.%d)\n",
             Version.Maj_ver, Version.Min_ver, MAJ_VER, MIN_VER);

   /* Prompt user */
   while (len == 0)
   {
      printf("\nType password: ");
      gets(string);
      len = strlen(string);

      if (len < 1 || len > 6)
      {
         printf ("Password must have 1-6 characters!\n");
         len = 0;
      }
      for (i = 0; i < len; i++)
         if (!isalnum (string[i]))
         {
            printf("Password must contain alphanumeric characters only!\n");
            len = 0;
            break;
         }
   }

   /* Password for AWARD BIOS */
   Config.AWARD_Passwd = AWARD_Hash(string);
   /* Password for AMI BIOS */
   for (i = 0; i < len; i++)
      string[i] = toupper (string[i]);
   buffer = (char *) malloc(7);
   NewAMI_PreCrypt(buffer, string);
   AMI_Crypt(Config.AMI_Passwd, buffer);
   free(buffer);

   printf("\nEnter LOCKIT halt mode:\n");
   printf("1). Normal exit (default)\n");
   printf("2). Shut OS down on exit\n");
   printf("3). Hang OS on exit\n\n");

GetHaltMode:
   switch (atoi(string)) {
      case 1: Config.Halt_mode = 0; break;
      case 2: Config.Halt_mode = 1; break;
      case 3: Config.Halt_mode = 2; break;

      default:
      printf("Halt mode: ");
      gets(string);
      goto GetHaltMode;
   }

   /* Write out new config */
   printf("\nAnd now, updating \"%s\"...\n", filename);
   for (i = 0; i <= 1; i++)
   {
      fseek(LockIt, offs[i] + sizeof(Signature) + sizeof(Version), SEEK_SET);
      fwrite(&Config, Version.Config_Size, 1, LockIt);
   }

   printf("Enjoy LockIt!!!\n");
   fclose(LockIt);
   return 0;
}
