
`timescale 1 ns / 1 ps
`ifndef DIRECTION_PARAMS_H
`define DIRECTION_PARAMS_H
`define VOID 2'b00
`define LEFT 2'b01
`define RIGHT 2'b10
`define UP 2'b11
// Used for pi switch
`define UPL 2'b11
`define UPR 2'b00 // replaces VOID in t_switch
`endif


	module F20180220_1_v1_0_S00_AXI #
	(
		// Users to add parameters here

		// User parameters ends
		// Do not modify the parameters beyond this line

		// Width of S_AXI data bus
		parameter integer C_S_AXI_DATA_WIDTH	= 32,
		// Width of S_AXI address bus
		parameter integer C_S_AXI_ADDR_WIDTH	= 5
	)
	(
		// Users to add ports here
        input clk_bft,
        input rst_n,
		// User ports ends
		// Do not modify the ports beyond this line
        
		// Global Clock Signal
		input wire  S_AXI_ACLK,
		// Global Reset Signal. This Signal is Active LOW
		input wire  S_AXI_ARESETN,
		// Write address (issued by master, acceped by Slave)
		input wire [C_S_AXI_ADDR_WIDTH-1 : 0] S_AXI_AWADDR,
		// Write channel Protection type. This signal indicates the
    		// privilege and security level of the transaction, and whether
    		// the transaction is a data access or an instruction access.
		input wire [2 : 0] S_AXI_AWPROT,
		// Write address valid. This signal indicates that the master signaling
    		// valid write address and control information.
		input wire  S_AXI_AWVALID,
		// Write address ready. This signal indicates that the slave is ready
    		// to accept an address and associated control signals.
		output wire  S_AXI_AWREADY,
		// Write data (issued by master, acceped by Slave) 
		input wire [C_S_AXI_DATA_WIDTH-1 : 0] S_AXI_WDATA,
		// Write strobes. This signal indicates which byte lanes hold
    		// valid data. There is one write strobe bit for each eight
    		// bits of the write data bus.    
		input wire [(C_S_AXI_DATA_WIDTH/8)-1 : 0] S_AXI_WSTRB,
		// Write valid. This signal indicates that valid write
    		// data and strobes are available.
		input wire  S_AXI_WVALID,
		// Write ready. This signal indicates that the slave
    		// can accept the write data.
		output wire  S_AXI_WREADY,
		// Write response. This signal indicates the status
    		// of the write transaction.
		output wire [1 : 0] S_AXI_BRESP,
		// Write response valid. This signal indicates that the channel
    		// is signaling a valid write response.
		output wire  S_AXI_BVALID,
		// Response ready. This signal indicates that the master
    		// can accept a write response.
		input wire  S_AXI_BREADY,
		// Read address (issued by master, acceped by Slave)
		input wire [C_S_AXI_ADDR_WIDTH-1 : 0] S_AXI_ARADDR,
		// Protection type. This signal indicates the privilege
    		// and security level of the transaction, and whether the
    		// transaction is a data access or an instruction access.
		input wire [2 : 0] S_AXI_ARPROT,
		// Read address valid. This signal indicates that the channel
    		// is signaling valid read address and control information.
		input wire  S_AXI_ARVALID,
		// Read address ready. This signal indicates that the slave is
    		// ready to accept an address and associated control signals.
		output wire  S_AXI_ARREADY,
		// Read data (issued by slave)
		output wire [C_S_AXI_DATA_WIDTH-1 : 0] S_AXI_RDATA,
		// Read response. This signal indicates the status of the
    		// read transfer.
		output wire [1 : 0] S_AXI_RRESP,
		// Read valid. This signal indicates that the channel is
    		// signaling the required read data.
		output wire  S_AXI_RVALID,
		// Read ready. This signal indicates that the master can
    		// accept the read data and response information.
		input wire  S_AXI_RREADY
	);

	// AXI4LITE signals
	reg [C_S_AXI_ADDR_WIDTH-1 : 0] 	axi_awaddr;
	reg  	axi_awready;
	reg  	axi_wready;
	reg [1 : 0] 	axi_bresp;
	reg  	axi_bvalid;
	reg [C_S_AXI_ADDR_WIDTH-1 : 0] 	axi_araddr;
	reg  	axi_arready;
	reg [C_S_AXI_DATA_WIDTH-1 : 0] 	axi_rdata;
	reg [1 : 0] 	axi_rresp;
	reg  	axi_rvalid;

	// Example-specific design signals
	// local parameter for addressing 32 bit / 64 bit C_S_AXI_DATA_WIDTH
	// ADDR_LSB is used for addressing 32/64 bit registers/memories
	// ADDR_LSB = 2 for 32 bits (n downto 2)
	// ADDR_LSB = 3 for 64 bits (n downto 3)
	localparam integer ADDR_LSB = (C_S_AXI_DATA_WIDTH/32) + 1;
	localparam integer OPT_MEM_ADDR_BITS = 2;
	//----------------------------------------------
	//-- Signals for user logic register space example
	//------------------------------------------------
	//-- Number of Slave Registers 8
	wire [C_S_AXI_DATA_WIDTH-1:0]	slv_reg0;
	wire [C_S_AXI_DATA_WIDTH-1:0]	slv_reg1;
	wire [C_S_AXI_DATA_WIDTH-1:0]	slv_reg2;
	wire [C_S_AXI_DATA_WIDTH-1:0]	slv_reg3;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg4;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg5;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg6;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg7;
	wire	 slv_reg_rden;
	wire	 slv_reg_wren;
	reg [C_S_AXI_DATA_WIDTH-1:0]	 reg_data_out;
	integer	 byte_index;
	reg	 aw_en;

	// I/O Connections assignments

	assign S_AXI_AWREADY	= axi_awready;
	assign S_AXI_WREADY	= axi_wready;
	assign S_AXI_BRESP	= axi_bresp;
	assign S_AXI_BVALID	= axi_bvalid;
	assign S_AXI_ARREADY	= axi_arready;
	assign S_AXI_RDATA	= axi_rdata;
	assign S_AXI_RRESP	= axi_rresp;
	assign S_AXI_RVALID	= axi_rvalid;
	// Implement axi_awready generation
	// axi_awready is asserted for one S_AXI_ACLK clock cycle when both
	// S_AXI_AWVALID and S_AXI_WVALID are asserted. axi_awready is
	// de-asserted when reset is low.

	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
	      axi_awready <= 1'b0;
	      aw_en <= 1'b1;
	    end 
	  else
	    begin    
	      if (~axi_awready && S_AXI_AWVALID && S_AXI_WVALID && aw_en)
	        begin
	          // slave is ready to accept write address when 
	          // there is a valid write address and write data
	          // on the write address and data bus. This design 
	          // expects no outstanding transactions. 
	          axi_awready <= 1'b1;
	          aw_en <= 1'b0;
	        end
	        else if (S_AXI_BREADY && axi_bvalid)
	            begin
	              aw_en <= 1'b1;
	              axi_awready <= 1'b0;
	            end
	      else           
	        begin
	          axi_awready <= 1'b0;
	        end
	    end 
	end       

	// Implement axi_awaddr latching
	// This process is used to latch the address when both 
	// S_AXI_AWVALID and S_AXI_WVALID are valid. 

	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
	      axi_awaddr <= 0;
	    end 
	  else
	    begin    
	      if (~axi_awready && S_AXI_AWVALID && S_AXI_WVALID && aw_en)
	        begin
	          // Write Address latching 
	          axi_awaddr <= S_AXI_AWADDR;
	        end
	    end 
	end       

	// Implement axi_wready generation
	// axi_wready is asserted for one S_AXI_ACLK clock cycle when both
	// S_AXI_AWVALID and S_AXI_WVALID are asserted. axi_wready is 
	// de-asserted when reset is low. 

	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
	      axi_wready <= 1'b0;
	    end 
	  else
	    begin    
	      if (~axi_wready && S_AXI_WVALID && S_AXI_AWVALID && aw_en )
	        begin
	          // slave is ready to accept write data when 
	          // there is a valid write address and write data
	          // on the write address and data bus. This design 
	          // expects no outstanding transactions. 
	          axi_wready <= 1'b1;
	        end
	      else
	        begin
	          axi_wready <= 1'b0;
	        end
	    end 
	end       

	// Implement memory mapped register select and write logic generation
	// The write data is accepted and written to memory mapped registers when
	// axi_awready, S_AXI_WVALID, axi_wready and S_AXI_WVALID are asserted. Write strobes are used to
	// select byte enables of slave registers while writing.
	// These registers are cleared when reset (active low) is applied.
	// Slave register write enable is asserted when valid address and data are available
	// and the slave is ready to accept the write address and write data.
	assign slv_reg_wren = axi_wready && S_AXI_WVALID && axi_awready && S_AXI_AWVALID;

	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
//	      slv_reg0 <= 0;
//	      slv_reg1 <= 0;
//	      slv_reg2 <= 0;
//	      slv_reg3 <= 0;
	      slv_reg4 <= 0;
	      slv_reg5 <= 0;
	      slv_reg6 <= 0;
	      slv_reg7 <= 0;
	    end 
	  else begin
	    if (slv_reg_wren)
	      begin
	        case ( axi_awaddr[ADDR_LSB+OPT_MEM_ADDR_BITS:ADDR_LSB] )
//	          3'h0:
//	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
//	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
//	                // Respective byte enables are asserted as per write strobes 
//	                // Slave register 0
//	                slv_reg0[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
//	              end  
//	          3'h1:
//	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
//	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
//	                // Respective byte enables are asserted as per write strobes 
//	                // Slave register 1
//	                slv_reg1[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
//	              end  
//	          3'h2:
//	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
//	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
//	                // Respective byte enables are asserted as per write strobes 
//	                // Slave register 2
//	                slv_reg2[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
//	              end  
//	          3'h3:
//	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
//	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
//	                // Respective byte enables are asserted as per write strobes 
//	                // Slave register 3
//	                slv_reg3[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
//	              end  
	          3'h4:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 4
	                slv_reg4[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          3'h5:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 5
	                slv_reg5[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          3'h6:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 6
	                slv_reg6[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          3'h7:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 7
	                slv_reg7[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          default : begin
//	                      slv_reg0 <= slv_reg0;
//	                      slv_reg1 <= slv_reg1;
//	                      slv_reg2 <= slv_reg2;
//	                      slv_reg3 <= slv_reg3;
	                      slv_reg4 <= slv_reg4;
	                      slv_reg5 <= slv_reg5;
	                      slv_reg6 <= slv_reg6;
	                      slv_reg7 <= slv_reg7;
	                    end
	        endcase
	      end
	  end
	end    

	// Implement write response logic generation
	// The write response and response valid signals are asserted by the slave 
	// when axi_wready, S_AXI_WVALID, axi_wready and S_AXI_WVALID are asserted.  
	// This marks the acceptance of address and indicates the status of 
	// write transaction.

	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
	      axi_bvalid  <= 0;
	      axi_bresp   <= 2'b0;
	    end 
	  else
	    begin    
	      if (axi_awready && S_AXI_AWVALID && ~axi_bvalid && axi_wready && S_AXI_WVALID)
	        begin
	          // indicates a valid write response is available
	          axi_bvalid <= 1'b1;
	          axi_bresp  <= 2'b0; // 'OKAY' response 
	        end                   // work error responses in future
	      else
	        begin
	          if (S_AXI_BREADY && axi_bvalid) 
	            //check if bready is asserted while bvalid is high) 
	            //(there is a possibility that bready is always asserted high)   
	            begin
	              axi_bvalid <= 1'b0; 
	            end  
	        end
	    end
	end   

	// Implement axi_arready generation
	// axi_arready is asserted for one S_AXI_ACLK clock cycle when
	// S_AXI_ARVALID is asserted. axi_awready is 
	// de-asserted when reset (active low) is asserted. 
	// The read address is also latched when S_AXI_ARVALID is 
	// asserted. axi_araddr is reset to zero on reset assertion.

	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
	      axi_arready <= 1'b0;
	      axi_araddr  <= 32'b0;
	    end 
	  else
	    begin    
	      if (~axi_arready && S_AXI_ARVALID)
	        begin
	          // indicates that the slave has acceped the valid read address
	          axi_arready <= 1'b1;
	          // Read address latching
	          axi_araddr  <= S_AXI_ARADDR;
	        end
	      else
	        begin
	          axi_arready <= 1'b0;
	        end
	    end 
	end       

	// Implement axi_arvalid generation
	// axi_rvalid is asserted for one S_AXI_ACLK clock cycle when both 
	// S_AXI_ARVALID and axi_arready are asserted. The slave registers 
	// data are available on the axi_rdata bus at this instance. The 
	// assertion of axi_rvalid marks the validity of read data on the 
	// bus and axi_rresp indicates the status of read transaction.axi_rvalid 
	// is deasserted on reset (active low). axi_rresp and axi_rdata are 
	// cleared to zero on reset (active low).  
	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
	      axi_rvalid <= 0;
	      axi_rresp  <= 0;
	    end 
	  else
	    begin    
	      if (axi_arready && S_AXI_ARVALID && ~axi_rvalid)
	        begin
	          // Valid read data is available at the read data bus
	          axi_rvalid <= 1'b1;
	          axi_rresp  <= 2'b0; // 'OKAY' response
	        end   
	      else if (axi_rvalid && S_AXI_RREADY)
	        begin
	          // Read data is accepted by the master
	          axi_rvalid <= 1'b0;
	        end                
	    end
	end    

	// Implement memory mapped register select and read logic generation
	// Slave register read enable is asserted when valid address is available
	// and the slave is ready to accept the read address.
	assign slv_reg_rden = axi_arready & S_AXI_ARVALID & ~axi_rvalid;
	always @(*)
	begin
	      // Address decoding for reading registers
	      case ( axi_araddr[ADDR_LSB+OPT_MEM_ADDR_BITS:ADDR_LSB] )
	        3'h0   : reg_data_out <= slv_reg0;
	        3'h1   : reg_data_out <= slv_reg1;
	        3'h2   : reg_data_out <= slv_reg2;
	        3'h3   : reg_data_out <= slv_reg3;
	        3'h4   : reg_data_out <= slv_reg4;
	        3'h5   : reg_data_out <= slv_reg5;
	        3'h6   : reg_data_out <= slv_reg6;
	        3'h7   : reg_data_out <= slv_reg7;
	        default : reg_data_out <= 0;
	      endcase
	end

	// Output register or memory read data
	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
	      axi_rdata  <= 0;
	    end 
	  else
	    begin    
	      // When there is a valid read address (S_AXI_ARVALID) with 
	      // acceptance of read address by the slave (axi_arready), 
	      // output the read dada 
	      if (slv_reg_rden)
	        begin
	          axi_rdata <= reg_data_out;     // register read data
	        end   
	    end
	end    

	// Add user logic here
	wire [96:0] pe_interface_0;
    wire [96:0] pe_interface_1;    
    wire [96:0] pe_interface_2;    
    wire [96:0] pe_interface_3;    
    wire [96:0] pe_interface_4;    
    wire [96:0] pe_interface_5;    
    wire [96:0] pe_interface_6;
    wire [96:0] pe_interface_7;    
    
    wire [96:0] interface_pe_0;
    wire [96:0] interface_pe_1;
    wire [96:0] interface_pe_2;
    wire [96:0] interface_pe_3;
    wire [96:0] interface_pe_4;
    wire [96:0] interface_pe_5;
    wire [96:0] interface_pe_6;
    wire [96:0] interface_pe_7;  
      
    pe_stream #(
        .p_sz(97),
        .p_load(93)
        )i1(
        .clk_bft(clk_bft),
        .clk_axi(S_AXI_ACLK),
        .rst_n(rst_n),
        .resend(),
        .interface_pe(interface_pe_1),
        .pe_interface(pe_interface_1)
        );

    pe_stream #(
        .p_sz(97),
        .p_load(93)
        )i2(
        .clk_bft(clk_bft),
        .clk_axi(S_AXI_ACLK),
        .rst_n(rst_n),
        .resend(),
        .interface_pe(interface_pe_2),
        .pe_interface(pe_interface_2)
        );
        
    pe_stream #(
        .p_sz(97),
        .p_load(93)
        )i3(
        .clk_bft(clk_bft),
        .clk_axi(S_AXI_ACLK),
        .rst_n(rst_n),
        .resend(),
        .interface_pe(interface_pe_3),
        .pe_interface(pe_interface_3)
        );    
    
    pe_stream #(
        .p_sz(97),
        .p_load(93)
        )i4(
        .clk_bft(clk_bft),
        .clk_axi(S_AXI_ACLK),
        .rst_n(rst_n),
        .resend(),
        .interface_pe(interface_pe_4),
        .pe_interface(pe_interface_4)
        );

    pe_stream #(
        .p_sz(97),
        .p_load(93)
        )i5(
        .clk_bft(clk_bft),
        .clk_axi(S_AXI_ACLK),
        .rst_n(rst_n),
        .resend(),
        .interface_pe(interface_pe_5),
        .pe_interface(pe_interface_5)
        );
        
    pe_stream #(
        .p_sz(97),
        .p_load(93)
        )i6(
        .clk_bft(clk_bft),
        .clk_axi(S_AXI_ACLK),
        .rst_n(rst_n),
        .resend(),
        .interface_pe(interface_pe_6),
        .pe_interface(pe_interface_6)
        );  
        
    pe_stream #(
        .p_sz(97),
        .p_load(93)
        )i7(
        .clk_bft(clk_bft),
        .clk_axi(S_AXI_ACLK),
        .rst_n(rst_n),
        .resend(),
        .interface_pe(interface_pe_7),
        .pe_interface(pe_interface_7)
        );

wire [31:0] start_sig;

    toggle_dect #(
        .data_width(32)
    ) toggle_inst (
        .data_out(start_sig),
        .data_in(slv_reg7),
        .clk(S_AXI_ACLK),
        .rst_n(S_AXI_ARESETN)
       );
 

fifo_generator_0 fifo_in (
  .rst(~S_AXI_ARESETN),        // input wire rst
  .wr_clk(clk_bft),  // input wire wr_clk
  .rd_clk(S_AXI_ACLK),  // input wire rd_clk
  .din(interface_pe_0),        // input wire [96 : 0] din
  .wr_en(interface_pe_0[96]),    // input wire wr_en
  .rd_en(start_sig[1]),    // input wire rd_en
  .dout({slv_reg3[0], slv_reg2, slv_reg1, slv_reg0}),      // output wire [96 : 0] dout
  .full(),      // output wire full
  .empty()    // output wire empty
);




reg rd_en_out;
wire empty_out;
wire [96:0] fifo_out_temp;
reg out_valid;
assign pe_interface_0[95:0] = fifo_out_temp[95:0];
assign pe_interface_0[96] = out_valid;
fifo_generator_0 fifo_out (
  .rst(~S_AXI_ARESETN),        // input wire rst
  .wr_clk(S_AXI_ACLK),  // input wire wr_clk
  .rd_clk(clk_bft),  // input wire rd_clk
  .din({slv_reg7[0], slv_reg6, slv_reg5, slv_reg4}),        // input wire [96 : 0] din
  .wr_en(start_sig[0]),    // input wire wr_en
  .rd_en(rd_en_out),    // input wire rd_en
  .dout(fifo_out_temp),      // output wire [96 : 0] dout
  .full(),      // output wire full
  .empty(empty_out)    // output wire empty
);


always@(posedge clk_bft or negedge rst_n)
begin
    if(!rst_n)
        out_valid <=0;
    else
        out_valid <= rd_en_out;
end


always@(posedge clk_bft or negedge rst_n)
begin
    if(!rst_n)
        rd_en_out <=0;
    else
        rd_en_out <= ~empty_out;
end

wire [97*8:0] pe_interface_pp0;

pipe_ff #(
        .data_width(97)
        )pipe_ff_inst_l_bus_i_p0(
        .clk(clk_bft),
        .din({pe_interface_7, pe_interface_6, pe_interface_5, pe_interface_4, pe_interface_3, pe_interface_2, pe_interface_1, pe_interface_0}),
        .dout(pe_interface_pp0));
        
    gen_nw #(
        .num_leaves(8),
        .payload_sz(93),
        .p_sz(97),
        .addr(1'b0),
        .level(0)
    )gen_nw_1(
        .clk(clk_bft),
        .reset(~rst_n),
        .pe_interface(pe_interface_pp0),
        .interface_pe({interface_pe_7, interface_pe_6, interface_pe_5, interface_pe_4, interface_pe_3, interface_pe_2, interface_pe_1, interface_pe_0}),
        .resend()
    );  
    // User logic ends

    endmodule


module gen_nw (
    input clk,
    input reset,
    input [p_sz*8-1:0] pe_interface,
    output [p_sz*8-1:0] interface_pe,
    output [8-1:0] resend
);
    parameter num_leaves= 8;
    parameter payload_sz= $clog2(num_leaves) + 4;
    parameter p_sz= 1 + $clog2(num_leaves) + payload_sz; //packet size
    parameter addr= 1'b0;
    parameter level= 0;
    
    wire [4*p_sz-1:0] switch_left;
    wire [4*p_sz-1:0] switch_right;
    wire [4*p_sz-1:0] left_switch;
    wire [4*p_sz-1:0] right_switch;
    wire [4*p_sz-1:0] switch_left_0;
    wire [4*p_sz-1:0] switch_right_0;
    wire [4*p_sz-1:0] left_switch_0;
    wire [4*p_sz-1:0] right_switch_0;


    wire [4*p_sz-1:0] switch_left_1;
    wire [4*p_sz-1:0] switch_right_1;
    wire [4*p_sz-1:0] left_switch_1;
    wire [4*p_sz-1:0] right_switch_1;


    wire [4*p_sz-1:0] switch_left_2;
    wire [4*p_sz-1:0] switch_right_2;
    wire [4*p_sz-1:0] left_switch_2;
    wire [4*p_sz-1:0] right_switch_2;


    wire [4*p_sz-1:0] switch_left_3;
    wire [4*p_sz-1:0] switch_right_3;
    wire [4*p_sz-1:0] left_switch_3;
    wire [4*p_sz-1:0] right_switch_3;



    pipe_ff #(
        .data_width(4*p_sz)
        )pipe_ff_inst_sl_0(
        .clk(clk),
        .din(switch_left_0),
        .dout(switch_left_1));
    pipe_ff #(
        .data_width(4*p_sz)
        )pipe_ff_inst_sr_0(
        .clk(clk),
        .reset(reset),
        .din(switch_right_0),
        .dout(switch_right_1));
    pipe_ff #(
        .data_width(4*p_sz)
        )pipe_ff_inst_ls_0(
        .clk(clk),
        .reset(reset),
        .din(left_switch_0),
        .dout(left_switch_1));
    pipe_ff #(
        .data_width(4*p_sz)
        )pipe_ff_inst_rs_0(
        .clk(clk),
        .reset(reset),
        .din(right_switch_0),
        .dout(right_switch_1));


    pipe_ff #(
        .data_width(4*p_sz)
        )pipe_ff_inst_sl_1(
        .clk(clk),
        .din(switch_left_1),
        .dout(switch_left_2));
    pipe_ff #(
        .data_width(4*p_sz)
        )pipe_ff_inst_sr_1(
        .clk(clk),
        .reset(reset),
        .din(switch_right_1),
        .dout(switch_right_2));
    pipe_ff #(
        .data_width(4*p_sz)
        )pipe_ff_inst_ls_1(
        .clk(clk),
        .reset(reset),
        .din(left_switch_1),
        .dout(left_switch_2));
    pipe_ff #(
        .data_width(4*p_sz)
        )pipe_ff_inst_rs_1(
        .clk(clk),
        .reset(reset),
        .din(right_switch_1),
        .dout(right_switch_2));


    pipe_ff #(
        .data_width(4*p_sz)
        )pipe_ff_inst_sl_2(
        .clk(clk),
        .din(switch_left_2),
        .dout(switch_left_3));
    pipe_ff #(
        .data_width(4*p_sz)
        )pipe_ff_inst_sr_2(
        .clk(clk),
        .reset(reset),
        .din(switch_right_2),
        .dout(switch_right_3));
    pipe_ff #(
        .data_width(4*p_sz)
        )pipe_ff_inst_ls_2(
        .clk(clk),
        .reset(reset),
        .din(left_switch_2),
        .dout(left_switch_3));
    pipe_ff #(
        .data_width(4*p_sz)
        )pipe_ff_inst_rs_2(
        .clk(clk),
        .reset(reset),
        .din(right_switch_2),
        .dout(right_switch_3));


    pipe_ff #(
        .data_width(4*p_sz)
        )pipe_ff_inst_sl_3(
        .clk(clk),
        .din(switch_left_3),
        .dout(switch_left));
    pipe_ff #(
        .data_width(4*p_sz)
        )pipe_ff_inst_sr_3(
        .clk(clk),
        .reset(reset),
        .din(switch_right_3),
        .dout(switch_right));
    pipe_ff #(
        .data_width(4*p_sz)
        )pipe_ff_inst_ls_3(
        .clk(clk),
        .reset(reset),
        .din(left_switch_3),
        .dout(left_switch));
    pipe_ff #(
        .data_width(4*p_sz)
        )pipe_ff_inst_rs_3(
        .clk(clk),
        .reset(reset),
        .din(right_switch_3),
        .dout(right_switch));




    pi_cluster #(
        .num_leaves(num_leaves),
        .payload_sz(payload_sz),
        .addr(addr),
        .level(level),
        .p_sz(p_sz),
        .num_switches(4))
        pi_lvl0(
            .clk(clk),
            .reset(reset),


            .l_bus_i(left_switch),
            .r_bus_i(right_switch),
            .l_bus_o(switch_left_0),
            .r_bus_o(switch_right_0));

    _22subtree #(
        .num_leaves(num_leaves),
        .payload_sz(payload_sz),
        .addr({1'b0}),
        .p_sz(p_sz))
        subtree_left(
            .clk(clk),
            .reset(reset),
            .bus_i(switch_left),
            .bus_o(left_switch_0),
            .pe_interface(pe_interface[p_sz*4-1:0]),
            .interface_pe(interface_pe[p_sz*4-1:0]),
            .resend(resend[4-1:0]));

    _22subtree #(
        .num_leaves(num_leaves),
        .payload_sz(payload_sz),
        .addr({1'b1}),
        .p_sz(p_sz))
        subtree_right(
            .clk(clk),
            .reset(reset),
            .bus_i(switch_right),
            .bus_o(right_switch_0),
            .pe_interface(pe_interface[p_sz*8-1:p_sz*4]),
            .interface_pe(interface_pe[p_sz*8-1:p_sz*4]),
            .resend(resend[8-1:4]));
endmodule
module _22subtree (
    input clk,
    input reset,
    input [p_sz*4-1:0] pe_interface,
    output [p_sz*4-1:0] interface_pe,
    output [4-1:0] resend,
    input [2*2*p_sz-1:0] bus_i,

    output [2*2*p_sz-1:0] bus_o
);
    parameter num_leaves= 8;
    parameter payload_sz= $clog2(num_leaves) + 4;
    parameter p_sz= 1 + $clog2(num_leaves) + payload_sz; //packet size
    parameter addr= 1'b0;
    parameter level= 1;
    
    wire [2*p_sz-1:0] switch_left;
    wire [2*p_sz-1:0] switch_right;
    wire [2*p_sz-1:0] left_switch;
    wire [2*p_sz-1:0] right_switch;
    wire [2*p_sz-1:0] switch_left_0;
    wire [2*p_sz-1:0] switch_right_0;
    wire [2*p_sz-1:0] left_switch_0;
    wire [2*p_sz-1:0] right_switch_0;


    wire [2*p_sz-1:0] switch_left_1;
    wire [2*p_sz-1:0] switch_right_1;
    wire [2*p_sz-1:0] left_switch_1;
    wire [2*p_sz-1:0] right_switch_1;


    wire [2*p_sz-1:0] switch_left_2;
    wire [2*p_sz-1:0] switch_right_2;
    wire [2*p_sz-1:0] left_switch_2;
    wire [2*p_sz-1:0] right_switch_2;


    wire [2*p_sz-1:0] switch_left_3;
    wire [2*p_sz-1:0] switch_right_3;
    wire [2*p_sz-1:0] left_switch_3;
    wire [2*p_sz-1:0] right_switch_3;



    pipe_ff #(
        .data_width(2*p_sz)
        )pipe_ff_inst_sl_0(
        .clk(clk),
        .din(switch_left_0),
        .dout(switch_left_1));
    pipe_ff #(
        .data_width(2*p_sz)
        )pipe_ff_inst_sr_0(
        .clk(clk),
        .reset(reset),
        .din(switch_right_0),
        .dout(switch_right_1));
    pipe_ff #(
        .data_width(2*p_sz)
        )pipe_ff_inst_ls_0(
        .clk(clk),
        .reset(reset),
        .din(left_switch_0),
        .dout(left_switch_1));
    pipe_ff #(
        .data_width(2*p_sz)
        )pipe_ff_inst_rs_0(
        .clk(clk),
        .reset(reset),
        .din(right_switch_0),
        .dout(right_switch_1));


    pipe_ff #(
        .data_width(2*p_sz)
        )pipe_ff_inst_sl_1(
        .clk(clk),
        .din(switch_left_1),
        .dout(switch_left_2));
    pipe_ff #(
        .data_width(2*p_sz)
        )pipe_ff_inst_sr_1(
        .clk(clk),
        .reset(reset),
        .din(switch_right_1),
        .dout(switch_right_2));
    pipe_ff #(
        .data_width(2*p_sz)
        )pipe_ff_inst_ls_1(
        .clk(clk),
        .reset(reset),
        .din(left_switch_1),
        .dout(left_switch_2));
    pipe_ff #(
        .data_width(2*p_sz)
        )pipe_ff_inst_rs_1(
        .clk(clk),
        .reset(reset),
        .din(right_switch_1),
        .dout(right_switch_2));


    pipe_ff #(
        .data_width(2*p_sz)
        )pipe_ff_inst_sl_2(
        .clk(clk),
        .din(switch_left_2),
        .dout(switch_left_3));
    pipe_ff #(
        .data_width(2*p_sz)
        )pipe_ff_inst_sr_2(
        .clk(clk),
        .reset(reset),
        .din(switch_right_2),
        .dout(switch_right_3));
    pipe_ff #(
        .data_width(2*p_sz)
        )pipe_ff_inst_ls_2(
        .clk(clk),
        .reset(reset),
        .din(left_switch_2),
        .dout(left_switch_3));
    pipe_ff #(
        .data_width(2*p_sz)
        )pipe_ff_inst_rs_2(
        .clk(clk),
        .reset(reset),
        .din(right_switch_2),
        .dout(right_switch_3));


    pipe_ff #(
        .data_width(2*p_sz)
        )pipe_ff_inst_sl_3(
        .clk(clk),
        .din(switch_left_3),
        .dout(switch_left));
    pipe_ff #(
        .data_width(2*p_sz)
        )pipe_ff_inst_sr_3(
        .clk(clk),
        .reset(reset),
        .din(switch_right_3),
        .dout(switch_right));
    pipe_ff #(
        .data_width(2*p_sz)
        )pipe_ff_inst_ls_3(
        .clk(clk),
        .reset(reset),
        .din(left_switch_3),
        .dout(left_switch));
    pipe_ff #(
        .data_width(2*p_sz)
        )pipe_ff_inst_rs_3(
        .clk(clk),
        .reset(reset),
        .din(right_switch_3),
        .dout(right_switch));




    pi_cluster #(
        .num_leaves(num_leaves),
        .payload_sz(payload_sz),
        .addr(addr),
        .level(level),
        .p_sz(p_sz),
        .num_switches(2))
        pi_lvl1(
            .clk(clk),
            .reset(reset),
            .u_bus_i(bus_i),
            .u_bus_o(bus_o),
            .l_bus_i(left_switch),
            .r_bus_i(right_switch),
            .l_bus_o(switch_left_0),
            .r_bus_o(switch_right_0));

    _2subtree #(
        .num_leaves(num_leaves),
        .payload_sz(payload_sz),
        .addr({addr, 1'b0}),
        .p_sz(p_sz))
        subtree_left(
            .clk(clk),
            .reset(reset),
            .bus_i(switch_left),
            .bus_o(left_switch_0),
            .pe_interface(pe_interface[p_sz*2-1:0]),
            .interface_pe(interface_pe[p_sz*2-1:0]),
            .resend(resend[2-1:0]));

    _2subtree #(
        .num_leaves(num_leaves),
        .payload_sz(payload_sz),
        .addr({addr, 1'b1}),
        .p_sz(p_sz))
        subtree_right(
            .clk(clk),
            .reset(reset),
            .bus_i(switch_right),
            .bus_o(right_switch_0),
            .pe_interface(pe_interface[p_sz*4-1:p_sz*2]),
            .interface_pe(interface_pe[p_sz*4-1:p_sz*2]),
            .resend(resend[4-1:2]));
endmodule
module _2subtree (
    input clk,
    input reset,
    input [p_sz*2-1:0] pe_interface,
    output [p_sz*2-1:0] interface_pe,
    output [2-1:0] resend,
    input [2*1*p_sz-1:0] bus_i,

    output [2*1*p_sz-1:0] bus_o
);
    parameter num_leaves= 8;
    parameter payload_sz= $clog2(num_leaves) + 4;
    parameter p_sz= 1 + $clog2(num_leaves) + payload_sz; //packet size
    parameter addr= 2'b00;
    parameter level= 2;
    
    wire [1*p_sz-1:0] switch_left;
    wire [1*p_sz-1:0] switch_right;
    wire [1*p_sz-1:0] left_switch;
    wire [1*p_sz-1:0] right_switch;
    wire [1*p_sz-1:0] switch_left_0;
    wire [1*p_sz-1:0] switch_right_0;
    wire [1*p_sz-1:0] left_switch_0;
    wire [1*p_sz-1:0] right_switch_0;


    wire [1*p_sz-1:0] switch_left_1;
    wire [1*p_sz-1:0] switch_right_1;
    wire [1*p_sz-1:0] left_switch_1;
    wire [1*p_sz-1:0] right_switch_1;


    wire [1*p_sz-1:0] switch_left_2;
    wire [1*p_sz-1:0] switch_right_2;
    wire [1*p_sz-1:0] left_switch_2;
    wire [1*p_sz-1:0] right_switch_2;


    wire [1*p_sz-1:0] switch_left_3;
    wire [1*p_sz-1:0] switch_right_3;
    wire [1*p_sz-1:0] left_switch_3;
    wire [1*p_sz-1:0] right_switch_3;



    pipe_ff #(
        .data_width(1*p_sz)
        )pipe_ff_inst_sl_0(
        .clk(clk),
        .din(switch_left_0),
        .dout(switch_left_1));
    pipe_ff #(
        .data_width(1*p_sz)
        )pipe_ff_inst_sr_0(
        .clk(clk),
        .reset(reset),
        .din(switch_right_0),
        .dout(switch_right_1));
    pipe_ff #(
        .data_width(1*p_sz)
        )pipe_ff_inst_ls_0(
        .clk(clk),
        .reset(reset),
        .din(left_switch_0),
        .dout(left_switch_1));
    pipe_ff #(
        .data_width(1*p_sz)
        )pipe_ff_inst_rs_0(
        .clk(clk),
        .reset(reset),
        .din(right_switch_0),
        .dout(right_switch_1));


    pipe_ff #(
        .data_width(1*p_sz)
        )pipe_ff_inst_sl_1(
        .clk(clk),
        .din(switch_left_1),
        .dout(switch_left_2));
    pipe_ff #(
        .data_width(1*p_sz)
        )pipe_ff_inst_sr_1(
        .clk(clk),
        .reset(reset),
        .din(switch_right_1),
        .dout(switch_right_2));
    pipe_ff #(
        .data_width(1*p_sz)
        )pipe_ff_inst_ls_1(
        .clk(clk),
        .reset(reset),
        .din(left_switch_1),
        .dout(left_switch_2));
    pipe_ff #(
        .data_width(1*p_sz)
        )pipe_ff_inst_rs_1(
        .clk(clk),
        .reset(reset),
        .din(right_switch_1),
        .dout(right_switch_2));


    pipe_ff #(
        .data_width(1*p_sz)
        )pipe_ff_inst_sl_2(
        .clk(clk),
        .din(switch_left_2),
        .dout(switch_left_3));
    pipe_ff #(
        .data_width(1*p_sz)
        )pipe_ff_inst_sr_2(
        .clk(clk),
        .reset(reset),
        .din(switch_right_2),
        .dout(switch_right_3));
    pipe_ff #(
        .data_width(1*p_sz)
        )pipe_ff_inst_ls_2(
        .clk(clk),
        .reset(reset),
        .din(left_switch_2),
        .dout(left_switch_3));
    pipe_ff #(
        .data_width(1*p_sz)
        )pipe_ff_inst_rs_2(
        .clk(clk),
        .reset(reset),
        .din(right_switch_2),
        .dout(right_switch_3));


    pipe_ff #(
        .data_width(1*p_sz)
        )pipe_ff_inst_sl_3(
        .clk(clk),
        .din(switch_left_3),
        .dout(switch_left));
    pipe_ff #(
        .data_width(1*p_sz)
        )pipe_ff_inst_sr_3(
        .clk(clk),
        .reset(reset),
        .din(switch_right_3),
        .dout(switch_right));
    pipe_ff #(
        .data_width(1*p_sz)
        )pipe_ff_inst_ls_3(
        .clk(clk),
        .reset(reset),
        .din(left_switch_3),
        .dout(left_switch));
    pipe_ff #(
        .data_width(1*p_sz)
        )pipe_ff_inst_rs_3(
        .clk(clk),
        .reset(reset),
        .din(right_switch_3),
        .dout(right_switch));




    pi_cluster #(
        .num_leaves(num_leaves),
        .payload_sz(payload_sz),
        .addr(addr),
        .level(level),
        .p_sz(p_sz),
        .num_switches(1))
        pi_lvl2(
            .clk(clk),
            .reset(reset),
            .u_bus_i(bus_i),
            .u_bus_o(bus_o),
            .l_bus_i(left_switch),
            .r_bus_i(right_switch),
            .l_bus_o(switch_left_0),
            .r_bus_o(switch_right_0));

    interface #(
        .num_leaves(num_leaves),
        .payload_sz(payload_sz),
        .addr({addr, 1'b0}),
        .p_sz(p_sz))
        subtree_left(
            .clk(clk),
            .reset(reset),
            .bus_i(switch_left),
            .bus_o(left_switch_0),
            .pe_interface(pe_interface[p_sz*1-1:0]),
            .interface_pe(interface_pe[p_sz*1-1:0]),
            .resend(resend[1-1:0]));

    interface #(
        .num_leaves(num_leaves),
        .payload_sz(payload_sz),
        .addr({addr, 1'b1}),
        .p_sz(p_sz))
        subtree_right(
            .clk(clk),
            .reset(reset),
            .bus_i(switch_right),
            .bus_o(right_switch_0),
            .pe_interface(pe_interface[p_sz*2-1:p_sz*1]),
            .interface_pe(interface_pe[p_sz*2-1:p_sz*1]),
            .resend(resend[2-1:1]));
endmodule


module direction_determiner (
    input valid_i,
    input [$clog2(num_leaves)-1:0] addr_i,
    output reg [1:0] d
    );

    // override these values in top modules
    parameter num_leaves= 0;
    parameter addr= 0;
    parameter level= 0;  //level = $bits(addr) 

    generate
        if (level == 0) begin
            always @*
                if (valid_i) begin
                    if (addr_i[$clog2(num_leaves)-1])
                        d= `RIGHT;
                    else
                        d= `LEFT;
                end
                else
                    d= `VOID;
            end
        else begin
            wire [level-1:0]  addr_xnor_addr_i= 
                ~(addr ^ addr_i[$clog2(num_leaves)-1:$clog2(num_leaves) - level]);

            always @*
                if (valid_i == 1'b0)
                    d= `VOID;
                else if (&addr_xnor_addr_i == 1'b1) begin
                    if (addr_i[$clog2(num_leaves)-1 - level] == 1'b0)
                        d= `LEFT;
                    else
                        d= `RIGHT;
                end
                else if (&addr_xnor_addr_i == 1'b0)
                    d= `UP;
                else
                    d= `VOID;
        end
    endgenerate
endmodule



module interface (
    input clk, 
    input reset, 
    input [p_sz-1:0] bus_i,
    output reg [p_sz-1:0] bus_o, 
    input [p_sz-1:0] pe_interface,
    output reg [p_sz-1:0] interface_pe,
    output resend
    );

    parameter num_leaves= 2;
    parameter payload_sz= 1;
    parameter addr= 1'b0;
    parameter p_sz= 1 + $clog2(num_leaves) + payload_sz; //packet size

    wire accept_packet;
    wire send_packet;
    assign accept_packet= bus_i[p_sz-1] && (bus_i[p_sz-2:payload_sz] == addr);
    assign send_packet= !(bus_i[p_sz-1] && addr != bus_i[p_sz-2:payload_sz]);

    always @(posedge clk) begin
    //    cache_o <= pe_interface;
        if (reset)
            {interface_pe, bus_o} <= 0;
        else begin
            if (accept_packet) interface_pe <= bus_i;
            else interface_pe <= 0;
            
            if (send_packet) begin            
                bus_o <=  pe_interface;   
            end
            else begin
                bus_o <= bus_i;
            end
       end
   end
    
endmodule

module pipe_ff (
    input clk, 
    input reset, 
    input [data_width-1:0] din,
    output reg [data_width-1:0] dout 
    );

    parameter data_width= 2;


    always @(posedge clk) begin
        if (reset)
            dout <= 0;
        else
            dout <=din;
    end
    
endmodule

module SynFIFO (
    clk,
    rst_n,
    rdata, 
    wfull, 
    rempty, 
    wdata,
    winc, 
    rinc
    );
    
parameter DSIZE = 8;
parameter ASIZE = 2;
parameter MEMDEPTH = 1<<ASIZE;


output [DSIZE-1:0] rdata;
output wfull;
output rempty;

input [DSIZE-1:0] wdata;
input winc, rinc, clk, rst_n;

reg [ASIZE:0] wptr;
reg [ASIZE:0] rptr;
reg [DSIZE-1:0] ex_mem [0:MEMDEPTH-1];

wire wfull_r;
wire [ASIZE:0] wptr_1;

//always @(posedge clk or negedge rst_n)
//    if (!rst_n) wptr <= 0;
//    else if (winc && !wfull_r) begin
//        ex_mem[wptr[ASIZE-1:0]] <= wdata;
//        wptr <= wptr+1;
//    end



blk_mem_gen_0 your_instance_name (
  .clka(clk),    // input wire clka
  .ena(1'b1),      // input wire ena
  .wea(winc && !wfull_r),      // input wire [0 : 0] wea
  .addra(wptr[ASIZE-1:0]),  // input wire [1 : 0] addra
  .dina(wdata),    // input wire [96 : 0] dina
  .douta(),  // output wire [96 : 0] douta
  .clkb(clk),    // input wire clkb
  .enb(1'b1),      // input wire enb
  .web(1'b0),      // input wire [0 : 0] web
  .addrb(rptr[ASIZE-1:0]),  // input wire [1 : 0] addrb
  .dinb(0),    // input wire [96 : 0] dinb
  .doutb(rdata)  // output wire [96 : 0] doutb
);


always @(posedge clk or negedge rst_n)
    if (!rst_n) rptr <= 0;
    else if (rinc && !rempty) rptr <= rptr+1;

assign wptr_1 = wptr + 1;    
//assign rdata = ex_mem[rptr[ASIZE-1:0]];
assign rempty = (rptr == wptr);
assign wfull = ((wptr_1[ASIZE-1:0] == rptr[ASIZE-1:0]) && (wptr_1[ASIZE] != rptr[ASIZE]) && winc) || wfull_r;
assign wfull_r = (wptr[ASIZE-1:0] == rptr[ASIZE-1:0]) && (wptr[ASIZE] != rptr[ASIZE]);
endmodule

`define PI_SWITCH

module pi_arbiter(
    input [1:0] d_l,
    input [1:0] d_r,
    input [1:0] d_ul,
    input [1:0] d_ur,
    input random,
    output reg rand_gen,
    output reg [1:0] sel_l,
    output reg [1:0] sel_r,
    output [1:0] sel_ul,
    output [1:0] sel_ur
    );
    
    parameter level= 1;
    /*
    *    d_l, d_r, d_u designate where the specific packet from a 
    *    certain direction would like to (ideally) go.
    *    d_{l,r,u{l,r}}=00, non-valid packet. 
    *   d_{l,r,u{l,r}}=01, packet should go left.
    *    d_{l,r,u{l,r}}=10, packet should go right.
       *    d_{l,r,u{l,r}}=11, packet should go up.
    */

    reg [1:0] sel_u1;
    reg [1:0] sel_u2;

    assign sel_ul= random ? sel_u1 : sel_u2;
    assign sel_ur= random ? sel_u2 : sel_u1;

        
    // temp var just used to determine how to route non-valid packets
    reg [3:0] is_void; 

    always @* begin
        is_void= 4'b1111; // local var, order is L, R, U1, U2;
    
        rand_gen= 0;

        // First Priority: Turnback Packets
        if (d_l == `LEFT)
            {sel_l, is_void[3]}= {`LEFT, 1'b0};
        if (d_r == `RIGHT)
            {sel_r, is_void[2]}= {`RIGHT, 1'b0};
        if (d_ul == `UP)
            {sel_u1, is_void[1]}= {`UPL, 1'b0};
        if (d_ur == `UP)
            {sel_u2, is_void[0]}= {`UPR, 1'b0};

        // Second Priority: Downlinks
        // Left Downlink
        if (d_ul == `LEFT || d_ur == `LEFT) begin
            if (is_void[3]) begin
                is_void[3]= 1'b0;
                if (d_ul == `LEFT && d_ur != `LEFT)
                    sel_l= `UPL;
                else if (d_ul != `LEFT && d_ur == `LEFT)
                    sel_l= `UPR;
                else if (d_ul == `LEFT && d_ur == `LEFT) begin
                    is_void[1]= 1'b0;
                    {sel_l, sel_u1}= {`UPL, `UPR};
                end
            end
            else begin
                if (d_ul == `LEFT) begin
                    is_void[1]= 1'b0;
                    sel_u1= `UPL;
                end
                if (d_ur == `LEFT) begin
                    is_void[0]= 1'b0;
                    sel_u2= `UPR;
                end
            end
        end

        // Right Downlink
        if (d_ul == `RIGHT || d_ur == `RIGHT) begin
            if (is_void[2]) begin
                is_void[2]= 1'b0;
                if (d_ul == `RIGHT && d_ur != `RIGHT)
                    sel_r= `UPL;
                else if (d_ul != `RIGHT && d_ur == `RIGHT)
                    sel_r= `UPR;
                else if (d_ul == `RIGHT && d_ur == `RIGHT) begin
                    is_void[1]= 1'b0;
                    {sel_r, sel_u1}= {`UPL, `UPR};
                end
            end
            else begin
                if (d_ul == `RIGHT) begin
                    is_void[1]= 1'b0;
                    sel_u1= `UPL;
                end
                if (d_ur == `RIGHT) begin
                    is_void[0]= 1'b0;
                    sel_u2= `UPR;
                end
            end
        end


        // Third Priority: Side Link
        // Left to Right (Left has priority over Right)
        if (d_l == `RIGHT) begin
            if (is_void[2]) begin
                is_void[2]= 1'b0;
                sel_r= `LEFT;
            end
            else if (is_void[3]) begin
                is_void[3]= 1'b0;
                sel_l= `LEFT;
            end
            else if (is_void[1]) begin
                is_void[1]= 1'b0;
                sel_u1= `LEFT;
            end
            else if (is_void[0]) begin
                is_void[0]= 1'b0;
                sel_u2= `LEFT;
            end
        end

        // Right to Left
        if (d_r == `LEFT) begin
            if (is_void[3]) begin
                is_void[3]= 1'b0;
                sel_l= `RIGHT;
            end
            else if (is_void[2]) begin
                is_void[2]= 1'b0;
                sel_r= `RIGHT;
            end
            else if (is_void[1]) begin
                is_void[1]= 1'b0;
                sel_u1= `RIGHT;
            end
            else if (is_void[0]) begin
                is_void[0]= 1'b0;
                sel_u2= `RIGHT;
            end
        end
        // Fourth Priority: Uplinks
        // Left to Up
        if (d_l == `UP) begin
            if (is_void[1]) begin
                is_void[1]= 1'b0;
                sel_u1= `LEFT;
            end
            else if (is_void[0]) begin
                is_void[0]= 1'b0;
                sel_u2= `LEFT;
            end
            else if (is_void[3]) begin
                is_void[3]= 1'b0;
                sel_l= `LEFT;
            end
            else if (is_void[2]) begin
                is_void[2]= 1'b0;
                sel_r= `LEFT;
            end
        end
        // Right to UP
        if (d_r == `UP) begin
            if (is_void[1]) begin
                is_void[1]= 1'b0;
                sel_u1= `RIGHT;
            end
            else if (is_void[0]) begin
                is_void[0]= 1'b0;
                sel_u2= `RIGHT;
            end
            else if (is_void[2]) begin
                is_void[2]= 1'b0;
                sel_r= `RIGHT;
            end
            else if (is_void[3]) begin
                is_void[3]= 1'b0;
                sel_l= `RIGHT;
            end
        end

        // Before taking care of void case, determine whether or not a new
        // random/toggle bit should be generated
        if (is_void[1] == 1'b0 || is_void[0] == 1'b0)
            rand_gen= 1;

        // Final Priority: Void 
        if (d_l == `VOID) begin
            if (is_void[3]) begin
                is_void[3]= 1'b0;
                sel_l= `LEFT;
            end
            if (is_void[2]) begin
                is_void[2]= 1'b0;
                sel_r= `LEFT;
            end
            if (is_void[1]) begin
                is_void[1]= 1'b0;
                sel_u1= `LEFT;
            end
            if (is_void[0]) begin
                is_void[0]= 1'b0;
                sel_u2= `LEFT;
            end
        end
        if (d_r == `VOID) begin
            if (is_void[3]) begin
                is_void[3]= 1'b0;
                sel_l= `RIGHT;
            end
            if (is_void[2]) begin
                is_void[2]= 1'b0;
                sel_r= `RIGHT;
            end
            if (is_void[1]) begin
                is_void[1]= 1'b0;
                sel_u1= `RIGHT;
            end
            if (is_void[0]) begin
                is_void[0]= 1'b0;
                sel_u2= `RIGHT;
            end
        end
        if (d_ul == `VOID) begin
            if (is_void[3]) begin
                is_void[3]= 1'b0;
                sel_l= `UPL;
            end
            if (is_void[2]) begin
                is_void[2]= 1'b0;
                sel_r= `UPL;
            end
            if (is_void[1]) begin
                is_void[1]= 1'b0;
                sel_u1= `UPL;
            end
            if (is_void[0]) begin
                is_void[0]= 1'b0;
                sel_u2= `UPL;
            end
        end
        if (d_ur == `VOID) begin
            if (is_void[3]) begin
                is_void[3]= 1'b0;
                sel_l= `UPR;
            end
            if (is_void[2]) begin
                is_void[2]= 1'b0;
                sel_r= `UPR;
            end
            if (is_void[1]) begin
                is_void[1]= 1'b0;
                sel_u1= `UPR;
            end
            if (is_void[0]) begin
                is_void[0]= 1'b0;
                sel_u2= `UPR;
            end
        end
    end

endmodule


module pi_cluster (
    input clk,
    input reset,
    input [num_switches*p_sz-1:0] l_bus_i,
    input [num_switches*p_sz-1:0] r_bus_i,
    input [2*num_switches*p_sz-1:0] u_bus_i,
    output [num_switches*p_sz-1:0] l_bus_o,
    output [num_switches*p_sz-1:0] r_bus_o,
    output [2*num_switches*p_sz-1:0] u_bus_o
    );
    // Override these values in top modules
    parameter num_leaves= 2;
    parameter payload_sz= 1;
    parameter addr= 1'b0;
    parameter level= 1; // only change if level == 0
    parameter p_sz= 1+$clog2(num_leaves)+payload_sz; //packet size
    parameter num_switches= 1;

    wire [num_switches*p_sz-1:0] ul_bus_i;
    wire [num_switches*p_sz-1:0] ur_bus_i;
    wire [num_switches*p_sz-1:0] ul_bus_o;
    wire [num_switches*p_sz-1:0] ur_bus_o;
    
    assign {ul_bus_i, ur_bus_i} = u_bus_i;
    assign u_bus_o= {ul_bus_o, ur_bus_o};
    genvar i;
    generate
    for (i= 0; i < num_switches; i= i + 1) begin
        pi_switch #(
            .num_leaves(num_leaves),
            .payload_sz(payload_sz),
            .addr(addr),
            .level(level),
            .p_sz(p_sz))
            ps (
                .clk(clk),
                .reset(reset),
                .l_bus_i(l_bus_i[i*p_sz+:p_sz]),
                .r_bus_i(r_bus_i[i*p_sz+:p_sz]),
                .ul_bus_i(ul_bus_i[i*p_sz+:p_sz]),
                .ur_bus_i(ur_bus_i[i*p_sz+:p_sz]),
                .l_bus_o(l_bus_o[i*p_sz+:p_sz]),
                .r_bus_o(r_bus_o[i*p_sz+:p_sz]),
                .ul_bus_o(ul_bus_o[i*p_sz+:p_sz]),
                .ur_bus_o(ur_bus_o[i*p_sz+:p_sz]));
    end
    endgenerate
endmodule    


module pi_switch (
    input clk,
    input reset,
    input [p_sz-1:0] l_bus_i,
    input [p_sz-1:0] r_bus_i,
    input [p_sz-1:0] ul_bus_i,
    input [p_sz-1:0] ur_bus_i,
    output reg [p_sz-1:0] l_bus_o,
    output reg [p_sz-1:0] r_bus_o,
    output reg [p_sz-1:0] ul_bus_o,
    output reg [p_sz-1:0] ur_bus_o
    );
    // Override these values in top modules
    parameter num_leaves= 2;
    parameter payload_sz= 1;
    parameter addr= 1'b0;
    parameter level= 0; // only change if level == 0
    parameter p_sz= 1+$clog2(num_leaves)+payload_sz; //packet size
    
    // bus has following structure: 1 bit [valid], logN bits [dest_addr],
    // M bits [payload]
    
    wire [1:0] d_l;
    wire [1:0] d_r;
    wire [1:0] d_ul;
    wire [1:0] d_ur;
        wire [1:0] d_l_p0;
    wire [1:0] d_r_p0;
    wire [1:0] d_ul_p0;
    wire [1:0] d_ur_p0;
    wire [1:0] sel_l;
    wire [1:0] sel_r;
    wire [1:0] sel_ul;
    wire [1:0] sel_ur;

    wire [1:0] sel_l_p0;
    wire [1:0] sel_r_p0;
    wire [1:0] sel_ul_p0;
    wire [1:0] sel_ur_p0;


    reg random;
    wire rand_gen;

        wire [p_sz-1:0] l_bus_i_p0;
    wire [p_sz-1:0] r_bus_i_p0;
    wire [p_sz-1:0] ul_bus_i_p0;
    wire [p_sz-1:0] ur_bus_i_p0;

        wire [p_sz-1:0] l_bus_i_p1;
    wire [p_sz-1:0] r_bus_i_p1;
    wire [p_sz-1:0] ul_bus_i_p1;
    wire [p_sz-1:0] ur_bus_i_p1;

    pipe_ff #(
        .data_width(p_sz)
        )pipe_ff_inst_l_bus_i_p0(
        .clk(clk),
        .din(l_bus_i),
        .dout(l_bus_i_p0));

    pipe_ff #(
        .data_width(p_sz)
        )pipe_ff_inst_r_bus_i_p0(
        .clk(clk),
        .din(r_bus_i),
        .dout(r_bus_i_p0));

    pipe_ff #(
        .data_width(p_sz)
        )pipe_ff_inst_ul_bus_i_p0(
        .clk(clk),
        .din(ul_bus_i),
        .dout(ul_bus_i_p0));

    pipe_ff #(
        .data_width(p_sz)
        )pipe_ff_inst_ur_bus_i_p0(
        .clk(clk),
        .din(ur_bus_i),
        .dout(ur_bus_i_p0));



    pipe_ff #(
        .data_width(p_sz)
        )pipe_ff_inst_l_bus_i_p1(
        .clk(clk),
        .din(l_bus_i_p0),
        .dout(l_bus_i_p1));

    pipe_ff #(
        .data_width(p_sz)
        )pipe_ff_inst_r_bus_i_p1(
        .clk(clk),
        .din(r_bus_i_p0),
        .dout(r_bus_i_p1));

    pipe_ff #(
        .data_width(p_sz)
        )pipe_ff_inst_ul_bus_i_p1(
        .clk(clk),
        .din(ul_bus_i_p0),
        .dout(ul_bus_i_p1));

    pipe_ff #(
        .data_width(p_sz)
        )pipe_ff_inst_ur_bus_i_p1(
        .clk(clk),
        .din(ur_bus_i_p0),
        .dout(ur_bus_i_p1));


    pipe_ff #(
        .data_width(2)
        )pipe_ff_inst_d_l_p0(
        .clk(clk),
        .din(d_l),
        .dout(d_l_p0));

    pipe_ff #(
        .data_width(2)
        )pipe_ff_inst_d_r_p0(
        .clk(clk),
        .din(d_r),
        .dout(d_r_p0));

    pipe_ff #(
        .data_width(2)
        )pipe_ff_inst_d_ul_p0(
        .clk(clk),
        .din(d_ul),
        .dout(d_ul_p0));

    pipe_ff #(
        .data_width(2)
        )pipe_ff_inst_d_ur_p0(
        .clk(clk),
        .din(d_ur),
        .dout(d_ur_p0));


    pipe_ff #(
        .data_width(2)
        )pipe_ff_inst_sel_l_p0(
        .clk(clk),
        .din(sel_l),
        .dout(sel_l_p0));

    pipe_ff #(
        .data_width(2)
        )pipe_ff_inst_sel_r_p0(
        .clk(clk),
        .din(sel_r),
        .dout(sel_r_p0));
    pipe_ff #(
        .data_width(2)
        )pipe_ff_inst_sel_ul_p0(
        .clk(clk),
        .din(sel_ul),
        .dout(sel_ul_p0));
    pipe_ff #(
        .data_width(2)
        )pipe_ff_inst_sel_ur_p0(
        .clk(clk),
        .din(sel_ur),
        .dout(sel_ur_p0));





    direction_determiner #(.num_leaves(num_leaves), 
                            .addr(addr),
                            .level(level)) 
                            dd_l(
                            .valid_i(l_bus_i[p_sz-1]),
                            .addr_i(l_bus_i[p_sz-2:payload_sz]), 
                            .d(d_l));

    direction_determiner #(.num_leaves(num_leaves), 
                            .addr(addr),
                            .level(level)) 
                            dd_r(
                            .valid_i(r_bus_i[p_sz-1]),
                            .addr_i(r_bus_i[p_sz-2:payload_sz]), 
                            .d(d_r));

    direction_determiner #(.num_leaves(num_leaves), 
                            .addr(addr),
                            .level(level))
                               dd_ul(
                            .valid_i(ul_bus_i[p_sz-1]),
                            .addr_i(ul_bus_i[p_sz-2:payload_sz]),
                            .d(d_ul));

    direction_determiner #(.num_leaves(num_leaves), 
                            .addr(addr),
                            .level(level))
                               dd_ur(
                            .valid_i(ur_bus_i[p_sz-1]),
                            .addr_i(ur_bus_i[p_sz-2:payload_sz]),
                            .d(d_ur));
    always @(posedge clk)
        if (reset)
            random <= 1'b0;
        else if (rand_gen)
            random <= ~random;
                        
    pi_arbiter #(
                .level(level))
                pi_a(
                    .d_l(d_l_p0),
                    .d_r(d_r_p0),
                       .d_ul(d_ul_p0),
                       .d_ur(d_ur_p0),
                       .sel_l(sel_l),
                       .sel_r(sel_r),
                       .sel_ul(sel_ul),
                       .sel_ur(sel_ur),
                    .random(random),
                    .rand_gen(rand_gen));

    always @(posedge clk)
        if (reset)
            {l_bus_o, r_bus_o, ul_bus_o, ur_bus_o} <= 0;
        else begin
            case (sel_l_p0)
                `LEFT: l_bus_o<= l_bus_i_p1;
                `RIGHT: l_bus_o<= r_bus_i_p1;
                `UPL: l_bus_o<= ul_bus_i_p1;
                `UPR: l_bus_o<= ur_bus_i_p1;
            endcase
        
            case (sel_r_p0)
                `LEFT: r_bus_o<= l_bus_i_p1;
                `RIGHT: r_bus_o<= r_bus_i_p1;
                `UPL: r_bus_o<= ul_bus_i_p1;
                `UPR: r_bus_o<= ur_bus_i_p1;
            endcase
            
            case (sel_ul_p0)
                `LEFT: ul_bus_o <= l_bus_i_p1;
                `RIGHT: ul_bus_o <= r_bus_i_p1;
                `UPL: ul_bus_o <= ul_bus_i_p1;
                `UPR: ul_bus_o <= ur_bus_i_p1;
            endcase

            case (sel_ur_p0)
                `LEFT: ur_bus_o <= l_bus_i_p1;
                `RIGHT: ur_bus_o <= r_bus_i_p1;
                `UPL: ur_bus_o <= ul_bus_i_p1;
                `UPR: ur_bus_o <= ur_bus_i_p1;
            endcase

        end
endmodule    


module t_arbiter(
    input [1:0] d_l,
    input [1:0] d_r,
    input [1:0] d_u,
    output reg [1:0] sel_l,
    output reg [1:0] sel_r,
    output reg [1:0] sel_u
    );
    
    parameter level= 1;
    /*
    *    d_l, d_r, d_u designate where the specific packet from a certain
    *    direction would like to (ideally go).
    *    d_{l,r,u}=00, non-valid packet. 
    *   d_{l,r,u}=01, packet should go left.
    *    d_{l,r,u}=10, packet should go right.
       *    d_{l,r,u}=11, packet should go up.
    */

    generate
        if (level == 0)
            always @* begin
                sel_l= `VOID;
                sel_r= `VOID;
                sel_u= `VOID;
                if (d_l == `LEFT)
                    sel_l= `LEFT;
                if (d_r == `RIGHT)
                    sel_r= `RIGHT;
                if (sel_l == `VOID && d_r == `LEFT)
                    sel_l= `RIGHT;
                                if (sel_l == `LEFT && d_r == `LEFT)
                    sel_r= `RIGHT;
                if (sel_r == `VOID && d_l == `RIGHT)
                    sel_r= `LEFT;
                if (sel_r == `RIGHT && d_l == `RIGHT)
                    sel_l= `LEFT;
            end
        else 
            /* 
            * select lines are for the MUX's that actually route the packets to the
            `UP* neighboring nodes. 
            */
            always @* begin
                sel_l= `VOID;
                sel_r= `VOID;
                sel_u= `VOID;
                // First Priority: Turnback (When a packet has already been deflected
                // and needs to turn back within one level)
                if (d_l == `LEFT)
                    sel_l= `LEFT;
                if (d_r == `RIGHT)
                    sel_r= `RIGHT;
                if (d_u == `UP)
                    sel_u= `UP;
                // Second Priority: Downlinks (When a packet wants to go from Up to
                // Left or Right-- must check if bus is already used by Turnbacked
                // packets)
                else if (d_u == `LEFT)
                    if (d_l != `LEFT)
                        sel_l= `UP;
                    // If left bus is already used by turnback packet, deflect up
                    // packet back up
                    else
                        sel_u= `UP;
                else if (d_u == `RIGHT)
                    if (d_r != `RIGHT)
                        sel_r= `UP;
                    // If right bus is already used by turnback packet, deflect up
                    // packet back up
                    else
                        sel_u= `UP;
                // Third Priority: `UP/Side Link
                // Left to Right
                if (d_l == `RIGHT)
                    // if right bus is not already used by either a turnback packet or
                    // a downlink packet, send left packet there
                    if (sel_r == `VOID)
                        sel_r= `LEFT;
                    // otherwise, deflect left packet 
                        // If downlink is already using left bus, deflect packet up
                    else if (d_u == `LEFT)
                        sel_u= `LEFT;
                        // Last remaining option is deflection in direction of arrival
                        // (must be correct, via deduction)
                    else
                        sel_l= `LEFT;
                // Left to Up
                else if (d_l == `UP)
                    // if up bus is not occupied by turnback packet, send uplink up
                    if (sel_u == `VOID)
                        sel_u= `LEFT;
                    // otherwise, deflect left packet
                    // deflect back in direction of arrival if possible
                    else if (sel_l == `VOID)
                        sel_l= `LEFT;
                    // otherwise, deflect to the right
                    else
                        sel_r= `LEFT;
                // Right to Left
                if (d_r == `LEFT)
                    // if left bus is not occupied by turnback packet or downlink
                    // paket, send right packet there
                    if (sel_l == `VOID)
                        sel_l= `RIGHT;
                    // otherwise, deflect packet
                    else if (sel_r == `VOID)
                        sel_r= `RIGHT;
                    else
                        sel_u= `RIGHT;
                // Right to Up
                else if (d_r == `UP)
                    // if up bus is not occupied by turnback packet or other uplink
                    // packet, send right uplink packet up
                    if (sel_u == `VOID)
                        sel_u= `RIGHT;
                    // else deflect right packet
                    else if (sel_r == `VOID)
                        sel_r= `RIGHT;
                    // last possible option is to send packet to the left
                    else
                        sel_l= `RIGHT;
                `ifdef OPTIMIZED
                // Makes exception to when left and right packets swap, up packet gets
                // deflected up
                if (d_l == `RIGHT && d_r == `LEFT && d_u != `VOID) begin
                    sel_l= `RIGHT;
                    sel_r= `LEFT;
                    sel_u= `UP;
                end
                `endif
            end
    endgenerate
endmodule


module t_cluster (
    input clk,
    input reset,
    input [num_switches*p_sz-1:0] l_bus_i,
    input [num_switches*p_sz-1:0] r_bus_i,
    input [num_switches*p_sz-1:0] u_bus_i,
    output [num_switches*p_sz-1:0] l_bus_o,
    output [num_switches*p_sz-1:0] r_bus_o,
    output [num_switches*p_sz-1:0] u_bus_o
    );
    // Override these values in top modules
    parameter num_leaves= 2;
    parameter payload_sz= 1;
    parameter addr= 1'b0;
    //parameter level= $bits(addr); // only change if level == 0
        parameter level= 15;
    parameter p_sz= 1+$clog2(num_leaves)+payload_sz; //packet size
    parameter num_switches= 1;

    genvar i;
    generate
    for (i= 0; i < num_switches; i= i + 1) begin
        t_switch #(
            .num_leaves(num_leaves),
            .payload_sz(payload_sz),
            .addr(addr),
            .level(level),
            .p_sz(p_sz))
            ts (
                .clk(clk),
                .reset(reset),
                .l_bus_i(l_bus_i[i*p_sz+:p_sz]),
                .r_bus_i(r_bus_i[i*p_sz+:p_sz]),
                .u_bus_i(u_bus_i[i*p_sz+:p_sz]),
                .l_bus_o(l_bus_o[i*p_sz+:p_sz]),
                .r_bus_o(r_bus_o[i*p_sz+:p_sz]),
                .u_bus_o(u_bus_o[i*p_sz+:p_sz]));
    end
    endgenerate
endmodule    

module t_switch (
    input clk,
    input reset,
    input [p_sz-1:0] l_bus_i,
    input [p_sz-1:0] r_bus_i,
    input [p_sz-1:0] u_bus_i,
    output reg [p_sz-1:0] l_bus_o,
    output reg [p_sz-1:0] r_bus_o,
    output reg [p_sz-1:0] u_bus_o
    );
    // Override these values in top modules
    parameter num_leaves= 2;
    parameter payload_sz= 1;
    parameter addr= 1'b0;
    parameter level= 15; // only change if level == 0
    parameter p_sz= 1+$clog2(num_leaves)+payload_sz; //packet size
    
    // bus has following structure: 1 bit [valid], logN bits [dest_addr],
    // M bits [payload]
    
    wire [1:0] d_l;
    wire [1:0] d_r;
    wire [1:0] d_u;
        wire [1:0] d_l_p0;
    wire [1:0] d_r_p0;
    wire [1:0] d_u_p0;
    wire [1:0] sel_l;
    wire [1:0] sel_r;
    wire [1:0] sel_u;
    wire [1:0] sel_l_p0;
    wire [1:0] sel_r_p0;
    wire [1:0] sel_u_p0;


        wire [p_sz-1:0] l_bus_i_p0;
    wire [p_sz-1:0] r_bus_i_p0;
    wire [p_sz-1:0] u_bus_i_p0;

        wire [p_sz-1:0] l_bus_i_p1;
    wire [p_sz-1:0] r_bus_i_p1;
    wire [p_sz-1:0] u_bus_i_p1;

    pipe_ff #(
        .data_width(p_sz)
        )pipe_ff_inst_l_bus_i_p0(
        .clk(clk),
        .din(l_bus_i),
        .dout(l_bus_i_p0));
    pipe_ff #(
        .data_width(p_sz)
        )pipe_ff_inst_r_bus_i_p0(
        .clk(clk),
        .din(r_bus_i),
        .dout(r_bus_i_p0));
    pipe_ff #(
        .data_width(p_sz)
        )pipe_ff_inst_u_bus_i_p0(
        .clk(clk),
        .din(u_bus_i),
        .dout(u_bus_i_p0));
//

    pipe_ff #(
        .data_width(p_sz)
        )pipe_ff_inst_l_bus_i_p1(
        .clk(clk),
        .din(l_bus_i_p0),
        .dout(l_bus_i_p1));
    pipe_ff #(
        .data_width(p_sz)
        )pipe_ff_inst_r_bus_i_p1(
        .clk(clk),
        .din(r_bus_i_p0),
        .dout(r_bus_i_p1));
    pipe_ff #(
        .data_width(p_sz)
        )pipe_ff_inst_u_bus_i_p1(
        .clk(clk),
        .din(u_bus_i_p0),
        .dout(u_bus_i_p1));
//

    pipe_ff #(
        .data_width(2)
        )pipe_ff_inst_d_l_p0(
        .clk(clk),
        .din(d_l),
        .dout(d_l_p0));

    pipe_ff #(
        .data_width(2)
        )pipe_ff_inst_d_r_p0(
        .clk(clk),
        .din(d_r),
        .dout(d_r_p0));

    pipe_ff #(
        .data_width(2)
        )pipe_ff_inst_d_u_p0(
        .clk(clk),
        .din(d_u),
        .dout(d_u_p0));

//


    pipe_ff #(
        .data_width(2)
        )pipe_ff_inst_sel_l_p0(
        .clk(clk),
        .din(sel_l),
        .dout(sel_l_p0));

    pipe_ff #(
        .data_width(2)
        )pipe_ff_inst_sel_r_p0(
        .clk(clk),
        .din(sel_r),
        .dout(sel_r_p0));
    pipe_ff #(
        .data_width(2)
        )pipe_ff_inst_sel_u_p0(
        .clk(clk),
        .din(sel_u),
        .dout(sel_u_p0));



    direction_determiner #(.num_leaves(num_leaves), 
                            .addr(addr),
                            .level(level)) 
                            dd_l(
                            .valid_i(l_bus_i[p_sz-1]),
                            .addr_i(l_bus_i[p_sz-2:payload_sz]), 
                            .d(d_l));

    direction_determiner #(.num_leaves(num_leaves), 
                            .addr(addr),
                            .level(level)) 
                            dd_r(
                            .valid_i(r_bus_i[p_sz-1]),
                            .addr_i(r_bus_i[p_sz-2:payload_sz]), 
                            .d(d_r));

    direction_determiner #(.num_leaves(num_leaves), 
                            .addr(addr),
                            .level(level))
                               dd_u(
                            .valid_i(u_bus_i[p_sz-1]),
                            .addr_i(u_bus_i[p_sz-2:payload_sz]),
                            .d(d_u));

                        
    t_arbiter #(.level(level))
    t_a(d_l_p0, d_r_p0, d_u_p0, sel_l, sel_r, sel_u);

    always @(posedge clk)
        if (reset)
            {l_bus_o, r_bus_o, u_bus_o} <= 0;
        else begin
            case (sel_l_p0)
                `VOID: l_bus_o<= 0;
                `LEFT: l_bus_o<= l_bus_i_p1;
                `RIGHT: l_bus_o<= r_bus_i_p1;
                `UP: l_bus_o<= u_bus_i_p1;
            endcase
        
            case (sel_r_p0)
                `VOID: r_bus_o<= 0;
                `LEFT: r_bus_o<= l_bus_i_p1;
                `RIGHT: r_bus_o<= r_bus_i_p1;
                `UP: r_bus_o<= u_bus_i_p1;
            endcase
            
            case (sel_u_p0)
                `VOID: u_bus_o <= 0;
                `LEFT: u_bus_o <= l_bus_i_p1;
                `RIGHT: u_bus_o <= r_bus_i_p1;
                `UP: u_bus_o <= u_bus_i_p1;
            endcase
        end
endmodule

module pe_stream #(
    parameter integer p_sz = 97,
    parameter integer p_load = 93
    )(
    input clk_bft,
    input clk_axi,
    input rst_n,
    input resend,
    input [p_sz-1:0] interface_pe,
    output [p_sz-1:0] pe_interface
    );
    
wire [p_sz-1:0] comp_in;
wire [p_sz-1:0] comp_out;

reg rd_en_in;
wire empty_in;
wire [p_sz-1:0] dout_in;

fifo_generator_0 fifo_in (
  .rst(~rst_n),        // input wire rst
  .wr_clk(clk_bft),  // input wire wr_clk
  .rd_clk(clk_axi),  // input wire rd_clk
  .din(interface_pe),        // input wire [96 : 0] din
  .wr_en(interface_pe[p_sz-1]),    // input wire wr_en
  .rd_en(rd_en_in),    // input wire rd_en
  .dout(dout_in),      // output wire [96 : 0] dout
  .full(),      // output wire full
  .empty(empty_in)    // output wire empty
);

always@(posedge clk_axi or negedge rst_n)
begin
    if(!rst_n)
        rd_en_in <=0;
    else
        rd_en_in <= ~empty_in;
end

reg [p_sz-1:0] din_out;
reg valid;
reg [2:0] addr;
reg [92:0] payload;

always@(posedge clk_axi or negedge rst_n)
begin
    if(!rst_n)
        din_out <=0;
    else
    begin
        valid <= dout_in[p_sz-1];
        addr <= dout_in[p_sz-2:p_sz-4]+1;
        payload <= dout_in[p_sz-5:0]+1;
        din_out <= {valid, addr, payload};
    end
        
end

reg rd_en_out;
wire empty_out;

fifo_generator_0 fifo_out (
  .rst(~rst_n),        // input wire rst
  .wr_clk(clk_axi),  // input wire wr_clk
  .rd_clk(clk_bft),  // input wire rd_clk
  .din(din_out),        // input wire [96 : 0] din
  .wr_en(din_out[p_sz-1]),    // input wire wr_en
  .rd_en(rd_en_out),    // input wire rd_en
  .dout(pe_interface),      // output wire [96 : 0] dout
  .full(),      // output wire full
  .empty(empty_out)    // output wire empty
);

always@(posedge clk_bft or negedge rst_n)
begin
    if(!rst_n)
        rd_en_out <=0;
    else
        rd_en_out <= ~empty_out;
end

endmodule   
        
    module toggle_dect #(
    parameter integer data_width = 8
)
(
    output [data_width-1:0]data_out,
    input [data_width-1:0] data_in,
    input clk,
    input rst_n
);

    reg [data_width-1:0] data_in_1;
    reg [data_width-1:0] data_in_2;
    
    always@(posedge clk or negedge rst_n) begin 
        if(!rst_n) begin
            {data_in_2, data_in_1} = 0;
        end else begin
            {data_in_2, data_in_1} = {data_in_1, data_in};
        end
    end
        
    assign data_out = data_in_2 ^ data_in_1;

endmodule
