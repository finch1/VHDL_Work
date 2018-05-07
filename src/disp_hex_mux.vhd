library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity disp_hex_mux is port( 
	clk, rst : in std_logic;
	hex3, hex2, hex1, hex0 : in std_logic_vector(3 downto 0);
	dp_in: in std_logic_vector(3 downto 0);
	an : out std_logic_vector(3 downto 0);
	sseg: out std_logic_vector(7 downto 0));
	
end disp_hex_mux;

architecture arch of disp_hex_mux is
	--each 7-seg led enabled (2^18/4) * 25 ns (40 ms)
	constant n: integer := 18;
	signal q_reg, q_next: unsigned (n-1 downto 0);
	signal sel: std_logic_vector(1 downto 0);
	signal hex: std_logic_vector(3 downto 0);
	signal dp: std_logic;
begin
	--register
	process(clk,rst)
	begin
		if rst = '1' then
			q_reg <= (others => '0');
		elsif rising_edge(clk) then
			q_reg <= q_next;
		end if;
	end process;
	
	--next state logic for the conter
	q_next <= q_reg +1;
	
	--2 MSBs of counter to control 4-to-1 muxing
	sel <= std_logic_vector(q_reg(n-1 downto n-2));
	
	process(sel)--, hex0, hex1, hex2, hex3, dp_in)
	begin
		case sel is
			when "00" =>
				an <= "1110";
				hex <= hex0;
				dp <= dp_in(0);
			when "01" =>
				an <= "1101";
				hex <= hex1;
				dp <= dp_in(1);
			when "10" =>
				an <= "1011";
				hex <= hex2;
				dp <= dp_in(2);
			when "11" =>
				an <= "0111";
				hex <= hex3;
				dp <= dp_in(3);
		end case;
	end process;
	
	-- hex to 7 segment led decoding
	with hex select
		sseg(6 downto 0) <= 
			"0000001" when "0000",
			"1001111" when "0001",
			"0010010" when "0010",
			"0000110" when "0011",
			"0000110" when "0100",
			"1001100" when "0101",
			"0100100" when "0110",
			"0100000" when "0111",
			"0001111" when "1000",
			"0000000" when "1001",
			"0000100" when "1010",
			"0001000" when "1011",			
			"1100000" when "1100",
			"0110001" when "1101",
			"0110000" when "1110",
			"0111000" when others;
	-- decimal point
	sseg(7) <= dp;
end arch;
