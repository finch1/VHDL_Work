library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity tbequal is
end entity;

architecture beh of tbequal is

    component equal
    generic(n : in integer := 8);
    port(
        a, b : in std_logic_vector(n-1 downto 0);
        same : out std_logic);
end component;

constant w : integer := 5; --signal width
signal a, b : std_logic_vector(w-1 downto 0);
signal y, y1, y2, y3 : std_logic;

constant period : time := 50ns;
constant strobe : time := period - 5ns;

begin
    p0 : process
    begin
        for j in 0 to 2**w-1 loop
            a <= conv_std_logic_vector(j,w);
            for k in 0 to 2**w-1 loop
                b <= conv_std_logic_vector(k,w);
					 assert false report "before up period" severity note;
                wait for period;
					 assert false report "after up period" severity note;
            end loop;
        end loop;
        wait;
    end process;

    y <= '1' when a = b else '0';
    check : process
        variable err_cnt : integer := 0;
    begin
			assert false report "before strobe" severity note;
        wait for strobe;
		  assert false report "after strobe" severity note;
        for j in 1 to 2**(w*2) loop
            if(y /= y1) or (y /= y2) or (y /= y3) then
                assert false report "not compare" severity warning;
                err_cnt := err_cnt +1;
            end if;
				assert false report "before down period" severity note;
            wait for period;
				assert false report "after down period" severity note;
        end loop;
        assert (err_cnt = 0) report "test failed" severity error;
        assert (err_cnt = 0) report "test passed" severity note;
        wait;
    end process;

    equal1 : equal
        generic map(n => w)
        port map(a => a, b => b, same => y1);
    equal2 : equal
        generic map(n => w)
        port map(a => a, b => b, same => y2);
    equal3 : equal
        generic map(n => w)
        port map(a => a, b => b, same => y3);
end beh;

configuration cfg_tbeqal of tbequal is
    for beh
		for equal1 : equal
			use entity work.equal(rtl1);
		end for;
		for equal2 : equal
			use entity work.equal(rtl2);
		end for;
		for equal3 : equal
			use entity work.equal(rtl3);            
		end for;
	end for;
end cfg_tbeqal;