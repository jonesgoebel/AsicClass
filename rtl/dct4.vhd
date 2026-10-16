 LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

USE IEEE.numeric_std.all;


entity dct4 is
	port (
		a1, a2: in SIGNED(15 downto 0);
		saida1, saida2: out SIGNED(21 downto 0)
	);
end dct4;

architecture arc_dct4 of dct4 is
	signal b1, b2: SIGNED(15 downto 0);
begin
	b1 <= a1 + a2;
	b2 <= a1 - a2;
	saida1 <= (b1 & "000000")  + (b2 & "00000")  - (a1 & "0000")  + (b1 & "00")  -  a1 ;
	saida2 <= (b2 & "000000")  - (b1 & "00000")  + (a2 & "0000")  + (b2 & "00")  +  a2 ;
			--20         19         17         16         13                       

end arc_dct4;
