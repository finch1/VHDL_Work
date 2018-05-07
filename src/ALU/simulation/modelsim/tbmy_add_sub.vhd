LIBRARY ieee  ; 
LIBRARY lpm  ; 
LIBRARY std  ; 
USE ieee.std_logic_1164.all  ; 
USE ieee.std_logic_textio.all  ; 
USE ieee.std_logic_unsigned.all  ; 
USE lpm.all  ; 
USE std.textio.all  ; 
USE work.random_generators.all  ; 
ENTITY tbmy_add_sub  IS 
END ; 
 
ARCHITECTURE tbmy_add_sub_arch OF tbmy_add_sub IS
  SIGNAL overflow   :  STD_LOGIC  ; 
  SIGNAL datab   :  std_logic_vector (7 downto 0)  ; 
  SIGNAL cin   :  STD_LOGIC  ; 
  SIGNAL add_sub   :  STD_LOGIC  ; 
  SIGNAL result   :  std_logic_vector (7 downto 0)  ; 
  SIGNAL cout   :  STD_LOGIC  ; 
  SIGNAL dataa   :  std_logic_vector (7 downto 0)  ; 
  COMPONENT MY_ADD_SUB  
    PORT ( 
      overflow  : out STD_LOGIC ; 
      datab  : in std_logic_vector (7 downto 0) := (others => '0') ; 
      cin  : in STD_LOGIC := '0'; 
      add_sub  : in STD_LOGIC := '0'; 
      result  : out std_logic_vector (7 downto 0) ; 
      cout  : out STD_LOGIC ; 
      dataa  : in std_logic_vector (7 downto 0) := (others => '0')  ); 
  END COMPONENT ; 
BEGIN
  DUT  : MY_ADD_SUB  
    PORT MAP ( 
      overflow   => overflow  ,
      datab   => datab  ,
      cin   => cin  ,
      add_sub   => add_sub  ,
      result   => result  ,
      cout   => cout  ,
      dataa   => dataa   ) ; 



-- "Random Pattern"(Normal) : seed = 5
-- Start Time = 0 ns, End Time = 1 us, Period = 50 ns
  Process
	variable max_rand : real := 1.0;
	variable iv : genstatus1;
	variable iy : genstatus2;
	variable rndval : real;
	variable mean : real := 0.0;
	variable seed : integer := 5 ;
	Begin
	iv(NTAB) := 0;
	iv(NTAB+1) := 0;
	for Z in 1 to 100
	loop
	   dist_normal (seed, rndval, mean, max_rand, iv, iy);
	   if (ieee.std_logic_arith.conv_std_logic_vector(integer(myceil(rndval, 1)), 1) /= "1") then
		    add_sub  <= '0'  ;
	   else
		    add_sub  <= '1'  ;
	   end if;
	   wait for 50 ns ;
-- 1 us, repeat pattern in loop.
	end  loop;
	wait;
 End Process;


-- "Constant Pattern"
-- Start Time = 0 ns, End Time = 1 us, Period = 0 ns
  Process
	Begin
	 cin  <= '0'  ;
	wait for 1 us ;
-- dumped values till 1 us
	wait;
 End Process;


-- "Random Pattern"(Normal) : seed = 81
-- Start Time = 0 ns, End Time = 1 us, Period = 50 ns
  Process
	variable max_rand : real := pow(2.0, real(dataa'length))-1.0;
	variable iv : genstatus1;
	variable iy : genstatus2;
	variable rndval : real;
	variable mean : real := 0.0;
	variable seed : integer := 81 ;
	Begin
	iv(NTAB) := 0;
	iv(NTAB+1) := 0;
	for Z in 1 to 100
	loop
	   dist_normal (seed, rndval, mean, max_rand, iv, iy);
	    dataa  <= ieee.std_logic_arith.conv_std_logic_vector(integer(myceil(rndval, dataa'length)), dataa'length)  ;
	   wait for 50 ns ;
-- 1 us, repeat pattern in loop.
	end  loop;
	wait;
 End Process;


-- "Random Pattern"(Normal) : seed = 64
-- Start Time = 0 ns, End Time = 1 us, Period = 50 ns
  Process
	variable max_rand : real := pow(2.0, real(datab'length))-1.0;
	variable iv : genstatus1;
	variable iy : genstatus2;
	variable rndval : real;
	variable mean : real := 0.0;
	variable seed : integer := 64 ;
	Begin
	iv(NTAB) := 0;
	iv(NTAB+1) := 0;
	for Z in 1 to 100
	loop
	   dist_normal (seed, rndval, mean, max_rand, iv, iy);
	    datab  <= ieee.std_logic_arith.conv_std_logic_vector(integer(myceil(rndval, datab'length)), datab'length)  ;
	   wait for 50 ns ;
-- 1 us, repeat pattern in loop.
	end  loop;
	wait;
 End Process;
END;
