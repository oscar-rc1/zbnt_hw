
################################################################
# This is a generated script based on design: bd_quad_tgen
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

namespace eval _tcl {
proc get_script_folder {} {
   set script_path [file normalize [info script]]
   set script_folder [file dirname $script_path]
   return $script_folder
}
}
variable script_folder
set script_folder [_tcl::get_script_folder]

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2018.3
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   catch {common::send_msg_id "BD_TCL-109" "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."}

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source bd_quad_tgen_script.tcl

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xc7z020clg484-1
   set_property BOARD_PART em.avnet.com:zed:part0:1.4 [current_project]
}


# CHANGE DESIGN NAME HERE
variable design_name
set design_name bd_quad_tgen

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} eq "" } {
   # USE CASES:
   #    1) Design_name not set

   set errMsg "Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      common::send_msg_id "BD_TCL-001" "INFO" "Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   common::send_msg_id "BD_TCL-002" "INFO" "Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES: 
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   common::send_msg_id "BD_TCL-003" "INFO" "Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   common::send_msg_id "BD_TCL-004" "INFO" "Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

common::send_msg_id "BD_TCL-005" "INFO" "Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   catch {common::send_msg_id "BD_TCL-114" "ERROR" $errMsg}
   return $nRet
}

set bCheckIPsPassed 1
##################################################################
# CHECK IPs
##################################################################
set bCheckIPs 1
if { $bCheckIPs == 1 } {
   set list_check_ips "\ 
xilinx.com:ip:xlconstant:1.1\
xilinx.com:ip:clk_wiz:6.0\
xilinx.com:ip:processing_system7:5.5\
xilinx.com:ip:proc_sys_reset:5.0\
oscar-rc.dev:zbnt_hw:simple_timer:1.0\
xilinx.com:ip:tri_mode_ethernet_mac:9.0\
oscar-rc.dev:zbnt_hw:eth_stats_collector:1.0\
oscar-rc.dev:zbnt_hw:eth_traffic_gen:1.0\
"

   set list_ips_missing ""
   common::send_msg_id "BD_TCL-006" "INFO" "Checking if the following IPs exist in the project's IP catalog: $list_check_ips ."

   foreach ip_vlnv $list_check_ips {
      set ip_obj [get_ipdefs -all $ip_vlnv]
      if { $ip_obj eq "" } {
         lappend list_ips_missing $ip_vlnv
      }
   }

   if { $list_ips_missing ne "" } {
      catch {common::send_msg_id "BD_TCL-115" "ERROR" "The following IPs are not found in the IP Catalog:\n  $list_ips_missing\n\nResolution: Please add the repository containing the IP(s) to the project." }
      set bCheckIPsPassed 0
   }

}

if { $bCheckIPsPassed != 1 } {
  common::send_msg_id "BD_TCL-1003" "WARNING" "Will not continue with creation of design due to the error(s) above."
  return 3
}

##################################################################
# DESIGN PROCs
##################################################################


# Hierarchical cell: eth3
proc create_hier_cell_eth3 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_eth3() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:mdio_rtl:1.0 mdio
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:rgmii_rtl:1.0 rgmii
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 s_axi_mac
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 s_axi_stats
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 s_axi_tgen

  # Create pins
  create_bd_pin -dir I -from 63 -to 0 current_time
  create_bd_pin -dir I -type clk gtx_clk
  create_bd_pin -dir I -type clk gtx_clk90
  create_bd_pin -dir I -type rst rst_n
  create_bd_pin -dir O -from 0 -to 0 s_axi_aresetn
  create_bd_pin -dir O s_axi_clk
  create_bd_pin -dir I time_running

  # Create instance: mac, and set properties
  set mac [ create_bd_cell -type ip -vlnv xilinx.com:ip:tri_mode_ethernet_mac:9.0 mac ]
  set_property -dict [ list \
   CONFIG.Frame_Filter {false} \
   CONFIG.MAC_Speed {1000_Mbps} \
   CONFIG.Make_MDIO_External {false} \
   CONFIG.Management_Frequency {125.00} \
   CONFIG.Number_of_Table_Entries {0} \
   CONFIG.Physical_Interface {RGMII} \
   CONFIG.Statistics_Counters {false} \
   CONFIG.SupportLevel {0} \
 ] $mac

  # Create instance: mac_ifg, and set properties
  set mac_ifg [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 mac_ifg ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
   CONFIG.CONST_WIDTH {8} \
 ] $mac_ifg

  # Create instance: mac_rst, and set properties
  set mac_rst [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 mac_rst ]

  # Create instance: reset, and set properties
  set reset [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 reset ]

  # Create instance: stats, and set properties
  set stats [ create_bd_cell -type ip -vlnv oscar-rc.dev:zbnt_hw:eth_stats_collector:1.0 stats ]

  # Create instance: tgen, and set properties
  set tgen [ create_bd_cell -type ip -vlnv oscar-rc.dev:zbnt_hw:eth_traffic_gen:1.0 tgen ]

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins s_axi_stats] [get_bd_intf_pins stats/S_AXI]
  connect_bd_intf_net -intf_net eth1_mac_mdio_internal [get_bd_intf_pins mdio] [get_bd_intf_pins mac/mdio_internal]
  connect_bd_intf_net -intf_net eth1_mac_rgmii [get_bd_intf_pins rgmii] [get_bd_intf_pins mac/rgmii]
  connect_bd_intf_net -intf_net eth1_tgen_M_AXIS [get_bd_intf_pins mac/s_axis_tx] [get_bd_intf_pins tgen/M_AXIS]
  connect_bd_intf_net -intf_net ps_interconnect_M02_AXI [get_bd_intf_pins s_axi_mac] [get_bd_intf_pins mac/s_axi]
  connect_bd_intf_net -intf_net ps_interconnect_M03_AXI [get_bd_intf_pins s_axi_tgen] [get_bd_intf_pins tgen/S_AXI]

  # Create port connections
  connect_bd_net -net current_time_0_1 [get_bd_pins current_time] [get_bd_pins stats/current_time]
  connect_bd_net -net eth0_mac_gtx_clk90_out [get_bd_pins gtx_clk90] [get_bd_pins mac/gtx_clk90]
  connect_bd_net -net eth0_mac_gtx_clk_out [get_bd_pins gtx_clk] [get_bd_pins mac/gtx_clk]
  connect_bd_net -net eth1_mac_tx_mac_aclk [get_bd_pins s_axi_clk] [get_bd_pins mac/s_axi_aclk] [get_bd_pins mac/tx_mac_aclk] [get_bd_pins reset/slowest_sync_clk] [get_bd_pins stats/clk] [get_bd_pins tgen/clk]
  connect_bd_net -net mac_ifg_dout [get_bd_pins mac/tx_ifg_delay] [get_bd_pins mac_ifg/dout]
  connect_bd_net -net mac_resetn_1 [get_bd_pins rst_n] [get_bd_pins reset/ext_reset_in]
  connect_bd_net -net mac_rst_dout [get_bd_pins mac/glbl_rstn] [get_bd_pins mac/rx_axi_rstn] [get_bd_pins mac/tx_axi_rstn] [get_bd_pins mac_rst/dout]
  connect_bd_net -net mac_rx_mac_aclk [get_bd_pins mac/rx_mac_aclk] [get_bd_pins stats/clk_rx]
  connect_bd_net -net mac_rx_statistics_valid [get_bd_pins mac/rx_statistics_valid] [get_bd_pins stats/rx_stats_valid]
  connect_bd_net -net mac_rx_statistics_vector [get_bd_pins mac/rx_statistics_vector] [get_bd_pins stats/rx_stats_vector]
  connect_bd_net -net mac_tx_statistics_valid [get_bd_pins mac/tx_statistics_valid] [get_bd_pins stats/tx_stats_valid]
  connect_bd_net -net mac_tx_statistics_vector [get_bd_pins mac/tx_statistics_vector] [get_bd_pins stats/tx_stats_vector]
  connect_bd_net -net rst_ps_main_100M_peripheral_aresetn [get_bd_pins s_axi_aresetn] [get_bd_pins mac/s_axi_resetn] [get_bd_pins reset/peripheral_aresetn] [get_bd_pins stats/rst_n] [get_bd_pins tgen/rst_n]
  connect_bd_net -net time_running_0_1 [get_bd_pins time_running] [get_bd_pins stats/time_running] [get_bd_pins tgen/ext_enable]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: eth2
proc create_hier_cell_eth2 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_eth2() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:mdio_rtl:1.0 mdio
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:rgmii_rtl:1.0 rgmii
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 s_axi_mac
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 s_axi_stats
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 s_axi_tgen

  # Create pins
  create_bd_pin -dir I -from 63 -to 0 current_time
  create_bd_pin -dir I -type clk gtx_clk
  create_bd_pin -dir I -type clk gtx_clk90
  create_bd_pin -dir I -type rst rst_n
  create_bd_pin -dir O -from 0 -to 0 s_axi_aresetn
  create_bd_pin -dir O s_axi_clk
  create_bd_pin -dir I time_running

  # Create instance: mac, and set properties
  set mac [ create_bd_cell -type ip -vlnv xilinx.com:ip:tri_mode_ethernet_mac:9.0 mac ]
  set_property -dict [ list \
   CONFIG.Frame_Filter {false} \
   CONFIG.MAC_Speed {1000_Mbps} \
   CONFIG.Make_MDIO_External {false} \
   CONFIG.Management_Frequency {125.00} \
   CONFIG.Number_of_Table_Entries {0} \
   CONFIG.Physical_Interface {RGMII} \
   CONFIG.Statistics_Counters {false} \
   CONFIG.SupportLevel {0} \
 ] $mac

  # Create instance: mac_ifg, and set properties
  set mac_ifg [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 mac_ifg ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
   CONFIG.CONST_WIDTH {8} \
 ] $mac_ifg

  # Create instance: mac_rst, and set properties
  set mac_rst [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 mac_rst ]

  # Create instance: reset, and set properties
  set reset [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 reset ]

  # Create instance: stats, and set properties
  set stats [ create_bd_cell -type ip -vlnv oscar-rc.dev:zbnt_hw:eth_stats_collector:1.0 stats ]

  # Create instance: tgen, and set properties
  set tgen [ create_bd_cell -type ip -vlnv oscar-rc.dev:zbnt_hw:eth_traffic_gen:1.0 tgen ]

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins s_axi_stats] [get_bd_intf_pins stats/S_AXI]
  connect_bd_intf_net -intf_net eth1_mac_mdio_internal [get_bd_intf_pins mdio] [get_bd_intf_pins mac/mdio_internal]
  connect_bd_intf_net -intf_net eth1_mac_rgmii [get_bd_intf_pins rgmii] [get_bd_intf_pins mac/rgmii]
  connect_bd_intf_net -intf_net eth1_tgen_M_AXIS [get_bd_intf_pins mac/s_axis_tx] [get_bd_intf_pins tgen/M_AXIS]
  connect_bd_intf_net -intf_net ps_interconnect_M02_AXI [get_bd_intf_pins s_axi_mac] [get_bd_intf_pins mac/s_axi]
  connect_bd_intf_net -intf_net ps_interconnect_M03_AXI [get_bd_intf_pins s_axi_tgen] [get_bd_intf_pins tgen/S_AXI]

  # Create port connections
  connect_bd_net -net current_time_0_1 [get_bd_pins current_time] [get_bd_pins stats/current_time]
  connect_bd_net -net eth0_mac_gtx_clk90_out [get_bd_pins gtx_clk90] [get_bd_pins mac/gtx_clk90]
  connect_bd_net -net eth0_mac_gtx_clk_out [get_bd_pins gtx_clk] [get_bd_pins mac/gtx_clk]
  connect_bd_net -net eth1_mac_tx_mac_aclk [get_bd_pins s_axi_clk] [get_bd_pins mac/s_axi_aclk] [get_bd_pins mac/tx_mac_aclk] [get_bd_pins reset/slowest_sync_clk] [get_bd_pins stats/clk] [get_bd_pins tgen/clk]
  connect_bd_net -net mac_ifg_dout [get_bd_pins mac/tx_ifg_delay] [get_bd_pins mac_ifg/dout]
  connect_bd_net -net mac_resetn_1 [get_bd_pins rst_n] [get_bd_pins reset/ext_reset_in]
  connect_bd_net -net mac_rst_dout [get_bd_pins mac/glbl_rstn] [get_bd_pins mac/rx_axi_rstn] [get_bd_pins mac/tx_axi_rstn] [get_bd_pins mac_rst/dout]
  connect_bd_net -net mac_rx_mac_aclk [get_bd_pins mac/rx_mac_aclk] [get_bd_pins stats/clk_rx]
  connect_bd_net -net mac_rx_statistics_valid [get_bd_pins mac/rx_statistics_valid] [get_bd_pins stats/rx_stats_valid]
  connect_bd_net -net mac_rx_statistics_vector [get_bd_pins mac/rx_statistics_vector] [get_bd_pins stats/rx_stats_vector]
  connect_bd_net -net mac_tx_statistics_valid [get_bd_pins mac/tx_statistics_valid] [get_bd_pins stats/tx_stats_valid]
  connect_bd_net -net mac_tx_statistics_vector [get_bd_pins mac/tx_statistics_vector] [get_bd_pins stats/tx_stats_vector]
  connect_bd_net -net rst_ps_main_100M_peripheral_aresetn [get_bd_pins s_axi_aresetn] [get_bd_pins mac/s_axi_resetn] [get_bd_pins reset/peripheral_aresetn] [get_bd_pins stats/rst_n] [get_bd_pins tgen/rst_n]
  connect_bd_net -net time_running_0_1 [get_bd_pins time_running] [get_bd_pins stats/time_running] [get_bd_pins tgen/ext_enable]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: eth1
proc create_hier_cell_eth1 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_eth1() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:mdio_rtl:1.0 mdio
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:rgmii_rtl:1.0 rgmii
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 s_axi_mac
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 s_axi_stats
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 s_axi_tgen

  # Create pins
  create_bd_pin -dir I -from 63 -to 0 current_time
  create_bd_pin -dir I -type clk gtx_clk
  create_bd_pin -dir I -type clk gtx_clk90
  create_bd_pin -dir I -type rst rst_n
  create_bd_pin -dir O -from 0 -to 0 s_axi_aresetn
  create_bd_pin -dir O s_axi_clk
  create_bd_pin -dir I time_running

  # Create instance: mac, and set properties
  set mac [ create_bd_cell -type ip -vlnv xilinx.com:ip:tri_mode_ethernet_mac:9.0 mac ]
  set_property -dict [ list \
   CONFIG.Frame_Filter {false} \
   CONFIG.MAC_Speed {1000_Mbps} \
   CONFIG.Make_MDIO_External {false} \
   CONFIG.Management_Frequency {125.00} \
   CONFIG.Number_of_Table_Entries {0} \
   CONFIG.Physical_Interface {RGMII} \
   CONFIG.Statistics_Counters {false} \
   CONFIG.SupportLevel {0} \
 ] $mac

  # Create instance: mac_ifg, and set properties
  set mac_ifg [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 mac_ifg ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
   CONFIG.CONST_WIDTH {8} \
 ] $mac_ifg

  # Create instance: mac_rst, and set properties
  set mac_rst [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 mac_rst ]

  # Create instance: reset, and set properties
  set reset [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 reset ]

  # Create instance: stats, and set properties
  set stats [ create_bd_cell -type ip -vlnv oscar-rc.dev:zbnt_hw:eth_stats_collector:1.0 stats ]

  # Create instance: tgen, and set properties
  set tgen [ create_bd_cell -type ip -vlnv oscar-rc.dev:zbnt_hw:eth_traffic_gen:1.0 tgen ]

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins s_axi_stats] [get_bd_intf_pins stats/S_AXI]
  connect_bd_intf_net -intf_net eth1_mac_mdio_internal [get_bd_intf_pins mdio] [get_bd_intf_pins mac/mdio_internal]
  connect_bd_intf_net -intf_net eth1_mac_rgmii [get_bd_intf_pins rgmii] [get_bd_intf_pins mac/rgmii]
  connect_bd_intf_net -intf_net eth1_tgen_M_AXIS [get_bd_intf_pins mac/s_axis_tx] [get_bd_intf_pins tgen/M_AXIS]
  connect_bd_intf_net -intf_net ps_interconnect_M02_AXI [get_bd_intf_pins s_axi_mac] [get_bd_intf_pins mac/s_axi]
  connect_bd_intf_net -intf_net ps_interconnect_M03_AXI [get_bd_intf_pins s_axi_tgen] [get_bd_intf_pins tgen/S_AXI]

  # Create port connections
  connect_bd_net -net current_time_0_1 [get_bd_pins current_time] [get_bd_pins stats/current_time]
  connect_bd_net -net eth0_mac_gtx_clk90_out [get_bd_pins gtx_clk90] [get_bd_pins mac/gtx_clk90]
  connect_bd_net -net eth0_mac_gtx_clk_out [get_bd_pins gtx_clk] [get_bd_pins mac/gtx_clk]
  connect_bd_net -net eth1_mac_tx_mac_aclk [get_bd_pins s_axi_clk] [get_bd_pins mac/s_axi_aclk] [get_bd_pins mac/tx_mac_aclk] [get_bd_pins reset/slowest_sync_clk] [get_bd_pins stats/clk] [get_bd_pins tgen/clk]
  connect_bd_net -net mac_ifg_dout [get_bd_pins mac/tx_ifg_delay] [get_bd_pins mac_ifg/dout]
  connect_bd_net -net mac_resetn_1 [get_bd_pins rst_n] [get_bd_pins reset/ext_reset_in]
  connect_bd_net -net mac_rst_dout [get_bd_pins mac/glbl_rstn] [get_bd_pins mac/rx_axi_rstn] [get_bd_pins mac/tx_axi_rstn] [get_bd_pins mac_rst/dout]
  connect_bd_net -net mac_rx_mac_aclk [get_bd_pins mac/rx_mac_aclk] [get_bd_pins stats/clk_rx]
  connect_bd_net -net mac_rx_statistics_valid [get_bd_pins mac/rx_statistics_valid] [get_bd_pins stats/rx_stats_valid]
  connect_bd_net -net mac_rx_statistics_vector [get_bd_pins mac/rx_statistics_vector] [get_bd_pins stats/rx_stats_vector]
  connect_bd_net -net mac_tx_statistics_valid [get_bd_pins mac/tx_statistics_valid] [get_bd_pins stats/tx_stats_valid]
  connect_bd_net -net mac_tx_statistics_vector [get_bd_pins mac/tx_statistics_vector] [get_bd_pins stats/tx_stats_vector]
  connect_bd_net -net rst_ps_main_100M_peripheral_aresetn [get_bd_pins s_axi_aresetn] [get_bd_pins mac/s_axi_resetn] [get_bd_pins reset/peripheral_aresetn] [get_bd_pins stats/rst_n] [get_bd_pins tgen/rst_n]
  connect_bd_net -net time_running_0_1 [get_bd_pins time_running] [get_bd_pins stats/time_running] [get_bd_pins tgen/ext_enable]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: eth0
proc create_hier_cell_eth0 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_eth0() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:mdio_io:1.0 mdio
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:rgmii_rtl:1.0 rgmii
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 s_axi_mac
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 s_axi_stats
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 s_axi_tgen

  # Create pins
  create_bd_pin -dir I -from 63 -to 0 current_time
  create_bd_pin -dir I -type clk gtx_clk
  create_bd_pin -dir O -type clk gtx_clk90_out
  create_bd_pin -dir O -type clk gtx_clk_out
  create_bd_pin -dir I -type clk refclk
  create_bd_pin -dir I -type rst rst_n
  create_bd_pin -dir O -from 0 -to 0 s_axi_aresetn
  create_bd_pin -dir O s_axi_clk
  create_bd_pin -dir I time_running

  # Create instance: mac, and set properties
  set mac [ create_bd_cell -type ip -vlnv xilinx.com:ip:tri_mode_ethernet_mac:9.0 mac ]
  set_property -dict [ list \
   CONFIG.Enable_MDIO {true} \
   CONFIG.Frame_Filter {false} \
   CONFIG.MAC_Speed {1000_Mbps} \
   CONFIG.Make_MDIO_External {false} \
   CONFIG.Management_Frequency {125.00} \
   CONFIG.Management_Interface {true} \
   CONFIG.Number_of_Table_Entries {0} \
   CONFIG.Physical_Interface {RGMII} \
   CONFIG.Statistics_Counters {false} \
   CONFIG.SupportLevel {1} \
 ] $mac

  # Create instance: mac_ifg, and set properties
  set mac_ifg [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 mac_ifg ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
   CONFIG.CONST_WIDTH {8} \
 ] $mac_ifg

  # Create instance: mac_rst, and set properties
  set mac_rst [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 mac_rst ]

  # Create instance: reset, and set properties
  set reset [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 reset ]

  # Create instance: stats, and set properties
  set stats [ create_bd_cell -type ip -vlnv oscar-rc.dev:zbnt_hw:eth_stats_collector:1.0 stats ]

  # Create instance: tgen, and set properties
  set tgen [ create_bd_cell -type ip -vlnv oscar-rc.dev:zbnt_hw:eth_traffic_gen:1.0 tgen ]

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins s_axi_stats] [get_bd_intf_pins stats/S_AXI]
  connect_bd_intf_net -intf_net eth0_mac_mdio_internal [get_bd_intf_pins mdio] [get_bd_intf_pins mac/mdio_internal]
  connect_bd_intf_net -intf_net eth0_mac_rgmii [get_bd_intf_pins rgmii] [get_bd_intf_pins mac/rgmii]
  connect_bd_intf_net -intf_net mem_streamer_0_M_AXIS [get_bd_intf_pins mac/s_axis_tx] [get_bd_intf_pins tgen/M_AXIS]
  connect_bd_intf_net -intf_net ps_interconnect_M01_AXI [get_bd_intf_pins s_axi_tgen] [get_bd_intf_pins tgen/S_AXI]
  connect_bd_intf_net -intf_net ps_main_axi_periph_M00_AXI [get_bd_intf_pins s_axi_mac] [get_bd_intf_pins mac/s_axi]

  # Create port connections
  connect_bd_net -net clk_wiz_0_clk_125M1 [get_bd_pins gtx_clk] [get_bd_pins mac/gtx_clk]
  connect_bd_net -net clk_wiz_0_clk_200M [get_bd_pins refclk] [get_bd_pins mac/refclk]
  connect_bd_net -net current_time_0_1 [get_bd_pins current_time] [get_bd_pins stats/current_time]
  connect_bd_net -net eth0_mac_gtx_clk90_out [get_bd_pins gtx_clk90_out] [get_bd_pins mac/gtx_clk90_out]
  connect_bd_net -net eth0_mac_gtx_clk_out [get_bd_pins gtx_clk_out] [get_bd_pins mac/gtx_clk_out]
  connect_bd_net -net eth0_mac_tx_mac_aclk [get_bd_pins s_axi_clk] [get_bd_pins mac/s_axi_aclk] [get_bd_pins mac/tx_mac_aclk] [get_bd_pins reset/slowest_sync_clk] [get_bd_pins stats/clk] [get_bd_pins tgen/clk]
  connect_bd_net -net eth0_tgen_ifg_delay [get_bd_pins mac/tx_ifg_delay] [get_bd_pins mac_ifg/dout]
  connect_bd_net -net mac_rx_mac_aclk [get_bd_pins mac/rx_mac_aclk] [get_bd_pins stats/clk_rx]
  connect_bd_net -net mac_rx_statistics_valid [get_bd_pins mac/rx_statistics_valid] [get_bd_pins stats/rx_stats_valid]
  connect_bd_net -net mac_rx_statistics_vector [get_bd_pins mac/rx_statistics_vector] [get_bd_pins stats/rx_stats_vector]
  connect_bd_net -net mac_tx_statistics_valid [get_bd_pins mac/tx_statistics_valid] [get_bd_pins stats/tx_stats_valid]
  connect_bd_net -net mac_tx_statistics_vector [get_bd_pins mac/tx_statistics_vector] [get_bd_pins stats/tx_stats_vector]
  connect_bd_net -net proc_sys_reset_0_peripheral_aresetn [get_bd_pins s_axi_aresetn] [get_bd_pins mac/s_axi_resetn] [get_bd_pins reset/peripheral_aresetn] [get_bd_pins stats/rst_n] [get_bd_pins tgen/rst_n]
  connect_bd_net -net rst_ps_main_100M_peripheral_aresetn [get_bd_pins rst_n] [get_bd_pins reset/ext_reset_in]
  connect_bd_net -net time_running_0_1 [get_bd_pins time_running] [get_bd_pins stats/time_running] [get_bd_pins tgen/ext_enable]
  connect_bd_net -net xlconstant_0_dout [get_bd_pins mac/glbl_rstn] [get_bd_pins mac/rx_axi_rstn] [get_bd_pins mac/tx_axi_rstn] [get_bd_pins mac_rst/dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}


# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  variable script_folder
  variable design_name

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports
  set DDR [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddrx_rtl:1.0 DDR ]
  set FIXED_IO [ create_bd_intf_port -mode Master -vlnv xilinx.com:display_processing_system7:fixedio_rtl:1.0 FIXED_IO ]
  set ethfmc_p0_mdio [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:mdio_rtl:1.0 ethfmc_p0_mdio ]
  set ethfmc_p0_rgmii [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:rgmii_rtl:1.0 ethfmc_p0_rgmii ]
  set ethfmc_p1_mdio [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:mdio_rtl:1.0 ethfmc_p1_mdio ]
  set ethfmc_p1_rgmii [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:rgmii_rtl:1.0 ethfmc_p1_rgmii ]
  set ethfmc_p2_mdio [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:mdio_rtl:1.0 ethfmc_p2_mdio ]
  set ethfmc_p2_rgmii [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:rgmii_rtl:1.0 ethfmc_p2_rgmii ]
  set ethfmc_p3_mdio [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:mdio_rtl:1.0 ethfmc_p3_mdio ]
  set ethfmc_p3_rgmii [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:rgmii_rtl:1.0 ethfmc_p3_rgmii ]

  # Create ports
  set ethfmc_clk_fsel [ create_bd_port -dir O -from 0 -to 0 ethfmc_clk_fsel ]
  set ethfmc_clk_n [ create_bd_port -dir I -type clk ethfmc_clk_n ]
  set ethfmc_clk_oe [ create_bd_port -dir O -from 0 -to 0 ethfmc_clk_oe ]
  set ethfmc_clk_p [ create_bd_port -dir I -type clk ethfmc_clk_p ]
  set ethfmc_p0_rst [ create_bd_port -dir O -from 0 -to 0 ethfmc_p0_rst ]
  set ethfmc_p1_rst [ create_bd_port -dir O -from 0 -to 0 ethfmc_p1_rst ]
  set ethfmc_p2_rst [ create_bd_port -dir O -from 0 -to 0 ethfmc_p2_rst ]
  set ethfmc_p3_rst [ create_bd_port -dir O -from 0 -to 0 ethfmc_p3_rst ]
  set led [ create_bd_port -dir O -from 7 -to 0 led ]

  # Create instance: constant_1, and set properties
  set constant_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 constant_1 ]

  # Create instance: constant_leds, and set properties
  set constant_leds [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 constant_leds ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {2} \
   CONFIG.CONST_WIDTH {8} \
 ] $constant_leds

  # Create instance: dcm_ethfmc, and set properties
  set dcm_ethfmc [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 dcm_ethfmc ]
  set_property -dict [ list \
   CONFIG.CLKIN1_JITTER_PS {80.0} \
   CONFIG.CLKOUT1_JITTER {119.348} \
   CONFIG.CLKOUT1_PHASE_ERROR {96.948} \
   CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {125.000} \
   CONFIG.CLKOUT2_JITTER {109.241} \
   CONFIG.CLKOUT2_PHASE_ERROR {96.948} \
   CONFIG.CLKOUT2_REQUESTED_OUT_FREQ {200.000} \
   CONFIG.CLKOUT2_USED {true} \
   CONFIG.CLK_OUT1_PORT {clk_125M} \
   CONFIG.CLK_OUT2_PORT {clk_200M} \
   CONFIG.MMCM_CLKFBOUT_MULT_F {8.000} \
   CONFIG.MMCM_CLKIN1_PERIOD {8.000} \
   CONFIG.MMCM_CLKOUT0_DIVIDE_F {8.000} \
   CONFIG.MMCM_CLKOUT1_DIVIDE {5} \
   CONFIG.MMCM_DIVCLK_DIVIDE {1} \
   CONFIG.NUM_OUT_CLKS {2} \
   CONFIG.PRIM_IN_FREQ {125.000} \
   CONFIG.PRIM_SOURCE {Differential_clock_capable_pin} \
   CONFIG.USE_LOCKED {false} \
   CONFIG.USE_RESET {false} \
 ] $dcm_ethfmc

  # Create instance: eth0
  create_hier_cell_eth0 [current_bd_instance .] eth0

  # Create instance: eth1
  create_hier_cell_eth1 [current_bd_instance .] eth1

  # Create instance: eth2
  create_hier_cell_eth2 [current_bd_instance .] eth2

  # Create instance: eth3
  create_hier_cell_eth3 [current_bd_instance .] eth3

  # Create instance: ps_interconnect, and set properties
  set ps_interconnect [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 ps_interconnect ]
  set_property -dict [ list \
   CONFIG.NUM_MI {13} \
 ] $ps_interconnect

  # Create instance: ps_main, and set properties
  set ps_main [ create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7:5.5 ps_main ]
  set_property -dict [ list \
   CONFIG.PCW_ACT_APU_PERIPHERAL_FREQMHZ {666.666687} \
   CONFIG.PCW_ACT_CAN_PERIPHERAL_FREQMHZ {10.000000} \
   CONFIG.PCW_ACT_DCI_PERIPHERAL_FREQMHZ {10.158730} \
   CONFIG.PCW_ACT_ENET0_PERIPHERAL_FREQMHZ {125.000000} \
   CONFIG.PCW_ACT_ENET1_PERIPHERAL_FREQMHZ {10.000000} \
   CONFIG.PCW_ACT_FPGA0_PERIPHERAL_FREQMHZ {125.000000} \
   CONFIG.PCW_ACT_FPGA1_PERIPHERAL_FREQMHZ {10.000000} \
   CONFIG.PCW_ACT_FPGA2_PERIPHERAL_FREQMHZ {10.000000} \
   CONFIG.PCW_ACT_FPGA3_PERIPHERAL_FREQMHZ {10.000000} \
   CONFIG.PCW_ACT_PCAP_PERIPHERAL_FREQMHZ {200.000000} \
   CONFIG.PCW_ACT_QSPI_PERIPHERAL_FREQMHZ {200.000000} \
   CONFIG.PCW_ACT_SDIO_PERIPHERAL_FREQMHZ {50.000000} \
   CONFIG.PCW_ACT_SMC_PERIPHERAL_FREQMHZ {10.000000} \
   CONFIG.PCW_ACT_SPI_PERIPHERAL_FREQMHZ {10.000000} \
   CONFIG.PCW_ACT_TPIU_PERIPHERAL_FREQMHZ {200.000000} \
   CONFIG.PCW_ACT_TTC0_CLK0_PERIPHERAL_FREQMHZ {111.111115} \
   CONFIG.PCW_ACT_TTC0_CLK1_PERIPHERAL_FREQMHZ {111.111115} \
   CONFIG.PCW_ACT_TTC0_CLK2_PERIPHERAL_FREQMHZ {111.111115} \
   CONFIG.PCW_ACT_TTC1_CLK0_PERIPHERAL_FREQMHZ {111.111115} \
   CONFIG.PCW_ACT_TTC1_CLK1_PERIPHERAL_FREQMHZ {111.111115} \
   CONFIG.PCW_ACT_TTC1_CLK2_PERIPHERAL_FREQMHZ {111.111115} \
   CONFIG.PCW_ACT_UART_PERIPHERAL_FREQMHZ {50.000000} \
   CONFIG.PCW_ACT_WDT_PERIPHERAL_FREQMHZ {111.111115} \
   CONFIG.PCW_APU_PERIPHERAL_FREQMHZ {666.666667} \
   CONFIG.PCW_ARMPLL_CTRL_FBDIV {40} \
   CONFIG.PCW_CAN_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_CAN_PERIPHERAL_DIVISOR1 {1} \
   CONFIG.PCW_CAN_PERIPHERAL_FREQMHZ {100} \
   CONFIG.PCW_CLK0_FREQ {125000000} \
   CONFIG.PCW_CLK1_FREQ {10000000} \
   CONFIG.PCW_CLK2_FREQ {10000000} \
   CONFIG.PCW_CLK3_FREQ {10000000} \
   CONFIG.PCW_CPU_CPU_PLL_FREQMHZ {1333.333} \
   CONFIG.PCW_CPU_PERIPHERAL_DIVISOR0 {2} \
   CONFIG.PCW_DCI_PERIPHERAL_DIVISOR0 {15} \
   CONFIG.PCW_DCI_PERIPHERAL_DIVISOR1 {7} \
   CONFIG.PCW_DDRPLL_CTRL_FBDIV {32} \
   CONFIG.PCW_DDR_DDR_PLL_FREQMHZ {1066.667} \
   CONFIG.PCW_DDR_PERIPHERAL_DIVISOR0 {2} \
   CONFIG.PCW_DDR_RAM_HIGHADDR {0x1FFFFFFF} \
   CONFIG.PCW_ENET0_ENET0_IO {MIO 16 .. 27} \
   CONFIG.PCW_ENET0_GRP_MDIO_ENABLE {1} \
   CONFIG.PCW_ENET0_GRP_MDIO_IO {MIO 52 .. 53} \
   CONFIG.PCW_ENET0_PERIPHERAL_DIVISOR0 {8} \
   CONFIG.PCW_ENET0_PERIPHERAL_DIVISOR1 {1} \
   CONFIG.PCW_ENET0_PERIPHERAL_ENABLE {1} \
   CONFIG.PCW_ENET0_PERIPHERAL_FREQMHZ {1000 Mbps} \
   CONFIG.PCW_ENET0_RESET_ENABLE {0} \
   CONFIG.PCW_ENET1_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_ENET1_PERIPHERAL_DIVISOR1 {1} \
   CONFIG.PCW_ENET1_RESET_ENABLE {0} \
   CONFIG.PCW_ENET_RESET_ENABLE {1} \
   CONFIG.PCW_ENET_RESET_SELECT {Share reset pin} \
   CONFIG.PCW_EN_CLK1_PORT {0} \
   CONFIG.PCW_EN_EMIO_TTC0 {1} \
   CONFIG.PCW_EN_ENET0 {1} \
   CONFIG.PCW_EN_GPIO {1} \
   CONFIG.PCW_EN_QSPI {1} \
   CONFIG.PCW_EN_SDIO0 {1} \
   CONFIG.PCW_EN_TTC0 {1} \
   CONFIG.PCW_EN_UART1 {1} \
   CONFIG.PCW_EN_USB0 {1} \
   CONFIG.PCW_FCLK0_PERIPHERAL_DIVISOR0 {4} \
   CONFIG.PCW_FCLK0_PERIPHERAL_DIVISOR1 {2} \
   CONFIG.PCW_FCLK1_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_FCLK1_PERIPHERAL_DIVISOR1 {1} \
   CONFIG.PCW_FCLK2_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_FCLK2_PERIPHERAL_DIVISOR1 {1} \
   CONFIG.PCW_FCLK3_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_FCLK3_PERIPHERAL_DIVISOR1 {1} \
   CONFIG.PCW_FCLK_CLK1_BUF {FALSE} \
   CONFIG.PCW_FPGA0_PERIPHERAL_FREQMHZ {125.000000} \
   CONFIG.PCW_FPGA1_PERIPHERAL_FREQMHZ {200.000000} \
   CONFIG.PCW_FPGA2_PERIPHERAL_FREQMHZ {50} \
   CONFIG.PCW_FPGA_FCLK0_ENABLE {1} \
   CONFIG.PCW_FPGA_FCLK1_ENABLE {0} \
   CONFIG.PCW_FPGA_FCLK2_ENABLE {0} \
   CONFIG.PCW_FPGA_FCLK3_ENABLE {0} \
   CONFIG.PCW_GPIO_MIO_GPIO_ENABLE {1} \
   CONFIG.PCW_GPIO_MIO_GPIO_IO {MIO} \
   CONFIG.PCW_I2C0_GRP_INT_ENABLE {0} \
   CONFIG.PCW_I2C0_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_I2C0_RESET_ENABLE {0} \
   CONFIG.PCW_I2C1_RESET_ENABLE {0} \
   CONFIG.PCW_I2C_PERIPHERAL_FREQMHZ {25} \
   CONFIG.PCW_I2C_RESET_ENABLE {1} \
   CONFIG.PCW_IOPLL_CTRL_FBDIV {30} \
   CONFIG.PCW_IO_IO_PLL_FREQMHZ {1000.000} \
   CONFIG.PCW_MIO_0_DIRECTION {inout} \
   CONFIG.PCW_MIO_0_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_0_PULLUP {disabled} \
   CONFIG.PCW_MIO_0_SLEW {slow} \
   CONFIG.PCW_MIO_10_DIRECTION {inout} \
   CONFIG.PCW_MIO_10_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_10_PULLUP {disabled} \
   CONFIG.PCW_MIO_10_SLEW {slow} \
   CONFIG.PCW_MIO_11_DIRECTION {inout} \
   CONFIG.PCW_MIO_11_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_11_PULLUP {disabled} \
   CONFIG.PCW_MIO_11_SLEW {slow} \
   CONFIG.PCW_MIO_12_DIRECTION {inout} \
   CONFIG.PCW_MIO_12_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_12_PULLUP {disabled} \
   CONFIG.PCW_MIO_12_SLEW {slow} \
   CONFIG.PCW_MIO_13_DIRECTION {inout} \
   CONFIG.PCW_MIO_13_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_13_PULLUP {disabled} \
   CONFIG.PCW_MIO_13_SLEW {slow} \
   CONFIG.PCW_MIO_14_DIRECTION {inout} \
   CONFIG.PCW_MIO_14_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_14_PULLUP {disabled} \
   CONFIG.PCW_MIO_14_SLEW {slow} \
   CONFIG.PCW_MIO_15_DIRECTION {inout} \
   CONFIG.PCW_MIO_15_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_15_PULLUP {disabled} \
   CONFIG.PCW_MIO_15_SLEW {slow} \
   CONFIG.PCW_MIO_16_DIRECTION {out} \
   CONFIG.PCW_MIO_16_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_16_PULLUP {disabled} \
   CONFIG.PCW_MIO_16_SLEW {fast} \
   CONFIG.PCW_MIO_17_DIRECTION {out} \
   CONFIG.PCW_MIO_17_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_17_PULLUP {disabled} \
   CONFIG.PCW_MIO_17_SLEW {fast} \
   CONFIG.PCW_MIO_18_DIRECTION {out} \
   CONFIG.PCW_MIO_18_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_18_PULLUP {disabled} \
   CONFIG.PCW_MIO_18_SLEW {fast} \
   CONFIG.PCW_MIO_19_DIRECTION {out} \
   CONFIG.PCW_MIO_19_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_19_PULLUP {disabled} \
   CONFIG.PCW_MIO_19_SLEW {fast} \
   CONFIG.PCW_MIO_1_DIRECTION {out} \
   CONFIG.PCW_MIO_1_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_1_PULLUP {disabled} \
   CONFIG.PCW_MIO_1_SLEW {fast} \
   CONFIG.PCW_MIO_20_DIRECTION {out} \
   CONFIG.PCW_MIO_20_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_20_PULLUP {disabled} \
   CONFIG.PCW_MIO_20_SLEW {fast} \
   CONFIG.PCW_MIO_21_DIRECTION {out} \
   CONFIG.PCW_MIO_21_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_21_PULLUP {disabled} \
   CONFIG.PCW_MIO_21_SLEW {fast} \
   CONFIG.PCW_MIO_22_DIRECTION {in} \
   CONFIG.PCW_MIO_22_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_22_PULLUP {disabled} \
   CONFIG.PCW_MIO_22_SLEW {fast} \
   CONFIG.PCW_MIO_23_DIRECTION {in} \
   CONFIG.PCW_MIO_23_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_23_PULLUP {disabled} \
   CONFIG.PCW_MIO_23_SLEW {fast} \
   CONFIG.PCW_MIO_24_DIRECTION {in} \
   CONFIG.PCW_MIO_24_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_24_PULLUP {disabled} \
   CONFIG.PCW_MIO_24_SLEW {fast} \
   CONFIG.PCW_MIO_25_DIRECTION {in} \
   CONFIG.PCW_MIO_25_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_25_PULLUP {disabled} \
   CONFIG.PCW_MIO_25_SLEW {fast} \
   CONFIG.PCW_MIO_26_DIRECTION {in} \
   CONFIG.PCW_MIO_26_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_26_PULLUP {disabled} \
   CONFIG.PCW_MIO_26_SLEW {fast} \
   CONFIG.PCW_MIO_27_DIRECTION {in} \
   CONFIG.PCW_MIO_27_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_27_PULLUP {disabled} \
   CONFIG.PCW_MIO_27_SLEW {fast} \
   CONFIG.PCW_MIO_28_DIRECTION {inout} \
   CONFIG.PCW_MIO_28_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_28_PULLUP {disabled} \
   CONFIG.PCW_MIO_28_SLEW {fast} \
   CONFIG.PCW_MIO_29_DIRECTION {in} \
   CONFIG.PCW_MIO_29_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_29_PULLUP {disabled} \
   CONFIG.PCW_MIO_29_SLEW {fast} \
   CONFIG.PCW_MIO_2_DIRECTION {inout} \
   CONFIG.PCW_MIO_2_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_2_PULLUP {disabled} \
   CONFIG.PCW_MIO_2_SLEW {fast} \
   CONFIG.PCW_MIO_30_DIRECTION {out} \
   CONFIG.PCW_MIO_30_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_30_PULLUP {disabled} \
   CONFIG.PCW_MIO_30_SLEW {fast} \
   CONFIG.PCW_MIO_31_DIRECTION {in} \
   CONFIG.PCW_MIO_31_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_31_PULLUP {disabled} \
   CONFIG.PCW_MIO_31_SLEW {fast} \
   CONFIG.PCW_MIO_32_DIRECTION {inout} \
   CONFIG.PCW_MIO_32_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_32_PULLUP {disabled} \
   CONFIG.PCW_MIO_32_SLEW {fast} \
   CONFIG.PCW_MIO_33_DIRECTION {inout} \
   CONFIG.PCW_MIO_33_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_33_PULLUP {disabled} \
   CONFIG.PCW_MIO_33_SLEW {fast} \
   CONFIG.PCW_MIO_34_DIRECTION {inout} \
   CONFIG.PCW_MIO_34_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_34_PULLUP {disabled} \
   CONFIG.PCW_MIO_34_SLEW {fast} \
   CONFIG.PCW_MIO_35_DIRECTION {inout} \
   CONFIG.PCW_MIO_35_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_35_PULLUP {disabled} \
   CONFIG.PCW_MIO_35_SLEW {fast} \
   CONFIG.PCW_MIO_36_DIRECTION {in} \
   CONFIG.PCW_MIO_36_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_36_PULLUP {disabled} \
   CONFIG.PCW_MIO_36_SLEW {fast} \
   CONFIG.PCW_MIO_37_DIRECTION {inout} \
   CONFIG.PCW_MIO_37_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_37_PULLUP {disabled} \
   CONFIG.PCW_MIO_37_SLEW {fast} \
   CONFIG.PCW_MIO_38_DIRECTION {inout} \
   CONFIG.PCW_MIO_38_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_38_PULLUP {disabled} \
   CONFIG.PCW_MIO_38_SLEW {fast} \
   CONFIG.PCW_MIO_39_DIRECTION {inout} \
   CONFIG.PCW_MIO_39_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_39_PULLUP {disabled} \
   CONFIG.PCW_MIO_39_SLEW {fast} \
   CONFIG.PCW_MIO_3_DIRECTION {inout} \
   CONFIG.PCW_MIO_3_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_3_PULLUP {disabled} \
   CONFIG.PCW_MIO_3_SLEW {fast} \
   CONFIG.PCW_MIO_40_DIRECTION {inout} \
   CONFIG.PCW_MIO_40_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_40_PULLUP {disabled} \
   CONFIG.PCW_MIO_40_SLEW {fast} \
   CONFIG.PCW_MIO_41_DIRECTION {inout} \
   CONFIG.PCW_MIO_41_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_41_PULLUP {disabled} \
   CONFIG.PCW_MIO_41_SLEW {fast} \
   CONFIG.PCW_MIO_42_DIRECTION {inout} \
   CONFIG.PCW_MIO_42_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_42_PULLUP {disabled} \
   CONFIG.PCW_MIO_42_SLEW {fast} \
   CONFIG.PCW_MIO_43_DIRECTION {inout} \
   CONFIG.PCW_MIO_43_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_43_PULLUP {disabled} \
   CONFIG.PCW_MIO_43_SLEW {fast} \
   CONFIG.PCW_MIO_44_DIRECTION {inout} \
   CONFIG.PCW_MIO_44_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_44_PULLUP {disabled} \
   CONFIG.PCW_MIO_44_SLEW {fast} \
   CONFIG.PCW_MIO_45_DIRECTION {inout} \
   CONFIG.PCW_MIO_45_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_45_PULLUP {disabled} \
   CONFIG.PCW_MIO_45_SLEW {fast} \
   CONFIG.PCW_MIO_46_DIRECTION {in} \
   CONFIG.PCW_MIO_46_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_46_PULLUP {disabled} \
   CONFIG.PCW_MIO_46_SLEW {slow} \
   CONFIG.PCW_MIO_47_DIRECTION {in} \
   CONFIG.PCW_MIO_47_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_47_PULLUP {disabled} \
   CONFIG.PCW_MIO_47_SLEW {slow} \
   CONFIG.PCW_MIO_48_DIRECTION {out} \
   CONFIG.PCW_MIO_48_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_48_PULLUP {disabled} \
   CONFIG.PCW_MIO_48_SLEW {slow} \
   CONFIG.PCW_MIO_49_DIRECTION {in} \
   CONFIG.PCW_MIO_49_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_49_PULLUP {disabled} \
   CONFIG.PCW_MIO_49_SLEW {slow} \
   CONFIG.PCW_MIO_4_DIRECTION {inout} \
   CONFIG.PCW_MIO_4_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_4_PULLUP {disabled} \
   CONFIG.PCW_MIO_4_SLEW {fast} \
   CONFIG.PCW_MIO_50_DIRECTION {inout} \
   CONFIG.PCW_MIO_50_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_50_PULLUP {disabled} \
   CONFIG.PCW_MIO_50_SLEW {slow} \
   CONFIG.PCW_MIO_51_DIRECTION {inout} \
   CONFIG.PCW_MIO_51_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_51_PULLUP {disabled} \
   CONFIG.PCW_MIO_51_SLEW {slow} \
   CONFIG.PCW_MIO_52_DIRECTION {out} \
   CONFIG.PCW_MIO_52_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_52_PULLUP {disabled} \
   CONFIG.PCW_MIO_52_SLEW {slow} \
   CONFIG.PCW_MIO_53_DIRECTION {inout} \
   CONFIG.PCW_MIO_53_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_53_PULLUP {disabled} \
   CONFIG.PCW_MIO_53_SLEW {slow} \
   CONFIG.PCW_MIO_5_DIRECTION {inout} \
   CONFIG.PCW_MIO_5_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_5_PULLUP {disabled} \
   CONFIG.PCW_MIO_5_SLEW {fast} \
   CONFIG.PCW_MIO_6_DIRECTION {out} \
   CONFIG.PCW_MIO_6_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_6_PULLUP {disabled} \
   CONFIG.PCW_MIO_6_SLEW {fast} \
   CONFIG.PCW_MIO_7_DIRECTION {out} \
   CONFIG.PCW_MIO_7_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_7_PULLUP {disabled} \
   CONFIG.PCW_MIO_7_SLEW {slow} \
   CONFIG.PCW_MIO_8_DIRECTION {out} \
   CONFIG.PCW_MIO_8_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_8_PULLUP {disabled} \
   CONFIG.PCW_MIO_8_SLEW {fast} \
   CONFIG.PCW_MIO_9_DIRECTION {inout} \
   CONFIG.PCW_MIO_9_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_9_PULLUP {disabled} \
   CONFIG.PCW_MIO_9_SLEW {slow} \
   CONFIG.PCW_MIO_TREE_PERIPHERALS {GPIO#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#SD 0#SD 0#SD 0#SD 0#SD 0#SD 0#SD 0#SD 0#UART 1#UART 1#GPIO#GPIO#Enet 0#Enet 0} \
   CONFIG.PCW_MIO_TREE_SIGNALS {gpio[0]#qspi0_ss_b#qspi0_io[0]#qspi0_io[1]#qspi0_io[2]#qspi0_io[3]/HOLD_B#qspi0_sclk#gpio[7]#gpio[8]#gpio[9]#gpio[10]#gpio[11]#gpio[12]#gpio[13]#gpio[14]#gpio[15]#tx_clk#txd[0]#txd[1]#txd[2]#txd[3]#tx_ctl#rx_clk#rxd[0]#rxd[1]#rxd[2]#rxd[3]#rx_ctl#data[4]#dir#stp#nxt#data[0]#data[1]#data[2]#data[3]#clk#data[5]#data[6]#data[7]#clk#cmd#data[0]#data[1]#data[2]#data[3]#wp#cd#tx#rx#gpio[50]#gpio[51]#mdc#mdio} \
   CONFIG.PCW_NAND_GRP_D8_ENABLE {0} \
   CONFIG.PCW_NAND_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_NOR_GRP_A25_ENABLE {0} \
   CONFIG.PCW_NOR_GRP_CS0_ENABLE {0} \
   CONFIG.PCW_NOR_GRP_CS1_ENABLE {0} \
   CONFIG.PCW_NOR_GRP_SRAM_CS0_ENABLE {0} \
   CONFIG.PCW_NOR_GRP_SRAM_CS1_ENABLE {0} \
   CONFIG.PCW_NOR_GRP_SRAM_INT_ENABLE {0} \
   CONFIG.PCW_NOR_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_PCAP_PERIPHERAL_DIVISOR0 {5} \
   CONFIG.PCW_PJTAG_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_PRESET_BANK0_VOLTAGE {LVCMOS 3.3V} \
   CONFIG.PCW_PRESET_BANK1_VOLTAGE {LVCMOS 1.8V} \
   CONFIG.PCW_QSPI_GRP_FBCLK_ENABLE {0} \
   CONFIG.PCW_QSPI_GRP_IO1_ENABLE {0} \
   CONFIG.PCW_QSPI_GRP_SINGLE_SS_ENABLE {1} \
   CONFIG.PCW_QSPI_GRP_SINGLE_SS_IO {MIO 1 .. 6} \
   CONFIG.PCW_QSPI_GRP_SS1_ENABLE {0} \
   CONFIG.PCW_QSPI_PERIPHERAL_DIVISOR0 {5} \
   CONFIG.PCW_QSPI_PERIPHERAL_ENABLE {1} \
   CONFIG.PCW_QSPI_PERIPHERAL_FREQMHZ {200} \
   CONFIG.PCW_QSPI_QSPI_IO {MIO 1 .. 6} \
   CONFIG.PCW_SD0_GRP_CD_ENABLE {1} \
   CONFIG.PCW_SD0_GRP_CD_IO {MIO 47} \
   CONFIG.PCW_SD0_GRP_POW_ENABLE {0} \
   CONFIG.PCW_SD0_GRP_WP_ENABLE {1} \
   CONFIG.PCW_SD0_GRP_WP_IO {MIO 46} \
   CONFIG.PCW_SD0_PERIPHERAL_ENABLE {1} \
   CONFIG.PCW_SD0_SD0_IO {MIO 40 .. 45} \
   CONFIG.PCW_SDIO_PERIPHERAL_DIVISOR0 {20} \
   CONFIG.PCW_SDIO_PERIPHERAL_FREQMHZ {50} \
   CONFIG.PCW_SDIO_PERIPHERAL_VALID {1} \
   CONFIG.PCW_SINGLE_QSPI_DATA_MODE {x4} \
   CONFIG.PCW_SMC_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_SPI_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_TPIU_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_TTC0_CLK0_PERIPHERAL_FREQMHZ {133.333333} \
   CONFIG.PCW_TTC0_CLK1_PERIPHERAL_FREQMHZ {133.333333} \
   CONFIG.PCW_TTC0_CLK2_PERIPHERAL_FREQMHZ {133.333333} \
   CONFIG.PCW_TTC0_PERIPHERAL_ENABLE {1} \
   CONFIG.PCW_TTC0_TTC0_IO {EMIO} \
   CONFIG.PCW_TTC_PERIPHERAL_FREQMHZ {50} \
   CONFIG.PCW_UART1_GRP_FULL_ENABLE {0} \
   CONFIG.PCW_UART1_PERIPHERAL_ENABLE {1} \
   CONFIG.PCW_UART1_UART1_IO {MIO 48 .. 49} \
   CONFIG.PCW_UART_PERIPHERAL_DIVISOR0 {20} \
   CONFIG.PCW_UART_PERIPHERAL_FREQMHZ {50} \
   CONFIG.PCW_UART_PERIPHERAL_VALID {1} \
   CONFIG.PCW_UIPARAM_ACT_DDR_FREQ_MHZ {533.333374} \
   CONFIG.PCW_UIPARAM_DDR_BANK_ADDR_COUNT {3} \
   CONFIG.PCW_UIPARAM_DDR_BL {8} \
   CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY0 {0.41} \
   CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY1 {0.411} \
   CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY2 {0.341} \
   CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY3 {0.358} \
   CONFIG.PCW_UIPARAM_DDR_CL {7} \
   CONFIG.PCW_UIPARAM_DDR_COL_ADDR_COUNT {10} \
   CONFIG.PCW_UIPARAM_DDR_CWL {6} \
   CONFIG.PCW_UIPARAM_DDR_DEVICE_CAPACITY {2048 MBits} \
   CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_0 {0.025} \
   CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_1 {0.028} \
   CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_2 {0.001} \
   CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_3 {0.001} \
   CONFIG.PCW_UIPARAM_DDR_DRAM_WIDTH {16 Bits} \
   CONFIG.PCW_UIPARAM_DDR_FREQ_MHZ {533.333313} \
   CONFIG.PCW_UIPARAM_DDR_MEMORY_TYPE {DDR 3} \
   CONFIG.PCW_UIPARAM_DDR_PARTNO {MT41J128M16 HA-15E} \
   CONFIG.PCW_UIPARAM_DDR_ROW_ADDR_COUNT {14} \
   CONFIG.PCW_UIPARAM_DDR_SPEED_BIN {DDR3_1066F} \
   CONFIG.PCW_UIPARAM_DDR_TRAIN_DATA_EYE {1} \
   CONFIG.PCW_UIPARAM_DDR_TRAIN_READ_GATE {1} \
   CONFIG.PCW_UIPARAM_DDR_TRAIN_WRITE_LEVEL {1} \
   CONFIG.PCW_UIPARAM_DDR_T_FAW {45.0} \
   CONFIG.PCW_UIPARAM_DDR_T_RAS_MIN {36.0} \
   CONFIG.PCW_UIPARAM_DDR_T_RC {49.5} \
   CONFIG.PCW_UIPARAM_DDR_T_RCD {7} \
   CONFIG.PCW_UIPARAM_DDR_T_RP {7} \
   CONFIG.PCW_UIPARAM_DDR_USE_INTERNAL_VREF {1} \
   CONFIG.PCW_USB0_PERIPHERAL_ENABLE {1} \
   CONFIG.PCW_USB0_PERIPHERAL_FREQMHZ {60} \
   CONFIG.PCW_USB0_RESET_ENABLE {0} \
   CONFIG.PCW_USB0_USB0_IO {MIO 28 .. 39} \
   CONFIG.PCW_USB1_RESET_ENABLE {0} \
   CONFIG.PCW_USB_RESET_ENABLE {1} \
   CONFIG.PCW_USB_RESET_SELECT {Share reset pin} \
   CONFIG.PCW_USE_DMA0 {0} \
   CONFIG.PCW_USE_M_AXI_GP1 {0} \
   CONFIG.preset {ZedBoard} \
 ] $ps_main

  # Create instance: ps_reset, and set properties
  set ps_reset [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 ps_reset ]

  # Create instance: simple_timer, and set properties
  set simple_timer [ create_bd_cell -type ip -vlnv oscar-rc.dev:zbnt_hw:simple_timer:1.0 simple_timer ]

  # Create interface connections
  connect_bd_intf_net -intf_net eth0_mac_mdio_external [get_bd_intf_ports ethfmc_p0_mdio] [get_bd_intf_pins eth0/mdio]
  connect_bd_intf_net -intf_net eth0_mac_rgmii [get_bd_intf_ports ethfmc_p0_rgmii] [get_bd_intf_pins eth0/rgmii]
  connect_bd_intf_net -intf_net eth1_mac_mdio_internal [get_bd_intf_ports ethfmc_p1_mdio] [get_bd_intf_pins eth1/mdio]
  connect_bd_intf_net -intf_net eth1_mac_rgmii [get_bd_intf_ports ethfmc_p1_rgmii] [get_bd_intf_pins eth1/rgmii]
  connect_bd_intf_net -intf_net eth2_mdio [get_bd_intf_ports ethfmc_p2_mdio] [get_bd_intf_pins eth2/mdio]
  connect_bd_intf_net -intf_net eth2_rgmii [get_bd_intf_ports ethfmc_p2_rgmii] [get_bd_intf_pins eth2/rgmii]
  connect_bd_intf_net -intf_net eth3_mdio [get_bd_intf_ports ethfmc_p3_mdio] [get_bd_intf_pins eth3/mdio]
  connect_bd_intf_net -intf_net eth3_rgmii [get_bd_intf_ports ethfmc_p3_rgmii] [get_bd_intf_pins eth3/rgmii]
  connect_bd_intf_net -intf_net ps_interconnect_M12_AXI [get_bd_intf_pins ps_interconnect/M12_AXI] [get_bd_intf_pins simple_timer/S_AXI]
  connect_bd_intf_net -intf_net ps_main_DDR [get_bd_intf_ports DDR] [get_bd_intf_pins ps_main/DDR]
  connect_bd_intf_net -intf_net ps_main_FIXED_IO [get_bd_intf_ports FIXED_IO] [get_bd_intf_pins ps_main/FIXED_IO]
  connect_bd_intf_net -intf_net ps_main_M_AXI_GP0 [get_bd_intf_pins ps_interconnect/S00_AXI] [get_bd_intf_pins ps_main/M_AXI_GP0]
  connect_bd_intf_net -intf_net s_axi_mac_1 [get_bd_intf_pins eth0/s_axi_mac] [get_bd_intf_pins ps_interconnect/M00_AXI]
  connect_bd_intf_net -intf_net s_axi_mac_2 [get_bd_intf_pins eth1/s_axi_mac] [get_bd_intf_pins ps_interconnect/M03_AXI]
  connect_bd_intf_net -intf_net s_axi_mac_3 [get_bd_intf_pins eth2/s_axi_mac] [get_bd_intf_pins ps_interconnect/M06_AXI]
  connect_bd_intf_net -intf_net s_axi_mac_4 [get_bd_intf_pins eth3/s_axi_mac] [get_bd_intf_pins ps_interconnect/M09_AXI]
  connect_bd_intf_net -intf_net s_axi_stats_1 [get_bd_intf_pins eth0/s_axi_stats] [get_bd_intf_pins ps_interconnect/M02_AXI]
  connect_bd_intf_net -intf_net s_axi_stats_2 [get_bd_intf_pins eth1/s_axi_stats] [get_bd_intf_pins ps_interconnect/M05_AXI]
  connect_bd_intf_net -intf_net s_axi_stats_3 [get_bd_intf_pins eth2/s_axi_stats] [get_bd_intf_pins ps_interconnect/M07_AXI]
  connect_bd_intf_net -intf_net s_axi_stats_4 [get_bd_intf_pins eth3/s_axi_stats] [get_bd_intf_pins ps_interconnect/M10_AXI]
  connect_bd_intf_net -intf_net s_axi_tgen_1 [get_bd_intf_pins eth0/s_axi_tgen] [get_bd_intf_pins ps_interconnect/M01_AXI]
  connect_bd_intf_net -intf_net s_axi_tgen_2 [get_bd_intf_pins eth1/s_axi_tgen] [get_bd_intf_pins ps_interconnect/M04_AXI]
  connect_bd_intf_net -intf_net s_axi_tgen_3 [get_bd_intf_pins eth2/s_axi_tgen] [get_bd_intf_pins ps_interconnect/M08_AXI]
  connect_bd_intf_net -intf_net s_axi_tgen_4 [get_bd_intf_pins eth3/s_axi_tgen] [get_bd_intf_pins ps_interconnect/M11_AXI]

  # Create port connections
  connect_bd_net -net M03_ARESETN_1 [get_bd_pins eth1/s_axi_aresetn] [get_bd_pins ps_interconnect/M03_ARESETN] [get_bd_pins ps_interconnect/M04_ARESETN] [get_bd_pins ps_interconnect/M05_ARESETN]
  connect_bd_net -net M09_ARESETN_1 [get_bd_pins eth3/s_axi_aresetn] [get_bd_pins ps_interconnect/M09_ARESETN] [get_bd_pins ps_interconnect/M10_ARESETN] [get_bd_pins ps_interconnect/M11_ARESETN] [get_bd_pins ps_interconnect/M12_ARESETN] [get_bd_pins simple_timer/rst_n]
  connect_bd_net -net clk_wiz_0_clk_125M [get_bd_pins ps_interconnect/ACLK] [get_bd_pins ps_interconnect/S00_ACLK] [get_bd_pins ps_main/FCLK_CLK0] [get_bd_pins ps_main/M_AXI_GP0_ACLK] [get_bd_pins ps_reset/slowest_sync_clk]
  connect_bd_net -net clk_wiz_0_clk_200M [get_bd_pins dcm_ethfmc/clk_200M] [get_bd_pins eth0/refclk]
  connect_bd_net -net constant_leds_dout [get_bd_ports led] [get_bd_pins constant_leds/dout]
  connect_bd_net -net dcm_ethfmc_clk_125M [get_bd_pins dcm_ethfmc/clk_125M] [get_bd_pins eth0/gtx_clk]
  connect_bd_net -net eth0_mac_gtx_clk90_out [get_bd_pins eth0/gtx_clk90_out] [get_bd_pins eth1/gtx_clk90] [get_bd_pins eth2/gtx_clk90] [get_bd_pins eth3/gtx_clk90]
  connect_bd_net -net eth0_s_axi_aresetn [get_bd_pins eth0/s_axi_aresetn] [get_bd_pins ps_interconnect/M00_ARESETN] [get_bd_pins ps_interconnect/M01_ARESETN] [get_bd_pins ps_interconnect/M02_ARESETN]
  connect_bd_net -net eth0_s_axi_clk [get_bd_pins eth0/s_axi_clk] [get_bd_pins ps_interconnect/M00_ACLK] [get_bd_pins ps_interconnect/M01_ACLK] [get_bd_pins ps_interconnect/M02_ACLK]
  connect_bd_net -net eth1_s_axi_clk [get_bd_pins eth1/s_axi_clk] [get_bd_pins ps_interconnect/M03_ACLK] [get_bd_pins ps_interconnect/M04_ACLK] [get_bd_pins ps_interconnect/M05_ACLK]
  connect_bd_net -net eth2_s_axi_aresetn [get_bd_pins eth2/s_axi_aresetn] [get_bd_pins ps_interconnect/M06_ARESETN] [get_bd_pins ps_interconnect/M07_ARESETN] [get_bd_pins ps_interconnect/M08_ARESETN]
  connect_bd_net -net eth2_s_axi_clk [get_bd_pins eth2/s_axi_clk] [get_bd_pins ps_interconnect/M06_ACLK] [get_bd_pins ps_interconnect/M07_ACLK] [get_bd_pins ps_interconnect/M08_ACLK]
  connect_bd_net -net eth3_s_axi_clk [get_bd_pins eth3/s_axi_clk] [get_bd_pins ps_interconnect/M09_ACLK] [get_bd_pins ps_interconnect/M10_ACLK] [get_bd_pins ps_interconnect/M11_ACLK]
  connect_bd_net -net ethfmc_clk_n_1 [get_bd_ports ethfmc_clk_n] [get_bd_pins dcm_ethfmc/clk_in1_n]
  connect_bd_net -net ethfmc_clk_p_1 [get_bd_ports ethfmc_clk_p] [get_bd_pins dcm_ethfmc/clk_in1_p]
  connect_bd_net -net gtx_clk_1 [get_bd_pins eth0/gtx_clk_out] [get_bd_pins eth1/gtx_clk] [get_bd_pins eth2/gtx_clk] [get_bd_pins eth3/gtx_clk] [get_bd_pins ps_interconnect/M12_ACLK] [get_bd_pins simple_timer/clk]
  connect_bd_net -net ps_main_FCLK_RESET0_N [get_bd_pins eth0/rst_n] [get_bd_pins eth1/rst_n] [get_bd_pins eth2/rst_n] [get_bd_pins eth3/rst_n] [get_bd_pins ps_main/FCLK_RESET0_N] [get_bd_pins ps_reset/ext_reset_in]
  connect_bd_net -net rst_ps_main_100M_peripheral_aresetn [get_bd_pins ps_interconnect/ARESETN] [get_bd_pins ps_interconnect/S00_ARESETN] [get_bd_pins ps_reset/peripheral_aresetn]
  connect_bd_net -net simple_timer_current_time [get_bd_pins eth0/current_time] [get_bd_pins eth1/current_time] [get_bd_pins eth2/current_time] [get_bd_pins eth3/current_time] [get_bd_pins simple_timer/current_time]
  connect_bd_net -net simple_timer_time_running [get_bd_pins eth0/time_running] [get_bd_pins eth1/time_running] [get_bd_pins eth2/time_running] [get_bd_pins eth3/time_running] [get_bd_pins simple_timer/time_running]
  connect_bd_net -net xlconstant_0_dout [get_bd_ports ethfmc_clk_fsel] [get_bd_ports ethfmc_clk_oe] [get_bd_ports ethfmc_p0_rst] [get_bd_ports ethfmc_p1_rst] [get_bd_ports ethfmc_p2_rst] [get_bd_ports ethfmc_p3_rst] [get_bd_pins constant_1/dout]

  # Create address segments
  create_bd_addr_seg -range 0x00010000 -offset 0x43C00000 [get_bd_addr_spaces ps_main/Data] [get_bd_addr_segs eth0/mac/s_axi/Reg] SEG_mac_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x43C10000 [get_bd_addr_spaces ps_main/Data] [get_bd_addr_segs eth1/mac/s_axi/Reg] SEG_mac_Reg1
  create_bd_addr_seg -range 0x00010000 -offset 0x43C20000 [get_bd_addr_spaces ps_main/Data] [get_bd_addr_segs eth2/mac/s_axi/Reg] SEG_mac_Reg2
  create_bd_addr_seg -range 0x00010000 -offset 0x43C30000 [get_bd_addr_spaces ps_main/Data] [get_bd_addr_segs eth3/mac/s_axi/Reg] SEG_mac_Reg3
  create_bd_addr_seg -range 0x00010000 -offset 0x43CD0000 [get_bd_addr_spaces ps_main/Data] [get_bd_addr_segs simple_timer/S_AXI/S_AXI_ADDR] SEG_simple_timer_S_AXI_ADDR
  create_bd_addr_seg -range 0x00010000 -offset 0x43C80000 [get_bd_addr_spaces ps_main/Data] [get_bd_addr_segs eth0/stats/S_AXI/S_AXI_ADDR] SEG_stats_S_AXI_ADDR
  create_bd_addr_seg -range 0x00010000 -offset 0x43C90000 [get_bd_addr_spaces ps_main/Data] [get_bd_addr_segs eth1/stats/S_AXI/S_AXI_ADDR] SEG_stats_S_AXI_ADDR1
  create_bd_addr_seg -range 0x00010000 -offset 0x43CA0000 [get_bd_addr_spaces ps_main/Data] [get_bd_addr_segs eth2/stats/S_AXI/S_AXI_ADDR] SEG_stats_S_AXI_ADDR2
  create_bd_addr_seg -range 0x00010000 -offset 0x43CB0000 [get_bd_addr_spaces ps_main/Data] [get_bd_addr_segs eth3/stats/S_AXI/S_AXI_ADDR] SEG_stats_S_AXI_ADDR3
  create_bd_addr_seg -range 0x00010000 -offset 0x43C40000 [get_bd_addr_spaces ps_main/Data] [get_bd_addr_segs eth0/tgen/S_AXI/S_AXI_ADDR] SEG_tgen_S_AXI_ADDR
  create_bd_addr_seg -range 0x00010000 -offset 0x43C50000 [get_bd_addr_spaces ps_main/Data] [get_bd_addr_segs eth1/tgen/S_AXI/S_AXI_ADDR] SEG_tgen_S_AXI_ADDR1
  create_bd_addr_seg -range 0x00010000 -offset 0x43C60000 [get_bd_addr_spaces ps_main/Data] [get_bd_addr_segs eth2/tgen/S_AXI/S_AXI_ADDR] SEG_tgen_S_AXI_ADDR2
  create_bd_addr_seg -range 0x00010000 -offset 0x43C70000 [get_bd_addr_spaces ps_main/Data] [get_bd_addr_segs eth3/tgen/S_AXI/S_AXI_ADDR] SEG_tgen_S_AXI_ADDR3


  # Restore current instance
  current_bd_instance $oldCurInst

  validate_bd_design
  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


