/**
# AXI4-Lite Protocol Bus Interface #

Implements an AXI4-Lite bus interface.
*/
interface axi4_lite_if
#(
    parameter N_BYTES    = 4,   ///< Number of bytes in bus (4 or 8)
    parameter ADDR_WIDTH = 12   ///< Width of address signals
)
(
    input logic ACLK, ///< Global clock signal
    input logic ARESETn ///< Global reset signal, active LOW
);

/**************************************************************************/
// AXI4 Write Address Channel
/**************************************************************************/

logic    [ADDR_WIDTH-1:0] AWADDR;   ///< Write address
logic               [2:0] AWPROT;   ///< Protection type
logic                     AWVALID;  ///< Write address valid
logic                     AWREADY;  ///< Write address ready

/**************************************************************************/
// AXI4 Write Data Channel
/**************************************************************************/

logic    [8*N_BYTES-1:0] WDATA;  ///< Write data
logic      [N_BYTES-1:0] WSTRB;  ///< Write strobes
logic                    WVALID; ///< Write valid
logic                    WREADY; ///< Write ready

/**************************************************************************/
// AXI4 Write Response Channel
/**************************************************************************/

logic              [1:0] BRESP;  ///< Write response
logic                    BVALID; ///< Write response valid
logic                    BREADY; ///< Response ready

/**************************************************************************/
// AXI4 Read Address Channel
/**************************************************************************/

logic    [ADDR_WIDTH-1:0] ARADDR;   ///< Read address
logic               [2:0] ARPROT;   ///< Protection type
logic                     ARVALID;  ///< Read address valid
logic                     ARREADY;  ///< Read address ready

/**************************************************************************/
// AXI4 Read Data Channel
/**************************************************************************/

logic    [8*N_BYTES-1:0] RDATA;  ///< Read data
logic              [1:0] RRESP;  ///< Read response
logic                    RVALID; ///< Read valid
logic                    RREADY; ///< Read ready

// AXI4 Interface Master
modport master (
    // Global Signals
    input  ACLK,
    input  ARESETn,
    // Write Address Channel
    output AWADDR,
    output AWPROT,
    output AWVALID,
    input  AWREADY,
    // Write Data Channel
    output WDATA,
    output WSTRB,
    output WVALID,
    input  WREADY,
    // Write Response Channel
    input  BRESP,
    input  BVALID,
    output BREADY,
    // Read Address Channel
    output ARADDR,
    output ARPROT,
    output ARVALID,
    input  ARREADY,
    // Read Data Channel
    input  RDATA,
    input  RRESP,
    input  RVALID,
    output RREADY
);

// AXI4 Interface Slave
modport slave (
    // Global Signals
    input  ACLK,
    input  ARESETn,
    // Write Address Channel
    input  AWADDR,
    input  AWPROT,
    input  AWVALID,
    output AWREADY,
    // Write Data Channel
    input  WDATA,
    input  WSTRB,
    input  WVALID,
    output WREADY,
    // Write Response Channel
    output BRESP,
    output BVALID,
    input  BREADY,
    // Read Address Channel
    input  ARADDR,
    input  ARPROT,
    input  ARVALID,
    output ARREADY,
    // Read Data Channel
    output RDATA,
    output RRESP,
    output RVALID,
    input  RREADY
);

/**
# AXI Tester #

Used for testing AXI4-Lite slaves.

Using a given address and random data, write & read...

1. Normally
2. Twice with no deassertion of AWVALID or WVALID
3. With AWVALID before WVALID
4. With WVALID before AWVALID
5. With BREADY at start
6. Twice with no deassertion of ARVALID 
7. With RREADY at start
8. Using each byte enable separately

*/

/**************************************************************************/
// Initialize Master Bus
/**************************************************************************/
task InitializeMaster ();
begin
    AWADDR  = '0;
    AWPROT  = '0;
    AWVALID = '0;
    WDATA   = '0;
    WSTRB   = '0;
    WVALID  = '0;
    BREADY  = '0;
    ARADDR  = '0;
    ARPROT  = '0;
    ARVALID = '0;
    RREADY  = '0;
end
endtask

/**************************************************************************/
// Write
/**************************************************************************/
task Write (
    input logic [ADDR_WIDTH-1:0] address,
    input logic [8*N_BYTES-1:0] data,
    input logic [3:0] strobes,
    output logic success
);

integer i;

begin
    @(posedge ACLK)
    AWADDR = address;
    AWPROT = 3'b000;
    AWVALID = 1'b1;
    WDATA = data;
    WSTRB = strobes;
    WVALID = 1'b1;
    success = 1'b1;
    fork : timeoutBlock
        begin
            i = 0;
            while (i < 32) #1 @(posedge ACLK) i++;
            success = 1'b0;
            $display("AXI Write Timeout");
        end
        begin
            fork
                begin
                    wait(AWREADY);
                    @(posedge ACLK) AWVALID = 1'b0;
                end
                begin
                    wait(WREADY);
                    @(posedge ACLK) WVALID = 1'b0;
                end
            join
            wait(BVALID);
            @(posedge ACLK) BREADY = 1'b1;
            @(posedge ACLK) BREADY = 1'b0;
        end
    join_any
    disable timeoutBlock;
    AWVALID = 1'b0;
    WVALID = 1'b0;
    BREADY = 1'b0;
end
endtask

/**************************************************************************/
// Read
/**************************************************************************/
task Read (
    input logic [ADDR_WIDTH-1:0] address,
    output logic [8*N_BYTES-1:0] data,
    output logic success
);

integer i;

begin
    @(posedge ACLK)
    ARADDR = address;
    ARPROT = 3'b000;
    ARVALID = 1'b1;
    success = 1'b1;
    fork : timeoutBlock
        begin
            i = 0;
            while (i < 32) #1 @(posedge ACLK) i++;
            success = 1'b0;
            $display("AXI Read Timeout");
        end
        begin
            wait(ARREADY);
            @(posedge ACLK) ARVALID = 1'b0;
            wait(RVALID);
            @(posedge ACLK) RREADY = 1'b1;
            @(posedge ACLK) RREADY = 1'b0;
        end
    join_any
    disable timeoutBlock;
    data = RDATA;
    ARVALID = 1'b0;
    RREADY = 1'b0;
end
endtask

/**************************************************************************/
// TestNormal
/**************************************************************************/
task TestNormal (
    input logic [ADDR_WIDTH-1:0] address,
    output logic pass
);

logic [8*N_BYTES-1:0] testData;
logic [8*N_BYTES-1:0] recvData;
logic success;

begin
    testData = $random();
    pass = 1'b1;
    Write(address, testData, 4'hF, success);
    pass &= success;
    Read(address, recvData, success);
    pass &= success;

    $display("Received: %x", recvData);

    if (testData != recvData) pass = 1'b0;
end
endtask

/**************************************************************************/
// TestDoubleWrite
/**************************************************************************/
task TestDoubleWrite;
endtask;

/**************************************************************************/
// TestAwValidFirst
/**************************************************************************/
task TestAwValidFirst;
endtask

/**************************************************************************/
// TestWValidFirst
/**************************************************************************/
task TestWValidFirst;
endtask

/**************************************************************************/
// TestBReadySet
/**************************************************************************/
task TestBReadySet;
endtask

/**************************************************************************/
// TestDoubleRead
/**************************************************************************/
task TestDoubleRead;
endtask

/**************************************************************************/
// TestRReady
/**************************************************************************/
task TestRReady;
endtask

/**************************************************************************/
// TestByteEnables
/**************************************************************************/
task TestByteEnables;
endtask

/**************************************************************************/
// TestDoubleWrite
/**************************************************************************/
task TestAll;
endtask

endinterface
