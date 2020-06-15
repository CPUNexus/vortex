`ifndef VX_DEFINE
`define VX_DEFINE

`include "VX_config.vh"

// `define QUEUE_FORCE_MLAB 1
// `define SYN 1
// `define ASIC 1
// `define SYN_FUNC 1

///////////////////////////////////////////////////////////////////////////////

`ifndef NDEBUG
    `define DEBUG_BLOCK(x) /* verilator lint_off UNUSED */ \
                           x \
                           /* verilator lint_on UNUSED */
`else
    `define DEBUG_BLOCK(x)
`endif

`define DEBUG_BEGIN /* verilator lint_off UNUSED */ 

`define DEBUG_END   /* verilator lint_on UNUSED */     

`define IGNORE_WARNINGS_BEGIN /* verilator lint_off UNUSED */ \
                              /* verilator lint_off PINCONNECTEMPTY */ \
                              /* verilator lint_off DECLFILENAME */

`define IGNORE_WARNINGS_END   /* verilator lint_on UNUSED */ \
                              /* verilator lint_on PINCONNECTEMPTY */ \
                              /* verilator lint_on DECLFILENAME */

`define UNUSED_VAR(x) /* verilator lint_off UNUSED */ \
                      wire [$bits(x)-1:0] __``x``__ = x; \
                      /* verilator lint_on UNUSED */

`define UNUSED_PIN(x)  /* verilator lint_off PINCONNECTEMPTY */ \
                       . x () \
                       /* verilator lint_on PINCONNECTEMPTY */

`define STRINGIFY(x) `"x`"

`define STATIC_ASSERT(cond, msg)    \
    generate                        \
        if (!(cond)) $error(msg);   \
    endgenerate

`define CLOG2(x)    $clog2(x)
`define FLOG2(x)    ($clog2(x) - (((1 << $clog2(x)) > (x)) ? 1 : 0))
`define LOG2UP(x)   (((x) > 1) ? $clog2(x) : 1)
`define ISPOW2(x)   (((x) != 0) && (0 == ((x) & ((x) - 1))))

`define MIN(x, y)   ((x < y) ? (x) : (y))
`define MAX(x, y)   ((x > y) ? (x) : (y))

`define UP(x)       (((x) > 0) ? x : 1)

///////////////////////////////////////////////////////////////////////////////

`define NW_BITS     `LOG2UP(`NUM_WARPS)

`define NT_BITS     `LOG2UP(`NUM_THREADS)

`define NC_BITS     `LOG2UP(`NUM_CORES)

`define REQS_BITS   `LOG2UP(NUM_REQUESTS)

`define NUM_GPRS    32

`define CSR_ADDR_SIZE 12

`define CSR_WIDTH   12

///////////////////////////////////////////////////////////////////////////////

`define BYTE_EN_NO      3'h7 
`define BYTE_EN_SB      3'h0 
`define BYTE_EN_SH      3'h1
`define BYTE_EN_SW      3'h2
`define BYTE_EN_UB      3'h4
`define BYTE_EN_UH      3'h5
`define BYTE_EN_BITS    3

///////////////////////////////////////////////////////////////////////////////

`define INST_R      7'd051
`define INST_L      7'd003
`define INST_ALU    7'd019
`define INST_S      7'd035
`define INST_B      7'd099
`define INST_LUI    7'd055
`define INST_AUIPC  7'd023
`define INST_JAL    7'd111
`define INST_JALR   7'd103
`define INST_SYS    7'd115
`define INST_GPGPU  7'd107

`define RS2_IMMED   1
`define RS2_REG     0

`define BR_NO       3'h0
`define BR_EQ       3'h1
`define BR_NE       3'h2
`define BR_LT       3'h3
`define BR_GT       3'h4
`define BR_LTU      3'h5
`define BR_GTU      3'h6

`define ALU_NO      5'd15
`define ALU_ADD     5'd00
`define ALU_SUB     5'd01
`define ALU_SLLA    5'd02
`define ALU_SLT     5'd03
`define ALU_SLTU    5'd04
`define ALU_XOR     5'd05
`define ALU_SRL     5'd06
`define ALU_SRA     5'd07
`define ALU_OR      5'd08
`define ALU_AND     5'd09
`define ALU_SUBU    5'd10
`define ALU_LUI     5'd11
`define ALU_AUIPC   5'd12
`define ALU_CSR_RW  5'd13
`define ALU_CSR_RS  5'd14
`define ALU_CSR_RC  5'd15
`define ALU_MUL     5'd16
`define ALU_MULH    5'd17
`define ALU_MULHSU  5'd18
`define ALU_MULHU   5'd19
`define ALU_DIV     5'd20
`define ALU_DIVU    5'd21
`define ALU_REM     5'd22
`define ALU_REMU    5'd23

`define WB_NO       2'h0
`define WB_ALU      2'h1
`define WB_MEM      2'h2
`define WB_JAL      2'h3

///////////////////////////////////////////////////////////////////////////////

`ifndef NDEBUG                    // pc,  wb, rd, warp_num
`define DEBUG_CORE_REQ_MDATA_WIDTH  (32 + 2 + 5 + `NW_BITS)
`else
`define DEBUG_CORE_REQ_MDATA_WIDTH  0
`endif

////////////////////////// Dcache Configurable Knobs //////////////////////////

// Cache ID
`define DCACHE_ID           (((`L3_ENABLE && `L2_ENABLE) ? 2 : `L2_ENABLE ? 1 : 0) + (CORE_ID * 3) + 0)

// TAG sharing enable       
`define DCORE_TAG_ID_BITS   `LOG2UP(`DCREQ_SIZE)

// Core request tag bits
`define DCORE_TAG_WIDTH     (`DEBUG_CORE_REQ_MDATA_WIDTH + `DCORE_TAG_ID_BITS)
 
// DRAM request data bits
`define DDRAM_LINE_WIDTH    (`DBANK_LINE_SIZE * 8)

// DRAM request address bits
`define DDRAM_ADDR_WIDTH    (32 - `CLOG2(`DBANK_LINE_SIZE))

// DRAM byte enable bits
`define DDRAM_BYTEEN_WIDTH  `DBANK_LINE_SIZE

// DRAM request tag bits
`define DDRAM_TAG_WIDTH     `DDRAM_ADDR_WIDTH

// Number of Word requests per cycle {1, 2, 4, 8, ...}
`define DNUM_REQUESTS       `NUM_THREADS

// Snoop request tag bits
`define DSNP_TAG_WIDTH      ((`NUM_CORES > 1) ? `LOG2UP(`L2SNRQ_SIZE) : `L2SNP_TAG_WIDTH)

////////////////////////// Icache Configurable Knobs //////////////////////////

// Cache ID
`define ICACHE_ID           (((`L3_ENABLE && `L2_ENABLE) ? 2 : `L2_ENABLE ? 1 : 0) + (CORE_ID * 3) + 1)

// Core request address bits
`define ICORE_ADDR_WIDTH    (32-`CLOG2(`IWORD_SIZE))

// Core request byte enable bits
`define ICORE_BYTEEN_WIDTH `DWORD_SIZE

// TAG sharing enable       
`define ICORE_TAG_ID_BITS   `LOG2UP(`ICREQ_SIZE)

// Core request tag bits
`define ICORE_TAG_WIDTH     (`DEBUG_CORE_REQ_MDATA_WIDTH + `ICORE_TAG_ID_BITS)

// DRAM request data bits
`define IDRAM_LINE_WIDTH    (`IBANK_LINE_SIZE * 8)

// DRAM request address bits
`define IDRAM_ADDR_WIDTH    (32 - `CLOG2(`IBANK_LINE_SIZE))

// DRAM byte enable bits
`define IDRAM_BYTEEN_WIDTH  `IBANK_LINE_SIZE

// DRAM request tag bits
`define IDRAM_TAG_WIDTH     `IDRAM_ADDR_WIDTH

// Number of Word requests per cycle {1, 2, 4, 8, ...}
`define INUM_REQUESTS       1

////////////////////////// SM Configurable Knobs //////////////////////////////

// Cache ID
`define SCACHE_ID           (((`L3_ENABLE && `L2_ENABLE) ? 2 : `L2_ENABLE ? 1 : 0) + (CORE_ID * 3) + 3)

// Number of Word requests per cycle {1, 2, 4, 8, ...}
`define SNUM_REQUESTS       `NUM_THREADS

// DRAM request address bits
`define SDRAM_ADDR_WIDTH    (32 - `CLOG2(`SBANK_LINE_SIZE))

// DRAM request tag bits
`define SDRAM_TAG_WIDTH     `SDRAM_ADDR_WIDTH

// Number of Word requests per cycle {1, 2, 4, 8, ...}
`define SNUM_REQUESTS       `NUM_THREADS

////////////////////////// L2cache Configurable Knobs /////////////////////////

// Cache ID
`define L2CACHE_ID          (`L3_ENABLE ? 1 : 0)

// Core request tag bits
`define L2CORE_TAG_WIDTH    (`DCORE_TAG_WIDTH + `CLOG2(`NUM_CORES))

// DRAM request data bits
`define L2DRAM_LINE_WIDTH   (`L2_ENABLE ? (`L2BANK_LINE_SIZE * 8) : `DDRAM_LINE_WIDTH)

// DRAM request address bits
`define L2DRAM_ADDR_WIDTH   (`L2_ENABLE ? (32 - `CLOG2(`L2BANK_LINE_SIZE)) : `DDRAM_ADDR_WIDTH)

// DRAM byte enable bits
`define L2DRAM_BYTEEN_WIDTH (`L2_ENABLE ? `L2BANK_LINE_SIZE : `DDRAM_BYTEEN_WIDTH)

// DRAM request tag bits
`define L2DRAM_TAG_WIDTH    (`L2_ENABLE ? `L2DRAM_ADDR_WIDTH : (`L2DRAM_ADDR_WIDTH+`CLOG2(`NUM_CORES*2)))

// Snoop request tag bits
`define L2SNP_TAG_WIDTH     (`L3_ENABLE ? `LOG2UP(`L3SNRQ_SIZE) : `L3SNP_TAG_WIDTH)

// Number of Word requests per cycle {1, 2, 4, 8, ...}
`define L2NUM_REQUESTS      (2 * `NUM_CORES)

////////////////////////// L3cache Configurable Knobs /////////////////////////

// Cache ID
`define L3CACHE_ID          0

// Core request tag bits
`define L3CORE_TAG_WIDTH    (`L2CORE_TAG_WIDTH + `CLOG2(`NUM_CLUSTERS))

// DRAM request data bits
`define L3DRAM_LINE_WIDTH   (`L3_ENABLE ? (`L3BANK_LINE_SIZE * 8) : `L2DRAM_LINE_WIDTH)

// DRAM request address bits
`define L3DRAM_ADDR_WIDTH   (`L3_ENABLE ? (32 - `CLOG2(`L3BANK_LINE_SIZE)) : `L2DRAM_ADDR_WIDTH)

// DRAM byte enable bits
`define L3DRAM_BYTEEN_WIDTH (`L3_ENABLE ? `L3BANK_LINE_SIZE : `L2DRAM_BYTEEN_WIDTH)

// DRAM request tag bits
`define L3DRAM_TAG_WIDTH    (`L3_ENABLE ? `L3DRAM_ADDR_WIDTH : `L2DRAM_TAG_WIDTH)

// Snoop request tag bits
`define L3SNP_TAG_WIDTH     16 

// Number of Word requests per cycle {1, 2, 4, 8, ...}
`define L3NUM_REQUESTS      `NUM_CLUSTERS

///////////////////////////////////////////////////////////////////////////////

`define VX_DRAM_BYTEEN_WIDTH    `L3DRAM_BYTEEN_WIDTH   
`define VX_DRAM_ADDR_WIDTH      `L3DRAM_ADDR_WIDTH
`define VX_DRAM_LINE_WIDTH      `L3DRAM_LINE_WIDTH
`define VX_DRAM_TAG_WIDTH       `L3DRAM_TAG_WIDTH
`define VX_SNP_TAG_WIDTH        `L3SNP_TAG_WIDTH    
`define VX_CORE_TAG_WIDTH       `DCORE_TAG_WIDTH 

`define DRAM_TO_BYTE_ADDR(x)     {x, (32-$bits(x))'(0)}

///////////////////////////////////////////////////////////////////////////////

`ifdef SCOPE
    `define SCOPE_SIGNALS_DATA_LIST \
        scope_icache_req_addr, \
        scope_icache_req_warp_num, \
        scope_icache_req_tag, \
        scope_icache_rsp_data, \
        scope_icache_rsp_tag, \
        scope_dcache_req_addr, \
        scope_dcache_req_warp_num, \
        scope_dcache_req_tag, \
        scope_dcache_rsp_data, \
        scope_dcache_rsp_tag, \
        scope_dram_req_addr, \
        scope_dram_req_tag, \
        scope_dram_rsp_tag, \
        scope_snp_req_addr, \
        scope_snp_req_invalidate, \
        scope_snp_req_tag, \
        scope_snp_rsp_tag, \
        scope_decode_warp_num, \
        scope_decode_curr_PC, \
        scope_decode_is_jal, \
        scope_decode_rs1, \
        scope_decode_rs2, \
        scope_execute_warp_num, \
        scope_execute_rd, \
        scope_execute_a, \
        scope_execute_b, \
        scope_writeback_warp_num, \
        scope_writeback_wb, \
        scope_writeback_rd, \
        scope_writeback_data,
         
    
    `define SCOPE_SIGNALS_UPD_LIST \
        scope_icache_req_valid, \
        scope_icache_req_ready, \
        scope_icache_rsp_valid, \
        scope_icache_rsp_ready, \
        scope_dcache_req_valid, \
        scope_dcache_req_ready, \
        scope_dcache_rsp_valid, \
        scope_dcache_rsp_ready, \
        scope_dram_req_valid, \
        scope_dram_req_ready, \
        scope_dram_rsp_valid, \
        scope_dram_rsp_ready, \
        scope_snp_req_valid, \
        scope_snp_req_ready, \
        scope_snp_rsp_valid, \
        scope_snp_rsp_ready, \
        scope_decode_valid, \
        scope_execute_valid, \
        scope_writeback_valid, \
        scope_schedule_delay, \
        scope_memory_delay, \
        scope_exec_delay, \
        scope_gpr_stage_delay, \
        scope_busy

    `define SCOPE_SIGNALS_DECL \
        wire scope_icache_req_valid; \
        wire [31:0] scope_icache_req_addr; \
        wire [1:0] scope_icache_req_warp_num; \
        wire [`ICORE_TAG_WIDTH-1:0] scope_icache_req_tag; \
        wire scope_icache_req_ready; \
        wire scope_icache_rsp_valid; \
        wire [31:0] scope_icache_rsp_data; \
        wire [`ICORE_TAG_WIDTH-1:0] scope_icache_rsp_tag; \
        wire scope_icache_rsp_ready; \
        wire [`DNUM_REQUESTS-1:0] scope_dcache_req_valid; \
        wire [31:0] scope_dcache_req_addr; \
        wire [1:0] scope_dcache_req_warp_num; \
        wire [`DCORE_TAG_WIDTH-1:0] scope_dcache_req_tag; \
        wire scope_dcache_req_ready; \
        wire [`DNUM_REQUESTS-1:0] scope_dcache_rsp_valid; \
        wire [31:0] scope_dcache_rsp_data; \
        wire [`DCORE_TAG_WIDTH-1:0] scope_dcache_rsp_tag; \
        wire scope_dcache_rsp_ready; \
        wire scope_dram_req_valid; \
        wire [31:0] scope_dram_req_addr; \
        wire [`VX_DRAM_TAG_WIDTH-1:0] scope_dram_req_tag; \
        wire scope_dram_req_ready; \
        wire scope_dram_rsp_valid; \
        wire [`VX_DRAM_TAG_WIDTH-1:0] scope_dram_rsp_tag; \
        wire scope_dram_rsp_ready; \
        wire scope_snp_req_valid; \
        wire [31:0] scope_snp_req_addr; \
        wire scope_snp_req_invalidate; \
        wire [`VX_SNP_TAG_WIDTH-1:0] scope_snp_req_tag; \
        wire scope_snp_req_ready; \
        wire scope_snp_rsp_valid; \
        wire [`VX_SNP_TAG_WIDTH-1:0] scope_snp_rsp_tag; \
        wire scope_busy; \
        wire scope_snp_rsp_ready; \
        wire scope_schedule_delay; \
        wire scope_memory_delay; \
        wire scope_exec_delay; \
        wire scope_gpr_stage_delay; \
        wire [3:0]  scope_decode_valid; \
        wire [1:0]  scope_decode_warp_num; \
        wire [31:0] scope_decode_curr_PC; \
        wire        scope_decode_is_jal; \
        wire [4:0]  scope_decode_rs1; \
        wire [4:0]  scope_decode_rs2; \
        wire [3:0]  scope_execute_valid; \
        wire [1:0]  scope_execute_warp_num; \
        wire [4:0]  scope_execute_rd; \
        wire [31:0] scope_execute_a; \
        wire [31:0] scope_execute_b; \
        wire [3:0]  scope_writeback_valid; \
        wire [1:0]  scope_writeback_warp_num; \
        wire [1:0]  scope_writeback_wb; \
        wire [4:0]  scope_writeback_rd; \
        wire [31:0] scope_writeback_data;

    `define SCOPE_SIGNALS_ICACHE_IO \
        /* verilator lint_off UNDRIVEN */ \
        output wire scope_icache_req_valid, \
        output wire [31:0] scope_icache_req_addr, \
        output wire [1:0] scope_icache_req_warp_num, \
        output wire [`ICORE_TAG_WIDTH-1:0] scope_icache_req_tag, \
        output wire scope_icache_req_ready, \
        output wire scope_icache_rsp_valid, \
        output wire [31:0] scope_icache_rsp_data, \
        output wire [`ICORE_TAG_WIDTH-1:0] scope_icache_rsp_tag, \
        output wire scope_icache_rsp_ready, \
        /* verilator lint_on UNDRIVEN */

    `define SCOPE_SIGNALS_DCACHE_IO \
        /* verilator lint_off UNDRIVEN */ \
        output wire [`DNUM_REQUESTS-1:0] scope_dcache_req_valid, \
        output wire [31:0] scope_dcache_req_addr, \
        output wire [1:0] scope_dcache_req_warp_num, \
        output wire [`DCORE_TAG_WIDTH-1:0] scope_dcache_req_tag, \
        output wire scope_dcache_req_ready, \
        output wire [`DNUM_REQUESTS-1:0] scope_dcache_rsp_valid, \
        output wire [31:0] scope_dcache_rsp_data, \
        output wire [`DCORE_TAG_WIDTH-1:0] scope_dcache_rsp_tag, \
        output wire scope_dcache_rsp_ready, \
        /* verilator lint_on UNDRIVEN */
        
    `define SCOPE_SIGNALS_DRAM_IO \
        /* verilator lint_off UNDRIVEN */ \
        output wire scope_dram_req_valid, \
        output wire [31:0] scope_dram_req_addr, \
        output wire [`VX_DRAM_TAG_WIDTH-1:0] scope_dram_req_tag, \
        output wire scope_dram_req_ready, \
        output wire scope_dram_rsp_valid, \
        output wire [`VX_DRAM_TAG_WIDTH-1:0] scope_dram_rsp_tag, \
        output wire scope_dram_rsp_ready, \
        /* verilator lint_on UNDRIVEN */

    `define SCOPE_SIGNALS_SNP_IO \
        /* verilator lint_off UNDRIVEN */ \
        output wire scope_snp_req_valid, \
        output wire [31:0] scope_snp_req_addr, \
        output wire scope_snp_req_invalidate, \
        output wire [`VX_SNP_TAG_WIDTH-1:0] scope_snp_req_tag, \
        output wire scope_snp_req_ready, \
        output wire scope_snp_rsp_valid, \
        output wire [`VX_SNP_TAG_WIDTH-1:0] scope_snp_rsp_tag, \
        output wire scope_snp_rsp_ready, \
        /* verilator lint_on UNDRIVEN */

    `define SCOPE_SIGNALS_CORE_IO \
        /* verilator lint_off UNDRIVEN */ \
        output wire scope_busy, \
        output wire scope_schedule_delay, \
        output wire scope_memory_delay, \
        output wire scope_exec_delay, \
        output wire scope_gpr_stage_delay, \
        /* verilator lint_on UNDRIVEN */

    `define SCOPE_SIGNALS_BE_IO \
        /* verilator lint_off UNDRIVEN */ \
        output wire [3:0]  scope_decode_valid, \
        output wire [1:0]  scope_decode_warp_num, \
        output wire [31:0] scope_decode_curr_PC, \
        output wire        scope_decode_is_jal, \
        output wire [4:0]  scope_decode_rs1, \
        output wire [4:0]  scope_decode_rs2, \
        output wire [3:0]  scope_execute_valid, \
        output wire [1:0]  scope_execute_warp_num, \
        output wire [4:0]  scope_execute_rd, \
        output wire [31:0] scope_execute_a, \
        output wire [31:0] scope_execute_b, \
        output wire [3:0]  scope_writeback_valid, \
        output wire [1:0]  scope_writeback_warp_num, \
        output wire [1:0]  scope_writeback_wb, \
        output wire [4:0]  scope_writeback_rd, \
        output wire [31:0] scope_writeback_data,
        /* verilator lint_on UNDRIVEN */

    `define SCOPE_SIGNALS_ICACHE_ATTACH \
        .scope_icache_req_valid (scope_icache_req_valid), \
        .scope_icache_req_addr  (scope_icache_req_addr), \
        .scope_icache_req_warp_num (scope_icache_req_warp_num), \
        .scope_icache_req_tag   (scope_icache_req_tag), \
        .scope_icache_req_ready (scope_icache_req_ready), \
        .scope_icache_rsp_valid (scope_icache_rsp_valid), \
        .scope_icache_rsp_data  (scope_icache_rsp_data), \
        .scope_icache_rsp_tag   (scope_icache_rsp_tag), \
        .scope_icache_rsp_ready (scope_icache_rsp_ready),

    `define SCOPE_SIGNALS_DCACHE_ATTACH \
        .scope_dcache_req_valid (scope_dcache_req_valid), \
        .scope_dcache_req_addr  (scope_dcache_req_addr), \
        .scope_dcache_req_warp_num (scope_dcache_req_warp_num), \
        .scope_dcache_req_tag   (scope_dcache_req_tag), \
        .scope_dcache_req_ready (scope_dcache_req_ready), \
        .scope_dcache_rsp_valid (scope_dcache_rsp_valid), \
        .scope_dcache_rsp_data  (scope_dcache_rsp_data), \
        .scope_dcache_rsp_tag   (scope_dcache_rsp_tag), \
        .scope_dcache_rsp_ready (scope_dcache_rsp_ready),

    `define SCOPE_SIGNALS_DRAM_ATTACH \
        .scope_dram_req_valid   (scope_dram_req_valid), \
        .scope_dram_req_addr    (scope_dram_req_addr), \
        .scope_dram_req_tag     (scope_dram_req_tag), \
        .scope_dram_req_ready   (scope_dram_req_ready), \
        .scope_dram_rsp_valid   (scope_dram_rsp_valid), \
        .scope_dram_rsp_tag     (scope_dram_rsp_tag), \
        .scope_dram_rsp_ready   (scope_dram_rsp_ready),

    `define SCOPE_SIGNALS_SNP_ATTACH \
        .scope_snp_req_valid    (scope_snp_req_valid), \
        .scope_snp_req_addr     (scope_snp_req_addr), \
        .scope_snp_req_invalidate(scope_snp_req_invalidate), \
        .scope_snp_req_tag      (scope_snp_req_tag), \
        .scope_snp_req_ready    (scope_snp_req_ready), \
        .scope_snp_rsp_valid    (scope_snp_rsp_valid), \
        .scope_snp_rsp_tag      (scope_snp_rsp_tag), \
        .scope_snp_rsp_ready    (scope_snp_rsp_ready),

    `define SCOPE_SIGNALS_CORE_ATTACH \
        .scope_busy             (scope_busy), \
        .scope_schedule_delay   (scope_schedule_delay), \
        .scope_memory_delay     (scope_memory_delay), \
        .scope_exec_delay       (scope_exec_delay), \
        .scope_gpr_stage_delay  (scope_gpr_stage_delay),

    `define SCOPE_SIGNALS_BE_ATTACH \
        .scope_decode_valid     (scope_decode_valid), \
        .scope_decode_warp_num  (scope_decode_warp_num), \
        .scope_decode_curr_PC   (scope_decode_curr_PC), \
        .scope_decode_is_jal    (scope_decode_is_jal), \
        .scope_decode_rs1       (scope_decode_rs1), \
        .scope_decode_rs2       (scope_decode_rs2), \
        .scope_execute_valid    (scope_execute_valid), \
        .scope_execute_warp_num (scope_execute_warp_num), \
        .scope_execute_rd       (scope_execute_rd), \
        .scope_execute_a        (scope_execute_a), \
        .scope_execute_b        (scope_execute_b), \
        .scope_writeback_valid  (scope_writeback_valid), \
        .scope_writeback_warp_num (scope_writeback_warp_num), \
        .scope_writeback_wb     (scope_writeback_wb), \
        .scope_writeback_rd     (scope_writeback_rd), \
        .scope_writeback_data   (scope_writeback_data),

    `define SCOPE_ASSIGN(d,s) assign d = s
`else
    `define SCOPE_SIGNALS_ICACHE_IO
    `define SCOPE_SIGNALS_DCACHE_IO
    `define SCOPE_SIGNALS_DRAM_IO
    `define SCOPE_SIGNALS_CORE_IO
    `define SCOPE_SIGNALS_BE_IO

    `define SCOPE_SIGNALS_ICACHE_ATTACH
    `define SCOPE_SIGNALS_DCACHE_ATTACH
    `define SCOPE_SIGNALS_DRAM_ATTACH
    `define SCOPE_SIGNALS_CORE_ATTACH
    `define SCOPE_SIGNALS_BE_ATTACH
    
    `define SCOPE_ASSIGN(d,s)
`endif

 // VX_DEFINE
`endif
