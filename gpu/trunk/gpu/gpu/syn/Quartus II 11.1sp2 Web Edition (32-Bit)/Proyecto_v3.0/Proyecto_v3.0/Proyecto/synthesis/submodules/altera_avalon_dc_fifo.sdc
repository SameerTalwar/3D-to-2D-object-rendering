# $Id: //acds/rel/11.1sp2/ip/sopc/components/altera_avalon_dc_fifo/altera_avalon_dc_fifo.sdc#1 $
# $Revision: #1 $
# $Date: 2011/11/10 $
#-------------------------------------------------------------------------------
# TimeQuest constraints to cut all false timing paths across asynchronous 
# clock domains. The paths are from the Gray Code read and write pointers to
# their respective synchronizer banks.

set_false_path -from [get_registers {*|in_wr_ptr_gray[*]}] -to [get_registers {*|altera_dcfifo_synchronizer_bundle:write_crosser|altera_std_synchronizer:sync[*].u|din_s1}]

set_false_path -from [get_registers {*|out_rd_ptr_gray[*]}] -to [get_registers {*|altera_dcfifo_synchronizer_bundle:read_crosser|altera_std_synchronizer:sync[*].u|din_s1}]

