unit mselibc;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msectypes;

const
 clib = 'c';
 threadslib = 'pthread';

type
 
//from bits/typesizes.h

 __dev_t = __UQUAD_TYPE;
 __uid_t = __U32_TYPE;
 __gid_t = __U32_TYPE;
 __ino_t = __ULONGWORD_TYPE;
 __ino64_t = __UQUAD_TYPE;
 __mode_t = __U32_TYPE;
 __nlink_t = __UWORD_TYPE;
 __off_t = __SLONGWORD_TYPE;
 __off64_t = __SQUAD_TYPE;
 __pid_t = __S32_TYPE;
 __rlim_t = __ULONGWORD_TYPE;
 __rlim64_t = __UQUAD_TYPE;
 __blkcnt_t = __SLONGWORD_TYPE;
 __blkcnt64_t = __SQUAD_TYPE;
 __fsblkcnt_t = __ULONGWORD_TYPE;
 __fsblkcnt64_t = __UQUAD_TYPE;
 __fsfilcnt_t = __ULONGWORD_TYPE;
 __fsfilcnt64_t = __UQUAD_TYPE;
 __id_t = __U32_TYPE;
 __clock_t = __SLONGWORD_TYPE;
 __time_t = __SLONGWORD_TYPE;
 __useconds_t = __U32_TYPE;
 __suseconds_t = __SLONGWORD_TYPE;
 __daddr_t = __S32_TYPE;
 __swblk_t = __SLONGWORD_TYPE;
 __key_t = __S32_TYPE;
 __clockid_t = __S32_TYPE;
 __timer_t = pointer; //void *;
 __blksize_t = __SLONGWORD_TYPE;
 __fsid_t = record
             __val: array[0..1] of longint;
            end;
//             __struct { int __val[2]; };
 __ssize_t = __SWORD_TYPE;

 __fd_mask = __ULONGWORD_TYPE; //dWord;
 {$ifdef CPU64}
 __ipc_pid_t = integer;
 {$else}
 __ipc_pid_t = word;
 {$endif}
 __caddr_t = ^char;
 
//ioctrl
const
   TCGETS = $5401;
   TCSETS = $5402;
   TCSETSW = $5403;
   TCSETSF = $5404;
   TCGETA = $5405;
   TCSETA = $5406;
   TCSETAW = $5407;
   TCSETAF = $5408;
   TCSBRK = $5409;
   TCXONC = $540A;
   TCFLSH = $540B;
   TIOCEXCL = $540C;
   TIOCNXCL = $540D;
   TIOCSCTTY = $540E;
   TIOCGPGRP = $540F;
   TIOCSPGRP = $5410;
   TIOCOUTQ = $5411;
   TIOCSTI = $5412;
   TIOCGWINSZ = $5413;
   TIOCSWINSZ = $5414;
   TIOCMGET = $5415;
   TIOCMBIS = $5416;
   TIOCMBIC = $5417;
   TIOCMSET = $5418;
   TIOCGSOFTCAR = $5419;
   TIOCSSOFTCAR = $541A;
   FIONREAD = $541B;
   TIOCINQ = FIONREAD;
   TIOCLINUX = $541C;
   TIOCCONS = $541D;
   TIOCGSERIAL = $541E;
   TIOCSSERIAL = $541F;
   TIOCPKT = $5420;
   FIONBIO = $5421;
   TIOCNOTTY = $5422;
   TIOCSETD = $5423;
   TIOCGETD = $5424;
   TCSBRKP = $5425;
   TIOCTTYGSTRUCT = $5426;
   TIOCSBRK = $5427;
   TIOCCBRK = $5428;
   TIOCGSID = $5429;
   
const
   FIONCLEX = $5450;
   FIOCLEX = $5451;
   FIOASYNC = $5452;
   TIOCSERCONFIG = $5453;
   TIOCSERGWILD = $5454;
   TIOCSERSWILD = $5455;
   TIOCGLCKTRMIOS = $5456;
   TIOCSLCKTRMIOS = $5457;
   TIOCSERGSTRUCT = $5458;
   TIOCSERGETLSR = $5459;
   TIOCSERGETMULTI = $545A;
   TIOCSERSETMULTI = $545B;
   TIOCMIWAIT = $545C;
   TIOCGICOUNT = $545D;
   TIOCGHAYESESP = $545E;
   TIOCSHAYESESP = $545F;
   TIOCPKT_DATA = 0;
   TIOCPKT_FLUSHREAD = 1;
   TIOCPKT_FLUSHWRITE = 2;
   TIOCPKT_STOP = 4;
   TIOCPKT_START = 8;
   TIOCPKT_NOSTOP = 16;
   TIOCPKT_DOSTOP = 32;
   TIOCSER_TEMT = $01;

const
   EPERM = 1;
   ENOENT = 2;
   ESRCH = 3;
   EINTR = 4;
   EIO = 5;
   ENXIO = 6;
   E2BIG = 7;
   ENOEXEC = 8;
   EBADF = 9;
   ECHILD = 10;
   EAGAIN = 11;
   ENOMEM = 12;
   EACCES = 13;
   EFAULT = 14;
   ENOTBLK = 15;
   EBUSY = 16;
   EEXIST = 17;
   EXDEV = 18;
   ENODEV = 19;
   ENOTDIR = 20;
   EISDIR = 21;
   EINVAL = 22;
   ENFILE = 23;
   EMFILE = 24;
   ENOTTY = 25;
   ETXTBSY = 26;
   EFBIG = 27;
   ENOSPC = 28;
   ESPIPE = 29;
   EROFS = 30;
   EMLINK = 31;
   EPIPE = 32;
   EDOM = 33;
   ERANGE = 34;
   EDEADLK = 35;
   ENAMETOOLONG = 36;
   ENOLCK = 37;
   ENOSYS = 38;
   ENOTEMPTY = 39;
   ELOOP = 40;
   EWOULDBLOCK = EAGAIN;
   ENOMSG = 42;
   EIDRM = 43;
   ECHRNG = 44;
   EL2NSYNC = 45;
   EL3HLT = 46;
   EL3RST = 47;
   ELNRNG = 48;
   EUNATCH = 49;
   ENOCSI = 50;
   EL2HLT = 51;
   EBADE = 52;
   EBADR = 53;
   EXFULL = 54;
   ENOANO = 55;
   EBADRQC = 56;
   EBADSLT = 57;
   EDEADLOCK = EDEADLK;
   EBFONT = 59;
   ENOSTR = 60;
   ENODATA = 61;
   ETIME = 62;
   ENOSR = 63;
   ENONET = 64;
   ENOPKG = 65;
   EREMOTE = 66;
   ENOLINK = 67;
   EADV = 68;
   ESRMNT = 69;
   ECOMM = 70;
   EPROTO = 71;
   EMULTIHOP = 72;
   EDOTDOT = 73;
   EBADMSG = 74;
   EOVERFLOW = 75;
   ENOTUNIQ = 76;
   EBADFD = 77;
   EREMCHG = 78;
   ELIBACC = 79;
   ELIBBAD = 80;
   ELIBSCN = 81;
   ELIBMAX = 82;
   ELIBEXEC = 83;
   EILSEQ = 84;
   ERESTART = 85;
   ESTRPIPE = 86;
   EUSERS = 87;
   ENOTSOCK = 88;
   EDESTADDRREQ = 89;
   EMSGSIZE = 90;
   EPROTOTYPE = 91;
   ENOPROTOOPT = 92;
   EPROTONOSUPPORT = 93;
   ESOCKTNOSUPPORT = 94;
   EOPNOTSUPP = 95;
   EPFNOSUPPORT = 96;
   EAFNOSUPPORT = 97;
   EADDRINUSE = 98;
   EADDRNOTAVAIL = 99;
   ENETDOWN = 100;
   ENETUNREACH = 101;
   ENETRESET = 102;
   ECONNABORTED = 103;
   ECONNRESET = 104;
   ENOBUFS = 105;
   EISCONN = 106;
   ENOTCONN = 107;
   ESHUTDOWN = 108;
   ETOOMANYREFS = 109;
   ETIMEDOUT = 110;
   ECONNREFUSED = 111;
   EHOSTDOWN = 112;
   EHOSTUNREACH = 113;
   EALREADY = 114;
   EINPROGRESS = 115;
   ESTALE = 116;
   EUCLEAN = 117;
   ENOTNAM = 118;
   ENAVAIL = 119;
   EISNAM = 120;
   EREMOTEIO = 121;
   EDQUOT = 122;
   ENOMEDIUM = 123;
   EMEDIUMTYPE = 124;

   O_ACCMODE  = &00003;
   O_RDONLY   = &00000;
   O_WRONLY   = &00001;
   O_RDWR     = &00002;
   O_CREAT    = &00100;
   O_EXCL     = &00200;
   O_NOCTTY   = &00400;
   O_TRUNC    = &01000;
   O_APPEND   = &02000;
   O_NONBLOCK = &04000;
   O_NDELAY   = O_NONBLOCK;
   O_SYNC     = &010000;
   O_FSYNC    = O_SYNC;
   O_ASYNC    = &020000;

   O_DIRECT    = &0040000;
   O_DIRECTORY = &0200000;
   O_NOFOLLOW  = &0400000;

   O_DSYNC = O_SYNC;
   O_RSYNC = O_SYNC;

   O_LARGEFILE = &0100000;

   F_DUPFD   = 0;
   F_GETFD   = 1;
   F_SETFD   = 2;
   F_GETFL   = 3;
   F_SETFL   = 4;

   F_GETLK   = 5;
   F_SETLK   = 6;
   F_SETLKW  = 7;

   F_GETLK64  = 12;
   F_SETLK64  = 13;
   F_SETLKW64 = 14;

   F_SETOWN = 8;
   F_GETOWN = 9;

   F_SETSIG = 10;
   F_GETSIG = 11;

   F_SETLEASE = 1024;
   F_GETLEASE = 1025;
   F_NOTIFY = 1026;

   FD_CLOEXEC = 1;
   F_RDLCK = 0;
   F_WRLCK = 1;
   F_UNLCK = 2;
   F_EXLCK = 4;
   F_SHLCK = 8;

   LOCK_SH = 1;
   LOCK_EX = 2;
   LOCK_NB = 4;
   LOCK_UN = 8;

   LOCK_MAND = 32;
   LOCK_READ = 64;
   LOCK_WRITE = 128;
   LOCK_RW = 192;

   DN_ACCESS = $00000001;
   DN_MODIFY = $00000002;
   DN_CREATE = $00000004;
   DN_DELETE = $00000008;
   DN_RENAME = $00000010;
   DN_ATTRIB = $00000020;
   DN_MULTISHOT = $80000000;
   
  __S_ISUID       = $800;
  __S_ISGID       = $400;
  __S_ISVTX       = $200;
  __S_IREAD       = $100;
  __S_IWRITE      = $80;
  __S_IEXEC       = $40;

  S_ISUID = __S_ISUID;
  S_ISGID = __S_ISGID;
  S_ISVTX = __S_ISVTX;

  S_IRUSR = __S_IREAD;
  S_IWUSR = __S_IWRITE;
  S_IXUSR = __S_IEXEC;
  S_IRWXU = (__S_IREAD or __S_IWRITE) or __S_IEXEC;

  S_IREAD = S_IRUSR;
  S_IWRITE = S_IWUSR;
  S_IEXEC = S_IXUSR;

  S_IRGRP = S_IRUSR shr 3;
  S_IWGRP = S_IWUSR shr 3;
  S_IXGRP = S_IXUSR shr 3;
  S_IRWXG = S_IRWXU shr 3;
  S_IROTH = S_IRGRP shr 3;
  S_IWOTH = S_IWGRP shr 3;
  S_IXOTH = S_IXGRP shr 3;
  S_IRWXO = S_IRWXG shr 3;

type
  __ptr_t = Pointer;
  P__ptr_t = ^__ptr_t;
  ptrdiff_t = Integer;
  __long_double_t = Extended;
  P__long_double_t = ^__long_double_t;
  size_t = longword;
  Psize_t = ^size_t;
  UInt64 = 0..High(Int64); // Must be unsigned.
  wchar_t = widechar;
  Pwchar_t = ^wchar_t;
  PPwchar_t = ^Pwchar_t;
  PPByte = ^PByte;
  PPPChar = ^PPChar;

   __u_char = byte;
   __u_short = word;
   __u_int = dword;
   __u_long = dword;
   __u_quad_t = qword;
   __quad_t = int64;

   __int8_t = char;
   __uint8_t = byte;
   __int16_t = smallint;
   __uint16_t = word;
   __int32_t = longint;
   __uint32_t = dword;
   __int64_t = Int64;
   __uint64_t = Qword;

   __qaddr_t = __quad_t;
//   __dev_t = __u_quad_t;
//   __uid_t = __u_int;
//   __gid_t = __u_int;
//   __ino_t = __u_long;
//   __mode_t = __u_int;
//   __nlink_t = __u_int;
//   __off_t = longint;
   __loff_t = __quad_t;
//   __pid_t = longint;
//   __ssize_t = longint;
//   __rlim_t = __u_long;
//   __rlim64_t = __u_quad_t;
//   __id_t = __u_int;
//   __fsid_t = record
//        __val : array[0..1] of longint;
//     end;

{
   __daddr_t = longint;
   __caddr_t = char;
   __time_t = longint;
   __useconds_t = dword;
   __suseconds_t = longint;
   __swblk_t = longint;
   __clock_t = longint;
   __clockid_t = longint;
   __timer_t = longint;
   __fd_mask = dWord;
}
  int64_t = Int64;
  uint8_t = byte;

  uint16_t = word;
  uint32_t = dword;
  uint64_t = qword;
  int_least8_t = char;
  int_least16_t = smallint;
  int_least32_t = longint;
  int_least64_t = int64;
  uint_least8_t = byte;
  uint_least16_t = word;
  uint_least32_t = dword;
  uint_least64_t = qword;

  int_fast8_t = shortint;
  int_fast16_t = longint;
  int_fast32_t = longint;
  int_fast64_t = int64;
  uint_fast8_t = byte;

  uint_fast16_t = dword;
  uint_fast32_t = dword;
  uint_fast64_t = qword;

  intptr_t = longint;
  uintptr_t = dword;
  intmax_t = Int64;
  uintmax_t = QWord;

const
  __FD_SETSIZE = 1024;
  __NFDBITS       = 8 * sizeof(__fd_mask);

type
//  __key_t = longint;
//  __ipc_pid_t = word;
//  __blksize_t = longint;
//  __blkcnt_t = longint;
//  __blkcnt64_t = __quad_t;
//  __fsblkcnt_t = __u_long;
//  __fsblkcnt64_t = __u_quad_t;
//  __fsfilcnt_t = __u_long;
//  __fsfilcnt64_t = __u_quad_t;
//  __ino64_t = __u_quad_t;
//  __off64_t = __loff_t;
  __t_scalar_t = longint;
  __t_uscalar_t = dword;
  __intptr_t = longint;
  __socklen_t = dword;
  TFileDescriptor = integer;

{$ifdef CPU64}
 P_stat = ^_stat;
 PStat = ^_stat;

 _stat = packed record
  st_dev: culong;
  st_ino: culong;
  st_nlink: culong;
  
  st_mode: cuint;
  st_uid: cuint;
  st_gid: cuint;
  __pad0: cuint;
  st_rdev: culong;
  st_size: clong;
  st_blksize: clong;
  st_blocks: clong;	///* Number 512-byte blocks allocated. */
  
  st_atime: culong;
  st_atime_nsec: culong;
  st_mtime: culong;
  st_mtime_nsec: culong;
  st_ctime: culong;
  st_ctime_nsec: culong;
  __unused: array[0..2] of clong;
 end;
 P_stat64 = ^_stat64;
 Pstat64 = ^_stat64;
 _stat64 = _stat; 
{$else}
 P_stat = ^_stat;
 PStat = ^_stat;

 _stat = packed record //probably wrong, not used
   st_dev : __dev_t;
   __pad1 : word;
   __align_pad1 : word;
   st_ino : __ino_t;
   st_mode : __mode_t;
   st_nlink : __nlink_t;
   st_uid : __uid_t;
   st_gid : __gid_t;
   st_rdev : __dev_t;
   __pad2 : word;
   __align_pad2 : word;
   st_size : __off_t;
   st_blksize : __blksize_t;
   st_blocks : __blkcnt_t;
   st_atime : __time_t;
   st_atime_nsec : longword;
   st_mtime : __time_t;
   st_mtime_nsec: longword;
   st_ctime : __time_t;
   st_ctime_nsec: longword;
   __unused4 : dword;
   __unused5 : dword;
 end;

   P_stat64 = ^_stat64;
   Pstat64 = ^_stat64;

   _stat64 = packed record
	st_dev: culonglong;                 // 0
	__pad0: array[0..3] of byte;        // 8
	__st_ino: culong;                   //12
	st_mode: cuint;                     //16
	st_nlink: cuint;                    //20
	st_uid: culong;                     //24
	st_gid: culong;                     //28
	st_rdev: culonglong;                //32
	__pad3: array[0..3] of byte;        //40
	st_size: clonglong;                 //44
	st_blksize: culong;                 //52
	st_blocks: culonglong;              //56
	st_atime: culong;                   //64
	st_atime_nsec: culong;              //68
	st_mtime: culong;                   //72
	st_mtime_nsec: cuint;               //76
	st_ctime: culong;                   //80
	st_ctime_nsec: culong;              //84
	st_ino: culonglong;                 //88
	                                    //96
	
   end;
{$endif}

  __fd_set = record
     fds_bits: packed array[0..(__FD_SETSIZE div __NFDBITS)-1] of __fd_mask;
  end;
  TFdSet = __fd_set;
  PFdSet = ^TFdSet;

 
Const
  stdin   = 0;
  stdout  = 1;
  stderr  = 2;
           
  
Type

  u_char = __u_char;
  u_short = __u_short;
  u_int = __u_int;
  u_long = __u_long;
  quad_t = __quad_t;
  u_quad_t = __u_quad_t;
  fsid_t = __fsid_t;
  loff_t = __loff_t;
  ino_t = __ino_t;
  ino64_t = __ino64_t;
  dev_t = __dev_t;
  gid_t = __gid_t;
  mode_t = __mode_t;
  nlink_t = __nlink_t;
  uid_t = __uid_t;
  off_t = __off_t;
  off64_t = __off64_t;
  pid_t = __pid_t;
  id_t = __id_t;
  ssize_t = __ssize_t;
  daddr_t = __daddr_t;
  caddr_t = __caddr_t;
  key_t = __key_t;
  useconds_t = __useconds_t;
  suseconds_t = __suseconds_t;
  ulong = dword;
  ushort = word;
  uint = dword;
  int8_t = char;
  int16_t = smallint;
  int32_t = longint;
  u_int8_t = byte;
  u_int16_t = word;
  u_int32_t = dword;
  register_t = longint;
  blksize_t = __blksize_t;
  blkcnt_t = __blkcnt_t;
  fsblkcnt_t = __fsblkcnt_t;
  fsfilcnt_t = __fsfilcnt_t;
  blkcnt64_t = __blkcnt64_t;
  fsblkcnt64_t = __fsblkcnt64_t;
  fsfilcnt64_t = __fsfilcnt64_t;

  P__key_t = ^__key_t;
  P__ipc_pid_t = ^__ipc_pid_t;
  P__blksize_t = ^__blksize_t;
  P__blkcnt_t = ^__blkcnt_t;
  P__blkcnt64_t = ^__blkcnt64_t;
  P__fsblkcnt_t = ^__fsblkcnt_t;
  P__fsblkcnt64_t = ^__fsblkcnt64_t;
  P__fsfilcnt_t = ^__fsfilcnt_t;
  P__fsfilcnt64_t = ^__fsfilcnt64_t;
  P__ino64_t = ^__ino64_t;
  P__off64_t = ^__off64_t;
  P__t_scalar_t = ^__t_scalar_t;
  P__t_uscalar_t = ^__t_uscalar_t;
  P__intptr_t = ^__intptr_t;
  P__socklen_t = ^__socklen_t;


  Pu_char = ^u_char;
  Pu_short = ^u_short;
  Pu_int = ^u_int;
  Pu_long = ^u_long;
  Pquad_t = ^quad_t;
  Pu_quad_t = ^u_quad_t;
  Pfsid_t = ^fsid_t;
  Ploff_t = ^loff_t;
  Pino_t = ^ino_t;
  Pino64_t = ^ino64_t;
  Pdev_t = ^dev_t;
  Pgid_t = ^gid_t;
  Pmode_t = ^mode_t;
  Pnlink_t = ^nlink_t;
  Puid_t = ^uid_t;
  Poff_t = ^off_t;
  Poff64_t = ^off64_t;
  Ppid_t = ^pid_t;
  Pssize_t = ^ssize_t;
  Pdaddr_t = ^daddr_t;
  Pcaddr_t = ^caddr_t;
  Pkey_t = ^key_t;
  Puseconds_t = ^useconds_t;
  Psuseconds_t = ^suseconds_t;
  Pulong = ^ulong;
  Pushort = ^ushort;
  Puint = ^uint;
  Pint8_t = ^int8_t;
  Pint16_t = ^int16_t;
  Pint32_t = ^int32_t;
  Pu_int8_t = ^u_int8_t;
  Pu_int16_t = ^u_int16_t;
  Pu_int32_t = ^u_int32_t;
  Pregister_t = ^register_t;
  Pblksize_t = ^blksize_t;
  Pblkcnt_t = ^blkcnt_t;
  Pfsblkcnt_t = ^fsblkcnt_t;
  Pfsfilcnt_t = ^fsfilcnt_t;
  Pblkcnt64_t = ^blkcnt64_t;
  Pfsblkcnt64_t = ^fsblkcnt64_t;
  Pfsfilcnt64_t = ^fsfilcnt64_t;

  P__qaddr_t = ^__qaddr_t;
  P__dev_t = ^__dev_t;
  P__uid_t = ^__uid_t;
  P__gid_t = ^__gid_t;
  P__ino_t = ^__ino_t;
  P__mode_t = ^__mode_t;
  P__nlink_t = ^__nlink_t;
  P__off_t = ^__off_t;
  P__loff_t = ^__loff_t;
  P__pid_t = ^__pid_t;
  P__ssize_t = ^__ssize_t;
  P__rlim_t = ^__rlim_t;
  P__rlim64_t = ^__rlim64_t;
  P__id_t = ^__id_t;
  P__fsid_t = ^__fsid_t;
  P__daddr_t = ^__daddr_t;
  P__caddr_t = ^__caddr_t;
  P__time_t = ^__time_t;
  P__useconds_t = ^__useconds_t;
  P__suseconds_t = ^__suseconds_t;
  P__swblk_t = ^__swblk_t;
  P__clock_t = ^__clock_t;
  P__clockid_t = ^__clockid_t;
  P__timer_t = ^__timer_t;

const
  __LC_CTYPE    = 0;
  __LC_NUMERIC  = 1;
  __LC_TIME     = 2;
  __LC_COLLATE  = 3;
  __LC_MONETARY = 4;
  __LC_MESSAGES = 5;
  __LC_ALL      = 6;
  __LC_PAPER    = 7;
  __LC_NAME     = 8;
  __LC_ADDRESS  = 9;
  __LC_TELEPHONE = 10;
  __LC_MEASUREMENT = 11;
  __LC_IDENTIFICATION = 12;

  LC_CTYPE = __LC_CTYPE;
  LC_NUMERIC = __LC_NUMERIC;
  LC_TIME = __LC_TIME;
  LC_COLLATE = __LC_COLLATE;
  LC_MONETARY = __LC_MONETARY;
  LC_MESSAGES = __LC_MESSAGES;
  LC_ALL = __LC_ALL;
  LC_PAPER = __LC_PAPER;
  LC_NAME = __LC_NAME;
  LC_ADDRESS = __LC_ADDRESS;
  LC_TELEPHONE = __LC_TELEPHONE;
  LC_MEASUREMENT = __LC_MEASUREMENT;
  LC_IDENTIFICATION = __LC_IDENTIFICATION;

 ABDAY_1 = (__LC_TIME shl 16);
 ABDAY_2 = (ABDAY_1)+1;
 ABDAY_3 = (ABDAY_1)+2;
 ABDAY_4 = (ABDAY_1)+3;
 ABDAY_5 = (ABDAY_1)+4;
 ABDAY_6 = (ABDAY_1)+5;
 ABDAY_7 = (ABDAY_1)+6;
 DAY_1 = (ABDAY_1)+7;
 DAY_2 = (ABDAY_1)+8;
 DAY_3 = (ABDAY_1)+9;
 DAY_4 = (ABDAY_1)+10;
 DAY_5 = (ABDAY_1)+11;
 DAY_6 = (ABDAY_1)+12;
 DAY_7 = (ABDAY_1)+13;
 ABMON_1 = (ABDAY_1)+14;
 ABMON_2 = (ABDAY_1)+15;
 ABMON_3 = (ABDAY_1)+16;
 ABMON_4 = (ABDAY_1)+17;
 ABMON_5 = (ABDAY_1)+18;
 ABMON_6 = (ABDAY_1)+19;
 ABMON_7 = (ABDAY_1)+20;
 ABMON_8 = (ABDAY_1)+21;
 ABMON_9 = (ABDAY_1)+22;
 ABMON_10 = (ABDAY_1)+23;
 ABMON_11 = (ABDAY_1)+24;
 ABMON_12 = (ABDAY_1)+25;
 MON_1 = (ABDAY_1)+26;
 MON_2 = (ABDAY_1)+27;
 MON_3 = (ABDAY_1)+28;
 MON_4 = (ABDAY_1)+29;
 MON_5 = (ABDAY_1)+30;
 MON_6 = (ABDAY_1)+31;
 MON_7 = (ABDAY_1)+32;
 MON_8 = (ABDAY_1)+33;
 MON_9 = (ABDAY_1)+34;
 MON_10 = (ABDAY_1)+35;
 MON_11 = (ABDAY_1)+36;
 MON_12 = (ABDAY_1)+37;
 AM_STR = (ABDAY_1)+38;
 PM_STR = (ABDAY_1)+39;
 D_T_FMT = (ABDAY_1)+40;
 D_FMT = (ABDAY_1)+41;
 T_FMT = (ABDAY_1)+42;
 T_FMT_AMPM = (ABDAY_1)+43;
 ERA = (ABDAY_1)+44;
 __ERA_YEAR = (ABDAY_1)+45;
 ERA_D_FMT = (ABDAY_1)+46;
 ALT_DIGITS = (ABDAY_1)+47;
 ERA_D_T_FMT = (ABDAY_1)+48;
 ERA_T_FMT = (ABDAY_1)+49;
 _NL_TIME_ERA_NUM_ENTRIES = (ABDAY_1)+50;
 _NL_TIME_ERA_ENTRIES = (ABDAY_1)+51;
 _NL_WABDAY_1 = (ABDAY_1)+52;
 _NL_WABDAY_2 = (ABDAY_1)+53;
 _NL_WABDAY_3 = (ABDAY_1)+54;
 _NL_WABDAY_4 = (ABDAY_1)+55;
 _NL_WABDAY_5 = (ABDAY_1)+56;
 _NL_WABDAY_6 = (ABDAY_1)+57;
 _NL_WABDAY_7 = (ABDAY_1)+58;
 _NL_WDAY_1 = (ABDAY_1)+59;
 _NL_WDAY_2 = (ABDAY_1)+60;
 _NL_WDAY_3 = (ABDAY_1)+61;
 _NL_WDAY_4 = (ABDAY_1)+62;
 _NL_WDAY_5 = (ABDAY_1)+63;
 _NL_WDAY_6 = (ABDAY_1)+64;
 _NL_WDAY_7 = (ABDAY_1)+65;
 _NL_WABMON_1 = (ABDAY_1)+66;
 _NL_WABMON_2 = (ABDAY_1)+67;
 _NL_WABMON_3 = (ABDAY_1)+68;
 _NL_WABMON_4 = (ABDAY_1)+69;
 _NL_WABMON_5 = (ABDAY_1)+70;
 _NL_WABMON_6 = (ABDAY_1)+71;
 _NL_WABMON_7 = (ABDAY_1)+72;
 _NL_WABMON_8 = (ABDAY_1)+73;
 _NL_WABMON_9 = (ABDAY_1)+74;
 _NL_WABMON_10 = (ABDAY_1)+75;
 _NL_WABMON_11 = (ABDAY_1)+76;
 _NL_WABMON_12 = (ABDAY_1)+77;
 _NL_WMON_1 = (ABDAY_1)+78;
 _NL_WMON_2 = (ABDAY_1)+79;
 _NL_WMON_3 = (ABDAY_1)+80;
 _NL_WMON_4 = (ABDAY_1)+81;
 _NL_WMON_5 = (ABDAY_1)+82;
 _NL_WMON_6 = (ABDAY_1)+83;
 _NL_WMON_7 = (ABDAY_1)+84;
 _NL_WMON_8 = (ABDAY_1)+85;
 _NL_WMON_9 = (ABDAY_1)+86;
 _NL_WMON_10 = (ABDAY_1)+87;
 _NL_WMON_11 = (ABDAY_1)+88;
 _NL_WMON_12 = (ABDAY_1)+89;
 _NL_WAM_STR = (ABDAY_1)+90;
 _NL_WPM_STR = (ABDAY_1)+91;
 _NL_WD_T_FMT = (ABDAY_1)+92;
 _NL_WD_FMT = (ABDAY_1)+93;
 _NL_WT_FMT = (ABDAY_1)+94;
 _NL_WT_FMT_AMPM = (ABDAY_1)+95;
 _NL_WERA_YEAR = (ABDAY_1)+96;
 _NL_WERA_D_FMT = (ABDAY_1)+97;
 _NL_WALT_DIGITS = (ABDAY_1)+98;
 _NL_WERA_D_T_FMT = (ABDAY_1)+99;
 _NL_WERA_T_FMT = (ABDAY_1)+100;
 _NL_TIME_WEEK_NDAYS = (ABDAY_1)+101;
 _NL_TIME_WEEK_1STDAY = (ABDAY_1)+102;
 _NL_TIME_WEEK_1STWEEK = (ABDAY_1)+103;
 _NL_TIME_FIRST_WEEKDAY = (ABDAY_1)+104;
 _NL_TIME_FIRST_WORKDAY = (ABDAY_1)+105;
 _NL_TIME_CAL_DIRECTION = (ABDAY_1)+106;
 _NL_TIME_TIMEZONE = (ABDAY_1)+107;
 _DATE_FMT = (ABDAY_1)+108;
 _NL_W_DATE_FMT = (ABDAY_1)+109;
 _NL_TIME_CODESET = (ABDAY_1)+110;
 _NL_NUM_LC_TIME = (ABDAY_1)+111;
 _NL_COLLATE_NRULES = (__LC_COLLATE shl 16);
 _NL_COLLATE_RULESETS = (_NL_COLLATE_NRULES)+1;
 _NL_COLLATE_TABLEMB = (_NL_COLLATE_NRULES)+2;
 _NL_COLLATE_WEIGHTMB = (_NL_COLLATE_NRULES)+3;
 _NL_COLLATE_EXTRAMB = (_NL_COLLATE_NRULES)+4;
 _NL_COLLATE_INDIRECTMB = (_NL_COLLATE_NRULES)+5;
 _NL_COLLATE_GAP1 = (_NL_COLLATE_NRULES)+6;
 _NL_COLLATE_GAP2 = (_NL_COLLATE_NRULES)+7;
 _NL_COLLATE_GAP3 = (_NL_COLLATE_NRULES)+8;
 _NL_COLLATE_TABLEWC = (_NL_COLLATE_NRULES)+9;
 _NL_COLLATE_WEIGHTWC = (_NL_COLLATE_NRULES)+10;
 _NL_COLLATE_EXTRAWC = (_NL_COLLATE_NRULES)+11;
 _NL_COLLATE_INDIRECTWC = (_NL_COLLATE_NRULES)+12;
 _NL_COLLATE_SYMB_HASH_SIZEMB = (_NL_COLLATE_NRULES)+13;
 _NL_COLLATE_SYMB_TABLEMB = (_NL_COLLATE_NRULES)+14;
 _NL_COLLATE_SYMB_EXTRAMB = (_NL_COLLATE_NRULES)+15;
 _NL_COLLATE_COLLSEQMB = (_NL_COLLATE_NRULES)+16;
 _NL_COLLATE_COLLSEQWC = (_NL_COLLATE_NRULES)+17;
 _NL_COLLATE_CODESET = (_NL_COLLATE_NRULES)+18;
 _NL_NUM_LC_COLLATE = (_NL_COLLATE_NRULES)+19;
 _NL_CTYPE_CLASS = (__LC_CTYPE shl 16);
 _NL_CTYPE_TOUPPER = (_NL_CTYPE_CLASS)+1;
 _NL_CTYPE_GAP1 = (_NL_CTYPE_CLASS)+2;
 _NL_CTYPE_TOLOWER = (_NL_CTYPE_CLASS)+3;
 _NL_CTYPE_GAP2 = (_NL_CTYPE_CLASS)+4;
 _NL_CTYPE_CLASS32 = (_NL_CTYPE_CLASS)+5;
 _NL_CTYPE_GAP3 = (_NL_CTYPE_CLASS)+6;
 _NL_CTYPE_GAP4 = (_NL_CTYPE_CLASS)+7;
 _NL_CTYPE_GAP5 = (_NL_CTYPE_CLASS)+8;
 _NL_CTYPE_GAP6 = (_NL_CTYPE_CLASS)+9;
 _NL_CTYPE_CLASS_NAMES = (_NL_CTYPE_CLASS)+10;
 _NL_CTYPE_MAP_NAMES = (_NL_CTYPE_CLASS)+11;
 _NL_CTYPE_WIDTH = (_NL_CTYPE_CLASS)+12;
 _NL_CTYPE_MB_CUR_MAX = (_NL_CTYPE_CLASS)+13;
 _NL_CTYPE_CODESET_NAME = (_NL_CTYPE_CLASS)+14;
 CODESET = _NL_CTYPE_CODESET_NAME;
 _NL_CTYPE_TOUPPER32 = (_NL_CTYPE_CODESET_NAME)+1;
 _NL_CTYPE_TOLOWER32 = (_NL_CTYPE_CODESET_NAME)+2;
 _NL_CTYPE_CLASS_OFFSET = (_NL_CTYPE_CODESET_NAME)+3;
 _NL_CTYPE_MAP_OFFSET = (_NL_CTYPE_CODESET_NAME)+4;
 _NL_CTYPE_INDIGITS_MB_LEN = (_NL_CTYPE_CODESET_NAME)+5;
 _NL_CTYPE_INDIGITS0_MB = (_NL_CTYPE_CODESET_NAME)+6;
 _NL_CTYPE_INDIGITS1_MB = (_NL_CTYPE_CODESET_NAME)+7;
 _NL_CTYPE_INDIGITS2_MB = (_NL_CTYPE_CODESET_NAME)+8;
 _NL_CTYPE_INDIGITS3_MB = (_NL_CTYPE_CODESET_NAME)+9;
 _NL_CTYPE_INDIGITS4_MB = (_NL_CTYPE_CODESET_NAME)+10;
 _NL_CTYPE_INDIGITS5_MB = (_NL_CTYPE_CODESET_NAME)+11;
 _NL_CTYPE_INDIGITS6_MB = (_NL_CTYPE_CODESET_NAME)+12;
 _NL_CTYPE_INDIGITS7_MB = (_NL_CTYPE_CODESET_NAME)+13;
 _NL_CTYPE_INDIGITS8_MB = (_NL_CTYPE_CODESET_NAME)+14;
 _NL_CTYPE_INDIGITS9_MB = (_NL_CTYPE_CODESET_NAME)+15;
 _NL_CTYPE_INDIGITS_WC_LEN = (_NL_CTYPE_CODESET_NAME)+16;
 _NL_CTYPE_INDIGITS0_WC = (_NL_CTYPE_CODESET_NAME)+17;
 _NL_CTYPE_INDIGITS1_WC = (_NL_CTYPE_CODESET_NAME)+18;
 _NL_CTYPE_INDIGITS2_WC = (_NL_CTYPE_CODESET_NAME)+19;
 _NL_CTYPE_INDIGITS3_WC = (_NL_CTYPE_CODESET_NAME)+20;
 _NL_CTYPE_INDIGITS4_WC = (_NL_CTYPE_CODESET_NAME)+21;
 _NL_CTYPE_INDIGITS5_WC = (_NL_CTYPE_CODESET_NAME)+22;
 _NL_CTYPE_INDIGITS6_WC = (_NL_CTYPE_CODESET_NAME)+23;
 _NL_CTYPE_INDIGITS7_WC = (_NL_CTYPE_CODESET_NAME)+24;
 _NL_CTYPE_INDIGITS8_WC = (_NL_CTYPE_CODESET_NAME)+25;
 _NL_CTYPE_INDIGITS9_WC = (_NL_CTYPE_CODESET_NAME)+26;
 _NL_CTYPE_OUTDIGIT0_MB = (_NL_CTYPE_CODESET_NAME)+27;
 _NL_CTYPE_OUTDIGIT1_MB = (_NL_CTYPE_CODESET_NAME)+28;
 _NL_CTYPE_OUTDIGIT2_MB = (_NL_CTYPE_CODESET_NAME)+29;
 _NL_CTYPE_OUTDIGIT3_MB = (_NL_CTYPE_CODESET_NAME)+30;
 _NL_CTYPE_OUTDIGIT4_MB = (_NL_CTYPE_CODESET_NAME)+31;
 _NL_CTYPE_OUTDIGIT5_MB = (_NL_CTYPE_CODESET_NAME)+32;
 _NL_CTYPE_OUTDIGIT6_MB = (_NL_CTYPE_CODESET_NAME)+33;
 _NL_CTYPE_OUTDIGIT7_MB = (_NL_CTYPE_CODESET_NAME)+34;
 _NL_CTYPE_OUTDIGIT8_MB = (_NL_CTYPE_CODESET_NAME)+35;
 _NL_CTYPE_OUTDIGIT9_MB = (_NL_CTYPE_CODESET_NAME)+36;
 _NL_CTYPE_OUTDIGIT0_WC = (_NL_CTYPE_CODESET_NAME)+37;
 _NL_CTYPE_OUTDIGIT1_WC = (_NL_CTYPE_CODESET_NAME)+38;
 _NL_CTYPE_OUTDIGIT2_WC = (_NL_CTYPE_CODESET_NAME)+39;
 _NL_CTYPE_OUTDIGIT3_WC = (_NL_CTYPE_CODESET_NAME)+40;
 _NL_CTYPE_OUTDIGIT4_WC = (_NL_CTYPE_CODESET_NAME)+41;
 _NL_CTYPE_OUTDIGIT5_WC = (_NL_CTYPE_CODESET_NAME)+42;
 _NL_CTYPE_OUTDIGIT6_WC = (_NL_CTYPE_CODESET_NAME)+43;
 _NL_CTYPE_OUTDIGIT7_WC = (_NL_CTYPE_CODESET_NAME)+44;
 _NL_CTYPE_OUTDIGIT8_WC = (_NL_CTYPE_CODESET_NAME)+45;
 _NL_CTYPE_OUTDIGIT9_WC = (_NL_CTYPE_CODESET_NAME)+46;
 _NL_CTYPE_TRANSLIT_TAB_SIZE = (_NL_CTYPE_CODESET_NAME)+47;
 _NL_CTYPE_TRANSLIT_FROM_IDX = (_NL_CTYPE_CODESET_NAME)+48;
 _NL_CTYPE_TRANSLIT_FROM_TBL = (_NL_CTYPE_CODESET_NAME)+49;
 _NL_CTYPE_TRANSLIT_TO_IDX = (_NL_CTYPE_CODESET_NAME)+50;
 _NL_CTYPE_TRANSLIT_TO_TBL = (_NL_CTYPE_CODESET_NAME)+51;
 _NL_CTYPE_TRANSLIT_DEFAULT_MISSING_LEN = (_NL_CTYPE_CODESET_NAME)+52;
 _NL_CTYPE_TRANSLIT_DEFAULT_MISSING = (_NL_CTYPE_CODESET_NAME)+53;
 _NL_CTYPE_TRANSLIT_IGNORE_LEN = (_NL_CTYPE_CODESET_NAME)+54;
 _NL_CTYPE_TRANSLIT_IGNORE = (_NL_CTYPE_CODESET_NAME)+55;
 _NL_CTYPE_EXTRA_MAP_1 = (_NL_CTYPE_CODESET_NAME)+56;
 _NL_CTYPE_EXTRA_MAP_2 = (_NL_CTYPE_CODESET_NAME)+57;
 _NL_CTYPE_EXTRA_MAP_3 = (_NL_CTYPE_CODESET_NAME)+58;
 _NL_CTYPE_EXTRA_MAP_4 = (_NL_CTYPE_CODESET_NAME)+59;
 _NL_CTYPE_EXTRA_MAP_5 = (_NL_CTYPE_CODESET_NAME)+60;
 _NL_CTYPE_EXTRA_MAP_6 = (_NL_CTYPE_CODESET_NAME)+61;
 _NL_CTYPE_EXTRA_MAP_7 = (_NL_CTYPE_CODESET_NAME)+62;
 _NL_CTYPE_EXTRA_MAP_8 = (_NL_CTYPE_CODESET_NAME)+63;
 _NL_CTYPE_EXTRA_MAP_9 = (_NL_CTYPE_CODESET_NAME)+64;
 _NL_CTYPE_EXTRA_MAP_10 = (_NL_CTYPE_CODESET_NAME)+65;
 _NL_CTYPE_EXTRA_MAP_11 = (_NL_CTYPE_CODESET_NAME)+66;
 _NL_CTYPE_EXTRA_MAP_12 = (_NL_CTYPE_CODESET_NAME)+67;
 _NL_CTYPE_EXTRA_MAP_13 = (_NL_CTYPE_CODESET_NAME)+68;
 _NL_CTYPE_EXTRA_MAP_14 = (_NL_CTYPE_CODESET_NAME)+69;
 _NL_NUM_LC_CTYPE = (_NL_CTYPE_CODESET_NAME)+70;
 __INT_CURR_SYMBOL = (__LC_MONETARY shl 16);
 __CURRENCY_SYMBOL = (__INT_CURR_SYMBOL)+1;
 __MON_DECIMAL_POINT = (__INT_CURR_SYMBOL)+2;
 __MON_THOUSANDS_SEP = (__INT_CURR_SYMBOL)+3;
 __MON_GROUPING = (__INT_CURR_SYMBOL)+4;
 __POSITIVE_SIGN = (__INT_CURR_SYMBOL)+5;
 __NEGATIVE_SIGN = (__INT_CURR_SYMBOL)+6;
 __INT_FRAC_DIGITS = (__INT_CURR_SYMBOL)+7;
 __FRAC_DIGITS = (__INT_CURR_SYMBOL)+8;
 __P_CS_PRECEDES = (__INT_CURR_SYMBOL)+9;
 __P_SEP_BY_SPACE = (__INT_CURR_SYMBOL)+10;
 __N_CS_PRECEDES = (__INT_CURR_SYMBOL)+11;
 __N_SEP_BY_SPACE = (__INT_CURR_SYMBOL)+12;
 __P_SIGN_POSN = (__INT_CURR_SYMBOL)+13;
 __N_SIGN_POSN = (__INT_CURR_SYMBOL)+14;
 _NL_MONETARY_CRNCYSTR = (__INT_CURR_SYMBOL)+15;
 __INT_P_CS_PRECEDES = (__INT_CURR_SYMBOL)+16;
 __INT_P_SEP_BY_SPACE = (__INT_CURR_SYMBOL)+17;
 __INT_N_CS_PRECEDES = (__INT_CURR_SYMBOL)+18;
 __INT_N_SEP_BY_SPACE = (__INT_CURR_SYMBOL)+19;
 __INT_P_SIGN_POSN = (__INT_CURR_SYMBOL)+20;
 __INT_N_SIGN_POSN = (__INT_CURR_SYMBOL)+21;
 _NL_MONETARY_DUO_INT_CURR_SYMBOL = (__INT_CURR_SYMBOL)+22;
 _NL_MONETARY_DUO_CURRENCY_SYMBOL = (__INT_CURR_SYMBOL)+23;
 _NL_MONETARY_DUO_INT_FRAC_DIGITS = (__INT_CURR_SYMBOL)+24;
 _NL_MONETARY_DUO_FRAC_DIGITS = (__INT_CURR_SYMBOL)+25;
 _NL_MONETARY_DUO_P_CS_PRECEDES = (__INT_CURR_SYMBOL)+26;
 _NL_MONETARY_DUO_P_SEP_BY_SPACE = (__INT_CURR_SYMBOL)+27;
 _NL_MONETARY_DUO_N_CS_PRECEDES = (__INT_CURR_SYMBOL)+28;
 _NL_MONETARY_DUO_N_SEP_BY_SPACE = (__INT_CURR_SYMBOL)+29;
 _NL_MONETARY_DUO_INT_P_CS_PRECEDES = (__INT_CURR_SYMBOL)+30;
 _NL_MONETARY_DUO_INT_P_SEP_BY_SPACE = (__INT_CURR_SYMBOL)+31;
 _NL_MONETARY_DUO_INT_N_CS_PRECEDES = (__INT_CURR_SYMBOL)+32;
 _NL_MONETARY_DUO_INT_N_SEP_BY_SPACE = (__INT_CURR_SYMBOL)+33;
 _NL_MONETARY_DUO_P_SIGN_POSN = (__INT_CURR_SYMBOL)+34;
 _NL_MONETARY_DUO_N_SIGN_POSN = (__INT_CURR_SYMBOL)+35;
 _NL_MONETARY_DUO_INT_P_SIGN_POSN = (__INT_CURR_SYMBOL)+36;
 _NL_MONETARY_DUO_INT_N_SIGN_POSN = (__INT_CURR_SYMBOL)+37;
 _NL_MONETARY_UNO_VALID_FROM = (__INT_CURR_SYMBOL)+38;
 _NL_MONETARY_UNO_VALID_TO = (__INT_CURR_SYMBOL)+39;
 _NL_MONETARY_DUO_VALID_FROM = (__INT_CURR_SYMBOL)+40;
 _NL_MONETARY_DUO_VALID_TO = (__INT_CURR_SYMBOL)+41;
 _NL_MONETARY_CONVERSION_RATE = (__INT_CURR_SYMBOL)+42;
 _NL_MONETARY_DECIMAL_POINT_WC = (__INT_CURR_SYMBOL)+43;
 _NL_MONETARY_THOUSANDS_SEP_WC = (__INT_CURR_SYMBOL)+44;
 _NL_MONETARY_CODESET = (__INT_CURR_SYMBOL)+45;
 _NL_NUM_LC_MONETARY = (__INT_CURR_SYMBOL)+46;
 __DECIMAL_POINT = (__LC_NUMERIC shl 16);
 RADIXCHAR = __DECIMAL_POINT;
 __THOUSANDS_SEP = (__DECIMAL_POINT)+1;
 THOUSEP = __THOUSANDS_SEP;
 __GROUPING = (__THOUSANDS_SEP)+1;
 _NL_NUMERIC_DECIMAL_POINT_WC = (__THOUSANDS_SEP)+2;
 _NL_NUMERIC_THOUSANDS_SEP_WC = (__THOUSANDS_SEP)+3;
 _NL_NUMERIC_CODESET = (__THOUSANDS_SEP)+4;
 _NL_NUM_LC_NUMERIC = (__THOUSANDS_SEP)+5;
 __YESEXPR = (__LC_MESSAGES shl 16);
 __NOEXPR = ((__LC_MESSAGES shl 16))+1;
 __YESSTR = ((__LC_MESSAGES shl 16))+2;
 __NOSTR = ((__LC_MESSAGES shl 16))+3;
 _NL_MESSAGES_CODESET = ((__LC_MESSAGES shl 16))+4;
 _NL_NUM_LC_MESSAGES = ((__LC_MESSAGES shl 16))+5;
 _NL_PAPER_HEIGHT = (__LC_PAPER shl 16);
 _NL_PAPER_WIDTH = (_NL_PAPER_HEIGHT)+1;
 _NL_PAPER_CODESET = (_NL_PAPER_HEIGHT)+2;
 _NL_NUM_LC_PAPER = (_NL_PAPER_HEIGHT)+3;
 _NL_NAME_NAME_FMT = (__LC_NAME shl 16);
 _NL_NAME_NAME_GEN = (_NL_NAME_NAME_FMT)+1;
 _NL_NAME_NAME_MR = (_NL_NAME_NAME_FMT)+2;
 _NL_NAME_NAME_MRS = (_NL_NAME_NAME_FMT)+3;
 _NL_NAME_NAME_MISS = (_NL_NAME_NAME_FMT)+4;
 _NL_NAME_NAME_MS = (_NL_NAME_NAME_FMT)+5;
 _NL_NAME_CODESET = (_NL_NAME_NAME_FMT)+6;
 _NL_NUM_LC_NAME = (_NL_NAME_NAME_FMT)+7;
 _NL_ADDRESS_POSTAL_FMT = (__LC_ADDRESS shl 16);
 _NL_ADDRESS_COUNTRY_NAME = (_NL_ADDRESS_POSTAL_FMT)+1;
 _NL_ADDRESS_COUNTRY_POST = (_NL_ADDRESS_POSTAL_FMT)+2;
 _NL_ADDRESS_COUNTRY_AB2 = (_NL_ADDRESS_POSTAL_FMT)+3;
 _NL_ADDRESS_COUNTRY_AB3 = (_NL_ADDRESS_POSTAL_FMT)+4;
 _NL_ADDRESS_COUNTRY_CAR = (_NL_ADDRESS_POSTAL_FMT)+5;
 _NL_ADDRESS_COUNTRY_NUM = (_NL_ADDRESS_POSTAL_FMT)+6;
 _NL_ADDRESS_COUNTRY_ISBN = (_NL_ADDRESS_POSTAL_FMT)+7;
 _NL_ADDRESS_LANG_NAME = (_NL_ADDRESS_POSTAL_FMT)+8;
 _NL_ADDRESS_LANG_AB = (_NL_ADDRESS_POSTAL_FMT)+9;
 _NL_ADDRESS_LANG_TERM = (_NL_ADDRESS_POSTAL_FMT)+10;
 _NL_ADDRESS_LANG_LIB = (_NL_ADDRESS_POSTAL_FMT)+11;
 _NL_ADDRESS_CODESET = (_NL_ADDRESS_POSTAL_FMT)+12;
 _NL_NUM_LC_ADDRESS = (_NL_ADDRESS_POSTAL_FMT)+13;
 _NL_TELEPHONE_TEL_INT_FMT = (__LC_TELEPHONE shl 16);
 _NL_TELEPHONE_TEL_DOM_FMT = (_NL_TELEPHONE_TEL_INT_FMT)+1;
 _NL_TELEPHONE_INT_SELECT = (_NL_TELEPHONE_TEL_INT_FMT)+2;
 _NL_TELEPHONE_INT_PREFIX = (_NL_TELEPHONE_TEL_INT_FMT)+3;
 _NL_TELEPHONE_CODESET = (_NL_TELEPHONE_TEL_INT_FMT)+4;
 _NL_NUM_LC_TELEPHONE = (_NL_TELEPHONE_TEL_INT_FMT)+5;
 _NL_MEASUREMENT_MEASUREMENT = (__LC_MEASUREMENT shl 16);
 _NL_MEASUREMENT_CODESET = (_NL_MEASUREMENT_MEASUREMENT)+1;
 _NL_NUM_LC_MEASUREMENT = (_NL_MEASUREMENT_MEASUREMENT)+2;
 _NL_IDENTIFICATION_TITLE = (__LC_IDENTIFICATION shl 16);
 _NL_IDENTIFICATION_SOURCE = (_NL_IDENTIFICATION_TITLE)+1;
 _NL_IDENTIFICATION_ADDRESS = (_NL_IDENTIFICATION_TITLE)+2;
 _NL_IDENTIFICATION_CONTACT = (_NL_IDENTIFICATION_TITLE)+3;
 _NL_IDENTIFICATION_EMAIL = (_NL_IDENTIFICATION_TITLE)+4;
 _NL_IDENTIFICATION_TEL = (_NL_IDENTIFICATION_TITLE)+5;
 _NL_IDENTIFICATION_FAX = (_NL_IDENTIFICATION_TITLE)+6;
 _NL_IDENTIFICATION_LANGUAGE = (_NL_IDENTIFICATION_TITLE)+7;
 _NL_IDENTIFICATION_TERRITORY = (_NL_IDENTIFICATION_TITLE)+8;
 _NL_IDENTIFICATION_AUDIENCE = (_NL_IDENTIFICATION_TITLE)+9;
 _NL_IDENTIFICATION_APPLICATION = (_NL_IDENTIFICATION_TITLE)+10;
 _NL_IDENTIFICATION_ABBREVIATION = (_NL_IDENTIFICATION_TITLE)+11;
 _NL_IDENTIFICATION_REVISION = (_NL_IDENTIFICATION_TITLE)+12;
 _NL_IDENTIFICATION_DATE = (_NL_IDENTIFICATION_TITLE)+13;
 _NL_IDENTIFICATION_CATEGORY = (_NL_IDENTIFICATION_TITLE)+14;
 _NL_IDENTIFICATION_CODESET = (_NL_IDENTIFICATION_TITLE)+15;
 _NL_NUM_LC_IDENTIFICATION = (_NL_IDENTIFICATION_TITLE)+16;
 _NL_NUM = (_NL_IDENTIFICATION_TITLE)+17;

const
   ERA_YEAR = __ERA_YEAR;
   INT_CURR_SYMBOL = __INT_CURR_SYMBOL;
   CURRENCY_SYMBOL = __CURRENCY_SYMBOL;
   MON_DECIMAL_POINT = __MON_DECIMAL_POINT;
   MON_THOUSANDS_SEP = __MON_THOUSANDS_SEP;
   MON_GROUPING = __MON_GROUPING;
   POSITIVE_SIGN = __POSITIVE_SIGN;
   NEGATIVE_SIGN = __NEGATIVE_SIGN;
   INT_FRAC_DIGITS = __INT_FRAC_DIGITS;
   FRAC_DIGITS = __FRAC_DIGITS;
   P_CS_PRECEDES = __P_CS_PRECEDES;
   P_SEP_BY_SPACE = __P_SEP_BY_SPACE;
   N_CS_PRECEDES = __N_CS_PRECEDES;
   N_SEP_BY_SPACE = __N_SEP_BY_SPACE;
   P_SIGN_POSN = __P_SIGN_POSN;
   N_SIGN_POSN = __N_SIGN_POSN;
   INT_P_CS_PRECEDES = __INT_P_CS_PRECEDES;
   INT_P_SEP_BY_SPACE = __INT_P_SEP_BY_SPACE;
   INT_N_CS_PRECEDES = __INT_N_CS_PRECEDES;
   INT_N_SEP_BY_SPACE = __INT_N_SEP_BY_SPACE;
   INT_P_SIGN_POSN = __INT_P_SIGN_POSN;
   INT_N_SIGN_POSN = __INT_N_SIGN_POSN;
   DECIMAL_POINT = __DECIMAL_POINT;
   THOUSANDS_SEP = __THOUSANDS_SEP;
   GROUPING = __GROUPING;
   YESSTR = __YESSTR;
   NOSTR = __NOSTR;
 
type
 Pnl_item = ^nl_item;
 nl_item = longint;

function nl_langinfo(__item: nl_item):Pchar; cdecl; external clib name 'nl_langinfo';

type
   Psched_param = ^sched_param;
   sched_param = record
     __sched_priority : longint;
   end;
   __sched_param = sched_param;
   P__sched_param = ^__sched_param;
   TSchedParam = __sched_param;
   PSchedParam = ^TSchedParam;

//pthread
type
  TStartRoutine = function (_para1:pointer): integer; cdecl;// pthread_create
  Ppthread_condattr_t = ^pthread_condattr_t;
  pthread_condattr_t = record
       __dummy : longint;
    end;
  TPthreadCondattr = pthread_condattr_t;
  PPthreadCondattr = ^TPthreadCondattr;
Const
  PTHREAD_CREATE_JOINABLE = 0;
  PTHREAD_CREATE_DETACHED = 1;

  PTHREAD_INHERIT_SCHED = 0;
  PTHREAD_EXPLICIT_SCHED = 1;

  PTHREAD_SCOPE_SYSTEM = 0;
  PTHREAD_SCOPE_PROCESS = 1;

  PTHREAD_MUTEX_TIMED_NP = 0;
  PTHREAD_MUTEX_RECURSIVE_NP = 1;
  PTHREAD_MUTEX_ERRORCHECK_NP = 2;
  PTHREAD_MUTEX_ADAPTIVE_NP = 3;
  PTHREAD_MUTEX_NORMAL = PTHREAD_MUTEX_TIMED_NP;
  PTHREAD_MUTEX_RECURSIVE = PTHREAD_MUTEX_RECURSIVE_NP;
  PTHREAD_MUTEX_ERRORCHECK = PTHREAD_MUTEX_ERRORCHECK_NP;
  PTHREAD_MUTEX_DEFAULT = PTHREAD_MUTEX_NORMAL;
  PTHREAD_MUTEX_FAST_NP = PTHREAD_MUTEX_ADAPTIVE_NP;

  PTHREAD_PROCESS_PRIVATE = 0;
  PTHREAD_PROCESS_SHARED = 1;

  PTHREAD_RWLOCK_PREFER_READER_NP = 0;
  PTHREAD_RWLOCK_PREFER_WRITER_NP = 1;
  PTHREAD_RWLOCK_PREFER_WRITER_NONRECURSIVE_NP = 2;
  PTHREAD_RWLOCK_DEFAULT_NP = PTHREAD_RWLOCK_PREFER_WRITER_NP;

  PTHREAD_ONCE_INIT = 0;
type
  P_pthread_fastlock = ^_pthread_fastlock;
  _pthread_fastlock = record
    __status : longint;
    __spinlock : longint;
  end;
  Ppthread_mutexattr_t = ^pthread_mutexattr_t;
  pthread_mutexattr_t = record
       __mutexkind : longint;
    end;

  Ppthread_t = ^pthread_t;
  pthread_t = culong;
  P_pthread_descr = ^_pthread_descr;
  _pthread_descr = pointer; // Opaque type.

  P__pthread_attr_s = ^__pthread_attr_s;
  __pthread_attr_s = record
       __detachstate : longint;
       __schedpolicy : longint;
       __schedparam : __sched_param;
       __inheritsched : longint;
       __scope : longint;
       __guardsize : size_t;
       __stackaddr_set : longint;
       __stackaddr : pointer;
       __stacksize : size_t;
    end;
  pthread_attr_t = __pthread_attr_s;
  Ppthread_attr_t = ^pthread_attr_t;

const
 __SIZEOF_SEM_T = {$ifdef CPU64}32{$else}16{$endif};
type
//semaphore
   Psem_t = ^sem_t;
   sem_t = array[0..__SIZEOF_SEM_T-1] of byte;
   {
   sem_t = record
        __sem_lock : _pthread_fastlock;
        __sem_value : longint;
        __sem_waiting : _pthread_descr;
     end;
     }
  TSemaphore = sem_t;
  PSemaphore = ^TSemaphore;

  Psigval = ^sigval;
  sigval = record
      case longint of
         0 : ( sival_int : cint );
         1 : ( sival_ptr : pointer );
      end;
  sigval_t = sigval;
  Psigval_t = ^sigval_t;

const 
 __SI_MAX_SIZE = 128;
 {$ifdef CPU64}
 __SI_PAD_SIZE = ((__SI_MAX_SIZE div sizeof (cint)) - 4);
 {$else}
 __SI_PAD_SIZE = ((__SI_MAX_SIZE div sizeof (cint)) - 3);
 {$endif}
type
 _si_pad = packed array[0..__SI_PAD_SIZE-1] of cint;

 // Borland compatibility types moved here, needed for siginfo
 _si_sigchld = record
    si_pid: __pid_t;
    si_uid: __uid_t;
    si_status: cint;
    si_utime: __clock_t;
    si_stime: __clock_t;
 end;
                       
 _si_kill =  record
   si_pid: __pid_t;
   si_uid: __uid_t;
 end;

 _si_sigfault = record
   si_addr: Pointer; 
 end;
 _si_sigpoll = record
   si_band: clong; 
   si_fd: cint;
 end;
 _si_timer = record
   _timer1: longword;
   _timer2: longword;
 end;
 _si_rt =  record
   si_pid: __pid_t;
   si_uid: __uid_t;
   si_sigval: sigval_t;
 end;
 Psiginfo = ^siginfo;
 siginfo = record
      si_signo : cint;
      si_errno : cint;
      si_code : cint;
      Case integer of 
        0: (_pad: _si_pad);
        1: (_kill: _si_kill);
        2: (_timer: _si_timer);
        3: (_rt: _si_rt);
        4: (_sigchld: _si_sigchld);
        5: (_sigfault: _si_sigfault);
        6: (_sigpoll: _si_sigpoll);
   end;
 siginfo_t = siginfo;
 Psiginfo_t = ^siginfo_t;
 Tsiginfo_t = siginfo_t;

 TSigActionHandlerEx = procedure(Signal: Integer; SignalInfo: PSigInfo;
                                 P: Pointer); cdecl;
 TRestoreHandler = procedure; cdecl;

type
   P__sig_atomic_t = ^__sig_atomic_t;
   __sig_atomic_t = longint;
Const
  _SIGSET_NWORDS = 1024 div (8 * (sizeof(dword)));
const
   SA_NOCLDSTOP = 1;
   SA_NOCLDWAIT = 2;
   SA_SIGINFO = 4;
type
   P__sigset_t = ^__sigset_t;
   __sigset_t = record
        __val : array[0..(_SIGSET_NWORDS)-1] of dword;
     end;
  sigset_t = __sigset_t;
  Psigset_t = ^sigset_t;
  TSigset = __sigset_t;
  PSigset = ^TSigset;
  
 TSigActionEx = packed record
                sa_sigaction: TSigActionHandlerEx;
                sa_mask: __sigset_t;
                sa_flags: Integer;
                sa_restorer: TRestoreHandler;
                end;
type
  __sighandler_t = procedure(SigNum: Integer); cdecl;
  TSignalHandler = __sighandler_t;
   P_sigaction = ^_sigaction;
   _sigaction = record // Renamed, avoid conflict with sigaction function
     case integer of
       1: (sa_handler : __sighandler_t;
           sa_mask : __sigset_t;
           sa_flags : longint;
           sa_restorer : procedure ;cdecl;
          );
       // Kylix compatibility
       2: (__sigaction_handler: __sighandler_t);
   end;
  TSigAction = _sigaction;
  PSigAction = ^TSigAction;
   __sigaction = _sigaction;
  TSigActionHandler = procedure(Signal: Integer); cdecl; 

const
  __S_IFMT        = $F000;
  __S_IFDIR       = $4000;
  __S_IFCHR       = $2000;
  __S_IFBLK       = $6000;
  __S_IFREG       = $8000;
  __S_IFIFO       = $1000;
  __S_IFLNK       = $A000;
  __S_IFSOCK      = $C000;

   S_IFMT   = __S_IFMT;
   S_IFDIR  = __S_IFDIR;
   S_IFCHR  = __S_IFCHR;
   S_IFBLK  = __S_IFBLK;
   S_IFREG  = __S_IFREG;
   S_IFIFO  = __S_IFIFO;
   S_IFLNK  = __S_IFLNK;
   S_IFSOCK = __S_IFSOCK;

function sigaction(__sig:longint; Const act: _sigaction; Var oldact: _sigaction):longint;cdecl;external clib name 'sigaction';
function sigaction(__sig: longint; Action: PSigAction; OldAction: PSigAction): Integer; cdecl;external clib name 'sigaction';

function m_sigprocmask(__how:longint; var SigSet : TSigSet;
            var oldset: Tsigset):longint;cdecl;external clib name 'sigprocmask';
function m_sigismember(var SigSet : TSigSet; SigNum : Longint):longint;cdecl;external clib name 'sigismember';

const
 __SIZEOF_PTHREAD_MUTEX_T = {$ifdef CPU64}40{$else}24{$endif};
type
  Ppthread_mutex_t = ^pthread_mutex_t;
  pthread_mutex_t = array[0..__SIZEOF_PTHREAD_MUTEX_T-1] of byte;
{
  pthread_mutex_t = record
       __m_reserved : longint;
       __m_count : longint;
       __m_owner : _pthread_descr;
       __m_kind : longint;
       __m_lock : _pthread_fastlock;
    end;
}
  DIR = record end;
   __dirstream = DIR;
  PDIR = ^DIR;

  TDirectoryStream = DIR;
  PDirectoryStream = ^TDirectoryStream;

   Ptimeval = ^timeval;
   timeval = record
        tv_sec : __time_t;
        tv_usec : __suseconds_t;
     end;
  TTimeVal = timeval;
  timezone = record
    tz_minuteswest: Integer;
    tz_dsttime: Integer;
  end;
  ptimezone = ^timezone;

  P__timezone_ptr_t = ^__timezone_ptr_t;
  __timezone_ptr_t = ^timezone;

function getpid:__pid_t;cdecl;external clib name 'getpid';
function sscanf(__s:Pchar; __format:Pchar; args:array of const):longint;cdecl;external clib name 'sscanf';
function sched_yield:longint;cdecl;external clib name 'sched_yield';
function usleep(__useconds:__useconds_t):longint;cdecl;external clib name 'usleep';
function __errno_location: PInteger; cdecl;external clib name '__errno_location';
function strerror_r(__errnum:longint; __buf:Pchar; __buflen:size_t):Pchar;cdecl;external clib name 'strerror_r';

//termios
const
   NCCS = 32;
type
   Pcc_t = ^cc_t;
   cc_t = char;

   Pspeed_t = ^speed_t;
   speed_t = dword;

   Ptcflag_t = ^tcflag_t;
   tcflag_t = dword;

   Ptermios = ^termios;
   termios = record
        c_iflag : tcflag_t;
        c_oflag : tcflag_t;
        c_cflag : tcflag_t;
        c_lflag : tcflag_t;
        c_line : cc_t;
        c_cc : array[0..(NCCS)-1] of cc_t;
        c_ispeed : speed_t;
        c_ospeed : speed_t;
     end;
type
  timespec = record
    tv_sec: __time_t;
    tv_nsec: clong;
  end;

  TTimeSpec = timespec;
  PTimeSpec = ^TTimeSpec;
const
 DT_UNKNOWN = 0;
 DT_FIFO = 1;
 DT_CHR = 2;
 DT_DIR = 4;
 DT_BLK = 6;
 DT_REG = 8;
 DT_LNK = 10;
 DT_SOCK = 12;
 DT_WHT = 14;
type
   Pdirent64 = ^dirent64;
   dirent64 = record
        d_ino : __ino64_t;
        d_off : __off64_t;
        d_reclen : word;
        d_type : byte;
        d_name : array[0..255] of char;
     end;
  PPDirEnt64 = ^PDirEnt64;
  
   time_t = __time_t;
   Ptime_t = ^time_t;

   Ptm = ^tm;
   tm = record
        tm_sec : longint;
        tm_min : longint;
        tm_hour : longint;
        tm_mday : longint;
        tm_mon : longint;
        tm_year : longint;
        tm_wday : longint;
        tm_yday : longint;
        tm_isdst : longint;
        case boolean of 
         false : (tm_gmtoff : longint;tm_zone : Pchar);
         true  : (__tm_gmtoff : longint;__tm_zone : Pchar);
	end;
  TMutexAttribute = pthread_mutexattr_t;
  PMutexAttribute = ^TMutexAttribute;
function pthread_mutexattr_init(var __attr: pthread_mutexattr_t):longint;cdecl; external threadslib;
function pthread_mutexattr_settype(var __attr: pthread_mutexattr_t; Kind: Integer): Integer; cdecl;external threadslib;
function pthread_mutexattr_destroy(var __attr: pthread_mutexattr_t):longint;cdecl; external threadslib;
function __mkdir(__path:Pchar; __mode:__mode_t):longint;cdecl;external clib name 'mkdir';
function fcntl(__fd:longint; __cmd:longint; args:array of const):longint;cdecl;external clib name 'fcntl';
function fcntl(__fd:longint; __cmd:longint):longint;cdecl;varargs;external clib name 'fcntl';
function open(__file:Pchar; __oflag:longint; args:array of const):longint;cdecl;external clib name 'open';
function open(__file:Pchar; __oflag:longint):longint;cdecl;varargs;external clib name 'open';
function __close(Handle: Integer): Integer; cdecl;external clib name 'close';
function fsync(__fd:longint):longint;cdecl;external clib name 'fsync';
function dup(__fd:longint):longint;cdecl;external clib name 'dup';
function dup2(__fd:longint; __fd2:longint):longint;cdecl;external clib name 'dup2';
function __read(Handle: Integer; var Buffer; Count: size_t): ssize_t; cdecl;external clib name 'read';
function __write(Handle: Integer; const Buffer; Count: size_t): ssize_t; cdecl;external clib name 'write';
function sem_init(__sem:Psem_t; __pshared:longint; __value:dword):longint;cdecl;external threadslib name 'sem_init';
function sem_init(var __sem: sem_t; __pshared:longint; __value:dword):longint;cdecl;external threadslib name 'sem_init';
function sem_destroy(var __sem: sem_t):longint;cdecl;external threadslib name 'sem_destroy';
function sem_post(var __sem: sem_t):longint;cdecl;external threadslib name 'sem_post';
function sem_wait(var __sem: sem_t):longint;cdecl;external threadslib name 'sem_wait';
function sem_trywait(var __sem: sem_t):longint;cdecl;external threadslib name 'sem_trywait';
function sem_getvalue(var __sem: sem_t; __sval:Plongint):longint;cdecl;external threadslib name 'sem_getvalue';

Const
  PTHREAD_CANCEL_ENABLE = 0;
  PTHREAD_CANCEL_DISABLE = 1;

  PTHREAD_CANCEL_DEFERRED = 0;
  PTHREAD_CANCEL_ASYNCHRONOUS = 1;

  PTHREAD_CANCELED = Pointer(-1);
  PTHREAD_BARRIER_SERIAL_THREAD = -1;

  NONRECURSIVE  = 0;
  RECURSIVE     = 1;

function pthread_setcanceltype(__type:longint;var __oldtype:longint):longint;cdecl; external threadslib;
function pthread_setcanceltype(__type:longint; __oldtype:Plongint):longint;cdecl;external threadslib name 'pthread_setcanceltype';
function pthread_setcancelstate(__state:longint; __oldstate:Plongint):longint;cdecl;external threadslib name 'pthread_setcancelstate';
function pthread_equal(__thread1:pthread_t; __thread2:pthread_t):longint;cdecl;external threadslib name 'pthread_equal';
function pthread_self:pthread_t;cdecl;external threadslib name 'pthread_self';

const
 _STAT_VER_LINUX_OLD = 1;
 _STAT_VER_KERNEL = 1;
 _STAT_VER_SVR4 = 2;
{$ifdef CPU64}
 _STAT_VER_LINUX = 1;
{$else}
 _STAT_VER_LINUX = 3;
{$endif}
 _STAT_VER = _STAT_VER_LINUX;
   
{$ifdef linux}

function __fxstat(__ver:longint; __fildes:longint; __stat_buf:Pstat):longint;
                             cdecl;external clib name '__fxstat';
function __xstat(__ver:longint; __filename:Pchar; __stat_buf:Pstat):longint;
                             cdecl;external clib name '__xstat';
function __lxstat(__ver:longint; __filename:Pchar; __stat_buf:Pstat):longint;
                             cdecl;external clib name '__lxstat';
{$ifndef CPU64}
function __fxstat64(__ver:longint; __fildes:longint; __stat_buf:Pstat64):longint;
                             cdecl;external clib name '__fxstat64';
function __xstat64(__ver:longint; __filename:Pchar; __stat_buf:Pstat64):longint;
                             cdecl;external clib name '__xstat64';
function __lxstat64(__ver:longint; __filename:Pchar; __stat_buf:Pstat64):longint;
                             cdecl;external clib name '__lxstat64';
{$endif}                                   
function stat(__file:Pchar; __buf:Pstat):longint;
function fstat(__fd:longint; __buf:Pstat):longint;

function stat64(__file:Pchar; __buf:Pstat64):longint;
function fstat64(__fd:longint; __buf:Pstat64):longint;

function lstat(__file:Pchar; __buf:Pstat):longint;
function lstat64(__file:Pchar; __buf:Pstat64):longint;
{$else}
function stat(__file:Pchar; __buf:Pstat):longint; cdecl;
                                   external clib name '__stat';
function fstat(__fd:longint; __buf:Pstat):longint; cdecl;
                                   external clib name '__fstat';

function stat64(__file:Pchar; __buf:Pstat64):longint; cdecl;
                                   external clib name '__stat64';
function fstat64(__fd:longint; __buf:Pstat64):longint; cdecl;
                                   external clib name '__fstat64';

function lstat(__file:Pchar; __buf:Pstat):longint; cdecl;
                                   external clib name '__lstat';
function lstat64(__file:Pchar; __buf:Pstat64):longint; cdecl;
                                   external clib name '__lstat';
{$endif}

function S_ISDIR(mode : __mode_t) : boolean;

function fchmod(__fd: longint; __mode:__mode_t):longint;cdecl;external clib name 'fchmod';
function __rename(__old: Pchar; __new:Pchar):longint;cdecl;external clib name 'rename';
function unlink(__name: Pchar): longint;cdecl;external clib name 'unlink';
function getcwd(__buf: Pchar; __size:size_t):Pchar;cdecl;external clib name 'getcwd';
function getenv(__name: Pchar): Pchar; cdecl; external clib name 'getenv';
function setenv(envname: pchar; envval: pchar;
                overwrite: cint): cint; cdecl; external clib name 'setenv';
function putenv(astring: Pchar): longint; cdecl; external clib name 'putenv';
function unsetenv(envname: pchar): cint; cdecl; external clib name 'unsetenv';

function __chdir(__path:Pchar):longint;cdecl;external clib name 'chdir';
function opendir(__name:Pchar):PDIR;cdecl;external clib name 'opendir';
function closedir(__dirp:PDIR):longint;cdecl;external clib name 'closedir';

type
  TUnixTime = tm;
  PUnixTime = ^TUnixTime;
  TTime_T = Time_t;
function __time(var __timer : ttime_t):time_t;cdecl;external clib name 'time';
function __time(__timer:Ptime_t):time_t;cdecl;external clib name 'time';
function timelocal(var __tp: tm):time_t;cdecl;external clib name 'timelocal';
function setlocale(__category:longint; __locale:Pchar):Pchar;cdecl;
                                               external clib name 'setlocale';
var
 clock_gettime: function(clk_id: cint; tp: ptimespec): cint; cdecl;
 
const
   CLOCK_REALTIME = 0;
   CLOCK_MONOTONIC = 1;
   CLOCK_PROCESS_CPUTIME_ID = 2;
   CLOCK_THREAD_CPUTIME_ID = 3;
   TIMER_ABSTIME = 1;

   SA_ONSTACK = $08000000;
   SA_RESTART = $10000000;
   SA_NODEFER = $40000000;
   SA_RESETHAND = $80000000;

   SA_INTERRUPT = $20000000;
   SA_NOMASK = SA_NODEFER;
   SA_ONESHOT = SA_RESETHAND;
   SA_STACK = SA_ONSTACK;

const
  SIG_ERR  = (-1);
  SIG_DFL  = (0);
  SIG_IGN  = (1);
  SIG_HOLD = (2);

   SIGHUP = 1;
   SIGINT = 2;
   SIGQUIT = 3;
   SIGILL = 4;
   SIGTRAP = 5;
   SIGABRT = 6;
   SIGIOT = 6;
   SIGBUS = 7;
   SIGFPE = 8;
   SIGKILL = 9;
   SIGUSR1 = 10;
   SIGSEGV = 11;
   SIGUSR2 = 12;
   SIGPIPE = 13;
   SIGALRM = 14;
   SIGTERM = 15;
   SIGSTKFLT = 16;
   SIGCHLD = 17;
   SIGCLD = SIGCHLD;
   SIGCONT = 18;
   SIGSTOP = 19;
   SIGTSTP = 20;
   SIGTTIN = 21;
   SIGTTOU = 22;
   SIGURG = 23;
   SIGXCPU = 24;
   SIGXFSZ = 25;
   SIGVTALRM = 26;
   SIGPROF = 27;
   SIGWINCH = 28;
   SIGIO = 29;
   SIGPOLL = SIGIO;
   SIGPWR = 30;
   SIGSYS = 31;
   SIGUNUSED = 31;
   _NSIG = 64;

type
   Psighandler_t = ^sighandler_t;
   sighandler_t = __sighandler_t;
   
  __itimer_which = (
   ITIMER_REAL := 0,
   ITIMER_VIRTUAL := 1,
   ITIMER_PROF := 2
  );

  Pitimerval = ^itimerval;
  itimerval = record
    it_interval : timeval;
    it_value : timeval;
  end;

  P__itimer_which_t = ^__itimer_which_t;
  __itimer_which_t = __itimer_which;

function setitimer(__which:__itimer_which_t; __new:Pitimerval; __old:Pitimerval):longint;cdecl;external clib name 'setitimer';
type
  wint_t = longword;
  __mbstate_t = record
    count: Integer;
    case { __value } Integer of
      0: (__wch: wint_t);
      1: (__wchb: packed array[0..4 - 1] of Char);
    end;
  mbstate_t = __mbstate_t;
 Pmbstate_t = ^mbstate_t;

function mbsnrtowcs(__dst:Pwchar_t; __src:PPchar; __nmc:size_t; __len:size_t; __ps:Pmbstate_t):size_t;cdecl;external clib name 'mbsnrtowcs';

const
   POLLIN = $001;
   POLLPRI = $002;
   POLLOUT = $004;

   POLLRDNORM = $040;
   POLLRDBAND = $080;
   POLLWRNORM = $100;
   POLLWRBAND = $200;

   POLLMSG = $400;

   POLLERR = $008;
   POLLHUP = $010;
   POLLNVAL = $020;
type
   Pnfds_t = ^nfds_t;
   nfds_t = dword;

   Ppollfd = ^pollfd;
   pollfd = record
      fd : longint;
      events : smallint;
      revents : smallint;
   end;
function poll(__fds: Ppollfd; __nfds:nfds_t; __timeout:longint):longint;cdecl;external clib name 'poll';
const
   SIG_BLOCK = 0;
   SIG_UNBLOCK = 1;
   SIG_SETMASK = 2;

function signal(__sig:longint; __handler:__sighandler_t):__sighandler_t;cdecl;external clib name 'signal';
function sigemptyset(var SigSet : TSigSet):longint;cdecl;external clib name 'sigemptyset';
function sigaddset(var SigSet : TSigSet; SigNum : Longint):longint;cdecl;external clib name 'sigaddset';
function sigismember(var SigSet : TSigSet; SigNum : Longint):longint;cdecl;external clib name 'sigismember';
function sigprocmask(__how:longint; var SigSet : TSigSet; var oldset: Tsigset):longint;cdecl;external clib name 'sigprocmask';
function pthread_sigmask(__how:longint; var __newmask:__sigset_t; var __oldmask:__sigset_t):longint;cdecl; external threadslib;

function kill(__pid:__pid_t; __sig:longint):longint;cdecl;external clib name 'kill';
function getpt:longint;cdecl;external clib name 'getpt';
function grantpt(__fd:longint):longint;cdecl;external clib name 'grantpt';
function unlockpt(__fd:longint):longint;cdecl;external clib name 'unlockpt';
function ptsname_r(__fd:longint; __buf:Pchar; __buflen:size_t):longint;cdecl;external clib name 'ptsname_r';

const
   VINTR = 0;
   VQUIT = 1;
   VERASE = 2;
   VKILL = 3;
   VEOF = 4;
   VTIME = 5;
   VMIN = 6;
   VSWTC = 7;
   VSTART = 8;
   VSTOP = 9;
   VSUSP = 10;
   VEOL = 11;
   VREPRINT = 12;
   VDISCARD = 13;
   VWERASE = 14;
   VLNEXT = 15;
   VEOL2 = 16;

  IGNBRK    = $0000001;
  BRKINT    = $0000002;
  IGNPAR    = $0000004;
  PARMRK    = $0000008;
  INPCK     = $0000010;
  ISTRIP    = $0000020;
  INLCR     = $0000040;
  IGNCR     = $0000080;
  ICRNL     = $0000100;
  IUCLC     = $0000200;
  IXON      = $0000400;
  IXANY     = $0000800;
  IXOFF     = $0001000;
  IMAXBEL   = $0002000;

  OPOST     = $0000001;
  OLCUC     = $0000002;
  ONLCR     = $0000004;
  OCRNL     = $0000008;
  ONOCR     = $0000010;
  ONLRET    = $0000020;
  OFILL     = $0000040;
  OFDEL     = $0000080;

  NLDLY     = $0000040;
  NL0       = $0000000;
  NL1       = $0000100;
  CRDLY     = $0000600;
  CR0       = $0000000;
  CR1       = $0000200;
  CR2       = $0000400;
  CR3       = $0000600;
  TABDLY    = $0001800;
  TAB0      = $0000000;
  TAB1      = $0000800;
  TAB2      = $0001000;
  TAB3      = $0001800;
  BSDLY     = $0002000;
  BS0       = $0000000;
  BS1       = $0002000;
  FFDLY     = $0080000;
  FF0       = $0000000;
  FF1       = $0010000;

  VTDLY     = $0004000;
  VT0       = $0000000;
  VT1       = $0004000;

  XTABS     = $0001800;

  CBAUD     = $000100F;
  B0        = $0000000;
  B50       = $0000001;
  B75       = $0000002;
  B110      = $0000003;
  B134      = $0000004;
  B150      = $0000005;
  B200      = $0000006;
  B300      = $0000007;
  B600      = $0000008;
  B1200     = $0000009;
  B1800     = $000000A;
  B2400     = $000000B;
  B4800     = $000000C;
  B9600     = $000000D;
  B19200    = $000000E;
  B38400    = $000000F;

  EXTA      = B19200;
  EXTB      = B38400;

  CSIZE     = $0000030;
  CS5       = $0000000;
  CS6       = $0000010;
  CS7       = $0000010;
  CS8       = $0000030;
  CSTOPB    = $0000040;
  CREAD     = $0000080;
  PARENB    = $0000100;
  PARODD    = $0000200;
  HUPCL     = $0000400;
  CLOCAL    = $0000800;

  CBAUDEX   = $0001000;

  B57600    = $0001001;
  B115200   = $0001002;
  B230400   = $0001003;
  B460800   = $0001004;
  B500000   = $0001005;
  B576000   = $0001006;
  B921600   = $0001007;
  B1000000  = $0001008;
  B1152000  = $0001009;
  B1500000  = $000100A;
  B2000000  = $000100B;
  B2500000  = $000100C;
  B3000000  = $000100D;
  B3500000  = $000100E;
  B4000000  = $000100F;

  CIBAUD    = $100F0000;
  CRTSCTS   = $80000000;

  ISIG      = $0000001;
  ICANON    = $0000002;

  XCASE     = $0000004;

  ECHO      = $0000008;
  ECHOE     = $0000010;
  ECHOK     = $0000020;
  ECHONL    = $0000040;
  NOFLSH    = $0000080;
  TOSTOP    = $0000100;

  ECHOCTL   = $0000200;
  ECHOPRT   = $0000400;
  ECHOKE    = $0000800;
  FLUSHO    = $0001000;
  PENDIN    = $0004000;

  IEXTEN    = $0010000;



  TCOOFF = 0;
  TCOON = 1;
  TCIOFF = 2;
  TCION = 3;
  TCIFLUSH = 0;
  TCOFLUSH = 1;
  TCIOFLUSH = 2;
  TCSANOW = 0;
  TCSADRAIN = 1;
  TCSAFLUSH = 2;

function SIGRTMIN : longint;cdecl; external clib name '__libc_current_sigrtmin';
function SIGRTMAX : longint;cdecl; external clib name '__libc_current_sigrtmax';
function ioctl(__fd:longint; __request:dword; args:array of const):longint;cdecl;external clib name 'ioctl';
function ioctl(__fd:longint; __request:dword; args:pointer):longint;cdecl;external clib name 'ioctl';
function cfsetispeed(var __termios_p: termios; __speed:speed_t):longint;cdecl;external clib name 'cfsetispeed';
function cfsetospeed(var __termios_p: termios; __speed:speed_t):longint;cdecl;external clib name 'cfsetospeed';
const
   TIOCM_LE = $001;
   TIOCM_DTR = $002;
   TIOCM_RTS = $004;
   TIOCM_ST = $008;
   TIOCM_SR = $010;
   TIOCM_CTS = $020;
   TIOCM_CAR = $040;
   TIOCM_RNG = $080;
   TIOCM_DSR = $100;
   TIOCM_CD = TIOCM_CAR;
   TIOCM_RI = TIOCM_RNG;
   N_TTY = 0;
   N_SLIP = 1;
   N_MOUSE = 2;
   N_PPP = 3;
   N_STRIP = 4;
   N_AX25 = 5;
   N_X25 = 6;
   N_6PACK = 7;
   N_MASC = 8;
   N_R3964 = 9;
   N_PROFIBUS_FDL = 10;
   N_IRDA = 11;
   N_SMSBLOCK = 12;
   N_HDLC = 13;
   N_SYNC_PPP = 14;
   N_HCI = 15;
   
function gettimeofday(var __tv:timeval; var _tz:timezone):longint;
                          cdecl;external clib name 'gettimeofday';
function gettimeofday(var __tv:timeval; __tz:__timezone_ptr_t):longint;
                          cdecl;external clib name 'gettimeofday';
function pthread_kill(__thread:pthread_t; __signo:longint):longint;
                          cdecl;external threadslib name 'pthread_kill';
const
   WNOHANG = 1;
   WUNTRACED = 2;
   __WALL = $40000000;
   __WCLONE = $80000000;
function waitpid(__pid:__pid_t; __stat_loc:Plongint; __options:longint):__pid_t;cdecl;external clib name 'waitpid';
function waitpid(__pid:__pid_t; var __stat_loc:longint; __options:longint):__pid_t;cdecl;external clib name 'waitpid';
function WEXITSTATUS(Status: longint): longint;
function __system(__command:Pchar):longint;cdecl;external clib name 'system';
type
  TPipeDescriptors = {packed} record
    ReadDes: Integer;
    WriteDes: Integer;
  end;
  PPipeDescriptors = ^TPipeDescriptors;

  TPipes = Array[0..1] of longint;
  PPipes = ^TPipes;
function pipe(var __pipedes: TPipes):longint;cdecl;external clib name 'pipe';
function pipe(var PipeDes: TPipeDescriptors): Integer; cdecl; external clib name 'pipe';
function vfork:__pid_t;cdecl;external clib name 'vfork';
function setsid:__pid_t;cdecl;external clib name 'setsid';
function setpgid(__pid:__pid_t; __pgid:__pid_t):longint;cdecl;external clib name 'setpgid';

const
   EXIT_FAILURE = 1;
   EXIT_SUCCESS = 0;

procedure _exit (__status : longint); cdecl; external clib name '_exit';
function execl(__path:Pchar; __arg:Pchar):longint;cdecl;varargs;external clib name 'execl';
function execl(__path:Pchar; __arg:Pchar; args:array of const):longint;cdecl;external clib name 'execl';

Type
  error_t = Integer;

function errno : error_t;
procedure free(__ptr:pointer);cdecl;external clib name 'free';

type
   Psa_family_t = ^sa_family_t;
   sa_family_t = word;
  SunB = record
    s_b1,
    s_b2,
    s_b3,
    s_b4: u_char;
  end;

  SunW = record
    s_w1,
    s_w2: u_short;
  end;
  in_addr =  record
    case Integer of
      0: (S_un_b: SunB);
      1: (S_un_w: SunW);
      2: (S_addr: u_long);
  end;
  TInAddr = in_addr;
  PInAddr = ^TInAddr;
  sockaddr = {packed} record
    case Integer of
      0: (sa_family: sa_family_t;
          sa_data: packed array[0..13] of Byte);
      1: (sin_family: sa_family_t;
          sin_port: u_short;
          sin_addr: TInAddr;
          sin_zero: packed array[0..7] of Byte);
  end;
  TSockAddr = sockaddr;
  PSockAddr = ^TSockAddr;

  sockaddr_in = sockaddr;
  Psockaddr_in = ^sockaddr;
  TSockAddrIn = sockaddr_in;
  PSockAddrIn = ^TSockAddrIn;
  Pin_port_t = ^in_port_t;
  in_port_t = uint16_t;

   Pin6_addr = ^in6_addr;
   in6_addr = record
     case longint of
      0 : ( in6_u : record
           case longint of
            0 : ( u6_addr8 : array[0..15] of uint8_t );
            1 : ( u6_addr16 : array[0..7] of uint16_t );
            2 : ( u6_addr32 : array[0..3] of uint32_t );
          end;);
    1 : (case Integer of
          0: (s6_addr: packed array [0..16-1] of __uint8_t);
          1: (s6_addr16: packed array [0..8-1] of uint16_t);
          2: (s6_addr32: packed array [0..4-1] of uint32_t);
        );
   end;


  Psockaddr_in6 = ^sockaddr_in6;
  sockaddr_in6 = record
    sin6_family: sa_family_t;
    sin6_port : in_port_t;
    sin6_flowinfo : uint32_t;
    sin6_addr : in6_addr;
    sin6_scope_id : uint32_t;
  end;
Const
  PF_UNSPEC = 0;
  PF_LOCAL = 1;
  PF_UNIX = PF_LOCAL;
  PF_FILE = PF_LOCAL;
  PF_INET = 2;
  PF_AX25 = 3;
  PF_IPX = 4;
  PF_APPLETALK = 5;
  PF_NETROM = 6;
  PF_BRIDGE = 7;
  PF_ATMPVC = 8;
  PF_X25 = 9;
  PF_INET6 = 10;
  PF_ROSE = 11;
  PF_DECnet = 12;
  PF_NETBEUI = 13;
  PF_SECURITY = 14;
  PF_KEY = 15;
  PF_NETLINK = 16;
  PF_ROUTE = PF_NETLINK;
  PF_PACKET = 17;
  PF_ASH = 18;
  PF_ECONET = 19;
  PF_ATMSVC = 20;
  PF_SNA = 22;
  PF_IRDA = 23;
  PF_PPPOX = 24;
  PF_WANPIPE = 25;
  PF_BLUETOOTH = 31;
  PF_MAX = 32;
  AF_UNSPEC = PF_UNSPEC;
  AF_LOCAL = PF_LOCAL;
  AF_UNIX = PF_UNIX;
  AF_FILE = PF_FILE;
  AF_INET = PF_INET;
  AF_AX25 = PF_AX25;
  AF_IPX = PF_IPX;
  AF_APPLETALK = PF_APPLETALK;
  AF_NETROM = PF_NETROM;
  AF_BRIDGE = PF_BRIDGE;
  AF_ATMPVC = PF_ATMPVC;
  AF_X25 = PF_X25;
  AF_INET6 = PF_INET6;
  AF_ROSE = PF_ROSE;
  AF_DECnet = PF_DECnet;
  AF_NETBEUI = PF_NETBEUI;
  AF_SECURITY = PF_SECURITY;
  AF_KEY = PF_KEY;
  AF_NETLINK = PF_NETLINK;
  AF_ROUTE = PF_ROUTE;
  AF_PACKET = PF_PACKET;
  AF_ASH = PF_ASH;
  AF_ECONET = PF_ECONET;
  AF_ATMSVC = PF_ATMSVC;
  AF_SNA = PF_SNA;
  AF_IRDA = PF_IRDA;
  AF_PPPOX = PF_PPPOX;
  AF_WANPIPE = PF_WANPIPE;
  AF_BLUETOOTH = PF_BLUETOOTH;
  AF_MAX = PF_MAX;
  SOL_RAW = 255;
  SOL_DECNET = 261;
  SOL_X25 = 262;
  SOL_PACKET = 263;
  SOL_ATM = 264;
  SOL_AAL = 265;
  SOL_IRDA = 266;
  SOMAXCONN = 128;

type
   __socket_type = (
  SOCK_STREAM := 1,
  SOCK_DGRAM := 2,
  SOCK_RAW := 3,
  SOCK_RDM := 4,
  SOCK_SEQPACKET := 5,
  SOCK_PACKET := 10
  );
  TSocket = longint;
  SOCKLEN_T = __socklen_t;
  PSOCKLEN_T = ^SOCKLEN_T;

  Paddrinfo = ^addrinfo;
  addrinfo = record
       ai_flags : longint;
       ai_family : longint;
       ai_socktype : longint;
       ai_protocol : longint;
       ai_addrlen : socklen_t;
       ai_addr : Psockaddr;
       ai_canonname : Pchar;
       ai_next : Paddrinfo;
    end;
  PPaddrinfo = ^Paddrinfo;

const
   SOL_SOCKET = 1;
   SO_DEBUG = 1;
   SO_REUSEADDR = 2;
   SO_TYPE = 3;
   SO_ERROR = 4;
   SO_DONTROUTE = 5;
   SO_BROADCAST = 6;
   SO_SNDBUF = 7;
   SO_RCVBUF = 8;
   SO_KEEPALIVE = 9;
   SO_OOBINLINE = 10;
   SO_NO_CHECK = 11;
   SO_PRIORITY = 12;
   SO_LINGER = 13;
   SO_BSDCOMPAT = 14;
   SO_PASSCRED = 16;
   SO_PEERCRED = 17;
   SO_RCVLOWAT = 18;
   SO_SNDLOWAT = 19;
   SO_RCVTIMEO = 20;
   SO_SNDTIMEO = 21;
   SO_SECURITY_AUTHENTICATION = 22;
   SO_SECURITY_ENCRYPTION_TRANSPORT = 23;
   SO_SECURITY_ENCRYPTION_NETWORK = 24;
   SO_BINDTODEVICE = 25;
   SO_ATTACH_FILTER = 26;
   SO_DETACH_FILTER = 27;
   SO_PEERNAME = 28;
   SO_TIMESTAMP = 29;
   SCM_TIMESTAMP = SO_TIMESTAMP;
   SO_ACCEPTCONN = 30;

function socket(__domain:longint; __type:longint; __protocol:longint):longint;cdecl;external clib name 'socket';
function socket(__domain: Integer; __type: __socket_type; __protocol: Integer): TSocket; cdecl;external clib name 'socket';
function shutdown(__fd:longint; __how:longint):longint;cdecl;external clib name 'shutdown';
function connect(__fd:longint; const __addr: sockaddr; __len:socklen_t):longint;cdecl;external clib name 'connect';
function connect(__fd:longint; __addr:Psockaddr; __len:socklen_t):longint;cdecl;external clib name 'connect';
function __libc_sa_len(__af: sa_family_t): Integer; cdecl;external clib name '__libc_sa_len';
function bind(__fd:longint; __addr:Psockaddr; __len:socklen_t):longint;cdecl;external clib name 'bind';
function SA_LEN(const buf): longword; // Untyped buffer; this is *unsafe*.
function listen(__fd:longint; __n:longint):longint;cdecl;external clib name 'listen';
function accept(__fd:longint; __addr:Psockaddr; __addr_len:Psocklen_t):longint;cdecl;external clib name 'accept';
function isfdtype(__fd:longint; __fdtype:longint):longint;cdecl;external clib name 'isfdtype';
function setsockopt(__fd:longint; __level:longint; __optname:longint; __optval:pointer; __optlen:socklen_t):longint;cdecl;external clib name 'setsockopt';
function getaddrinfo(__name:Pchar; __service:Pchar; __req:Paddrinfo; __pai:PPaddrinfo):longint;cdecl;external clib name 'getaddrinfo';
function htons(__hostshort:uint16_t):uint16_t;cdecl;external clib name 'htons';
procedure freeaddrinfo(__ai:Paddrinfo);cdecl;external clib name 'freeaddrinfo';
function ntohs(__netshort:uint16_t):uint16_t;cdecl;external clib name 'ntohs';

function gai_strerror(__ecode:longint):Pchar;cdecl;external clib name 'gai_strerror';

implementation
uses
 msedynload,msesys;
 
Function WEXITSTATUS(Status: longint): longint;
begin
  Result:=(Status and $FF00) shr 8;
end;

function errno : error_t;
begin
  Result:=__errno_location()^;
end;

function SA_LEN(const Buf): longword; // Untyped buffer; this is *unsafe*.

begin
  Result:=__libc_sa_len(PSockAddr(@Buf)^.sa_family);
end;

function S_ISDIR(mode: __mode_t) : boolean;
begin
 result:= mode and __S_IFDIR = __S_IFDIR;
end;

{$ifdef linux}

function stat(__file:Pchar; __buf: Pstat): longint;
begin
 __xstat(_STAT_VER,__file,__buf);
end;

function fstat(__fd:longint; __buf: Pstat): longint;
begin
 __fxstat(_STAT_VER,__fd,__buf);
end;

function lstat(__file:Pchar; __buf: Pstat): longint;
begin
 __lxstat(_STAT_VER,__file,__buf);
end;

function stat64(__file:Pchar; __buf:Pstat64):longint;
begin
{$ifdef CPU64}
 __xstat(_STAT_VER,__file,__buf);
{$else}
 __xstat64(_STAT_VER,__file,__buf);
{$endif}
end;

function fstat64(__fd:longint; __buf:Pstat64):longint;
begin
{$ifdef CPU64}
 __fxstat(_STAT_VER,__fd,__buf);
{$else}
 __fxstat64(_STAT_VER,__fd,__buf);
{$endif}
end;

function lstat64(__file:Pchar; __buf:Pstat64):longint;
begin
{$ifdef CPU64}
 __lxstat(_STAT_VER,__file,__buf);
{$else}
 __lxstat64(_STAT_VER,__file,__buf);
{$endif}
end;

{$endif} //linux

var
 rtlibinfo: dynlibinfoty;

procedure initlib;
const
 funcs: array[0..0] of funcinfoty = (
   (n: 'clock_gettime'; d: @clock_gettime) //0
   );    
begin
 try
  initializedynlib(rtlibinfo,['librt.so.1','librt.so','libc.so.6'],[],funcs);
 except
 end;
end;

initialization
 initializelibinfo(rtlibinfo);
 initlib;
finalization
 finalizelibinfo(rtlibinfo);
end.
