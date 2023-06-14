# System Calls
## Executing syscalls
In order to call syscalls you must move the syscall number into the %RAX register as well as the arguments in the subsequent registers.  
**ARG0** - %RDI  
**ARG1** - %RSI  
**ARG2** - %RDX  
**ARG3** - %R10  
**ARG4** - %R8  
**ARG5** = %R9  
*Note: Subsequent arguments are passed through the stack (Top of stack to Bottom).  
        This does not remove the arguments from the stack.*  
\\
The `syscall` function can then be executed to run the system call.  
\\
A more detailed list with each syscall, their arguments, and links to their documention can be found [here](https://chromium.googlesource.com/chromiumos/docs/+/HEAD/constants/syscalls.md).

## Hello World

## User Input

## File Handeling
### Constants
There are quite a few constants that are used which are only defined by the C/C++ source code and so we must define at the begining of our program as well to use.

#### File Status Flags
##### Access Modes
**O_RDONLY** = 00  
*Open file with read only permissions.*  

**O_WRONLY** = 01  
*Open file with write only permissions.*  

**O_RDWR** = 02  
*Open file with read and write permissions..*  

**O_ACCMODE** = 0003  
*O_ACCMODE is can be used as a mask to get the original Access mode from the file status when bitwise-ANDed with the file status flag. It itself is not an access mode that can be used.*

##### I/O Modes
**O_APPEND** = 0200  
*Set append mode.*  
**O_DSYNC** = 010000  
*Write according to synchronized I/O data integrity completion.*  
**O_NONBLOCK** = 04000  
*Non-blocking mode.*  
**O_SYNC** = 04010000  
*Write according to synchronized I/O file integrity completion.*  
**O_RSYNC** = 04010000  
*Synchronized read I/O operations.*  
*For now, Linux has no separate synchronicity options for read
operations.  We define O_RSYNC therefore as the same as O_SYNC
since this is a superset.*

#### File Creation Flags
**O_CREAT** = 0100  
*Create file if it does not exist.*  
**O_EXCL** = 0200  
*Exclusive use flag.*  
**O_NOCTTY** = 0400  
*Do not assign controlling terminal.*  
**O_TRUNC** = 01000  
*Truncate flag.*  
