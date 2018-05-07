library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity add_w_carry is port(
	a, b : in std_logic_vector(3 downto 0);
	sum : out std_logic_vector(3 downto 0);
	cout : out std_logic
	);
end add_w_carry;

architecture const_arch of add_w_carry is
constant N : integer := 4;
signal a_ext, b_ext, sum_ext : unsigned(N downto 0);

begin
	a_ext <= unsigned ('0' & a);
	b_ext <= unsigned ('0' & b);
	sum_ext <= a_ext + b_ext;
	sum <= std_logic_vector(sum_ext(N - 1 downto 0));
	cout <= sum_ext(N);
end const_arch;
	