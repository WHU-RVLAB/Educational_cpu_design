 /*                                                                      
 Copyright 2022-2022 School of Physics and Technology， Wuhan University                
                                                                         
 Licensed under the Apache License, Version 2.0 (the "License");         
 you may not use this file except in compliance with the License.        
 You may obtain a copy of the License at                                 
                                                                         
     http://www.apache.org/licenses/LICENSE-2.0                          
                                                                         
  Unless required by applicable law or agreed to in writing, software    
 distributed under the License is distributed on an "AS IS" BASIS,       
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and     
 limitations under the License.                                          
 */      

`include "core_defines.v"

module core #(
    /*parameters*/
) (
    /*external_signals*/
    //instruction_fetch_signals
    output [`CPU_PC_SIZE-1:0]    ifu_pc_addr,
    input  [`CPU_INSTR_SIZE-1:0] ifu_instr_fetched,

    /*basic_signals*/
    input clk,
    input rst_n
);

/*inter_reg_signals*/
wire [`CPU_PC_SIZE-1:0]       if2id_pc,
wire [`CPU_INSTR_SIZE-1:0]    if2id_instr,
wire [`CPU_PC_SIZE-1:0]       id2ex_pc,
wire [`CPU_INSTR_SIZE-1:0]    id2ex_instr,
wire [`CPU_RFIDX_WIDTH-1:0]   id2ex_rs1_idx,
wire [`CPU_RFIDX_WIDTH-1:0]   id2ex_rs2_idx,
wire [`CPU_RFIDX_WIDTH-1:0]   id2ex_rsd_idx,
wire [`CPU_XLEN-1:0]          id2ex_rs1_data,
wire [`CPU_XLEN-1:0]          id2ex_rs2_data,
wire [`CPU_PC_SIZE-1:0]       ex2mem_pc,
wire [`CPU_INSTR_SIZE-1:0]    ex2mem_instr,
wire [`CPU_RFIDX_WIDTH-1:0]   ex2mem_rs1_idx,
wire [`CPU_RFIDX_WIDTH-1:0]   ex2mem_rs2_idx,
wire [`CPU_RFIDX_WIDTH-1:0]   ex2mem_rsd_idx,
wire [`CPU_XLEN-1:0]          ex2mem_rs1_data,
wire [`CPU_XLEN-1:0]          ex2mem_rs2_data,
wire [`CPU_XLEN-1:0]          ex2mem_rsd_data,
wire [`CPU_PC_SIZE-1:0]       mem2wb_pc,
wire [`CPU_INSTR_SIZE-1:0]    mem2wb_instr,
wire [`CPU_RFIDX_WIDTH-1:0]   mem2wb_rs1_idx,
wire [`CPU_RFIDX_WIDTH-1:0]   mem2wb_rs2_idx,
wire [`CPU_RFIDX_WIDTH-1:0]   mem2wb_rsd_idx,
wire [`CPU_XLEN-1:0]          mem2wb_rs1_data,
wire [`CPU_XLEN-1:0]          mem2wb_rs2_data,
wire [`CPU_XLEN-1:0]          mem2wb_rsd_data,


core_ifu u_core_ifu(
    .pc_addr          (ifu_pc_addr       ),
    .instr_fetched    (ifu_instr_fetched ),
    .pc_o             (if2id_pc          ),
    .instr_o          (if2id_instr       ),

    .clk              (clk           ),
    .rst_n            (rst_n         )
);


core_idu u_core_idu(
    .pc_i             (if2id_pc         ),
    .instr_i          (if2id_instr      ),

    .pc_o             (id2ex_pc         ),
    .instr_o          (id2ex_instr      ),
    .rs1_idx_o        (id2ex_rs1_idx    ),
    .rs2_idx_o        (id2ex_rs2_idx    ),
    .rsd_idx_o        (id2ex_rsd_idx    ),
    .rs1_data_o       (id2ex_rs1_data   ),
    .rs2_data_o       (id2ex_rs2_data   ),

    .clk              (clk        ),
    .rst_n            (rst_n      )
);


core_exu u_core_exu(
    .pc_i             (id2ex_pc         ),
    .instr_i          (id2ex_instr      ),
    .rs1_idx_i        (id2ex_rs1_idx    ),
    .rs2_idx_i        (id2ex_rs2_idx    ),
    .rsd_idx_i        (id2ex_rsd_idx    ),
    .rs1_data_i       (id2ex_rs1_data   ),
    .rs2_data_i       (id2ex_rs2_data   ),

    .pc_o             (ex2mem_pc       ),
    .instr_o          (ex2mem_instr    ),
    .rs1_idx_o        (ex2mem_rs1_idx  ),
    .rs2_idx_o        (ex2mem_rs2_idx  ),
    .rsd_idx_o        (ex2mem_rsd_idx  ),
    .rs1_data_o       (ex2mem_rs1_data ),
    .rs2_data_o       (ex2mem_rs2_data ),
    .rsd_data_o       (ex2mem_rsd_data ),

    .clk              (clk        ),
    .rst_n            (rst_n      )
);

core_mem u_core_mem(
    .pc_i             (ex2mem_pc         ),
    .instr_i          (ex2mem_instr      ),
    .rs1_idx_i        (ex2mem_rs1_idx    ),
    .rs2_idx_i        (ex2mem_rs2_idx    ),
    .rsd_idx_i        (ex2mem_rsd_idx    ),
    .rs1_data_i       (ex2mem_rs1_data   ),
    .rs2_data_i       (ex2mem_rs2_data   ),
    .rsd_data_i       (ex2mem_rsd_data   ),

    .pc_o             (mem2wb_pc         ),
    .instr_o          (mem2wb_instr      ),
    .rs1_idx_o        (mem2wb_rs1_idx    ),
    .rs2_idx_o        (mem2wb_rs2_idx    ),
    .rsd_idx_o        (mem2wb_rsd_idx    ),
    .rs1_data_o       (mem2wb_rs1_data   ),
    .rs2_data_o       (mem2wb_rs2_data   ),
    .rsd_data_o       (mem2wb_rsd_data   ),

    .clk              (clk        ),
    .rst_n            (rst_n      )
);

core_wb u_core_wb(
    .pc_i             (mem2wb_pc         ),
    .instr_i          (mem2wb_instr      ),
    .rs1_idx_i        (mem2wb_rs1_idx    ),
    .rs2_idx_i        (mem2wb_rs2_idx    ),
    .rsd_idx_i        (mem2wb_rsd_idx    ),
    .rs1_data_i       (mem2wb_rs1_data   ),
    .rs2_data_i       (mem2wb_rs2_data   ),
    .rsd_data_i       (mem2wb_rsd_data   ),

    .clk              (clk        ),
    .rst_n            (rst_n      )
);

core_regfile u_core_regfile(

    .clk              (clk   ),
    .rst_n            (rst_n )
);


    
endmodule