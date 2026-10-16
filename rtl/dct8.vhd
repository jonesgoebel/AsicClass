 LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

USE IEEE.numeric_std.all;

entity dct8 is
	port (
		a1, a2, a3, a4: in SIGNED(15 downto 0);
		saida1, saida2, saida3, saida4: out SIGNED(21 downto 0)
	);
end dct8;

architecture arc_dct8 of dct8 is
	signal b1, b2, b3, b4, b5, b6, b7, b8: SIGNED(15 downto 0);
begin
	b1 <= a1 + a2;
	b2 <= a1 + a3;
	b3 <= a3 + a4;
	b4 <= a1 - a2;
	b5 <= a1 - a3;
	b6 <= a2 + a4;
	b7 <= a2 - a4;
	b8 <= a3 - a4;
	saida1 <= 	 (b1 & "000000")  + (b2 & "00000")  + (b3 & "0000")  - (b4 & "000")  + (a2 & "00")  + (b3 & "0")  +  b4 ;
	saida2 <= 	 (b5 & "000000")  - (b3 & "00000")  - (b6 & "0000")  + (b2 & "000")  + (a1 & "00")  - (b6 & "0")  -  b2 ;
	saida3 <=  - (b7 & "000000")  + (b4 & "00000")  + (b2 & "0000")  + (b6 & "000")  + (a4 & "00")  + (b2 & "0")  -  b6 ;
	saida4 <= 	 (b8 & "000000")  - (b6 & "00000")  + (b4 & "0000")  + (b3 & "000")  + (a3 & "00")  + (b4 & "0")  -  b3 ;
			                                                   

end arc_dct8;
