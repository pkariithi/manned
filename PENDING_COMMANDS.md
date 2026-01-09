# Pending Commands

This file lists Linux commands from the target list that have not yet been added to the application.

## File & Directory Operations
- `more` - Display text one screen at a time (older than less)
- `mount` - Mount a filesystem
- `umount` - Unmount filesystems
- `lsblk` - List block devices
- `blkid` - Locate/print block device attributes
- `locate` - Find files by name (fast database search)
- `updatedb` - Update locate database
- `split` - Split files into smaller pieces

## Text Processing
- `nl` - Number lines of files
- `patch` - Apply a diff file to an original
- `join` - Join lines of two files on a common field
- `paste` - Merge lines of files side by side

## Process Management
- `killall` - Kill processes by name
- `bg` - Move jobs to background
- `fg` - Move jobs to foreground
- `jobs` - Display status of jobs
- `nice` - Run a program with modified scheduling priority

## System Information
- `groups` - Print group names a user belongs to
- `vmstat` - Report virtual memory statistics
- `lscpu` - Display CPU architecture information
- `lsmem` - List memory devices and their attributes
- `lsusb` - List USB devices
- `lspci` - List PCI devices
- `lsof` - List open files and processes using them

## User & Permissions
- `chgrp` - Change group ownership
- `su` - Switch user
- `passwd` - Change user password
- `useradd` - Create a new user account
- `usermod` - Modify a user account
- `userdel` - Delete a user account
- `groupadd` - Create a new group
- `groupdel` - Delete a group
- `groupmod` - Modify a group

## Network
- `netstat` - Print network connections, routing tables, interface statistics
- `ss` - Another utility to investigate sockets (modern replacement for netstat)
- `traceroute` - Print the route packets take to network host
- `ifconfig` - Configure network interfaces (legacy, but still commonly used)
- `host` - DNS lookup utility
- `dig` - DNS lookup utility (more detailed than host)
- `nslookup` - Query Internet name servers interactively

## Package Management
- `apt-get` - APT package handling utility (command-line tool)
- `apt-cache` - Query the APT cache

## Archive & Compression
- `xz` - Compress or decompress .xz files
- `7z` - 7-Zip archive manager
- `bzip2` - Compress files using bzip2 algorithm
- `bunzip2` - Decompress bzip2 files

## Shell & Environment
- `bash` - GNU Bourne-Again SHell
- `sh` - Shell command interpreter
- `env` - Run a program in a modified environment
- `export` - Set export attribute for shell variables
- `alias` - Create an alias
- `info` - Read Info documents
- `whereis` - Locate the binary, source, and manual page files
- `time` - Run programs and summarize system resource usage
- `yes` - Output a string repeatedly until killed
- `exit` - Exit the shell

## Monitoring
- `iostat` - Report CPU and I/O statistics
- `sar` - Collect, report, or save system activity information

## Disk Management
- `fdisk` - Partition table manipulator
- `parted` - Disk partitioning and partition resizing program
- `mkfs` - Build a Linux filesystem
- `fsck` - Check and repair a Linux filesystem
- `dd` - Convert and copy files (disk operations)

## Systemd & Logs
- `systemd-analyze` - Analyze systemd boot performance
- `logrotate` - Rotate, compress, and mail system logs

## Task Scheduling
- `at` - Execute commands at a specified time
- `atq` - Display pending jobs in at queue
- `atrm` - Remove jobs from at queue

## System Utilities
- `sync` - Synchronize cached writes to persistent storage
- `passwd` - Change user password (also in User & Permissions)
- `hostname` - Show or set system hostname (also in System Information)

## Summary

**Total pending commands: 57**

### Categories:
- File & Directory Operations: 9
- Text Processing: 4
- Process Management: 5
- System Information: 8
- User & Permissions: 9
- Network: 8
- Package Management: 2 (Ubuntu-specific: apt-get, apt-cache)
- Archive & Compression: 4
- Shell & Environment: 7
- Monitoring: 2
- Disk Management: 5
- Systemd & Logs: 3
- Task Scheduling: 4
- System Utilities: 3

### Notes:
- Commands are Ubuntu-focused (distribution-specific commands for other distros removed)
- Some commands have alternatives already added (e.g., `less` vs `more`, `htop` vs `top`)
- `watch` appears twice in the original list (likely a duplicate)
- Some commands are shell built-ins (e.g., `bash`, `sh`, `export`, `alias`, `exit`)
- Some commands appear in multiple categories (e.g., `passwd`, `hostname`) - listed in most relevant category
- Commands added focus on practical, commonly-used Ubuntu operations
- Systemd commands (`journalctl`, `systemd-analyze`) are essential for modern Ubuntu systems
- Disk management commands (`fdisk`, `parted`, `mkfs`, `fsck`) are important but require caution

