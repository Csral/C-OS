# Kernels

## Types of kernels

### Functions of Kernel

1) Process Management

Kernel must manage any process and execution that takes place in OS.

This includes but is not restricted to:
* Scheduling and executing processes
* Context switching between and for processes (Privileged access)
* Process creations
* Process termination

2) Memory Management

If any process requests for memory then the kernel should handle it.

This includes but is not restricted to:
* Allocating and deallocating memory
* Claiming back unused memory
* Managing virtual and real memory
* Protecting memory
* Sharing memory

3) Device Management

All hardware devices including IO devices interact with kernel and software programs receive or request information about hardware devices using kernel.

This includes but is not restricted to:
* Managing IO devices
* Detecting connected and new devices
* Providing an interface for hardware devices
* Handling device drivers

4) File System Management

Kernel is responsible for handling files and folders (directories) such as opening files, mounting directories etc.

This includes but is not restricted to:
* Managing file operations
* Handling storage
* Handling mountings, binds and unmounting

5) Resources Management

Kernel is responsible for providing the hardware resources to applications running in user space.

This includes but is not restricted to:
* Managing the system resources such as CPU, GPU, disk space, RAM etc
* Allocating the required resources and reclaiming them when deallocating
* Monitoring the resources used
* Handling excessive resource requests

6) Security and Access Control

This includes but is not restricted to:
* Enforcing access control policies
* Managing user permissions
* Ensuring system security and integrity

7) Inter-Process Communication

* Ensuring features that help in communicating between processes
* Kernel have process table which keeps track of processes