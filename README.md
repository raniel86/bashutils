# BashUtils
A collection of file sh to simplify various operations.

## compress.sh
Create a file .tar.gz of the item passed as the first argument of the script.

Usage:
```bash
./compress.sh FORDER_OR_FILE_TO_COMPRESS
```

Examples:
```bash
./compress.sh directory_to_compress
```
```bash
./compress.sh file_to_compress.example
```

## jar2run.sh
Create a runnable program from a .jar file.

Usage:
```bash
./jar2run.sh JAR_TO_CONVERT
```

## passwordgen.sh
Create a random string that can be used like a password; if length is omitted, the password will be of 32 characters.

Usage:
```bash
./passwordgen.sh LENGTH
```
