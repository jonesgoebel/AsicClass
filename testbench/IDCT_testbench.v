
`timescale 1 ns / 1 ns


module IDCT_testbench;
  integer PERIOD = 100;
  wire [15:0] A1,A2,A3,A4,A5,A6,A7,A8;
  wire [1:0] TAM;
  wire  USO;
  wire [14:0] Sum1_4,Sum2_4,Sum3_4,Sum4_4,Sum5_4,Sum6_4,Sum7_4,Sum8_4;
  reg clk;
  reg [31:0] K;
  integer MAX=1000,gg;
  integer file;

  initial begin
	//gg=$value$plusargs("PERIOD=%d",PERIOD);
	file  = $fopen("../entradasReais/file_size", "r");	
	gg = $fscanf(file, "%d",MAX);	
	clk = 1'b0;
	
	  
  end

  initial
  begin
	
    $dumpfile ("IDCT.vcd"); //create a specific VCD filename, used for switching activity
    $dumpvars(0,IDCT_testbench.arch); // signal the output of the simulation values. With no args dump all variables 
  
    for (K=0;K <= MAX-1; K=K+1)
    begin
	
        @(posedge clk);           // wait for some clocks 
	if(K==(MAX-1)) 
	begin 
		$display("\nLinha:%d Max:%d", K, MAX); 
		$display("Video0: Acabou em %d s", $time/1000); 
		$finish; 
	end
    end
  end   // --------------------end stimulus -------------------------------------------------------


  always begin
  	#(PERIOD/2) clk = ~clk;
  end

	rom_read memory1 (K,A1,A2,A3,A4,A5,A6,A7,A8,TAM,USO);
	idct8_multi arch(clk,TAM,USO,A1,A2,A3,A4,A5,A6,A7,A8,Sum1_4,Sum2_4,Sum3_4,Sum4_4,Sum5_4,Sum6_4,Sum7_4,Sum8_4);

endmodule



module rom_read (K,a1,a2,a3,a4,a5,a6,a7,a8,TAM,USO); 
	parameter integer index  = 1000000;
	input [31:0] K; // Index number of the memory, select k position of memory
	output reg [15:0] a1,a2,a3,a4,a5,a6,a7,a8;
	output reg [1:0] TAM;
	output reg USO;
	
	
	reg [15:0]  a1_rom  [0:index-1];
	reg [15:0]  a2_rom  [0:index-1];
	reg [15:0]  a3_rom  [0:index-1];
	reg [15:0]  a4_rom  [0:index-1];
	reg [15:0]  a5_rom  [0:index-1];
	reg [15:0]  a6_rom  [0:index-1];
	reg [15:0]  a7_rom  [0:index-1];
	reg [15:0]  a8_rom  [0:index-1];
	reg [1:0]  TAM_rom [0:index-1];
	reg USO_rom [0:index-1];


initial 
  begin
    $readmemb ("../entradasReais/IN1.txt", a1_rom);   //  read file with ROMs values, is synthesizable
	$readmemb ("../entradasReais/IN2.txt", a2_rom);   
	$readmemb ("../entradasReais/IN3.txt", a3_rom); 	
	$readmemb ("../entradasReais/IN4.txt", a4_rom);
	$readmemb ("../entradasReais/IN5.txt", a5_rom); 
	$readmemb ("../entradasReais/IN6.txt", a6_rom);
	$readmemb ("../entradasReais/IN7.txt", a7_rom); 
	$readmemb ("../entradasReais/IN8.txt", a8_rom); 
		
	$readmemb ("../entradasReais/TAM.txt", TAM_rom);
	
	$readmemb ("../entradasReais/USO.txt", USO_rom);
  end

  always @( K ) 
  begin
  	a1 = a1_rom[K] ;
	a2 = a2_rom[K] ;
	a3 = a3_rom[K] ;
	a4 = a4_rom[K] ;
	a5 = a5_rom[K] ;
	a6 = a6_rom[K] ;
	a7 = a7_rom[K] ;
	a8 = a8_rom[K] ;
	
	TAM = TAM_rom[K] ;
	
	USO = USO_rom[K] ;
	
  end  
endmodule
