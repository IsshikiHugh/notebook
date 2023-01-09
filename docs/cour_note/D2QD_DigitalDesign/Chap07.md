# Chap 7 Memory Basics

!!! summary "框架"
    - Two types: RAM & ROM
        - RAM ship consists of an array of RAM cells, decoders, write circuits, read circuits, output circuits
        - RAM bit slice
        - DRAM
        - Error-detection and correction codes, often based on Hamming codes
    - R&W operations have specific steps and associated timing parameters: access time & write cycle time
    - static(SRAM) or dynamic(DRAM), volatile or nonvolatile

## 7-1 Memory

> Two types of memories are used in various parts of a computer: random-access memory (RAM) and read-only memory (ROM). RAM accepts new information for storage to be available later for use. The process of storing new information in memory is referred to as a memory write operation. The process of transferring the stored information out of memory is referred to as a memory read operation. RAM can perform both the write and the read operations, whereas ROM, as introduced in Section 6-8, performs only read operations. RAM sizes may range from hundreds to billions of bits.

> Memory is a collection of binary storage cells together with associated circuits needed to transfer information into and out of the cells.

## 7-2 RAM

> Memory cells can be accessed to transfer information to or from any desired location, with the access taking the same time regardless of the location, hence the name random-access memory. In contrast,serial memory, such as is exhibited by a hard drive, takes different lengths of time to access information, depending on where the desired location is relative to the current physical position of the disk.

`word`: 

> A word is an entity of bits that moves in and out of memory as a unit—a group of 1s and 0s that represents a number, an instruction, one or more alphanumeric characters, or other binary-coded information.

> A group of eight bits is called a byte. 

> Most computer memories use words that are multiples of eight bits in length. Thus, a 16-bit word contains two bytes, and a 32-bit word is made up of four bytes. **The capacity of a memory** unit is usually stated as the total number of bytes that it can store.

>  Communication between a memory and its environment is achieved through **data input and output lines, address selection lines, and control lines** that specify the direction of transfer of information.

> Computer memory varies greatly in size. It is customary to refer to the number of words (or bytes) in memory with one of the letters K (kilo), M (mega), or G (giga). K is equal to 2^10, M to 2^20, and G to 2^30.

>  A word in memory is selected by its binary address. When a word is read or written, the memory operates on all 16 bits as a single unit.

> The 1K * 16 memory of the figure has 10 bits in the address and 16 bits in each word. The number of address bits needed in memory is dependent on the total number of words that can be stored and is independent of the number of bits in each word. The number of bits in the address for a word is determined from the relationship 2^k >= m, where m is the total number of words and k is the minimum number of address bits satisfying the relationship.

> The two operations that a random-access memory can perform are write and read. A write is a transfer into memory of a new word to be stored. A read is a transfer of a copy of a stored word out of memory.

> The steps that must be taken for a write are as follows:
> 
> 1. Apply the binary address of the desired word to the address lines.
> 2. Apply the data bits that must be stored in memory to the data input lines.
> 3. Activate the Write input.
> 
> The memory unit will then take the bits from the data input lines and store them in the word specified by the address lines.The steps that must be taken for a read are as follows:
> 
> 1. Apply the binary address of the desired word to the address lines.
> 2. Activate the Read input.
> 
> The memory will then take the bits from the word that has been selected by the address and apply them to the data output lines. The contents of the selected word are not changed by reading them.

...


> To avoid destroying data in other memory words, it is important that this change occur after the signals on the address lines have become fixed at the desired values. 








