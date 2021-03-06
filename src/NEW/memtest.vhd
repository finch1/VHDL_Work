-- Copyright (C) 1991-2013 Altera Corporation
-- Your use of Altera Corporation's design tools, logic functions 
-- and other software and tools, and its AMPP partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Altera Program License 
-- Subscription Agreement, Altera MegaCore Function License 
-- Agreement, or other applicable license agreement, including, 
-- without limitation, that your use is for the sole purpose of 
-- programming logic devices manufactured by Altera and sold by 
-- Altera or its authorized distributors.  Please refer to the 
-- applicable agreement for further details.

-- PROGRAM		"Quartus II 32-bit"
-- VERSION		"Version 13.1.0 Build 162 10/23/2013 SJ Web Edition"
-- CREATED		"Sat Feb 11 21:53:12 2017"

LIBRARY ieee;
USE ieee.std_logic_1164.all; 

LIBRARY work;

ENTITY memtest_pm IS 
	PORT
	(
		clk :  IN  STD_LOGIC;
		rst :  IN  STD_LOGIC;
		wren :  IN  STD_LOGIC;
		data :  IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
		q :  OUT  STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
END memtest_pm;

ARCHITECTURE bdf_type OF memtest_pm IS 

COMPONENT ram
	PORT(wren : IN STD_LOGIC;
		 clock : IN STD_LOGIC;
		 address : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
		 data : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 q : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
END COMPONENT;

COMPONENT pc
GENERIC (n : INTEGER
			);
	PORT(clk : IN STD_LOGIC;
		 rst : IN STD_LOGIC;
		 pc_out : OUT STD_LOGIC_VECTOR(4 DOWNTO 0)
	);
END COMPONENT;

SIGNAL	SYNTHESIZED_WIRE_0 :  STD_LOGIC_VECTOR(4 DOWNTO 0);


BEGIN 



b2v_inst : ram
PORT MAP(wren => wren,
		 clock => clk,
		 address => SYNTHESIZED_WIRE_0,
		 data => data,
		 q => q);


b2v_inst1 : pc
GENERIC MAP(n => 4
			)
PORT MAP(clk => clk,
		 rst => rst,
		 pc_out => SYNTHESIZED_WIRE_0);


END bdf_type;