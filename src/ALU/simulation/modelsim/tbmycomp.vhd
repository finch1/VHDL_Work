-- ----------------------------------------------------------------
-- tbmycomp.vhd
--
-- 4/22/2016
--
-- simple compare testbench
--
-- ----------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library std;
use std.textio.all;

use work.log_pkg.all;

-- ----------------------------------------------------------------

entity tbmycomp is 
	generic(	iwidth : natural := 4);
end entity;

architecture tbmycomp_arch of tbmycomp is

	-- ------------------------------------------------------------
	-- components
	-- ------------------------------------------------------------

	component mycomp is 
		generic(	iwidth : natural);
		port( a, b : in  std_logic_vector(iwidth -1 downto 0);
				y    : out std_logic_vector(6 downto 0));
	end component;
	
	-- ------------------------------------------------------------
	-- parameters
	-- ------------------------------------------------------------
	-- time delay between value change
	constant strobe : time := 5 ns;
	
	-- ------------------------------------------------------------
	-- internal signals
	-- ------------------------------------------------------------
	
	signal a, b : std_logic_vector(iwidth -1 downto 0);
	signal y    : std_logic_vector(6 downto 0);
	signal my_expected  : std_logic_vector(6 downto 0);

begin
	-- ------------------------------------------------------------
	-- component under test
	-- ------------------------------------------------------------
	
	cut : mycomp
		generic map(iwidth => iwidth)
		port map   (a => a,
						b => b,
						y => y);
						
	-- ----------------------------------------------------------
	-- stimulus
	-- ----------------------------------------------------------
	
	process
	
		-- stimulus file details
		constant file_name 	: string := "compout.txt";	
		variable file_status	: file_open_status;
		file 	   file_handle	: text;
		variable file_line	: line;
		
		-- file read access success
		variable read_ok : boolean;
		
		-- integer value read from the line
		variable val : integer;
		
		-- expected output
		variable out_exp : std_logic_vector(6 downto 0);
		
		-- skip tabs
		variable tab : character;
	
	begin
		-- ----------------------------------------------------------
		-- testbench message
		-- ----------------------------------------------------------
		
		log_title("Comparator testbench");
		
		-- ----------------------------------------------------------
		-- default stimulus
		-- ----------------------------------------------------------
		
		a <= (others => '0');
		b <= (others => '0');
		my_expected <= (others => '0');
		
		-- put delay between stimulus
		wait for strobe;
		
		-- ----------------------------------------------------------
		-- open stimulus file
		-- ----------------------------------------------------------
		
		log("open stimulus file'" & file_name & "'");
		
		-- open the file
		file_open(file_status, file_handle, file_name, read_mode);
		assert file_status = open_ok
			report "error: failed to open the " &
				"input data file " & file_name
			severity failure;
			
		-- skip empty lines and lines that start with #
		while not endfile(file_handle) loop
			readline(file_handle, file_line);
			if ( (file_line'length = 0) or
			    ((file_line'length > 0) and
			     (file_line(file_line'left) /= '#')) ) then
				exit;
			end if;
		end loop;

		-- ----------------------------------------------------------
		-- open stimulus file
		-- ----------------------------------------------------------
		
		log("apply stimulus");
		
		-- loop through all the entries in the stimulus file
		while not endfile(file_handle) loop
			--read a line
			readline(file_handle, file_line);
			
			--parse the stimulus packet
			for i in 1 to 3 loop
				read(file_line, val, read_ok);
				assert read_ok
					report "error: number if packets read failed!"
					severity failure;
				case i is 
					when 1 =>
						a <= std_logic_vector(to_signed(val,iwidth));
					when 2 => 
						b <= std_logic_vector(to_signed(val,iwidth));
					when 3 => 
						my_expected <= std_logic_vector(to_unsigned(val,my_expected'length));
					when others => 
						assert false 
							report "error: invalid input"
							severity failure;
				end case;
			end loop;
			
			-- delay after stable result to check output. 
			wait for strobe;
			
			assert my_expected(0) = y(0)
				report "error: EQZ doesn't match!"
				severity warning;
				
			assert my_expected(1) = y(1)
				report "error: EQL doesn't match!"
				severity warning;
				
			assert my_expected(2) = y(2)
				report "error: GRT doesn't match!"
				severity warning;
				
			assert my_expected(3) = y(3)
				report "error: GRE doesn't match!"
				severity warning;
				
			assert my_expected(4) = y(4)
				report "error: LSS doesn't match!"
				severity warning;
				
			assert my_expected(5) = y(5)
				report "error: LSE doesn't match!"
				severity warning;
				
			assert my_expected(6) = y(6)
				report "error: SGN doesn't match!"
				severity warning;
				
			wait for strobe;
				
		end loop;
		
		log("all stimulus checks passed!");
		
		-- close file
		file_close(file_handle);
		
		-- ----------------------------------------------------------
		-- stimulus complete
		-- ----------------------------------------------------------
		
		log_title("simulation complete");
		
		-- ----------------------------------------------------------
		-- end simulation
		-- ----------------------------------------------------------
		
		wait;
	end process;
end architecture;