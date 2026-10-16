 LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

USE IEEE.numeric_std.all;

entity op_module_idct8 is

	port (	
		--ENTRADAS	
		TAM: in std_logic_vector(1 downto 0):="00";
		IN0_ARCH, IN1_ARCH, IN2_ARCH, IN3_ARCH, IN4_ARCH, IN5_ARCH, IN6_ARCH, IN7_ARCH: in std_logic_vector(15 downto 0):="0000000000000000";
		--SAIDA
		DST0, DST1, DST2, DST3, DST4, DST5, DST6, DST7: out std_logic_vector(14 downto 0)
		);
end op_module_idct8;
 
architecture behavior of op_module_idct8 is 

	component dct16 is
		port (
			a1,	a2,	a3,	a4,	a5,	a6,	a7,	a8: in SIGNED(15 downto 0);
			saida1,	saida2,	saida3,	saida4,	saida5,	saida6,	saida7,	saida8: out SIGNED(21 downto 0)
		);
	end component;
	
	component dct8 is
		port (
			a1, a2, a3, a4: in SIGNED(15 downto 0);
			saida1, saida2, saida3, saida4: out SIGNED(21 downto 0)
		);
	end component;
	
	component dct4 is
		port (
			a1, a2: in SIGNED(15 downto 0);
			saida1, saida2: out SIGNED(21 downto 0)
		);
	end component;

	
	signal O0, O1, O2, O3, O4, O5, O6, O7: SIGNED (21 downto 0);
	signal O8, O9, O10, O11, O12, O13, O14, O15: SIGNED (21 downto 0);
	signal EO0, EO1, EO2, EO3: SIGNED (21 downto 0);
	signal EO4, EO5, EO6, EO7: SIGNED (21 downto 0);
	signal EEO0, EEO1: SIGNED (21 downto 0);
	signal EEO2, EEO3: SIGNED (21 downto 0);
	signal EEEO0: SIGNED (21 downto 0);
	signal EEEO1: SIGNED (21 downto 0);
	signal EEEE0, EEEE1: SIGNED (21 downto 0);
	signal EEE0, EEE3: SIGNED (21 downto 0);
	signal EEE1, EEE2: SIGNED (21 downto 0);
	signal EE0, EE1: SIGNED (21 downto 0);
	signal EE2, EE3, EE4, EE5: SIGNED (21 downto 0);
	signal EE6, EE7: SIGNED (21 downto 0);
	signal E0, E1, E2, E3, E12, E13, E14, E15: SIGNED (21 downto 0);
	signal E4, E5, E6, E7, E8, E9, E10, E11 : SIGNED (21 downto 0);
	signal soma0, 	soma1, 	soma2, 	soma3, 	soma4, 	soma5, 	soma6, 	soma7: SIGNED (21 downto 0);
	signal soma8, 	soma9, 	soma10,	soma11,	soma12,	soma13,	soma14,	soma15: SIGNED (21 downto 0);
	signal soma16,	soma17,	soma18,	soma19,	soma20,	soma21,	soma22,	soma23: SIGNED (21 downto 0);
	signal soma24,	soma25,	soma26,	soma27,	soma28,	soma29,	soma30,	soma31: SIGNED (21 downto 0);
	signal 	f0, f1, f2, f3, f4, f5, f6, f7, f8, f9, f10, f11, f12, f13, f14, f15,
				f16, f17, f18, f19, f20, f21, f22, f23, f24, f25, f26, f27, f28, f29, f30, f31: SIGNED (21 downto 0);
	signal g0, g2, g4, g6, g8, g10, g12, g14, g16, g18, g20, g22, g24, g26, g28, g30: SIGNED (21 downto 0);
	
	signal IN0, IN2, IN4, IN6, IN8, IN10, IN12, IN14, IN16, IN18, IN20, IN22, IN24, IN26, IN28, IN30: SIGNED(15 downto 0);	

	
	
	
	
	begin
		IN0 <=  Signed(IN0_ARCH);
		IN4 <=  Signed(IN1_ARCH);
		IN8 <=  Signed(IN2_ARCH);
		IN12 <= Signed(IN3_ARCH);
		IN16 <= Signed(IN4_ARCH);
		IN20 <= Signed(IN5_ARCH);
		IN24 <= Signed(IN6_ARCH);
		IN28 <= Signed(IN7_ARCH);	
	
	EEO: dct8
		port map(	a1 => IN4, 
					a2 => IN12, 
					a3 => IN20, 
					a4 => IN28,
					saida1 => EEO0, 
					saida2 => EEO1, 
					saida3 => EEO2, 
					saida4 => EEO3);
	
	--IDCT16 -> EEO ; IDCT8 -> EO ; IDCT4 -> O
	EEEO: dct4
		port map(	a1 => IN8,
					a2 => IN24,
					saida1 => EEEO0,
					saida2 => EEEO1);

	--IDCT16 -> EEE ; IDCT8 -> EE ; IDCT4 -> E
	EEEE0 <= ((IN0 & "000000")+(IN16 & "000000"));
	EEEE1 <= ((IN0 & "000000")-(IN16 & "000000"));
    --
	----saidas: 4,8,16,32
	EEE0 <= EEEE0 + EEEO0;
	EEE1 <= EEEE1 + EEEO1;
	EEE2 <= EEEE1 - EEEO1;
	EEE3 <= EEEE0 - EEEO0;
    --
	----saidas: 8,16,32
	EE0 <= EEE0 + EEO0;
	EE1 <= EEE1 + EEO1;
	EE2 <= EEE2 + EEO2;
	EE3 <= EEE3 + EEO3;
	EE4 <= EEE3 - EEO3;
	EE5 <= EEE2 - EEO2;
	EE6 <= EEE1 - EEO1;
	EE7 <= EEE0 - EEO0;

		

	with TAM select
		g0 <= 	EEE0 when "00", -- 4
				EE0 when others; -- 8
								
		--g2 <= E1;		
		g4 <= EE1;
		--g6 <= E3;
					
	with TAM select
		g8 <= 	EEE1 when "00", -- 4
				EE2 when OTHERS; -- 8
						
		--g10 <= E5;						
		g12 <= EE3; -- 8
		--g14 <= E7;
						
	with TAM select
		g16 <= 	EEE2 when "00", -- 4
				EE4 when others; -- 8
						
		--g18 <= E9;				
		g20 <= EE5;
		--g22 <= E11;
					
	with TAM select
		g24 <= EEE3 when "00", -- 4
				EE6 when others; -- 8;
					
		--g26 <= E13;
		g28 <= EE7;
		--g30 <= E15;
				
	soma0  <= (g0 	+ "0000000000000001000000");			
	soma4  <= (g4 	+ "0000000000000001000000");			
	soma8  <= (g8 	+ "0000000000000001000000");			
	soma12 <= (g12 	+ "0000000000000001000000");		
	soma16 <= (g16 	+ "0000000000000001000000");		
	soma20 <= (g20	+ "0000000000000001000000");			
	soma24 <= (g24	+ "0000000000000001000000");			
	soma28 <= (g28	+ "0000000000000001000000");		
		           
	DST0  <= std_logic_vector(soma0 (21 downto 7));		
	DST1  <= std_logic_vector(soma4 (21 downto 7));		
	DST2  <= std_logic_vector(soma8 (21 downto 7));		
	DST3  <= std_logic_vector(soma12 (21 downto 7));		
	DST4  <= std_logic_vector(soma16 (21 downto 7));		
	DST5  <= std_logic_vector(soma20 (21 downto 7));		
	DST6  <= std_logic_vector(soma24 (21 downto 7));		
	DST7  <= std_logic_vector(soma28 (21 downto 7));				
	
end behavior;	
