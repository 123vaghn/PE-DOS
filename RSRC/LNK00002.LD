

/*!

Copyright (C) 2020 Joseph Combs - All Rights Reserved

Linker file for dosbios.sys

!*/




OUTPUT		(DOSBIOS.SYS)
OUTPUT_FORMAT	(binary)
ENTRY		(DosMain)

SECTIONS
{
	/*!
	SYSTEM DATA BEGINS HERE
	
	!*/
	.DATA : /* SYSTEM DATA BEGINS AFTER BIOS DATA */
	{
	_DATA_BEGIN = .;
		*(.DATA.IO)	/* I/O SYSTEM DATA	*/
		*(.DATA.SYSTEM)	/* BASE SYSTEM DATA	*/
		*(.DATA)	/* EVERYTHING ELSE	*/
	_DATA_END = .;
	}
	
	/*!
	SYSTEM CODE BEGINS HERE
	
	!*/
	.TEXT : AT (ALIGN(LOADADDR(.DATA) + SIZEOF(.DATA), 16))
	{
	_CODE_BEGIN = .;
		*(.CODE.IO)	/* I/O SYSTEM CODE	*/
		*(.CODE.SYSTEM)	/* BASE SYSTEM CODE	*/
		*(.CODE)	/* EVERYTHING ELSE	*/
	_CODE_END = .;
	}
	
	/*!
	INIT DATA+CODE BEGINS HERE
	
	!*/
	.INIT : AT (ALIGN(LOADADDR(.TEXT) + SIZEOF(.TEXT), 16))
	{
	_INIT_BEGIN = .;
		*(.INIT)
	_INIT_END = .;
	}
	
	/*!
	EXCLUDE
	
	!*/
	/DISCARD/ : { *(.*) }
}

/*!
END OF FILE
!*/

