
LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;                                
USE std.textio.ALL;


ENTITY IDCT_tb IS
END IDCT_tb;
ARCHITECTURE idct_paralela_arch OF IDCT_tb IS
-- constants                                                 
-- signals                                                   
SIGNAL clk : STD_LOGIC:='0';
SIGNAL CONTROL_WORD : STD_LOGIC_VECTOR(1 DOWNTO 0):="00";
SIGNAL USO : STD_LOGIC:='0';
SIGNAL IN0 : STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL IN1 : STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL IN2 : STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL IN3 : STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL IN4 : STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL IN5 : STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL IN6 : STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL IN7 : STD_LOGIC_VECTOR(15 DOWNTO 0);

SIGNAL OUT0 : STD_LOGIC_VECTOR(14 DOWNTO 0);
SIGNAL OUT1 : STD_LOGIC_VECTOR(14 DOWNTO 0);
SIGNAL OUT2 : STD_LOGIC_VECTOR(14 DOWNTO 0);
SIGNAL OUT3 : STD_LOGIC_VECTOR(14 DOWNTO 0);
SIGNAL OUT4 : STD_LOGIC_VECTOR(14 DOWNTO 0);
SIGNAL OUT5 : STD_LOGIC_VECTOR(14 DOWNTO 0);
SIGNAL OUT6 : STD_LOGIC_VECTOR(14 DOWNTO 0);
SIGNAL OUT7 : STD_LOGIC_VECTOR(14 DOWNTO 0);


signal delay_start : std_logic:='0';

function str_to_stdvec(inp: string) return std_logic_vector is
	variable temp: std_logic_vector(inp'range);
	begin
		for i in inp'range loop
			if (inp(i) = '1') then
				temp(i) := '1';
			elsif (inp(i) = '0') then
				temp(i) := '0';
			end if;
		end loop;
		return temp;
	end function str_to_stdvec;

	function stdvec_to_str(inp: std_logic_vector) return string is
		variable temp: string(inp'left+1 downto 1);
	begin
		for i in inp'reverse_range loop
			if (inp(i) = '1') then
				temp(i+1) := '1';
			elsif (inp(i) = '0') then
				temp(i+1) := '0';
			end if;
		end loop;
		return temp;
	end function stdvec_to_str;


BEGIN
	arch : entity work.idct8_multi PORT MAP (
	clk,CONTROL_WORD,USO,IN0,IN1,IN2,IN3,IN4,IN5,IN6,IN7,OUT0,OUT1,OUT2,OUT3,OUT4,OUT5,OUT6,OUT7
	);
init : PROCESS                                               
-- variable declarations                                     
BEGIN                                                        
  delay_start <= '0';
WAIT;                                                       
END PROCESS init;

Clock : PROCESS
BEGIN
  clk <= '0', '1' AFTER 50 ns;
  WAIT FOR 100 ns;
END PROCESS;

DS : PROCESS (clk)
BEGIN
  if (clk'event and clk = '1') then
      IF (delay_start = '0') THEN
        delay_start <= '1';        
      END IF;
  end if;
END PROCESS;

                                           
always : PROCESS

file file_IN0, file_IN1, file_IN2, file_IN3, file_IN4, file_IN5, file_IN6, file_IN7, file_CW, USO_file: text;
variable inType : std_logic_vector (15 downto 0);
variable str_type : string (16 downto 1); 
variable str_type1 : string (2 downto 1); 
variable str_type2 : character; 
variable lineType : line;                                             
-- optional sensitivity list                                  
-- (        )                                                 
-- variable declarations                                      
BEGIN
--  wait until (delay_start = '1');
FILE_OPEN(file_IN0, "../entradasReais/IN1.txt", READ_MODE);
FILE_OPEN(file_IN1, "../entradasReais/IN2.txt", READ_MODE);
FILE_OPEN(file_IN2, "../entradasReais/IN3.txt", READ_MODE);
FILE_OPEN(file_IN3, "../entradasReais/IN4.txt", READ_MODE);
FILE_OPEN(file_IN4, "../entradasReais/IN5.txt", READ_MODE);
FILE_OPEN(file_IN5, "../entradasReais/IN6.txt", READ_MODE);
FILE_OPEN(file_IN6, "../entradasReais/IN7.txt", READ_MODE);
FILE_OPEN(file_IN7, "../entradasReais/IN8.txt", READ_MODE);

FILE_OPEN(file_CW, "../entradasReais/TAM.txt", READ_MODE);

FILE_OPEN(USO_file, "../entradasReais/USO.txt", READ_MODE);

  while not endfile (file_IN0) LOOP
    readline (file_IN0, lineType);
    read (lineType, str_type);
    IN0 <= str_to_stdvec(str_type);
    
    readline (file_IN1, lineType);
    read (lineType, str_type);
    IN1 <= str_to_stdvec(str_type);
    
    readline (file_IN2, lineType);
    read (lineType, str_type);
    IN2 <= str_to_stdvec(str_type);
    
    readline (file_IN3, lineType);
    read (lineType, str_type);
    IN3 <= str_to_stdvec(str_type);
    
    readline (file_IN4, lineType);
    read (lineType, str_type);
    IN4 <= str_to_stdvec(str_type);
    
    readline (file_IN5, lineType);
    read (lineType, str_type);
    IN5 <= str_to_stdvec(str_type);
    
    readline (file_IN6, lineType);
    read (lineType, str_type);
    IN6 <= str_to_stdvec(str_type);
    
    readline (file_IN7, lineType);
    read (lineType, str_type);
    IN7 <= str_to_stdvec(str_type);
    
    readline (USO_file, lineType);
    read (lineType, str_type2);
		if(str_type2 ='1' ) then
			USO<='1';
		else
			USO<='0';
		end if;
		
   -- USO <= str_to_stdvec(str_type2);
    
    
    readline (file_CW, lineType);
    read (lineType, str_type1);
    CONTROL_WORD <= str_to_stdvec(str_type1);
    
    wait until(clk'event and clk = '0');
    wait until(clk'event and clk = '1');
  end loop;
    
    
    assert false report "end of simulation" severity failure;                                                  


END PROCESS always;  
                                        
END idct_paralela_arch;
