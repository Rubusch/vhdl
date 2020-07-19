-- Copyright (C) 2018  Intel Corporation. All rights reserved.
-- Your use of Intel Corporation's design tools, logic functions 
-- and other software and tools, and its AMPP partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Intel Program License 
-- Subscription Agreement, the Intel Quartus Prime License Agreement,
-- the Intel FPGA IP License Agreement, or other applicable license
-- agreement, including, without limitation, that your use is for
-- the sole purpose of programming logic devices manufactured by
-- Intel and sold by Intel or its authorized distributors.  Please
-- refer to the applicable agreement for further details.

-- PROGRAM		"Quartus Prime"
-- VERSION		"Version 18.1.0 Build 625 09/12/2018 SJ Lite Edition"
-- CREATED		"Sun Jul 19 17:45:49 2020"

LIBRARY ieee;
USE ieee.std_logic_1164.all; 

LIBRARY work;

ENTITY fulladder IS 
	PORT
	(
		A :  IN  STD_LOGIC;
		B :  IN  STD_LOGIC;
		CARRY_IN :  IN  STD_LOGIC;
		SUM :  OUT  STD_LOGIC;
		CARRY_OUT :  OUT  STD_LOGIC
	);
END fulladder;

ARCHITECTURE bdf_type OF fulladder IS 

COMPONENT halfadder_ent
	PORT(A : IN STD_LOGIC;
		 B : IN STD_LOGIC;
		 SUM : OUT STD_LOGIC;
		 CARRY : OUT STD_LOGIC
	);
END COMPONENT;

SIGNAL	SYNTHESIZED_WIRE_0 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_1 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_2 :  STD_LOGIC;


BEGIN 



b2v_inst : halfadder_ent
PORT MAP(A => A,
		 B => SYNTHESIZED_WIRE_0,
		 SUM => SUM,
		 CARRY => SYNTHESIZED_WIRE_2);


b2v_inst1 : halfadder_ent
PORT MAP(A => CARRY_IN,
		 B => B,
		 SUM => SYNTHESIZED_WIRE_0,
		 CARRY => SYNTHESIZED_WIRE_1);


CARRY_OUT <= SYNTHESIZED_WIRE_1 OR SYNTHESIZED_WIRE_2;


END bdf_type;