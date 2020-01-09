//******************************************************************************
//+--------------------------------------------------------------------------+**
//|                            ****                                          |**
//|                            ****                                          |**
//|                            ******o***                                    |**
//|                      ********_///_****                                   |**
//|                      ***** /_//_/ ****                                   |**
//|                       ** ** (__/ ****                                    |**
//|                           *********                                      |**
//|                            ****                                          |**
//|                            ***                                           |**
//|                                                                          |**
//|         Copyright (c) 1998-2010 Texas Instruments Incorporated           |**
//|                        ALL RIGHTS RESERVED                               |**
//|                                                                          |**
//| Permission is hereby granted to licensees of Texas Instruments           |**
//| Incorporated (TI) products to use this computer program for the sole     |**
//| purpose of implementing a licensee product based on TI products.         |**
//| No other rights to reproduce, use, or disseminate this computer          |**
//| program, whether in part or in whole, are granted.                       |**
//|                                                                          |**
//| TI makes no representation or warranties with respect to the             |**
//| performance of this computer program, and specifically disclaims         |**
//| any responsibility for any damages, special or consequential,            |**
//| connected with the use of this program.                                  |**
//|                                                                          |**
//+--------------------------------------------------------------------------+**
//*****************************************************************************/
// file:   pinmux.p
//
// brief:  This file is responsible of PIN MUX settings via R30/R31
//         for both the PRUs
//
//
//  (C) Copyright 2017, post, Inc
//
//  author    meet
//
//  version  gp45beta
// PRU1-18\19\20\21\22\23 can in or out
// PRU0-10\11\12\13\14\15 can in or out
//2017-1-11set pru1-18--21 input &pru0 10-13 input anther 12pin for output

#ifndef __pinmux_p
#define __pinmux_p 1

#include "pinmux.hp"

// Refer to this mapping in the file - \prussdrv\include\pruss_intc_mapping.h
#define PRU0_PRU1_INTERRUPT     32
#define PRU1_PRU0_INTERRUPT     33
#define PRU0_ARM_INTERRUPT      34
#define PRU1_ARM_INTERRUPT      35
#define ARM_PRU0_INTERRUPT      36
#define ARM_PRU1_INTERRUPT      37

.origin 0
.entrypoint main

main:

    //Configure PINMUX for PRU1_R30[31]
    //PRU1_R30[31]
    M_MOV32   R0, SYS_BASE            
    LBBO    R1, R0, PINMUX10, 4 
    SBCO    R1, C3, 0, 4        // Store original setting of PINMUX10
                                // for pinmux_reset.p
	M_MOV32   R0, SYS_BASE            
    LBBO    R1, R0, PINMUX11, 4 	
    SBCO    R1, C3, 4, 4        // Store original setting of PINMUX11	
	
	M_MOV32   R0, SYS_BASE            
    LBBO    R1, R0, PINMUX12, 4 	
    SBCO    R1, C3, 8, 4        // Store original setting of PINMUX12								
								
    M_MOV32   R0, SYS_BASE            
    LBBO    R1, R0, PINMUX13, 4 	
    SBCO    R1, C3, 12, 4        // Store original setting of PINMUX13
	M_MOV32   R0, SYS_BASE            
    LBBO    R1, R0, PINMUX15, 4 	
    SBCO    R1, C3, 16, 4        // Store original setting of PINMUX15
	
    M_MOV32   R0, SYS_BASE            
    LBBO    R1, R0, PINMUX16, 4 	
    SBCO    R1, C3, 20, 4        // Store original setting of PINMUX18	
    M_MOV32   R0, SYS_BASE            
    LBBO    R1, R0, PINMUX18, 4 	
    SBCO    R1, C3, 24, 4        // Store original setting of PINMUX16	


	
    //PRU1_R30[15]--PRU1_DIO15
    M_MOV32   R0, SYS_BASE            
    LBBO    R1, R0, PINMUX12, 4 
    AND R1.b0,R1.b0,#0xF0
    OR R1.b0,R1.b0,#0x04
    SBBO    R1, R0, PINMUX12, 4   //out just can used for pluse

	//PRU1_R30[16]--PRU1_DIO16
    M_MOV32   R0, SYS_BASE            
    LBBO    R1, R0, PINMUX11, 4 
    AND R1.b3,R1.b3,#0x0F
    OR R1.b3,R1.b3,#0x40         //out
    SBBO    R1, R0, PINMUX11, 4  

    //PRU1_R30[17]--PRU1_DIO17
    M_MOV32   R0, SYS_BASE            
    LBBO    R1, R0, PINMUX11, 4 
    AND R1.b3,R1.b3,#0xF0
    OR R1.b3,R1.b3,#0x04         //out
    SBBO    R1, R0, PINMUX11, 4

	
	//PRU1_R31[18]--PRU1_DIO18  //input
    M_MOV32   R0, SYS_BASE            
    LBBO    R1, R0, PINMUX11, 4 
    AND R1.b2,R1.b2,#0x0F
    //OR R1.b1,R1.b2,#0x40
    SBBO    R1, R0, PINMUX11, 4 

    //PRU1_R31[19]--PRU1_DIO19  //input 
    M_MOV32   R0, SYS_BASE            
    LBBO    R1, R0, PINMUX11, 4 
    AND R1.b2,R1.b2,#0xF0
   // OR R1.b1,R1.b2,#0x04
    SBBO    R1, R0, PINMUX11, 4

    //PRU1_R30[20]--PRU1_DIO20
    M_MOV32   R0, SYS_BASE            
    LBBO    R1, R0, PINMUX11, 4 
    AND R1.b1,R1.b1,#0x0F
    OR R1.b1,R1.b1,#0x40       //output 
    SBBO    R1, R0, PINMUX11, 4 

    //PRU1_R30[21]--PRU1_DIO21
    M_MOV32   R0, SYS_BASE            
    LBBO    R1, R0, PINMUX11, 4 
    AND R1.b1,R1.b1,#0xF0
    OR R1.b1,R1.b1,#0x04     //output 
    SBBO    R1, R0, PINMUX11, 4

	
	//PRU1_R30[22]--PRU1_DIO22  // input
    M_MOV32   R0, SYS_BASE            
    LBBO    R1, R0, PINMUX11, 4 
    AND R1.b0,R1.b0,#0x0F
    //OR R1.b0,R1.b0,#0x40        //
    SBBO    R1, R0, PINMUX11, 4 

    //PRU1_R30[23]--PRU1_DIO23  //
    M_MOV32   R0, SYS_BASE            
    LBBO    R1, R0, PINMUX11, 4 
    AND R1.b0,R1.b0,#0xF0
    OR R1.b0,R1.b0,#0x04
    SBBO    R1, R0, PINMUX11, 4  //

    //PRU1_R30[24]--PRU1_DIO24
    M_MOV32   R0, SYS_BASE            
    LBBO    R1, R0, PINMUX10, 4 
    AND R1.b3,R1.b3,#0x0F
    OR R1.b3,R1.b3,#0x40         //out
    SBBO    R1, R0, PINMUX10, 4 

    //PRU1_R30[25]--PRU1_DIO25
    M_MOV32   R0, SYS_BASE            
    LBBO    R1, R0, PINMUX10, 4 
    AND R1.b3,R1.b3,#0xF0
    OR R1.b3,R1.b3,#0x04         //out
    SBBO    R1, R0, PINMUX10, 4

    //PRU1_R30[26]--PRU1_DIO26
    M_MOV32   R0, SYS_BASE            
    LBBO    R1, R0, PINMUX10, 4 
    AND R1.b2,R1.b2,#0x0F
    OR R1.b2,R1.b2,#0x40         //out
    SBBO    R1, R0, PINMUX10, 4 

    //PRU1_R30[27]--PRU1_DIO27
    M_MOV32   R0, SYS_BASE            
    LBBO    R1, R0, PINMUX10, 4 
    AND R1.b2,R1.b2,#0xF0
    OR R1.b2,R1.b2,#0x04        //out
    SBBO    R1, R0, PINMUX10, 4

  	//PRU1_R30[28]--PRU1_DIO28
    M_MOV32   R0, SYS_BASE            
    LBBO    R1, R0, PINMUX10, 4 
    AND R1.b1,R1.b1,#0x0F
    OR R1.b1,R1.b1,#0x40       //out
    SBBO    R1, R0, PINMUX10, 4 

    //PRU1_R30[29]--PRU1_DIO29
    M_MOV32   R0, SYS_BASE            
    LBBO    R1, R0, PINMUX10, 4 
    AND R1.b1,R1.b1,#0xF0
    OR R1.b1,R1.b1,#0x04       //out
    SBBO    R1, R0, PINMUX10, 4

    //PRU1_R30[30]--PRU1_DIO30
    M_MOV32   R0, SYS_BASE            
    LBBO    R1, R0, PINMUX10, 4 
    AND R1.b0,R1.b0,#0x0F
    OR R1.b0,R1.b0,#0x40      //out
    SBBO    R1, R0, PINMUX10, 4 
	
    //PRU1_R30[31] PRU1_DIO31							
    M_MOV32   R0, SYS_BASE            
    LBBO    R1, R0, PINMUX10, 4															
    AND R1.b0,R1.b0,#0xF0
    OR R1.b0,R1.b0,#0x04     //out 
    SBBO    R1, R0, PINMUX10, 4
//--------------------------------------------	
	
	
   //PRU0 pin config
   //PRU0_R30[31] --PRU0_DIO31   //out
   M_MOV32   R0, SYS_BASE 
   LBBO    R1, R0, PINMUX13, 4 
   AND R1.b1,R1.b1,#0xF0
   OR R1.b1,R1.b1,#0x01          //bit8--11 ==01
   SBBO    R1, R0, PINMUX13, 4 
   //PRU0_R30[30] --PRU0_DIO30   //out
   M_MOV32   R0, SYS_BASE 
   LBBO    R1, R0, PINMUX13, 4 
   AND R1.b1,R1.b1,#0x0F
   OR R1.b1,R1.b1,#0x10          //bit8--15 ==01
   SBBO    R1, R0, PINMUX13, 4 
   //PRU0_R30[29] --PRU0_DIO29  //out
   M_MOV32   R0, SYS_BASE 
   LBBO    R1, R0, PINMUX13, 4 
   AND R1.b2,R1.b2,#0xF0
   OR R1.b2,R1.b2,#0x01          //bit16--19 ==01
   SBBO    R1, R0, PINMUX13, 4 
   //PRU0_R30[28] --PRU0_DIO28  //out
   M_MOV32   R0, SYS_BASE 
   LBBO    R1, R0, PINMUX13, 4 
   AND R1.b2,R1.b2,#0x0F
   OR R1.b2,R1.b2,#0x10          //bit20--23 ==01
   SBBO    R1, R0, PINMUX13, 4 
   //PRU0_R30[27] --PRU0_DIO27   //out
   M_MOV32   R0, SYS_BASE 
   LBBO    R1, R0, PINMUX13, 4 
   AND R1.b3,R1.b3,#0xF0
   OR R1.b3,R1.b3,#0x01          //bit24--27 ==01
   SBBO    R1, R0, PINMUX13, 4 
   
   //PRU0_R30[26] --PRU0_DIO26  //out 
   M_MOV32   R0, SYS_BASE 
   LBBO    R1, R0, PINMUX13, 4 
   AND R1.b3,R1.b3,#0x0F
   OR R1.b3,R1.b3,#0x10          //bit28--31 ==01
   SBBO    R1, R0, PINMUX13, 4 
   // 2016-7-20 def PRU1_R31[17] input pin
   //PRU0_30[26] and PRU1_R31[17] at same pin
   
   
   
   //PRU0_R30[25] --PRU0_DIO25  //out 
   M_MOV32   R0, SYS_BASE 
   LBBO    R1, R0, PINMUX18, 4 
   AND R1.b1,R1.b1,#0xF0
   OR R1.b1,R1.b1,#0x01          //bit8--11 ==01
   SBBO    R1, R0, PINMUX18, 4 
   //PRU0_R30[24] --PRU0_DIO24  //out
   M_MOV32   R0, SYS_BASE 
   LBBO    R1, R0, PINMUX18, 4 
   AND R1.b1,R1.b1,#0x0F
   OR R1.b1,R1.b1,#0x10          //bit8--15 ==01
   SBBO    R1, R0, PINMUX18, 4 
   //PRU0_R30[23] --PRU0_DIO23   //out
   M_MOV32   R0, SYS_BASE 
   LBBO    R1, R0, PINMUX18, 4 
   AND R1.b2,R1.b2,#0xF0
   OR R1.b2,R1.b2,#0x01          //bit16--19 ==01
   SBBO    R1, R0, PINMUX18, 4 
   //PRU0_R30[22] --PRU0_DIO22  //out
   M_MOV32   R0, SYS_BASE 
   LBBO    R1, R0, PINMUX18, 4 
   AND R1.b2,R1.b2,#0x0F
   OR R1.b2,R1.b2,#0x10          //bit20--23 ==01
   SBBO    R1, R0, PINMUX18, 4 
   //
   //---------
   //PRU0_R30[15] --PRU0_DIO15   // out
   M_MOV32   R0, SYS_BASE 
   LBBO    R1, R0, PINMUX15, 4 
   AND R1.b1,R1.b1,#0xF0
   //OR R1.b1,R1.b1,#0x08          //bit8--11 ==08
   
   SBBO    R1, R0, PINMUX15, 4 
   //PRU0_R30[14] --PRU0_DIO14   //out
   M_MOV32   R0, SYS_BASE 
   LBBO    R1, R0, PINMUX15, 4 
   AND R1.b1,R1.b1,#0x0F
    //OR R1.b1,R1.b1,#0x80          
   
   SBBO    R1, R0, PINMUX15, 4 
   
//------------input--------   
   //PRU0_R30[13] --PRU0_DIO13    input
   M_MOV32   R0, SYS_BASE 
   LBBO    R1, R0, PINMUX15, 4 
   AND R1.b2,R1.b2,#0xF0
   //OR R1.b2,R1.b2,#0x08           
   SBBO    R1, R0, PINMUX15, 4 
   //PRU0_R30[12] --PRU0_DIO12  input
   M_MOV32   R0, SYS_BASE 
   LBBO    R1, R0, PINMUX15, 4 
   AND R1.b2,R1.b2,#0x0F
   //OR R1.b1,R1.b1,#0x80          
   SBBO    R1, R0, PINMUX15, 4  
   //PRU0_R30[11] --PRU0_DIO11   input    
   M_MOV32   R0, SYS_BASE 
   LBBO    R1, R0, PINMUX15, 4 
   AND R1.b3,R1.b3,#0xF0
   //OR R1.b3,R1.b3,#0x08          //bit8--11 ==08
   SBBO    R1, R0, PINMUX15, 4 
   //PRU0_R30[10] --PRU0_DIO10   input 
   M_MOV32   R0, SYS_BASE 
   LBBO    R1, R0, PINMUX15, 4 
   AND R1.b3,R1.b3,#0x0F
   //OR R1.b3,R1.b3,#0x80          //bit8--11 ==08
   SBBO    R1, R0, PINMUX15, 4 
   
   //PRU0_R30[9] --PRU0_DIO9   //not connect just set input
   M_MOV32   R0, SYS_BASE 
   LBBO    R1, R0, PINMUX16, 4 
   AND R1.b0,R1.b0,#0xF0
   //OR R1.b0,R1.b0,#0x08          //bit8--11 ==08
   SBBO    R1, R0, PINMUX16, 4   
	 
 test1:	 
	// Send notification to Host for program completion
    MOV R31.b0, #PRU1_ARM_INTERRUPT
    
    // Halt the processor
    HALT
    
#endif