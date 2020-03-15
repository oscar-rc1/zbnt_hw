
################################################################
# This is a generated script based on design: bd_dual_detector
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
# source bd_dual_detector_script.tcl

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xczu3eg-sbva484-1-e
   set_property BOARD_PART em.avnet.com:ultra96v1:part0:1.2 [current_project]
}


# CHANGE DESIGN NAME HERE
variable design_name
set design_name bd_dual_detector

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
xilinx.com:ip:axi_ethernetlite:3.0\
xilinx.com:ip:xlconstant:1.1\
oscar-rc.dev:zbnt_hw:util_iobuf:1.0\
xilinx.com:ip:zynq_ultra_ps_e:3.2\
xilinx.com:ip:proc_sys_reset:5.0\
oscar-rc.dev:zbnt_hw:simple_timer:1.1\
xilinx.com:ip:axi_register_slice:2.1\
oscar-rc.dev:zbnt_hw:circular_dma:1.1\
xilinx.com:ip:fifo_generator:13.2\
xilinx.com:ip:axis_switch:1.1\
oscar-rc.dev:zbnt_hw:util_gmii_slice:1.0\
oscar-rc.dev:zbnt_hw:util_sgmii_crossover:1.0\
xilinx.com:ip:gig_ethernet_pcs_pma:16.1\
oscar-rc.dev:zbnt_hw:eth_frame_detector:1.1\
alexforencich.com:verilog-ethernet:eth_mac_1g:1.0\
oscar-rc.dev:zbnt_hw:eth_stats_collector:1.1\
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
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 RX_AXIS
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 TX_AXIS
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 axis_stats
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:gmii_rtl:1.0 gmii
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 s_axi_stats

  # Create pins
  create_bd_pin -dir I -from 63 -to 0 current_time
  create_bd_pin -dir I -type clk gtx_clk
  create_bd_pin -dir I -type rst rst_n
  create_bd_pin -dir O rx_clk
  create_bd_pin -dir I time_running

  # Create instance: mac, and set properties
  set mac [ create_bd_cell -type ip -vlnv alexforencich.com:verilog-ethernet:eth_mac_1g:1.0 mac ]
  set_property -dict [ list \
   CONFIG.C_GTX_AS_RX_CLK {true} \
   CONFIG.C_IFACE_TYPE {GMII} \
 ] $mac

  # Create instance: stats, and set properties
  set stats [ create_bd_cell -type ip -vlnv oscar-rc.dev:zbnt_hw:eth_stats_collector:1.1 stats ]
  set_property -dict [ list \
   CONFIG.C_AXIS_LOG_WIDTH {128} \
   CONFIG.C_AXI_WIDTH {64} \
 ] $stats

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins s_axi_stats] [get_bd_intf_pins stats/S_AXI]
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins gmii] [get_bd_intf_pins mac/GMII]
  connect_bd_intf_net -intf_net eth_mac_1g_0_RX_AXIS [get_bd_intf_pins RX_AXIS] [get_bd_intf_pins mac/RX_AXIS]
  connect_bd_intf_net -intf_net [get_bd_intf_nets eth_mac_1g_0_RX_AXIS] [get_bd_intf_pins RX_AXIS] [get_bd_intf_pins stats/AXIS_RX]
  connect_bd_intf_net -intf_net stats_M_AXIS_LOG [get_bd_intf_pins axis_stats] [get_bd_intf_pins stats/M_AXIS_LOG]
  connect_bd_intf_net -intf_net tgen_M_AXIS [get_bd_intf_pins TX_AXIS] [get_bd_intf_pins mac/TX_AXIS]
  connect_bd_intf_net -intf_net [get_bd_intf_nets tgen_M_AXIS] [get_bd_intf_pins TX_AXIS] [get_bd_intf_pins stats/AXIS_TX]

  # Create port connections
  connect_bd_net -net current_time_0_1 [get_bd_pins current_time] [get_bd_pins stats/current_time]
  connect_bd_net -net eth1_mac_tx_mac_aclk [get_bd_pins gtx_clk] [get_bd_pins mac/gtx_clk] [get_bd_pins stats/clk] [get_bd_pins stats/clk_tx]
  connect_bd_net -net eth_mac_1g_0_rx_clk [get_bd_pins rx_clk] [get_bd_pins mac/rx_clk] [get_bd_pins stats/clk_rx]
  connect_bd_net -net rst_ps_main_100M_peripheral_aresetn [get_bd_pins rst_n] [get_bd_pins mac/gtx_rst_n] [get_bd_pins stats/rst_n]
  connect_bd_net -net time_running_0_1 [get_bd_pins time_running] [get_bd_pins stats/time_running]

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
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 RX_AXIS
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 TX_AXIS
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 axis_stats
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:gmii_rtl:1.0 gmii
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 s_axi_stats

  # Create pins
  create_bd_pin -dir I -from 63 -to 0 current_time
  create_bd_pin -dir I -type clk gtx_clk
  create_bd_pin -dir I -type rst rst_n
  create_bd_pin -dir O rx_clk
  create_bd_pin -dir I time_running

  # Create instance: mac, and set properties
  set mac [ create_bd_cell -type ip -vlnv alexforencich.com:verilog-ethernet:eth_mac_1g:1.0 mac ]
  set_property -dict [ list \
   CONFIG.C_GTX_AS_RX_CLK {true} \
   CONFIG.C_IFACE_TYPE {GMII} \
 ] $mac

  # Create instance: stats, and set properties
  set stats [ create_bd_cell -type ip -vlnv oscar-rc.dev:zbnt_hw:eth_stats_collector:1.1 stats ]
  set_property -dict [ list \
   CONFIG.C_AXIS_LOG_WIDTH {128} \
   CONFIG.C_AXI_WIDTH {64} \
 ] $stats

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins s_axi_stats] [get_bd_intf_pins stats/S_AXI]
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins gmii] [get_bd_intf_pins mac/GMII]
  connect_bd_intf_net -intf_net eth_mac_1g_0_RX_AXIS [get_bd_intf_pins RX_AXIS] [get_bd_intf_pins mac/RX_AXIS]
  connect_bd_intf_net -intf_net [get_bd_intf_nets eth_mac_1g_0_RX_AXIS] [get_bd_intf_pins RX_AXIS] [get_bd_intf_pins stats/AXIS_RX]
  connect_bd_intf_net -intf_net stats_M_AXIS_LOG [get_bd_intf_pins axis_stats] [get_bd_intf_pins stats/M_AXIS_LOG]
  connect_bd_intf_net -intf_net tgen_M_AXIS [get_bd_intf_pins TX_AXIS] [get_bd_intf_pins mac/TX_AXIS]
  connect_bd_intf_net -intf_net [get_bd_intf_nets tgen_M_AXIS] [get_bd_intf_pins TX_AXIS] [get_bd_intf_pins stats/AXIS_TX]

  # Create port connections
  connect_bd_net -net current_time_0_1 [get_bd_pins current_time] [get_bd_pins stats/current_time]
  connect_bd_net -net eth1_mac_tx_mac_aclk [get_bd_pins gtx_clk] [get_bd_pins mac/gtx_clk] [get_bd_pins stats/clk] [get_bd_pins stats/clk_tx]
  connect_bd_net -net eth_mac_1g_0_rx_clk [get_bd_pins rx_clk] [get_bd_pins mac/rx_clk] [get_bd_pins stats/clk_rx]
  connect_bd_net -net rst_ps_main_100M_peripheral_aresetn [get_bd_pins rst_n] [get_bd_pins mac/gtx_rst_n] [get_bd_pins stats/rst_n]
  connect_bd_net -net time_running_0_1 [get_bd_pins time_running] [get_bd_pins stats/time_running]

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
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 RX_AXIS
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 TX_AXIS
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 axis_stats
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:gmii_rtl:1.0 gmii
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 s_axi_stats

  # Create pins
  create_bd_pin -dir I -from 63 -to 0 current_time
  create_bd_pin -dir I -type clk gtx_clk
  create_bd_pin -dir I -type rst rst_n
  create_bd_pin -dir O rx_clk
  create_bd_pin -dir I time_running

  # Create instance: mac, and set properties
  set mac [ create_bd_cell -type ip -vlnv alexforencich.com:verilog-ethernet:eth_mac_1g:1.0 mac ]
  set_property -dict [ list \
   CONFIG.C_GTX_AS_RX_CLK {true} \
   CONFIG.C_IFACE_TYPE {GMII} \
 ] $mac

  # Create instance: stats, and set properties
  set stats [ create_bd_cell -type ip -vlnv oscar-rc.dev:zbnt_hw:eth_stats_collector:1.1 stats ]
  set_property -dict [ list \
   CONFIG.C_AXIS_LOG_WIDTH {128} \
   CONFIG.C_AXI_WIDTH {64} \
 ] $stats

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins s_axi_stats] [get_bd_intf_pins stats/S_AXI]
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins gmii] [get_bd_intf_pins mac/GMII]
  connect_bd_intf_net -intf_net eth_mac_1g_0_RX_AXIS [get_bd_intf_pins RX_AXIS] [get_bd_intf_pins mac/RX_AXIS]
  connect_bd_intf_net -intf_net [get_bd_intf_nets eth_mac_1g_0_RX_AXIS] [get_bd_intf_pins RX_AXIS] [get_bd_intf_pins stats/AXIS_RX]
  connect_bd_intf_net -intf_net stats_M_AXIS_LOG [get_bd_intf_pins axis_stats] [get_bd_intf_pins stats/M_AXIS_LOG]
  connect_bd_intf_net -intf_net tgen_M_AXIS [get_bd_intf_pins TX_AXIS] [get_bd_intf_pins mac/TX_AXIS]
  connect_bd_intf_net -intf_net [get_bd_intf_nets tgen_M_AXIS] [get_bd_intf_pins TX_AXIS] [get_bd_intf_pins stats/AXIS_TX]

  # Create port connections
  connect_bd_net -net current_time_0_1 [get_bd_pins current_time] [get_bd_pins stats/current_time]
  connect_bd_net -net eth1_mac_tx_mac_aclk [get_bd_pins gtx_clk] [get_bd_pins mac/gtx_clk] [get_bd_pins stats/clk] [get_bd_pins stats/clk_tx]
  connect_bd_net -net eth_mac_1g_0_rx_clk [get_bd_pins rx_clk] [get_bd_pins mac/rx_clk] [get_bd_pins stats/clk_rx]
  connect_bd_net -net rst_ps_main_100M_peripheral_aresetn [get_bd_pins rst_n] [get_bd_pins mac/gtx_rst_n] [get_bd_pins stats/rst_n]
  connect_bd_net -net time_running_0_1 [get_bd_pins time_running] [get_bd_pins stats/time_running]

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
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 RX_AXIS
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 TX_AXIS
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 axis_stats
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:gmii_rtl:1.0 gmii
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 s_axi_stats

  # Create pins
  create_bd_pin -dir I -from 63 -to 0 current_time
  create_bd_pin -dir I -type clk gtx_clk
  create_bd_pin -dir I -type rst rst_n
  create_bd_pin -dir O rx_clk
  create_bd_pin -dir I time_running

  # Create instance: mac, and set properties
  set mac [ create_bd_cell -type ip -vlnv alexforencich.com:verilog-ethernet:eth_mac_1g:1.0 mac ]
  set_property -dict [ list \
   CONFIG.C_GTX_AS_RX_CLK {true} \
   CONFIG.C_IFACE_TYPE {GMII} \
 ] $mac

  # Create instance: stats, and set properties
  set stats [ create_bd_cell -type ip -vlnv oscar-rc.dev:zbnt_hw:eth_stats_collector:1.1 stats ]
  set_property -dict [ list \
   CONFIG.C_AXIS_LOG_WIDTH {128} \
   CONFIG.C_AXI_WIDTH {64} \
 ] $stats

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins s_axi_stats] [get_bd_intf_pins stats/S_AXI]
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins gmii] [get_bd_intf_pins mac/GMII]
  connect_bd_intf_net -intf_net eth_mac_1g_0_RX_AXIS [get_bd_intf_pins RX_AXIS] [get_bd_intf_pins mac/RX_AXIS]
  connect_bd_intf_net -intf_net [get_bd_intf_nets eth_mac_1g_0_RX_AXIS] [get_bd_intf_pins RX_AXIS] [get_bd_intf_pins stats/AXIS_RX]
  connect_bd_intf_net -intf_net stats_M_AXIS_LOG [get_bd_intf_pins axis_stats] [get_bd_intf_pins stats/M_AXIS_LOG]
  connect_bd_intf_net -intf_net tgen_M_AXIS [get_bd_intf_pins TX_AXIS] [get_bd_intf_pins mac/TX_AXIS]
  connect_bd_intf_net -intf_net [get_bd_intf_nets tgen_M_AXIS] [get_bd_intf_pins TX_AXIS] [get_bd_intf_pins stats/AXIS_TX]

  # Create port connections
  connect_bd_net -net current_time_0_1 [get_bd_pins current_time] [get_bd_pins stats/current_time]
  connect_bd_net -net eth1_mac_tx_mac_aclk [get_bd_pins gtx_clk] [get_bd_pins mac/gtx_clk] [get_bd_pins stats/clk] [get_bd_pins stats/clk_tx]
  connect_bd_net -net eth_mac_1g_0_rx_clk [get_bd_pins rx_clk] [get_bd_pins mac/rx_clk] [get_bd_pins stats/clk_rx]
  connect_bd_net -net rst_ps_main_100M_peripheral_aresetn [get_bd_pins rst_n] [get_bd_pins mac/gtx_rst_n] [get_bd_pins stats/rst_n]
  connect_bd_net -net time_running_0_1 [get_bd_pins time_running] [get_bd_pins stats/time_running]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: mitm_b
proc create_hier_cell_mitm_b { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_mitm_b() - Empty argument(s)!"}
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
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 axis_detector_a
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 axis_detector_b
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 axis_stats_a
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 axis_stats_b
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:gmii_rtl:1.0 gmii_a
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:gmii_rtl:1.0 gmii_b
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 s_axi_detector
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 s_axi_stats_a
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 s_axi_stats_b

  # Create pins
  create_bd_pin -dir I -from 63 -to 0 current_time
  create_bd_pin -dir I -type clk gtx_clk
  create_bd_pin -dir I -type rst rst_n
  create_bd_pin -dir I time_running

  # Create instance: detector, and set properties
  set detector [ create_bd_cell -type ip -vlnv oscar-rc.dev:zbnt_hw:eth_frame_detector:1.1 detector ]
  set_property -dict [ list \
   CONFIG.C_AXIS_LOG_WIDTH {128} \
   CONFIG.C_AXI_WIDTH {64} \
   CONFIG.C_LOOP_FIFO_A_SIZE {8192} \
   CONFIG.C_LOOP_FIFO_B_SIZE {1024} \
   CONFIG.C_NUM_SCRIPTS {2} \
   CONFIG.C_SHARED_RX_CLK {true} \
   CONFIG.C_SHARED_TX_CLK {true} \
 ] $detector

  # Create instance: eth2
  create_hier_cell_eth2 $hier_obj eth2

  # Create instance: eth3
  create_hier_cell_eth3 $hier_obj eth3

  # Create interface connections
  connect_bd_intf_net -intf_net S02_AXIS_1 [get_bd_intf_pins axis_stats_a] [get_bd_intf_pins eth2/axis_stats]
  connect_bd_intf_net -intf_net TX_AXIS_1 [get_bd_intf_pins detector/M_AXIS_A] [get_bd_intf_pins eth2/TX_AXIS]
  connect_bd_intf_net -intf_net TX_AXIS_2 [get_bd_intf_pins detector/M_AXIS_B] [get_bd_intf_pins eth3/TX_AXIS]
  connect_bd_intf_net -intf_net detector_M_AXIS_LOG_A [get_bd_intf_pins axis_detector_a] [get_bd_intf_pins detector/M_AXIS_LOG_A]
  connect_bd_intf_net -intf_net detector_M_AXIS_LOG_B [get_bd_intf_pins axis_detector_b] [get_bd_intf_pins detector/M_AXIS_LOG_B]
  connect_bd_intf_net -intf_net eth2_GMII_0 [get_bd_intf_pins gmii_a] [get_bd_intf_pins eth2/gmii]
  connect_bd_intf_net -intf_net eth2_RX_AXIS [get_bd_intf_pins detector/S_AXIS_A] [get_bd_intf_pins eth2/RX_AXIS]
  connect_bd_intf_net -intf_net eth3_RX_AXIS [get_bd_intf_pins detector/S_AXIS_B] [get_bd_intf_pins eth3/RX_AXIS]
  connect_bd_intf_net -intf_net eth3_axis_stats [get_bd_intf_pins axis_stats_b] [get_bd_intf_pins eth3/axis_stats]
  connect_bd_intf_net -intf_net eth3_gmii [get_bd_intf_pins gmii_b] [get_bd_intf_pins eth3/gmii]
  connect_bd_intf_net -intf_net s_axi_detector_1 [get_bd_intf_pins s_axi_detector] [get_bd_intf_pins detector/S_AXI]
  connect_bd_intf_net -intf_net s_axi_stats_1 [get_bd_intf_pins s_axi_stats_a] [get_bd_intf_pins eth2/s_axi_stats]
  connect_bd_intf_net -intf_net s_axi_stats_2 [get_bd_intf_pins s_axi_stats_b] [get_bd_intf_pins eth3/s_axi_stats]

  # Create port connections
  connect_bd_net -net constant_1_dout [get_bd_pins rst_n] [get_bd_pins detector/s_axi_resetn] [get_bd_pins eth2/rst_n] [get_bd_pins eth3/rst_n]
  connect_bd_net -net eth2_rx_clk [get_bd_pins detector/s_axis_a_clk] [get_bd_pins eth2/rx_clk]
  connect_bd_net -net eth3_rx_clk [get_bd_pins detector/s_axis_b_clk] [get_bd_pins eth3/rx_clk]
  connect_bd_net -net ethfmc_clk_buf_IBUF_OUT [get_bd_pins gtx_clk] [get_bd_pins detector/m_axis_a_clk] [get_bd_pins detector/m_axis_b_clk] [get_bd_pins detector/s_axi_clk] [get_bd_pins eth2/gtx_clk] [get_bd_pins eth3/gtx_clk]
  connect_bd_net -net simple_timer_current_time [get_bd_pins current_time] [get_bd_pins detector/current_time] [get_bd_pins eth2/current_time] [get_bd_pins eth3/current_time]
  connect_bd_net -net simple_timer_time_running [get_bd_pins time_running] [get_bd_pins detector/time_running] [get_bd_pins eth2/time_running] [get_bd_pins eth3/time_running]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: mitm_a
proc create_hier_cell_mitm_a { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_mitm_a() - Empty argument(s)!"}
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
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 axis_detector_a
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 axis_detector_b
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 axis_stats_a
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 axis_stats_b
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:gmii_rtl:1.0 gmii_a
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:gmii_rtl:1.0 gmii_b
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 s_axi_detector
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 s_axi_stats_a
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 s_axi_stats_b

  # Create pins
  create_bd_pin -dir I -from 63 -to 0 current_time
  create_bd_pin -dir I -type clk gtx_clk
  create_bd_pin -dir I -type rst rst_n
  create_bd_pin -dir I time_running

  # Create instance: detector, and set properties
  set detector [ create_bd_cell -type ip -vlnv oscar-rc.dev:zbnt_hw:eth_frame_detector:1.1 detector ]
  set_property -dict [ list \
   CONFIG.C_AXIS_LOG_WIDTH {128} \
   CONFIG.C_AXI_WIDTH {64} \
   CONFIG.C_LOOP_FIFO_A_SIZE {8192} \
   CONFIG.C_LOOP_FIFO_B_SIZE {1024} \
   CONFIG.C_NUM_SCRIPTS {2} \
   CONFIG.C_SHARED_RX_CLK {true} \
   CONFIG.C_SHARED_TX_CLK {true} \
 ] $detector

  # Create instance: eth0
  create_hier_cell_eth0 $hier_obj eth0

  # Create instance: eth1
  create_hier_cell_eth1 $hier_obj eth1

  # Create interface connections
  connect_bd_intf_net -intf_net S02_AXIS_1 [get_bd_intf_pins axis_stats_a] [get_bd_intf_pins eth0/axis_stats]
  connect_bd_intf_net -intf_net TX_AXIS_1 [get_bd_intf_pins detector/M_AXIS_A] [get_bd_intf_pins eth0/TX_AXIS]
  connect_bd_intf_net -intf_net TX_AXIS_2 [get_bd_intf_pins detector/M_AXIS_B] [get_bd_intf_pins eth1/TX_AXIS]
  connect_bd_intf_net -intf_net detector_M_AXIS_LOG_A [get_bd_intf_pins axis_detector_a] [get_bd_intf_pins detector/M_AXIS_LOG_A]
  connect_bd_intf_net -intf_net detector_M_AXIS_LOG_B [get_bd_intf_pins axis_detector_b] [get_bd_intf_pins detector/M_AXIS_LOG_B]
  connect_bd_intf_net -intf_net eth2_GMII_0 [get_bd_intf_pins gmii_a] [get_bd_intf_pins eth0/gmii]
  connect_bd_intf_net -intf_net eth2_RX_AXIS [get_bd_intf_pins detector/S_AXIS_A] [get_bd_intf_pins eth0/RX_AXIS]
  connect_bd_intf_net -intf_net eth3_RX_AXIS [get_bd_intf_pins detector/S_AXIS_B] [get_bd_intf_pins eth1/RX_AXIS]
  connect_bd_intf_net -intf_net eth3_axis_stats [get_bd_intf_pins axis_stats_b] [get_bd_intf_pins eth1/axis_stats]
  connect_bd_intf_net -intf_net eth3_gmii [get_bd_intf_pins gmii_b] [get_bd_intf_pins eth1/gmii]
  connect_bd_intf_net -intf_net s_axi_detector_1 [get_bd_intf_pins s_axi_detector] [get_bd_intf_pins detector/S_AXI]
  connect_bd_intf_net -intf_net s_axi_stats_1 [get_bd_intf_pins s_axi_stats_a] [get_bd_intf_pins eth0/s_axi_stats]
  connect_bd_intf_net -intf_net s_axi_stats_2 [get_bd_intf_pins s_axi_stats_b] [get_bd_intf_pins eth1/s_axi_stats]

  # Create port connections
  connect_bd_net -net constant_1_dout [get_bd_pins rst_n] [get_bd_pins detector/s_axi_resetn] [get_bd_pins eth0/rst_n] [get_bd_pins eth1/rst_n]
  connect_bd_net -net eth2_rx_clk [get_bd_pins detector/s_axis_a_clk] [get_bd_pins eth0/rx_clk]
  connect_bd_net -net eth3_rx_clk [get_bd_pins detector/s_axis_b_clk] [get_bd_pins eth1/rx_clk]
  connect_bd_net -net ethfmc_clk_buf_IBUF_OUT [get_bd_pins gtx_clk] [get_bd_pins detector/m_axis_a_clk] [get_bd_pins detector/m_axis_b_clk] [get_bd_pins detector/s_axi_clk] [get_bd_pins eth0/gtx_clk] [get_bd_pins eth1/gtx_clk]
  connect_bd_net -net simple_timer_current_time [get_bd_pins current_time] [get_bd_pins detector/current_time] [get_bd_pins eth0/current_time] [get_bd_pins eth1/current_time]
  connect_bd_net -net simple_timer_time_running [get_bd_pins time_running] [get_bd_pins detector/time_running] [get_bd_pins eth0/time_running] [get_bd_pins eth1/time_running]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: gmii_to_sgmii
proc create_hier_cell_gmii_to_sgmii { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_gmii_to_sgmii() - Empty argument(s)!"}
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
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 clk_625M
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:gmii_rtl:1.0 gmii_0
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:gmii_rtl:1.0 gmii_1
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:gmii_rtl:1.0 gmii_2
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:gmii_rtl:1.0 gmii_3
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:sgmii_rtl:1.0 sgmii_0
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:sgmii_rtl:1.0 sgmii_1
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:sgmii_rtl:1.0 sgmii_2
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:sgmii_rtl:1.0 sgmii_3
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:sgmii_rtl:1.0 sgmii_unused

  # Create pins
  create_bd_pin -dir O clk_125M
  create_bd_pin -dir O rst_out

  # Create instance: autoneg_vector, and set properties
  set autoneg_vector [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 autoneg_vector ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {38913} \
   CONFIG.CONST_WIDTH {16} \
 ] $autoneg_vector

  # Create instance: cfg_vector, and set properties
  set cfg_vector [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 cfg_vector ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {16} \
   CONFIG.CONST_WIDTH {5} \
 ] $cfg_vector

  # Create instance: gmii_3_slice, and set properties
  set gmii_3_slice [ create_bd_cell -type ip -vlnv oscar-rc.dev:zbnt_hw:util_gmii_slice:1.0 gmii_3_slice ]

  # Create instance: reset, and set properties
  set reset [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 reset ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
 ] $reset

  # Create instance: sgmii_3_crossover, and set properties
  set sgmii_3_crossover [ create_bd_cell -type ip -vlnv oscar-rc.dev:zbnt_hw:util_sgmii_crossover:1.0 sgmii_3_crossover ]

  # Create instance: sgmii_port0_port1, and set properties
  set sgmii_port0_port1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:gig_ethernet_pcs_pma:16.1 sgmii_port0_port1 ]
  set_property -dict [ list \
   CONFIG.Auto_Negotiation {true} \
   CONFIG.ClockSelection {Async} \
   CONFIG.Ext_Management_Interface {false} \
   CONFIG.Management_Interface {false} \
   CONFIG.NumOfLanes {2} \
   CONFIG.SGMII_PHY_Mode {false} \
   CONFIG.Standard {SGMII} \
   CONFIG.SupportLevel {Include_Shared_Logic_in_Example_Design} \
   CONFIG.TransceiverControl {false} \
 ] $sgmii_port0_port1

  # Create instance: sgmii_port2, and set properties
  set sgmii_port2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:gig_ethernet_pcs_pma:16.1 sgmii_port2 ]
  set_property -dict [ list \
   CONFIG.Auto_Negotiation {true} \
   CONFIG.ClockSelection {Async} \
   CONFIG.Ext_Management_Interface {false} \
   CONFIG.Management_Interface {false} \
   CONFIG.SGMII_PHY_Mode {false} \
   CONFIG.Standard {SGMII} \
   CONFIG.SupportLevel {Include_Shared_Logic_in_Example_Design} \
 ] $sgmii_port2

  # Create instance: sgmii_port3_rx, and set properties
  set sgmii_port3_rx [ create_bd_cell -type ip -vlnv xilinx.com:ip:gig_ethernet_pcs_pma:16.1 sgmii_port3_rx ]
  set_property -dict [ list \
   CONFIG.Auto_Negotiation {false} \
   CONFIG.ClockSelection {Async} \
   CONFIG.EMAC_IF_TEMAC {TEMAC} \
   CONFIG.Ext_Management_Interface {false} \
   CONFIG.Management_Interface {false} \
   CONFIG.NumOfLanes {1} \
   CONFIG.Standard {SGMII} \
   CONFIG.SupportLevel {Include_Shared_Logic_in_Core} \
   CONFIG.TransceiverControl {false} \
 ] $sgmii_port3_rx

  # Create instance: sgmii_port3_tx, and set properties
  set sgmii_port3_tx [ create_bd_cell -type ip -vlnv xilinx.com:ip:gig_ethernet_pcs_pma:16.1 sgmii_port3_tx ]
  set_property -dict [ list \
   CONFIG.Auto_Negotiation {false} \
   CONFIG.ClockSelection {Async} \
   CONFIG.Ext_Management_Interface {false} \
   CONFIG.Management_Interface {false} \
   CONFIG.Standard {SGMII} \
 ] $sgmii_port3_tx

  # Create instance: signal_detect, and set properties
  set signal_detect [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 signal_detect ]

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins gmii_3] [get_bd_intf_pins gmii_3_slice/S_GMII]
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins sgmii_unused] [get_bd_intf_pins sgmii_3_crossover/M_SGMII_B]
  connect_bd_intf_net -intf_net eth0_GMII_0 [get_bd_intf_pins gmii_1] [get_bd_intf_pins sgmii_port0_port1/gmii_pcs_pma_0]
  connect_bd_intf_net -intf_net eth1_GMII_0 [get_bd_intf_pins gmii_2] [get_bd_intf_pins sgmii_port0_port1/gmii_pcs_pma_1]
  connect_bd_intf_net -intf_net eth2_GMII_0 [get_bd_intf_pins gmii_0] [get_bd_intf_pins sgmii_port2/gmii_pcs_pma_0]
  connect_bd_intf_net -intf_net gig_ethernet_pcs_pma_0_1_sgmii_0 [get_bd_intf_pins sgmii_0] [get_bd_intf_pins sgmii_port0_port1/sgmii_0]
  connect_bd_intf_net -intf_net gig_ethernet_pcs_pma_0_1_sgmii_1 [get_bd_intf_pins sgmii_1] [get_bd_intf_pins sgmii_port0_port1/sgmii_1]
  connect_bd_intf_net -intf_net gig_ethernet_pcs_pma_2_sgmii_0 [get_bd_intf_pins sgmii_2] [get_bd_intf_pins sgmii_port2/sgmii_0]
  connect_bd_intf_net -intf_net refclk625_in_0_1 [get_bd_intf_pins clk_625M] [get_bd_intf_pins sgmii_port3_rx/refclk625_in]
  connect_bd_intf_net -intf_net sgmii_port3_rx_sgmii_0 [get_bd_intf_pins sgmii_3_crossover/S_SGMII_B] [get_bd_intf_pins sgmii_port3_rx/sgmii_0]
  connect_bd_intf_net -intf_net sgmii_port3_tx_sgmii_0 [get_bd_intf_pins sgmii_3_crossover/S_SGMII_A] [get_bd_intf_pins sgmii_port3_tx/sgmii_0]
  connect_bd_intf_net -intf_net util_gmii_slice_0_M_GMII_RX [get_bd_intf_pins gmii_3_slice/M_GMII_RX] [get_bd_intf_pins sgmii_port3_rx/gmii_pcs_pma_0]
  connect_bd_intf_net -intf_net util_gmii_slice_0_M_GMII_TX [get_bd_intf_pins gmii_3_slice/M_GMII_TX] [get_bd_intf_pins sgmii_port3_tx/gmii_pcs_pma_0]
  connect_bd_intf_net -intf_net util_sgmii_concat_0_M_SGMII [get_bd_intf_pins sgmii_3] [get_bd_intf_pins sgmii_3_crossover/M_SGMII_A]

  # Create port connections
  connect_bd_net -net cfg_autoneg1_dout [get_bd_pins autoneg_vector/dout] [get_bd_pins sgmii_port0_port1/an_adv_config_vector_0] [get_bd_pins sgmii_port0_port1/an_adv_config_vector_1] [get_bd_pins sgmii_port2/an_adv_config_vector_0]
  connect_bd_net -net cfg_autoneg_dout [get_bd_pins cfg_vector/dout] [get_bd_pins sgmii_port0_port1/configuration_vector_0] [get_bd_pins sgmii_port0_port1/configuration_vector_1] [get_bd_pins sgmii_port2/configuration_vector_0]
  connect_bd_net -net gig_ethernet_pcs_pma_0_1_riu_prsnt [get_bd_pins sgmii_port0_port1/riu_prsnt] [get_bd_pins sgmii_port3_rx/riu_prsnt_1]
  connect_bd_net -net gig_ethernet_pcs_pma_0_1_riu_rd_data [get_bd_pins sgmii_port0_port1/riu_rd_data] [get_bd_pins sgmii_port3_rx/riu_rddata_1]
  connect_bd_net -net gig_ethernet_pcs_pma_0_1_riu_valid [get_bd_pins sgmii_port0_port1/riu_valid] [get_bd_pins sgmii_port3_rx/riu_valid_1]
  connect_bd_net -net gig_ethernet_pcs_pma_0_1_rx_dly_rdy [get_bd_pins sgmii_port0_port1/rx_dly_rdy] [get_bd_pins sgmii_port3_rx/rx_dly_rdy_1]
  connect_bd_net -net gig_ethernet_pcs_pma_0_1_rx_vtc_rdy [get_bd_pins sgmii_port0_port1/rx_vtc_rdy] [get_bd_pins sgmii_port3_rx/rx_vtc_rdy_1]
  connect_bd_net -net gig_ethernet_pcs_pma_0_1_tx_dly_rdy [get_bd_pins sgmii_port0_port1/tx_dly_rdy] [get_bd_pins sgmii_port3_rx/tx_dly_rdy_1]
  connect_bd_net -net gig_ethernet_pcs_pma_0_1_tx_vtc_rdy [get_bd_pins sgmii_port0_port1/tx_vtc_rdy] [get_bd_pins sgmii_port3_rx/tx_vtc_rdy_1]
  connect_bd_net -net gig_ethernet_pcs_pma_2_riu_prsnt [get_bd_pins sgmii_port2/riu_prsnt] [get_bd_pins sgmii_port3_rx/riu_prsnt_2]
  connect_bd_net -net gig_ethernet_pcs_pma_2_riu_rd_data [get_bd_pins sgmii_port2/riu_rd_data] [get_bd_pins sgmii_port3_rx/riu_rddata_2]
  connect_bd_net -net gig_ethernet_pcs_pma_2_riu_valid [get_bd_pins sgmii_port2/riu_valid] [get_bd_pins sgmii_port3_rx/riu_valid_2]
  connect_bd_net -net gig_ethernet_pcs_pma_2_rx_dly_rdy [get_bd_pins sgmii_port2/rx_dly_rdy] [get_bd_pins sgmii_port3_rx/rx_dly_rdy_2]
  connect_bd_net -net gig_ethernet_pcs_pma_2_rx_vtc_rdy [get_bd_pins sgmii_port2/rx_vtc_rdy] [get_bd_pins sgmii_port3_rx/rx_vtc_rdy_2]
  connect_bd_net -net gig_ethernet_pcs_pma_2_tx_dly_rdy [get_bd_pins sgmii_port2/tx_dly_rdy] [get_bd_pins sgmii_port3_rx/tx_dly_rdy_2]
  connect_bd_net -net gig_ethernet_pcs_pma_2_tx_vtc_rdy [get_bd_pins sgmii_port2/tx_vtc_rdy] [get_bd_pins sgmii_port3_rx/tx_vtc_rdy_2]
  connect_bd_net -net gig_ethernet_pcs_pma_3_rx_clk125_out [get_bd_pins clk_125M] [get_bd_pins sgmii_port0_port1/clk125m] [get_bd_pins sgmii_port2/clk125m] [get_bd_pins sgmii_port3_rx/clk125_out] [get_bd_pins sgmii_port3_tx/clk125m]
  connect_bd_net -net gig_ethernet_pcs_pma_3_rx_clk312_out [get_bd_pins sgmii_port0_port1/clk312] [get_bd_pins sgmii_port2/clk312] [get_bd_pins sgmii_port3_rx/clk312_out] [get_bd_pins sgmii_port3_tx/clk312]
  connect_bd_net -net gig_ethernet_pcs_pma_3_rx_riu_addr_out [get_bd_pins sgmii_port0_port1/riu_addr] [get_bd_pins sgmii_port2/riu_addr] [get_bd_pins sgmii_port3_rx/riu_addr_out] [get_bd_pins sgmii_port3_tx/riu_addr]
  connect_bd_net -net gig_ethernet_pcs_pma_3_rx_riu_clk_out [get_bd_pins sgmii_port0_port1/riu_clk] [get_bd_pins sgmii_port2/riu_clk] [get_bd_pins sgmii_port3_rx/riu_clk_out] [get_bd_pins sgmii_port3_tx/riu_clk]
  connect_bd_net -net gig_ethernet_pcs_pma_3_rx_riu_nibble_sel_out [get_bd_pins sgmii_port0_port1/riu_nibble_sel] [get_bd_pins sgmii_port2/riu_nibble_sel] [get_bd_pins sgmii_port3_rx/riu_nibble_sel_out] [get_bd_pins sgmii_port3_tx/riu_nibble_sel]
  connect_bd_net -net gig_ethernet_pcs_pma_3_rx_riu_wr_data_out [get_bd_pins sgmii_port0_port1/riu_wr_data] [get_bd_pins sgmii_port2/riu_wr_data] [get_bd_pins sgmii_port3_rx/riu_wr_data_out] [get_bd_pins sgmii_port3_tx/riu_wr_data]
  connect_bd_net -net gig_ethernet_pcs_pma_3_rx_riu_wr_en_out [get_bd_pins sgmii_port0_port1/riu_wr_en] [get_bd_pins sgmii_port2/riu_wr_en] [get_bd_pins sgmii_port3_rx/riu_wr_en_out] [get_bd_pins sgmii_port3_tx/riu_wr_en]
  connect_bd_net -net gig_ethernet_pcs_pma_3_rx_rst_125_out [get_bd_pins rst_out] [get_bd_pins sgmii_port0_port1/reset] [get_bd_pins sgmii_port2/reset] [get_bd_pins sgmii_port3_rx/rst_125_out] [get_bd_pins sgmii_port3_tx/reset]
  connect_bd_net -net gig_ethernet_pcs_pma_3_rx_rx_bs_en_vtc_out [get_bd_pins sgmii_port0_port1/rx_bs_en_vtc] [get_bd_pins sgmii_port2/rx_bs_en_vtc] [get_bd_pins sgmii_port3_rx/rx_bs_en_vtc_out] [get_bd_pins sgmii_port3_tx/rx_bs_en_vtc]
  connect_bd_net -net gig_ethernet_pcs_pma_3_rx_rx_bs_rst_out [get_bd_pins sgmii_port0_port1/rx_bs_rst] [get_bd_pins sgmii_port2/rx_bs_rst] [get_bd_pins sgmii_port3_rx/rx_bs_rst_out] [get_bd_pins sgmii_port3_tx/rx_bs_rst]
  connect_bd_net -net gig_ethernet_pcs_pma_3_rx_rx_bsc_en_vtc_out [get_bd_pins sgmii_port0_port1/rx_bsc_en_vtc] [get_bd_pins sgmii_port2/rx_bsc_en_vtc] [get_bd_pins sgmii_port3_rx/rx_bsc_en_vtc_out] [get_bd_pins sgmii_port3_tx/rx_bsc_en_vtc]
  connect_bd_net -net gig_ethernet_pcs_pma_3_rx_rx_bsc_rst_out [get_bd_pins sgmii_port0_port1/rx_bsc_rst] [get_bd_pins sgmii_port2/rx_bsc_rst] [get_bd_pins sgmii_port3_rx/rx_bsc_rst_out] [get_bd_pins sgmii_port3_tx/rx_bsc_rst]
  connect_bd_net -net gig_ethernet_pcs_pma_3_rx_rx_btval_1 [get_bd_pins sgmii_port0_port1/rx_btval] [get_bd_pins sgmii_port3_rx/rx_btval_1]
  connect_bd_net -net gig_ethernet_pcs_pma_3_rx_rx_btval_2 [get_bd_pins sgmii_port2/rx_btval] [get_bd_pins sgmii_port3_rx/rx_btval_2]
  connect_bd_net -net gig_ethernet_pcs_pma_3_rx_rx_btval_3 [get_bd_pins sgmii_port3_rx/rx_btval_3] [get_bd_pins sgmii_port3_tx/rx_btval]
  connect_bd_net -net gig_ethernet_pcs_pma_3_rx_rx_pll_clk_out [get_bd_pins sgmii_port0_port1/rx_pll_clk] [get_bd_pins sgmii_port2/rx_pll_clk] [get_bd_pins sgmii_port3_rx/rx_pll_clk_out] [get_bd_pins sgmii_port3_tx/rx_pll_clk]
  connect_bd_net -net gig_ethernet_pcs_pma_3_rx_rx_rst_dly_out [get_bd_pins sgmii_port0_port1/rx_rst_dly] [get_bd_pins sgmii_port2/rx_rst_dly] [get_bd_pins sgmii_port3_rx/rx_rst_dly_out] [get_bd_pins sgmii_port3_tx/rx_rst_dly]
  connect_bd_net -net gig_ethernet_pcs_pma_3_rx_tx_bs_en_vtc_out [get_bd_pins sgmii_port0_port1/tx_bs_en_vtc] [get_bd_pins sgmii_port2/tx_bs_en_vtc] [get_bd_pins sgmii_port3_rx/tx_bs_en_vtc_out] [get_bd_pins sgmii_port3_tx/tx_bs_en_vtc]
  connect_bd_net -net gig_ethernet_pcs_pma_3_rx_tx_bs_rst_out [get_bd_pins sgmii_port0_port1/tx_bs_rst] [get_bd_pins sgmii_port2/tx_bs_rst] [get_bd_pins sgmii_port3_rx/tx_bs_rst_out] [get_bd_pins sgmii_port3_tx/tx_bs_rst]
  connect_bd_net -net gig_ethernet_pcs_pma_3_rx_tx_bsc_en_vtc_out [get_bd_pins sgmii_port0_port1/tx_bsc_en_vtc] [get_bd_pins sgmii_port2/tx_bsc_en_vtc] [get_bd_pins sgmii_port3_rx/tx_bsc_en_vtc_out] [get_bd_pins sgmii_port3_tx/tx_bsc_en_vtc]
  connect_bd_net -net gig_ethernet_pcs_pma_3_rx_tx_bsc_rst_out [get_bd_pins sgmii_port0_port1/tx_bsc_rst] [get_bd_pins sgmii_port2/tx_bsc_rst] [get_bd_pins sgmii_port3_rx/tx_bsc_rst_out] [get_bd_pins sgmii_port3_tx/tx_bsc_rst]
  connect_bd_net -net gig_ethernet_pcs_pma_3_rx_tx_pll_clk_out [get_bd_pins sgmii_port0_port1/tx_pll_clk] [get_bd_pins sgmii_port2/tx_pll_clk] [get_bd_pins sgmii_port3_rx/tx_pll_clk_out] [get_bd_pins sgmii_port3_tx/tx_pll_clk]
  connect_bd_net -net gig_ethernet_pcs_pma_3_rx_tx_rdclk_out [get_bd_pins sgmii_port0_port1/tx_rdclk] [get_bd_pins sgmii_port2/tx_rdclk] [get_bd_pins sgmii_port3_rx/tx_rdclk_out] [get_bd_pins sgmii_port3_tx/tx_rdclk]
  connect_bd_net -net gig_ethernet_pcs_pma_3_rx_tx_rst_dly_out [get_bd_pins sgmii_port0_port1/tx_rst_dly] [get_bd_pins sgmii_port2/tx_rst_dly] [get_bd_pins sgmii_port3_rx/tx_rst_dly_out] [get_bd_pins sgmii_port3_tx/tx_rst_dly]
  connect_bd_net -net gig_ethernet_pcs_pma_3_tx_riu_prsnt [get_bd_pins sgmii_port3_rx/riu_prsnt_3] [get_bd_pins sgmii_port3_tx/riu_prsnt]
  connect_bd_net -net gig_ethernet_pcs_pma_3_tx_riu_rd_data [get_bd_pins sgmii_port3_rx/riu_rddata_3] [get_bd_pins sgmii_port3_tx/riu_rd_data]
  connect_bd_net -net gig_ethernet_pcs_pma_3_tx_riu_valid [get_bd_pins sgmii_port3_rx/riu_valid_3] [get_bd_pins sgmii_port3_tx/riu_valid]
  connect_bd_net -net gig_ethernet_pcs_pma_3_tx_rx_dly_rdy [get_bd_pins sgmii_port3_rx/rx_dly_rdy_3] [get_bd_pins sgmii_port3_tx/rx_dly_rdy]
  connect_bd_net -net gig_ethernet_pcs_pma_3_tx_rx_vtc_rdy [get_bd_pins sgmii_port3_rx/rx_vtc_rdy_3] [get_bd_pins sgmii_port3_tx/rx_vtc_rdy]
  connect_bd_net -net gig_ethernet_pcs_pma_3_tx_tx_dly_rdy [get_bd_pins sgmii_port3_rx/tx_dly_rdy_3] [get_bd_pins sgmii_port3_tx/tx_dly_rdy]
  connect_bd_net -net gig_ethernet_pcs_pma_3_tx_tx_vtc_rdy [get_bd_pins sgmii_port3_rx/tx_vtc_rdy_3] [get_bd_pins sgmii_port3_tx/tx_vtc_rdy]
  connect_bd_net -net reset_dout [get_bd_pins reset/dout] [get_bd_pins sgmii_port3_rx/reset]
  connect_bd_net -net xlconstant_0_dout1 [get_bd_pins sgmii_port0_port1/signal_detect_0] [get_bd_pins sgmii_port0_port1/signal_detect_1] [get_bd_pins sgmii_port2/signal_detect_0] [get_bd_pins sgmii_port3_rx/signal_detect_0] [get_bd_pins sgmii_port3_tx/signal_detect_0] [get_bd_pins signal_detect/dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: dma
proc create_hier_cell_dma { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_dma() - Empty argument(s)!"}
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
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S00_AXIS
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S01_AXIS
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S02_AXIS
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S03_AXIS
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S04_AXIS
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S05_AXIS
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S06_AXIS
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S07_AXIS
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_LITE

  # Create pins
  create_bd_pin -dir I clk
  create_bd_pin -dir O irq
  create_bd_pin -dir I rst_n

  # Create instance: axi_regslice, and set properties
  set axi_regslice [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_regslice ]

  # Create instance: dma, and set properties
  set dma [ create_bd_cell -type ip -vlnv oscar-rc.dev:zbnt_hw:circular_dma:1.1 dma ]
  set_property -dict [ list \
   CONFIG.C_ADDR_WIDTH {64} \
   CONFIG.C_AXIS_OCCUP_WIDTH {15} \
   CONFIG.C_AXIS_WIDTH {128} \
   CONFIG.C_AXI_WIDTH {64} \
   CONFIG.C_MAX_BURST {4} \
   CONFIG.C_VALUE_AWPROT {"010"} \
   CONFIG.C_VALUE_AWUSER {"0001"} \
 ] $dma

  # Create instance: fifo_0, and set properties
  set fifo_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:fifo_generator:13.2 fifo_0 ]
  set_property -dict [ list \
   CONFIG.Empty_Threshold_Assert_Value_axis {4094} \
   CONFIG.Empty_Threshold_Assert_Value_rach {14} \
   CONFIG.Empty_Threshold_Assert_Value_wach {14} \
   CONFIG.Empty_Threshold_Assert_Value_wrch {14} \
   CONFIG.Enable_Data_Counts_axis {false} \
   CONFIG.Enable_ECC_axis {false} \
   CONFIG.Enable_TLAST {true} \
   CONFIG.FIFO_Implementation_axis {Common_Clock_Block_RAM} \
   CONFIG.FIFO_Implementation_rach {Common_Clock_Distributed_RAM} \
   CONFIG.FIFO_Implementation_rdch {Common_Clock_Builtin_FIFO} \
   CONFIG.FIFO_Implementation_wach {Common_Clock_Distributed_RAM} \
   CONFIG.FIFO_Implementation_wdch {Common_Clock_Builtin_FIFO} \
   CONFIG.FIFO_Implementation_wrch {Common_Clock_Distributed_RAM} \
   CONFIG.Full_Threshold_Assert_Value_axis {4095} \
   CONFIG.Full_Threshold_Assert_Value_rach {15} \
   CONFIG.Full_Threshold_Assert_Value_wach {15} \
   CONFIG.Full_Threshold_Assert_Value_wrch {15} \
   CONFIG.INTERFACE_TYPE {AXI_STREAM} \
   CONFIG.Input_Depth_axis {4096} \
   CONFIG.Reset_Type {Asynchronous_Reset} \
   CONFIG.TDATA_NUM_BYTES {16} \
   CONFIG.TKEEP_WIDTH {16} \
   CONFIG.TSTRB_WIDTH {16} \
   CONFIG.TUSER_WIDTH {0} \
   CONFIG.Use_Embedded_Registers_axis {true} \
 ] $fifo_0

  # Create instance: fifo_1, and set properties
  set fifo_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:fifo_generator:13.2 fifo_1 ]
  set_property -dict [ list \
   CONFIG.Empty_Threshold_Assert_Value_axis {4094} \
   CONFIG.Empty_Threshold_Assert_Value_rach {14} \
   CONFIG.Empty_Threshold_Assert_Value_wach {14} \
   CONFIG.Empty_Threshold_Assert_Value_wrch {14} \
   CONFIG.Enable_Data_Counts_axis {false} \
   CONFIG.Enable_TLAST {true} \
   CONFIG.FIFO_Implementation_axis {Common_Clock_Block_RAM} \
   CONFIG.FIFO_Implementation_rach {Common_Clock_Distributed_RAM} \
   CONFIG.FIFO_Implementation_rdch {Common_Clock_Builtin_FIFO} \
   CONFIG.FIFO_Implementation_wach {Common_Clock_Distributed_RAM} \
   CONFIG.FIFO_Implementation_wdch {Common_Clock_Builtin_FIFO} \
   CONFIG.FIFO_Implementation_wrch {Common_Clock_Distributed_RAM} \
   CONFIG.Full_Threshold_Assert_Value_axis {4095} \
   CONFIG.Full_Threshold_Assert_Value_rach {15} \
   CONFIG.Full_Threshold_Assert_Value_wach {15} \
   CONFIG.Full_Threshold_Assert_Value_wrch {15} \
   CONFIG.INTERFACE_TYPE {AXI_STREAM} \
   CONFIG.Input_Depth_axis {4096} \
   CONFIG.Reset_Type {Asynchronous_Reset} \
   CONFIG.TDATA_NUM_BYTES {16} \
   CONFIG.TKEEP_WIDTH {16} \
   CONFIG.TSTRB_WIDTH {16} \
   CONFIG.TUSER_WIDTH {0} \
   CONFIG.Use_Embedded_Registers_axis {true} \
 ] $fifo_1

  # Create instance: fifo_2, and set properties
  set fifo_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:fifo_generator:13.2 fifo_2 ]
  set_property -dict [ list \
   CONFIG.Empty_Threshold_Assert_Value_axis {4094} \
   CONFIG.Empty_Threshold_Assert_Value_rach {14} \
   CONFIG.Empty_Threshold_Assert_Value_wach {14} \
   CONFIG.Empty_Threshold_Assert_Value_wrch {14} \
   CONFIG.Enable_Data_Counts_axis {false} \
   CONFIG.Enable_TLAST {true} \
   CONFIG.FIFO_Implementation_axis {Common_Clock_Block_RAM} \
   CONFIG.FIFO_Implementation_rach {Common_Clock_Distributed_RAM} \
   CONFIG.FIFO_Implementation_rdch {Common_Clock_Builtin_FIFO} \
   CONFIG.FIFO_Implementation_wach {Common_Clock_Distributed_RAM} \
   CONFIG.FIFO_Implementation_wdch {Common_Clock_Builtin_FIFO} \
   CONFIG.FIFO_Implementation_wrch {Common_Clock_Distributed_RAM} \
   CONFIG.Full_Threshold_Assert_Value_axis {4095} \
   CONFIG.Full_Threshold_Assert_Value_rach {15} \
   CONFIG.Full_Threshold_Assert_Value_wach {15} \
   CONFIG.Full_Threshold_Assert_Value_wrch {15} \
   CONFIG.INTERFACE_TYPE {AXI_STREAM} \
   CONFIG.Input_Depth_axis {4096} \
   CONFIG.Reset_Type {Asynchronous_Reset} \
   CONFIG.TDATA_NUM_BYTES {16} \
   CONFIG.TKEEP_WIDTH {16} \
   CONFIG.TSTRB_WIDTH {16} \
   CONFIG.TUSER_WIDTH {0} \
   CONFIG.Use_Embedded_Registers_axis {true} \
 ] $fifo_2

  # Create instance: fifo_3, and set properties
  set fifo_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:fifo_generator:13.2 fifo_3 ]
  set_property -dict [ list \
   CONFIG.Empty_Threshold_Assert_Value_axis {4094} \
   CONFIG.Empty_Threshold_Assert_Value_rach {14} \
   CONFIG.Empty_Threshold_Assert_Value_wach {14} \
   CONFIG.Empty_Threshold_Assert_Value_wrch {14} \
   CONFIG.Enable_Data_Counts_axis {false} \
   CONFIG.Enable_TLAST {true} \
   CONFIG.FIFO_Implementation_axis {Common_Clock_Block_RAM} \
   CONFIG.FIFO_Implementation_rach {Common_Clock_Distributed_RAM} \
   CONFIG.FIFO_Implementation_rdch {Common_Clock_Builtin_FIFO} \
   CONFIG.FIFO_Implementation_wach {Common_Clock_Distributed_RAM} \
   CONFIG.FIFO_Implementation_wdch {Common_Clock_Builtin_FIFO} \
   CONFIG.FIFO_Implementation_wrch {Common_Clock_Distributed_RAM} \
   CONFIG.Full_Threshold_Assert_Value_axis {4095} \
   CONFIG.Full_Threshold_Assert_Value_rach {15} \
   CONFIG.Full_Threshold_Assert_Value_wach {15} \
   CONFIG.Full_Threshold_Assert_Value_wrch {15} \
   CONFIG.INTERFACE_TYPE {AXI_STREAM} \
   CONFIG.Input_Depth_axis {4096} \
   CONFIG.Reset_Type {Asynchronous_Reset} \
   CONFIG.TDATA_NUM_BYTES {16} \
   CONFIG.TKEEP_WIDTH {16} \
   CONFIG.TSTRB_WIDTH {16} \
   CONFIG.TUSER_WIDTH {0} \
   CONFIG.Use_Embedded_Registers_axis {true} \
 ] $fifo_3

  # Create instance: fifo_4, and set properties
  set fifo_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:fifo_generator:13.2 fifo_4 ]
  set_property -dict [ list \
   CONFIG.Empty_Threshold_Assert_Value_axis {62} \
   CONFIG.Empty_Threshold_Assert_Value_rach {14} \
   CONFIG.Empty_Threshold_Assert_Value_wach {14} \
   CONFIG.Empty_Threshold_Assert_Value_wrch {14} \
   CONFIG.Enable_Data_Counts_axis {false} \
   CONFIG.Enable_TLAST {true} \
   CONFIG.FIFO_Implementation_axis {Common_Clock_Distributed_RAM} \
   CONFIG.FIFO_Implementation_rach {Common_Clock_Distributed_RAM} \
   CONFIG.FIFO_Implementation_rdch {Common_Clock_Builtin_FIFO} \
   CONFIG.FIFO_Implementation_wach {Common_Clock_Distributed_RAM} \
   CONFIG.FIFO_Implementation_wdch {Common_Clock_Builtin_FIFO} \
   CONFIG.FIFO_Implementation_wrch {Common_Clock_Distributed_RAM} \
   CONFIG.Full_Threshold_Assert_Value_axis {63} \
   CONFIG.Full_Threshold_Assert_Value_rach {15} \
   CONFIG.Full_Threshold_Assert_Value_wach {15} \
   CONFIG.Full_Threshold_Assert_Value_wrch {15} \
   CONFIG.INTERFACE_TYPE {AXI_STREAM} \
   CONFIG.Input_Depth_axis {64} \
   CONFIG.Reset_Type {Asynchronous_Reset} \
   CONFIG.TDATA_NUM_BYTES {16} \
   CONFIG.TKEEP_WIDTH {16} \
   CONFIG.TSTRB_WIDTH {16} \
   CONFIG.TUSER_WIDTH {0} \
   CONFIG.Use_Embedded_Registers_axis {false} \
 ] $fifo_4

  # Create instance: fifo_5, and set properties
  set fifo_5 [ create_bd_cell -type ip -vlnv xilinx.com:ip:fifo_generator:13.2 fifo_5 ]
  set_property -dict [ list \
   CONFIG.Empty_Threshold_Assert_Value_axis {62} \
   CONFIG.Empty_Threshold_Assert_Value_rach {14} \
   CONFIG.Empty_Threshold_Assert_Value_wach {14} \
   CONFIG.Empty_Threshold_Assert_Value_wrch {14} \
   CONFIG.Enable_Data_Counts_axis {false} \
   CONFIG.Enable_TLAST {true} \
   CONFIG.FIFO_Implementation_axis {Common_Clock_Distributed_RAM} \
   CONFIG.FIFO_Implementation_rach {Common_Clock_Distributed_RAM} \
   CONFIG.FIFO_Implementation_rdch {Common_Clock_Builtin_FIFO} \
   CONFIG.FIFO_Implementation_wach {Common_Clock_Distributed_RAM} \
   CONFIG.FIFO_Implementation_wdch {Common_Clock_Builtin_FIFO} \
   CONFIG.FIFO_Implementation_wrch {Common_Clock_Distributed_RAM} \
   CONFIG.Full_Threshold_Assert_Value_axis {63} \
   CONFIG.Full_Threshold_Assert_Value_rach {15} \
   CONFIG.Full_Threshold_Assert_Value_wach {15} \
   CONFIG.Full_Threshold_Assert_Value_wrch {15} \
   CONFIG.INTERFACE_TYPE {AXI_STREAM} \
   CONFIG.Input_Depth_axis {64} \
   CONFIG.Reset_Type {Asynchronous_Reset} \
   CONFIG.TDATA_NUM_BYTES {16} \
   CONFIG.TKEEP_WIDTH {16} \
   CONFIG.TSTRB_WIDTH {16} \
   CONFIG.TUSER_WIDTH {0} \
   CONFIG.Use_Embedded_Registers_axis {false} \
 ] $fifo_5

  # Create instance: fifo_6, and set properties
  set fifo_6 [ create_bd_cell -type ip -vlnv xilinx.com:ip:fifo_generator:13.2 fifo_6 ]
  set_property -dict [ list \
   CONFIG.Empty_Threshold_Assert_Value_axis {62} \
   CONFIG.Empty_Threshold_Assert_Value_rach {14} \
   CONFIG.Empty_Threshold_Assert_Value_wach {14} \
   CONFIG.Empty_Threshold_Assert_Value_wrch {14} \
   CONFIG.Enable_Data_Counts_axis {false} \
   CONFIG.Enable_TLAST {true} \
   CONFIG.FIFO_Implementation_axis {Common_Clock_Distributed_RAM} \
   CONFIG.FIFO_Implementation_rach {Common_Clock_Distributed_RAM} \
   CONFIG.FIFO_Implementation_rdch {Common_Clock_Builtin_FIFO} \
   CONFIG.FIFO_Implementation_wach {Common_Clock_Distributed_RAM} \
   CONFIG.FIFO_Implementation_wdch {Common_Clock_Builtin_FIFO} \
   CONFIG.FIFO_Implementation_wrch {Common_Clock_Distributed_RAM} \
   CONFIG.Full_Threshold_Assert_Value_axis {63} \
   CONFIG.Full_Threshold_Assert_Value_rach {15} \
   CONFIG.Full_Threshold_Assert_Value_wach {15} \
   CONFIG.Full_Threshold_Assert_Value_wrch {15} \
   CONFIG.INTERFACE_TYPE {AXI_STREAM} \
   CONFIG.Input_Depth_axis {64} \
   CONFIG.Reset_Type {Asynchronous_Reset} \
   CONFIG.TDATA_NUM_BYTES {16} \
   CONFIG.TKEEP_WIDTH {16} \
   CONFIG.TSTRB_WIDTH {16} \
   CONFIG.TUSER_WIDTH {0} \
   CONFIG.Use_Embedded_Registers_axis {false} \
 ] $fifo_6

  # Create instance: fifo_7, and set properties
  set fifo_7 [ create_bd_cell -type ip -vlnv xilinx.com:ip:fifo_generator:13.2 fifo_7 ]
  set_property -dict [ list \
   CONFIG.Empty_Threshold_Assert_Value_axis {62} \
   CONFIG.Empty_Threshold_Assert_Value_rach {14} \
   CONFIG.Empty_Threshold_Assert_Value_wach {14} \
   CONFIG.Empty_Threshold_Assert_Value_wrch {14} \
   CONFIG.Enable_Data_Counts_axis {false} \
   CONFIG.Enable_TLAST {true} \
   CONFIG.FIFO_Implementation_axis {Common_Clock_Distributed_RAM} \
   CONFIG.FIFO_Implementation_rach {Common_Clock_Distributed_RAM} \
   CONFIG.FIFO_Implementation_rdch {Common_Clock_Builtin_FIFO} \
   CONFIG.FIFO_Implementation_wach {Common_Clock_Distributed_RAM} \
   CONFIG.FIFO_Implementation_wdch {Common_Clock_Builtin_FIFO} \
   CONFIG.FIFO_Implementation_wrch {Common_Clock_Distributed_RAM} \
   CONFIG.Full_Threshold_Assert_Value_axis {63} \
   CONFIG.Full_Threshold_Assert_Value_rach {15} \
   CONFIG.Full_Threshold_Assert_Value_wach {15} \
   CONFIG.Full_Threshold_Assert_Value_wrch {15} \
   CONFIG.INTERFACE_TYPE {AXI_STREAM} \
   CONFIG.Input_Depth_axis {64} \
   CONFIG.Reset_Type {Asynchronous_Reset} \
   CONFIG.TDATA_NUM_BYTES {16} \
   CONFIG.TKEEP_WIDTH {16} \
   CONFIG.TSTRB_WIDTH {16} \
   CONFIG.TUSER_WIDTH {0} \
   CONFIG.Use_Embedded_Registers_axis {false} \
 ] $fifo_7

  # Create instance: fifo_8, and set properties
  set fifo_8 [ create_bd_cell -type ip -vlnv xilinx.com:ip:fifo_generator:13.2 fifo_8 ]
  set_property -dict [ list \
   CONFIG.Empty_Threshold_Assert_Value_axis {126} \
   CONFIG.Empty_Threshold_Assert_Value_rach {14} \
   CONFIG.Empty_Threshold_Assert_Value_wach {14} \
   CONFIG.Empty_Threshold_Assert_Value_wrch {14} \
   CONFIG.Enable_Data_Counts_axis {false} \
   CONFIG.Enable_TLAST {true} \
   CONFIG.FIFO_Implementation_axis {Common_Clock_Distributed_RAM} \
   CONFIG.FIFO_Implementation_rach {Common_Clock_Distributed_RAM} \
   CONFIG.FIFO_Implementation_rdch {Common_Clock_Builtin_FIFO} \
   CONFIG.FIFO_Implementation_wach {Common_Clock_Distributed_RAM} \
   CONFIG.FIFO_Implementation_wdch {Common_Clock_Builtin_FIFO} \
   CONFIG.FIFO_Implementation_wrch {Common_Clock_Distributed_RAM} \
   CONFIG.Full_Threshold_Assert_Value_axis {127} \
   CONFIG.Full_Threshold_Assert_Value_rach {15} \
   CONFIG.Full_Threshold_Assert_Value_wach {15} \
   CONFIG.Full_Threshold_Assert_Value_wrch {15} \
   CONFIG.INTERFACE_TYPE {AXI_STREAM} \
   CONFIG.Input_Depth_axis {128} \
   CONFIG.Reset_Type {Asynchronous_Reset} \
   CONFIG.TDATA_NUM_BYTES {16} \
   CONFIG.TKEEP_WIDTH {16} \
   CONFIG.TSTRB_WIDTH {16} \
   CONFIG.TUSER_WIDTH {0} \
   CONFIG.Use_Embedded_Registers_axis {false} \
 ] $fifo_8

  # Create instance: fifo_9, and set properties
  set fifo_9 [ create_bd_cell -type ip -vlnv xilinx.com:ip:fifo_generator:13.2 fifo_9 ]
  set_property -dict [ list \
   CONFIG.Empty_Threshold_Assert_Value_axis {8190} \
   CONFIG.Empty_Threshold_Assert_Value_rach {14} \
   CONFIG.Empty_Threshold_Assert_Value_wach {14} \
   CONFIG.Empty_Threshold_Assert_Value_wrch {14} \
   CONFIG.Enable_Data_Counts_axis {false} \
   CONFIG.Enable_TLAST {true} \
   CONFIG.FIFO_Implementation_axis {Common_Clock_Block_RAM} \
   CONFIG.FIFO_Implementation_rach {Common_Clock_Distributed_RAM} \
   CONFIG.FIFO_Implementation_rdch {Common_Clock_Builtin_FIFO} \
   CONFIG.FIFO_Implementation_wach {Common_Clock_Distributed_RAM} \
   CONFIG.FIFO_Implementation_wdch {Common_Clock_Builtin_FIFO} \
   CONFIG.FIFO_Implementation_wrch {Common_Clock_Distributed_RAM} \
   CONFIG.Full_Threshold_Assert_Value_axis {8191} \
   CONFIG.Full_Threshold_Assert_Value_rach {15} \
   CONFIG.Full_Threshold_Assert_Value_wach {15} \
   CONFIG.Full_Threshold_Assert_Value_wrch {15} \
   CONFIG.INTERFACE_TYPE {AXI_STREAM} \
   CONFIG.Input_Depth_axis {8192} \
   CONFIG.Reset_Type {Asynchronous_Reset} \
   CONFIG.TDATA_NUM_BYTES {16} \
   CONFIG.TKEEP_WIDTH {16} \
   CONFIG.TSTRB_WIDTH {16} \
   CONFIG.TUSER_WIDTH {0} \
   CONFIG.Use_Embedded_Registers_axis {true} \
 ] $fifo_9

  # Create instance: fifo_10, and set properties
  set fifo_10 [ create_bd_cell -type ip -vlnv xilinx.com:ip:fifo_generator:13.2 fifo_10 ]
  set_property -dict [ list \
   CONFIG.Empty_Threshold_Assert_Value_axis {16382} \
   CONFIG.Empty_Threshold_Assert_Value_rach {14} \
   CONFIG.Empty_Threshold_Assert_Value_wach {14} \
   CONFIG.Empty_Threshold_Assert_Value_wrch {14} \
   CONFIG.Enable_Data_Counts_axis {true} \
   CONFIG.Enable_TLAST {true} \
   CONFIG.FIFO_Implementation_axis {Common_Clock_Block_RAM} \
   CONFIG.FIFO_Implementation_rach {Common_Clock_Distributed_RAM} \
   CONFIG.FIFO_Implementation_rdch {Common_Clock_Builtin_FIFO} \
   CONFIG.FIFO_Implementation_wach {Common_Clock_Distributed_RAM} \
   CONFIG.FIFO_Implementation_wdch {Common_Clock_Builtin_FIFO} \
   CONFIG.FIFO_Implementation_wrch {Common_Clock_Distributed_RAM} \
   CONFIG.Full_Threshold_Assert_Value_axis {16383} \
   CONFIG.Full_Threshold_Assert_Value_rach {15} \
   CONFIG.Full_Threshold_Assert_Value_wach {15} \
   CONFIG.Full_Threshold_Assert_Value_wrch {15} \
   CONFIG.INTERFACE_TYPE {AXI_STREAM} \
   CONFIG.Input_Depth_axis {16384} \
   CONFIG.Reset_Type {Asynchronous_Reset} \
   CONFIG.TDATA_NUM_BYTES {16} \
   CONFIG.TKEEP_WIDTH {16} \
   CONFIG.TSTRB_WIDTH {16} \
   CONFIG.TUSER_WIDTH {0} \
   CONFIG.Use_Embedded_Registers_axis {true} \
 ] $fifo_10

  # Create instance: switch_main, and set properties
  set switch_main [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_switch:1.1 switch_main ]
  set_property -dict [ list \
   CONFIG.ARB_ALGORITHM {3} \
   CONFIG.ARB_ON_MAX_XFERS {0} \
   CONFIG.ARB_ON_TLAST {1} \
   CONFIG.HAS_TLAST {1} \
   CONFIG.NUM_SI {5} \
 ] $switch_main

  # Create instance: switch_sc, and set properties
  set switch_sc [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_switch:1.1 switch_sc ]
  set_property -dict [ list \
   CONFIG.ARB_ALGORITHM {3} \
   CONFIG.ARB_ON_MAX_XFERS {0} \
   CONFIG.ARB_ON_TLAST {1} \
   CONFIG.HAS_TLAST {1} \
   CONFIG.NUM_SI {4} \
 ] $switch_sc

  # Create interface connections
  connect_bd_intf_net -intf_net S00_AXIS_1 [get_bd_intf_pins S00_AXIS] [get_bd_intf_pins fifo_0/S_AXIS]
  connect_bd_intf_net -intf_net S01_AXIS_1 [get_bd_intf_pins S01_AXIS] [get_bd_intf_pins fifo_1/S_AXIS]
  connect_bd_intf_net -intf_net S02_AXIS_1 [get_bd_intf_pins S02_AXIS] [get_bd_intf_pins fifo_2/S_AXIS]
  connect_bd_intf_net -intf_net S03_AXIS_1 [get_bd_intf_pins S03_AXIS] [get_bd_intf_pins fifo_3/S_AXIS]
  connect_bd_intf_net -intf_net S04_AXIS_1 [get_bd_intf_pins S04_AXIS] [get_bd_intf_pins fifo_4/S_AXIS]
  connect_bd_intf_net -intf_net S05_AXIS_1 [get_bd_intf_pins S05_AXIS] [get_bd_intf_pins fifo_5/S_AXIS]
  connect_bd_intf_net -intf_net S06_AXIS_1 [get_bd_intf_pins S06_AXIS] [get_bd_intf_pins fifo_6/S_AXIS]
  connect_bd_intf_net -intf_net S07_AXIS_1 [get_bd_intf_pins S07_AXIS] [get_bd_intf_pins fifo_7/S_AXIS]
  connect_bd_intf_net -intf_net S_AXI_ITE_1 [get_bd_intf_pins S_AXI_LITE] [get_bd_intf_pins dma/S_AXI]
  connect_bd_intf_net -intf_net axi_regslice_M_AXI [get_bd_intf_pins M_AXI] [get_bd_intf_pins axi_regslice/M_AXI]
  connect_bd_intf_net -intf_net dma_M_AXI [get_bd_intf_pins axi_regslice/S_AXI] [get_bd_intf_pins dma/M_AXI]
  connect_bd_intf_net -intf_net fifo_0_M_AXIS [get_bd_intf_pins fifo_0/M_AXIS] [get_bd_intf_pins switch_main/S00_AXIS]
  connect_bd_intf_net -intf_net fifo_1_M_AXIS [get_bd_intf_pins fifo_1/M_AXIS] [get_bd_intf_pins switch_main/S01_AXIS]
  connect_bd_intf_net -intf_net fifo_2_M_AXIS [get_bd_intf_pins fifo_4/M_AXIS] [get_bd_intf_pins switch_sc/S00_AXIS]
  connect_bd_intf_net -intf_net fifo_2_M_AXIS1 [get_bd_intf_pins fifo_2/M_AXIS] [get_bd_intf_pins switch_main/S02_AXIS]
  connect_bd_intf_net -intf_net fifo_3_M_AXIS [get_bd_intf_pins fifo_5/M_AXIS] [get_bd_intf_pins switch_sc/S01_AXIS]
  connect_bd_intf_net -intf_net fifo_3_M_AXIS1 [get_bd_intf_pins fifo_3/M_AXIS] [get_bd_intf_pins switch_main/S03_AXIS]
  connect_bd_intf_net -intf_net fifo_4_M_AXIS [get_bd_intf_pins dma/S_AXIS_S2MM] [get_bd_intf_pins fifo_10/M_AXIS]
  connect_bd_intf_net -intf_net fifo_4_M_AXIS1 [get_bd_intf_pins fifo_6/M_AXIS] [get_bd_intf_pins switch_sc/S03_AXIS]
  connect_bd_intf_net -intf_net fifo_5_M_AXIS1 [get_bd_intf_pins fifo_7/M_AXIS] [get_bd_intf_pins switch_sc/S02_AXIS]
  connect_bd_intf_net -intf_net fifo_8_M_AXIS [get_bd_intf_pins fifo_8/M_AXIS] [get_bd_intf_pins switch_main/S04_AXIS]
  connect_bd_intf_net -intf_net fifo_9_M_AXIS [get_bd_intf_pins fifo_10/S_AXIS] [get_bd_intf_pins fifo_9/M_AXIS]
  connect_bd_intf_net -intf_net switch_main_M00_AXIS [get_bd_intf_pins fifo_9/S_AXIS] [get_bd_intf_pins switch_main/M00_AXIS]
  connect_bd_intf_net -intf_net switch_sc_M00_AXIS [get_bd_intf_pins fifo_8/S_AXIS] [get_bd_intf_pins switch_sc/M00_AXIS]

  # Create port connections
  connect_bd_net -net clk_1 [get_bd_pins clk] [get_bd_pins axi_regslice/aclk] [get_bd_pins dma/clk] [get_bd_pins fifo_0/s_aclk] [get_bd_pins fifo_1/s_aclk] [get_bd_pins fifo_10/s_aclk] [get_bd_pins fifo_2/s_aclk] [get_bd_pins fifo_3/s_aclk] [get_bd_pins fifo_4/s_aclk] [get_bd_pins fifo_5/s_aclk] [get_bd_pins fifo_6/s_aclk] [get_bd_pins fifo_7/s_aclk] [get_bd_pins fifo_8/s_aclk] [get_bd_pins fifo_9/s_aclk] [get_bd_pins switch_main/aclk] [get_bd_pins switch_sc/aclk]
  connect_bd_net -net dma_fifo_rst_n [get_bd_pins dma/fifo_rst_n] [get_bd_pins fifo_0/s_aresetn] [get_bd_pins fifo_1/s_aresetn] [get_bd_pins fifo_10/s_aresetn] [get_bd_pins fifo_2/s_aresetn] [get_bd_pins fifo_3/s_aresetn] [get_bd_pins fifo_4/s_aresetn] [get_bd_pins fifo_5/s_aresetn] [get_bd_pins fifo_6/s_aresetn] [get_bd_pins fifo_7/s_aresetn] [get_bd_pins fifo_8/s_aresetn] [get_bd_pins fifo_9/s_aresetn] [get_bd_pins switch_main/aresetn] [get_bd_pins switch_sc/aresetn]
  connect_bd_net -net dma_irq [get_bd_pins irq] [get_bd_pins dma/irq]
  connect_bd_net -net fifo_4_axis_data_count [get_bd_pins dma/fifo_occupancy] [get_bd_pins fifo_10/axis_data_count]
  connect_bd_net -net rst_n_1 [get_bd_pins rst_n] [get_bd_pins axi_regslice/aresetn] [get_bd_pins dma/rst_n]

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
  set eth96 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 eth96 ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {625000000} \
   ] $eth96
  set eth96_p0 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:sgmii_rtl:1.0 eth96_p0 ]
  set eth96_p1 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:sgmii_rtl:1.0 eth96_p1 ]
  set eth96_p2 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:sgmii_rtl:1.0 eth96_p2 ]
  set eth96_p3 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:sgmii_rtl:1.0 eth96_p3 ]
  set eth96_unused [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:sgmii_rtl:1.0 eth96_unused ]

  # Create ports
  set eth96_p0_rst_n [ create_bd_port -dir O -from 0 -to 0 eth96_p0_rst_n ]
  set eth96_p1_rst_n [ create_bd_port -dir O -from 0 -to 0 eth96_p1_rst_n ]
  set eth96_p2_rst_n [ create_bd_port -dir O -from 0 -to 0 eth96_p2_rst_n ]
  set eth96_p3_rst_n [ create_bd_port -dir O -from 0 -to 0 eth96_p3_rst_n ]
  set mdc [ create_bd_port -dir O -type clk mdc ]
  set mdio [ create_bd_port -dir IO -from 0 -to 0 mdio ]

  # Create instance: axi_ethlite, and set properties
  set axi_ethlite [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_ethernetlite:3.0 axi_ethlite ]
  set_property -dict [ list \
   CONFIG.C_INCLUDE_GLOBAL_BUFFERS {0} \
   CONFIG.C_INCLUDE_INTERNAL_LOOPBACK {0} \
   CONFIG.C_RX_PING_PONG {0} \
   CONFIG.C_TX_PING_PONG {0} \
 ] $axi_ethlite

  # Create instance: constant_0, and set properties
  set constant_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 constant_0 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
 ] $constant_0

  # Create instance: constant_1, and set properties
  set constant_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 constant_1 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {1} \
 ] $constant_1

  # Create instance: dma
  create_hier_cell_dma [current_bd_instance .] dma

  # Create instance: gmii_to_sgmii
  create_hier_cell_gmii_to_sgmii [current_bd_instance .] gmii_to_sgmii

  # Create instance: mdio_iobuf, and set properties
  set mdio_iobuf [ create_bd_cell -type ip -vlnv oscar-rc.dev:zbnt_hw:util_iobuf:1.0 mdio_iobuf ]

  # Create instance: mitm_a
  create_hier_cell_mitm_a [current_bd_instance .] mitm_a

  # Create instance: mitm_b
  create_hier_cell_mitm_b [current_bd_instance .] mitm_b

  # Create instance: ps_interconnect, and set properties
  set ps_interconnect [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 ps_interconnect ]
  set_property -dict [ list \
   CONFIG.ENABLE_ADVANCED_OPTIONS {0} \
   CONFIG.NUM_MI {9} \
 ] $ps_interconnect

  # Create instance: ps_main, and set properties
  set ps_main [ create_bd_cell -type ip -vlnv xilinx.com:ip:zynq_ultra_ps_e:3.2 ps_main ]
  set_property -dict [ list \
   CONFIG.PSU_BANK_0_IO_STANDARD {LVCMOS18} \
   CONFIG.PSU_BANK_1_IO_STANDARD {LVCMOS18} \
   CONFIG.PSU_BANK_2_IO_STANDARD {LVCMOS18} \
   CONFIG.PSU_BANK_3_IO_STANDARD {LVCMOS18} \
   CONFIG.PSU_DDR_RAM_HIGHADDR {0x7FFFFFFF} \
   CONFIG.PSU_DDR_RAM_HIGHADDR_OFFSET {0x00000002} \
   CONFIG.PSU_DDR_RAM_LOWADDR_OFFSET {0x80000000} \
   CONFIG.PSU_MIO_0_DIRECTION {out} \
   CONFIG.PSU_MIO_0_INPUT_TYPE {schmitt} \
   CONFIG.PSU_MIO_10_DIRECTION {inout} \
   CONFIG.PSU_MIO_11_DIRECTION {inout} \
   CONFIG.PSU_MIO_12_DIRECTION {inout} \
   CONFIG.PSU_MIO_13_DIRECTION {inout} \
   CONFIG.PSU_MIO_13_DRIVE_STRENGTH {4} \
   CONFIG.PSU_MIO_14_DIRECTION {inout} \
   CONFIG.PSU_MIO_14_DRIVE_STRENGTH {4} \
   CONFIG.PSU_MIO_15_DIRECTION {inout} \
   CONFIG.PSU_MIO_15_DRIVE_STRENGTH {4} \
   CONFIG.PSU_MIO_16_DIRECTION {inout} \
   CONFIG.PSU_MIO_16_DRIVE_STRENGTH {4} \
   CONFIG.PSU_MIO_17_DIRECTION {inout} \
   CONFIG.PSU_MIO_18_DIRECTION {inout} \
   CONFIG.PSU_MIO_19_DIRECTION {inout} \
   CONFIG.PSU_MIO_1_DIRECTION {in} \
   CONFIG.PSU_MIO_1_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_1_SLEW {slow} \
   CONFIG.PSU_MIO_20_DIRECTION {inout} \
   CONFIG.PSU_MIO_21_DIRECTION {inout} \
   CONFIG.PSU_MIO_21_DRIVE_STRENGTH {4} \
   CONFIG.PSU_MIO_22_DIRECTION {out} \
   CONFIG.PSU_MIO_22_DRIVE_STRENGTH {4} \
   CONFIG.PSU_MIO_22_INPUT_TYPE {schmitt} \
   CONFIG.PSU_MIO_23_DIRECTION {inout} \
   CONFIG.PSU_MIO_24_DIRECTION {in} \
   CONFIG.PSU_MIO_24_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_24_SLEW {slow} \
   CONFIG.PSU_MIO_25_DIRECTION {inout} \
   CONFIG.PSU_MIO_26_DIRECTION {in} \
   CONFIG.PSU_MIO_26_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_26_SLEW {slow} \
   CONFIG.PSU_MIO_27_DIRECTION {out} \
   CONFIG.PSU_MIO_27_INPUT_TYPE {schmitt} \
   CONFIG.PSU_MIO_28_DIRECTION {in} \
   CONFIG.PSU_MIO_28_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_28_SLEW {slow} \
   CONFIG.PSU_MIO_29_DIRECTION {out} \
   CONFIG.PSU_MIO_29_INPUT_TYPE {schmitt} \
   CONFIG.PSU_MIO_2_DIRECTION {in} \
   CONFIG.PSU_MIO_2_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_2_SLEW {slow} \
   CONFIG.PSU_MIO_30_DIRECTION {in} \
   CONFIG.PSU_MIO_30_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_30_SLEW {slow} \
   CONFIG.PSU_MIO_31_DIRECTION {inout} \
   CONFIG.PSU_MIO_31_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_31_INPUT_TYPE {schmitt} \
   CONFIG.PSU_MIO_31_SLEW {slow} \
   CONFIG.PSU_MIO_32_DIRECTION {out} \
   CONFIG.PSU_MIO_32_INPUT_TYPE {schmitt} \
   CONFIG.PSU_MIO_33_DIRECTION {out} \
   CONFIG.PSU_MIO_33_INPUT_TYPE {schmitt} \
   CONFIG.PSU_MIO_34_DIRECTION {out} \
   CONFIG.PSU_MIO_34_INPUT_TYPE {schmitt} \
   CONFIG.PSU_MIO_35_DIRECTION {inout} \
   CONFIG.PSU_MIO_35_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_35_INPUT_TYPE {schmitt} \
   CONFIG.PSU_MIO_35_SLEW {slow} \
   CONFIG.PSU_MIO_36_DIRECTION {inout} \
   CONFIG.PSU_MIO_36_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_36_INPUT_TYPE {schmitt} \
   CONFIG.PSU_MIO_36_SLEW {slow} \
   CONFIG.PSU_MIO_37_DIRECTION {inout} \
   CONFIG.PSU_MIO_37_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_37_INPUT_TYPE {schmitt} \
   CONFIG.PSU_MIO_37_SLEW {slow} \
   CONFIG.PSU_MIO_38_DIRECTION {inout} \
   CONFIG.PSU_MIO_39_DIRECTION {inout} \
   CONFIG.PSU_MIO_39_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_39_SLEW {fast} \
   CONFIG.PSU_MIO_3_DIRECTION {out} \
   CONFIG.PSU_MIO_3_INPUT_TYPE {schmitt} \
   CONFIG.PSU_MIO_40_DIRECTION {inout} \
   CONFIG.PSU_MIO_41_DIRECTION {inout} \
   CONFIG.PSU_MIO_42_DIRECTION {inout} \
   CONFIG.PSU_MIO_43_DIRECTION {inout} \
   CONFIG.PSU_MIO_44_DIRECTION {inout} \
   CONFIG.PSU_MIO_45_DIRECTION {inout} \
   CONFIG.PSU_MIO_46_DIRECTION {inout} \
   CONFIG.PSU_MIO_47_DIRECTION {inout} \
   CONFIG.PSU_MIO_48_DIRECTION {inout} \
   CONFIG.PSU_MIO_49_DIRECTION {inout} \
   CONFIG.PSU_MIO_4_DIRECTION {inout} \
   CONFIG.PSU_MIO_50_DIRECTION {inout} \
   CONFIG.PSU_MIO_51_DIRECTION {out} \
   CONFIG.PSU_MIO_51_INPUT_TYPE {schmitt} \
   CONFIG.PSU_MIO_52_DIRECTION {in} \
   CONFIG.PSU_MIO_52_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_52_SLEW {slow} \
   CONFIG.PSU_MIO_53_DIRECTION {in} \
   CONFIG.PSU_MIO_53_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_53_SLEW {slow} \
   CONFIG.PSU_MIO_54_DIRECTION {inout} \
   CONFIG.PSU_MIO_55_DIRECTION {in} \
   CONFIG.PSU_MIO_55_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_55_SLEW {slow} \
   CONFIG.PSU_MIO_56_DIRECTION {inout} \
   CONFIG.PSU_MIO_57_DIRECTION {inout} \
   CONFIG.PSU_MIO_58_DIRECTION {out} \
   CONFIG.PSU_MIO_58_INPUT_TYPE {schmitt} \
   CONFIG.PSU_MIO_59_DIRECTION {inout} \
   CONFIG.PSU_MIO_5_DIRECTION {inout} \
   CONFIG.PSU_MIO_60_DIRECTION {inout} \
   CONFIG.PSU_MIO_61_DIRECTION {inout} \
   CONFIG.PSU_MIO_62_DIRECTION {inout} \
   CONFIG.PSU_MIO_63_DIRECTION {inout} \
   CONFIG.PSU_MIO_64_DIRECTION {in} \
   CONFIG.PSU_MIO_64_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_64_SLEW {slow} \
   CONFIG.PSU_MIO_65_DIRECTION {in} \
   CONFIG.PSU_MIO_65_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_65_SLEW {slow} \
   CONFIG.PSU_MIO_66_DIRECTION {inout} \
   CONFIG.PSU_MIO_67_DIRECTION {in} \
   CONFIG.PSU_MIO_67_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_67_SLEW {slow} \
   CONFIG.PSU_MIO_68_DIRECTION {inout} \
   CONFIG.PSU_MIO_69_DIRECTION {inout} \
   CONFIG.PSU_MIO_6_DIRECTION {inout} \
   CONFIG.PSU_MIO_70_DIRECTION {out} \
   CONFIG.PSU_MIO_70_INPUT_TYPE {schmitt} \
   CONFIG.PSU_MIO_71_DIRECTION {inout} \
   CONFIG.PSU_MIO_72_DIRECTION {inout} \
   CONFIG.PSU_MIO_73_DIRECTION {inout} \
   CONFIG.PSU_MIO_74_DIRECTION {inout} \
   CONFIG.PSU_MIO_75_DIRECTION {inout} \
   CONFIG.PSU_MIO_76_DIRECTION {inout} \
   CONFIG.PSU_MIO_76_INPUT_TYPE {schmitt} \
   CONFIG.PSU_MIO_77_DIRECTION {inout} \
   CONFIG.PSU_MIO_7_DIRECTION {inout} \
   CONFIG.PSU_MIO_8_DIRECTION {inout} \
   CONFIG.PSU_MIO_9_DIRECTION {inout} \
   CONFIG.PSU_MIO_TREE_PERIPHERALS {UART 1#UART 1#UART 0#UART 0#I2C 1#I2C 1#SPI 1#GPIO0 MIO#GPIO0 MIO#SPI 1#SPI 1#SPI 1#GPIO0 MIO#SD 0#SD 0#SD 0#SD 0#GPIO0 MIO#GPIO0 MIO#GPIO0 MIO#GPIO0 MIO#SD 0#SD 0#GPIO0 MIO#SD 0#GPIO0 MIO#PMU GPI 0#DPAUX#DPAUX#DPAUX#DPAUX#GPIO1 MIO#PMU GPO 0#PMU GPO 1#PMU GPO 2#GPIO1 MIO#GPIO1 MIO#GPIO1 MIO#SPI 0#GPIO1 MIO#GPIO1 MIO#SPI 0#SPI 0#SPI 0#GPIO1 MIO#GPIO1 MIO#SD 1#SD 1#SD 1#SD 1#SD 1#SD 1#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 1#USB 1#USB 1#USB 1#USB 1#USB 1#USB 1#USB 1#USB 1#USB 1#USB 1#USB 1#GPIO2 MIO#GPIO2 MIO} \
   CONFIG.PSU_MIO_TREE_SIGNALS {txd#rxd#rxd#txd#scl_out#sda_out#sclk_out#gpio0[7]#gpio0[8]#n_ss_out[0]#miso#mosi#gpio0[12]#sdio0_data_out[0]#sdio0_data_out[1]#sdio0_data_out[2]#sdio0_data_out[3]#gpio0[17]#gpio0[18]#gpio0[19]#gpio0[20]#sdio0_cmd_out#sdio0_clk_out#gpio0[23]#sdio0_cd_n#gpio0[25]#gpi[0]#dp_aux_data_out#dp_hot_plug_detect#dp_aux_data_oe#dp_aux_data_in#gpio1[31]#gpo[0]#gpo[1]#gpo[2]#gpio1[35]#gpio1[36]#gpio1[37]#sclk_out#gpio1[39]#gpio1[40]#n_ss_out[0]#miso#mosi#gpio1[44]#gpio1[45]#sdio1_data_out[0]#sdio1_data_out[1]#sdio1_data_out[2]#sdio1_data_out[3]#sdio1_cmd_out#sdio1_clk_out#ulpi_clk_in#ulpi_dir#ulpi_tx_data[2]#ulpi_nxt#ulpi_tx_data[0]#ulpi_tx_data[1]#ulpi_stp#ulpi_tx_data[3]#ulpi_tx_data[4]#ulpi_tx_data[5]#ulpi_tx_data[6]#ulpi_tx_data[7]#ulpi_clk_in#ulpi_dir#ulpi_tx_data[2]#ulpi_nxt#ulpi_tx_data[0]#ulpi_tx_data[1]#ulpi_stp#ulpi_tx_data[3]#ulpi_tx_data[4]#ulpi_tx_data[5]#ulpi_tx_data[6]#ulpi_tx_data[7]#gpio2[76]#gpio2[77]} \
   CONFIG.PSU_SD0_INTERNAL_BUS_WIDTH {4} \
   CONFIG.PSU_SD1_INTERNAL_BUS_WIDTH {4} \
   CONFIG.PSU__ACT_DDR_FREQ_MHZ {525.000000} \
   CONFIG.PSU__AFI0_COHERENCY {0} \
   CONFIG.PSU__CAN1__GRP_CLK__ENABLE {0} \
   CONFIG.PSU__CAN1__PERIPHERAL__ENABLE {0} \
   CONFIG.PSU__CRF_APB__ACPU_CTRL__ACT_FREQMHZ {1200.000000} \
   CONFIG.PSU__CRF_APB__ACPU_CTRL__DIVISOR0 {1} \
   CONFIG.PSU__CRF_APB__ACPU_CTRL__SRCSEL {APLL} \
   CONFIG.PSU__CRF_APB__APLL_CTRL__DIV2 {1} \
   CONFIG.PSU__CRF_APB__APLL_CTRL__FBDIV {72} \
   CONFIG.PSU__CRF_APB__APLL_CTRL__FRACDATA {0.000000} \
   CONFIG.PSU__CRF_APB__APLL_CTRL__SRCSEL {PSS_REF_CLK} \
   CONFIG.PSU__CRF_APB__APLL_FRAC_CFG__ENABLED {0} \
   CONFIG.PSU__CRF_APB__APLL_TO_LPD_CTRL__DIVISOR0 {3} \
   CONFIG.PSU__CRF_APB__DBG_FPD_CTRL__ACT_FREQMHZ {250.000000} \
   CONFIG.PSU__CRF_APB__DBG_FPD_CTRL__DIVISOR0 {2} \
   CONFIG.PSU__CRF_APB__DBG_FPD_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRF_APB__DBG_TRACE_CTRL__DIVISOR0 {5} \
   CONFIG.PSU__CRF_APB__DBG_TRACE_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRF_APB__DBG_TSTMP_CTRL__ACT_FREQMHZ {250.000000} \
   CONFIG.PSU__CRF_APB__DBG_TSTMP_CTRL__DIVISOR0 {2} \
   CONFIG.PSU__CRF_APB__DBG_TSTMP_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRF_APB__DDR_CTRL__ACT_FREQMHZ {262.500000} \
   CONFIG.PSU__CRF_APB__DDR_CTRL__DIVISOR0 {4} \
   CONFIG.PSU__CRF_APB__DDR_CTRL__FREQMHZ {533} \
   CONFIG.PSU__CRF_APB__DDR_CTRL__SRCSEL {DPLL} \
   CONFIG.PSU__CRF_APB__DPDMA_REF_CTRL__ACT_FREQMHZ {600.000000} \
   CONFIG.PSU__CRF_APB__DPDMA_REF_CTRL__DIVISOR0 {2} \
   CONFIG.PSU__CRF_APB__DPDMA_REF_CTRL__SRCSEL {APLL} \
   CONFIG.PSU__CRF_APB__DPLL_CTRL__DIV2 {1} \
   CONFIG.PSU__CRF_APB__DPLL_CTRL__FBDIV {63} \
   CONFIG.PSU__CRF_APB__DPLL_CTRL__FRACDATA {0.000000} \
   CONFIG.PSU__CRF_APB__DPLL_CTRL__SRCSEL {PSS_REF_CLK} \
   CONFIG.PSU__CRF_APB__DPLL_FRAC_CFG__ENABLED {0} \
   CONFIG.PSU__CRF_APB__DPLL_TO_LPD_CTRL__DIVISOR0 {2} \
   CONFIG.PSU__CRF_APB__DP_AUDIO_REF_CTRL__ACT_FREQMHZ {25.000000} \
   CONFIG.PSU__CRF_APB__DP_AUDIO_REF_CTRL__DIVISOR0 {20} \
   CONFIG.PSU__CRF_APB__DP_AUDIO_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRF_APB__DP_AUDIO_REF_CTRL__SRCSEL {RPLL} \
   CONFIG.PSU__CRF_APB__DP_AUDIO__FRAC_ENABLED {1} \
   CONFIG.PSU__CRF_APB__DP_STC_REF_CTRL__ACT_FREQMHZ {26.315790} \
   CONFIG.PSU__CRF_APB__DP_STC_REF_CTRL__DIVISOR0 {19} \
   CONFIG.PSU__CRF_APB__DP_STC_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRF_APB__DP_STC_REF_CTRL__SRCSEL {RPLL} \
   CONFIG.PSU__CRF_APB__DP_VIDEO_REF_CTRL__ACT_FREQMHZ {300.000000} \
   CONFIG.PSU__CRF_APB__DP_VIDEO_REF_CTRL__DIVISOR0 {5} \
   CONFIG.PSU__CRF_APB__DP_VIDEO_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRF_APB__DP_VIDEO_REF_CTRL__SRCSEL {VPLL} \
   CONFIG.PSU__CRF_APB__DP_VIDEO__FRAC_ENABLED {1} \
   CONFIG.PSU__CRF_APB__GDMA_REF_CTRL__ACT_FREQMHZ {600.000000} \
   CONFIG.PSU__CRF_APB__GDMA_REF_CTRL__DIVISOR0 {2} \
   CONFIG.PSU__CRF_APB__GDMA_REF_CTRL__SRCSEL {APLL} \
   CONFIG.PSU__CRF_APB__GPU_REF_CTRL__ACT_FREQMHZ {500.000000} \
   CONFIG.PSU__CRF_APB__GPU_REF_CTRL__DIVISOR0 {1} \
   CONFIG.PSU__CRF_APB__GPU_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRF_APB__PCIE_REF_CTRL__DIVISOR0 {6} \
   CONFIG.PSU__CRF_APB__PCIE_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRF_APB__SATA_REF_CTRL__DIVISOR0 {5} \
   CONFIG.PSU__CRF_APB__SATA_REF_CTRL__FREQMHZ {250} \
   CONFIG.PSU__CRF_APB__SATA_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRF_APB__TOPSW_LSBUS_CTRL__ACT_FREQMHZ {100.000000} \
   CONFIG.PSU__CRF_APB__TOPSW_LSBUS_CTRL__DIVISOR0 {5} \
   CONFIG.PSU__CRF_APB__TOPSW_LSBUS_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRF_APB__TOPSW_MAIN_CTRL__ACT_FREQMHZ {525.000000} \
   CONFIG.PSU__CRF_APB__TOPSW_MAIN_CTRL__DIVISOR0 {2} \
   CONFIG.PSU__CRF_APB__TOPSW_MAIN_CTRL__SRCSEL {DPLL} \
   CONFIG.PSU__CRF_APB__VPLL_CTRL__DIV2 {1} \
   CONFIG.PSU__CRF_APB__VPLL_CTRL__FBDIV {90} \
   CONFIG.PSU__CRF_APB__VPLL_CTRL__FRACDATA {0.000000} \
   CONFIG.PSU__CRF_APB__VPLL_CTRL__FRACFREQ {300} \
   CONFIG.PSU__CRF_APB__VPLL_CTRL__SRCSEL {PSS_REF_CLK} \
   CONFIG.PSU__CRF_APB__VPLL_FRAC_CFG__ENABLED {1} \
   CONFIG.PSU__CRF_APB__VPLL_TO_LPD_CTRL__DIVISOR0 {3} \
   CONFIG.PSU__CRL_APB__ADMA_REF_CTRL__ACT_FREQMHZ {500.000000} \
   CONFIG.PSU__CRL_APB__ADMA_REF_CTRL__DIVISOR0 {3} \
   CONFIG.PSU__CRL_APB__ADMA_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__AFI6_REF_CTRL__DIVISOR0 {3} \
   CONFIG.PSU__CRL_APB__AMS_REF_CTRL__ACT_FREQMHZ {50.000000} \
   CONFIG.PSU__CRL_APB__AMS_REF_CTRL__DIVISOR0 {30} \
   CONFIG.PSU__CRL_APB__AMS_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__AMS_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__CAN0_REF_CTRL__DIVISOR0 {15} \
   CONFIG.PSU__CRL_APB__CAN0_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__CAN0_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__CAN1_REF_CTRL__DIVISOR0 {15} \
   CONFIG.PSU__CRL_APB__CAN1_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__CAN1_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__CPU_R5_CTRL__ACT_FREQMHZ {500.000000} \
   CONFIG.PSU__CRL_APB__CPU_R5_CTRL__DIVISOR0 {3} \
   CONFIG.PSU__CRL_APB__CPU_R5_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__CSU_PLL_CTRL__ACT_FREQMHZ {500} \
   CONFIG.PSU__CRL_APB__CSU_PLL_CTRL__DIVISOR0 {4} \
   CONFIG.PSU__CRL_APB__CSU_PLL_CTRL__FREQMHZ {400} \
   CONFIG.PSU__CRL_APB__CSU_PLL_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__DBG_LPD_CTRL__ACT_FREQMHZ {250.000000} \
   CONFIG.PSU__CRL_APB__DBG_LPD_CTRL__DIVISOR0 {6} \
   CONFIG.PSU__CRL_APB__DBG_LPD_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__DLL_REF_CTRL__ACT_FREQMHZ {1500.000000} \
   CONFIG.PSU__CRL_APB__GEM0_REF_CTRL__ACT_FREQMHZ {125} \
   CONFIG.PSU__CRL_APB__GEM0_REF_CTRL__DIVISOR0 {12} \
   CONFIG.PSU__CRL_APB__GEM0_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__GEM0_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__GEM1_REF_CTRL__DIVISOR0 {12} \
   CONFIG.PSU__CRL_APB__GEM1_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__GEM1_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__GEM2_REF_CTRL__DIVISOR0 {12} \
   CONFIG.PSU__CRL_APB__GEM2_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__GEM2_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__GEM3_REF_CTRL__DIVISOR0 {12} \
   CONFIG.PSU__CRL_APB__GEM3_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__GEM3_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__GEM_TSU_REF_CTRL__ACT_FREQMHZ {250} \
   CONFIG.PSU__CRL_APB__GEM_TSU_REF_CTRL__DIVISOR0 {4} \
   CONFIG.PSU__CRL_APB__GEM_TSU_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__GEM_TSU_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__I2C0_REF_CTRL__DIVISOR0 {15} \
   CONFIG.PSU__CRL_APB__I2C0_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__I2C0_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__I2C1_REF_CTRL__ACT_FREQMHZ {100.000000} \
   CONFIG.PSU__CRL_APB__I2C1_REF_CTRL__DIVISOR0 {15} \
   CONFIG.PSU__CRL_APB__I2C1_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__I2C1_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__IOPLL_CTRL__DIV2 {1} \
   CONFIG.PSU__CRL_APB__IOPLL_CTRL__FBDIV {90} \
   CONFIG.PSU__CRL_APB__IOPLL_CTRL__FRACDATA {0.000000} \
   CONFIG.PSU__CRL_APB__IOPLL_CTRL__SRCSEL {PSS_REF_CLK} \
   CONFIG.PSU__CRL_APB__IOPLL_FRAC_CFG__ENABLED {0} \
   CONFIG.PSU__CRL_APB__IOPLL_TO_FPD_CTRL__DIVISOR0 {3} \
   CONFIG.PSU__CRL_APB__IOU_SWITCH_CTRL__ACT_FREQMHZ {250.000000} \
   CONFIG.PSU__CRL_APB__IOU_SWITCH_CTRL__DIVISOR0 {6} \
   CONFIG.PSU__CRL_APB__IOU_SWITCH_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__LPD_LSBUS_CTRL__ACT_FREQMHZ {100.000000} \
   CONFIG.PSU__CRL_APB__LPD_LSBUS_CTRL__DIVISOR0 {15} \
   CONFIG.PSU__CRL_APB__LPD_LSBUS_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__LPD_SWITCH_CTRL__ACT_FREQMHZ {500.000000} \
   CONFIG.PSU__CRL_APB__LPD_SWITCH_CTRL__DIVISOR0 {3} \
   CONFIG.PSU__CRL_APB__LPD_SWITCH_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__NAND_REF_CTRL__DIVISOR0 {15} \
   CONFIG.PSU__CRL_APB__NAND_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__NAND_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__PCAP_CTRL__ACT_FREQMHZ {187.500000} \
   CONFIG.PSU__CRL_APB__PCAP_CTRL__DIVISOR0 {8} \
   CONFIG.PSU__CRL_APB__PCAP_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__PL0_REF_CTRL__ACT_FREQMHZ {125.000000} \
   CONFIG.PSU__CRL_APB__PL0_REF_CTRL__DIVISOR0 {12} \
   CONFIG.PSU__CRL_APB__PL0_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__PL0_REF_CTRL__FREQMHZ {125} \
   CONFIG.PSU__CRL_APB__PL0_REF_CTRL__SRCSEL {RPLL} \
   CONFIG.PSU__CRL_APB__PL1_REF_CTRL__ACT_FREQMHZ {2.000000} \
   CONFIG.PSU__CRL_APB__PL1_REF_CTRL__DIVISOR0 {4} \
   CONFIG.PSU__CRL_APB__PL1_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__PL1_REF_CTRL__FREQMHZ {100} \
   CONFIG.PSU__CRL_APB__PL1_REF_CTRL__SRCSEL {RPLL} \
   CONFIG.PSU__CRL_APB__PL2_REF_CTRL__ACT_FREQMHZ {299.999700} \
   CONFIG.PSU__CRL_APB__PL2_REF_CTRL__DIVISOR0 {4} \
   CONFIG.PSU__CRL_APB__PL2_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__PL2_REF_CTRL__FREQMHZ {100} \
   CONFIG.PSU__CRL_APB__PL2_REF_CTRL__SRCSEL {RPLL} \
   CONFIG.PSU__CRL_APB__PL3_REF_CTRL__ACT_FREQMHZ {374.999625} \
   CONFIG.PSU__CRL_APB__PL3_REF_CTRL__DIVISOR0 {4} \
   CONFIG.PSU__CRL_APB__PL3_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__PL3_REF_CTRL__FREQMHZ {100} \
   CONFIG.PSU__CRL_APB__PL3_REF_CTRL__SRCSEL {RPLL} \
   CONFIG.PSU__CRL_APB__QSPI_REF_CTRL__DIVISOR0 {5} \
   CONFIG.PSU__CRL_APB__QSPI_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__QSPI_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__RPLL_CTRL__DIV2 {1} \
   CONFIG.PSU__CRL_APB__RPLL_CTRL__FBDIV {90} \
   CONFIG.PSU__CRL_APB__RPLL_CTRL__FRACDATA {0.000000} \
   CONFIG.PSU__CRL_APB__RPLL_CTRL__FRACFREQ {25} \
   CONFIG.PSU__CRL_APB__RPLL_CTRL__SRCSEL {PSS_REF_CLK} \
   CONFIG.PSU__CRL_APB__RPLL_FRAC_CFG__ENABLED {1} \
   CONFIG.PSU__CRL_APB__RPLL_TO_FPD_CTRL__DIVISOR0 {3} \
   CONFIG.PSU__CRL_APB__SDIO0_REF_CTRL__ACT_FREQMHZ {187.500000} \
   CONFIG.PSU__CRL_APB__SDIO0_REF_CTRL__DIVISOR0 {8} \
   CONFIG.PSU__CRL_APB__SDIO0_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__SDIO0_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__SDIO1_REF_CTRL__ACT_FREQMHZ {187.500000} \
   CONFIG.PSU__CRL_APB__SDIO1_REF_CTRL__DIVISOR0 {8} \
   CONFIG.PSU__CRL_APB__SDIO1_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__SDIO1_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__SPI0_REF_CTRL__ACT_FREQMHZ {187.500000} \
   CONFIG.PSU__CRL_APB__SPI0_REF_CTRL__DIVISOR0 {8} \
   CONFIG.PSU__CRL_APB__SPI0_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__SPI0_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__SPI1_REF_CTRL__ACT_FREQMHZ {187.500000} \
   CONFIG.PSU__CRL_APB__SPI1_REF_CTRL__DIVISOR0 {8} \
   CONFIG.PSU__CRL_APB__SPI1_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__SPI1_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__TIMESTAMP_REF_CTRL__ACT_FREQMHZ {100.000000} \
   CONFIG.PSU__CRL_APB__TIMESTAMP_REF_CTRL__DIVISOR0 {15} \
   CONFIG.PSU__CRL_APB__TIMESTAMP_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__UART0_REF_CTRL__ACT_FREQMHZ {100.000000} \
   CONFIG.PSU__CRL_APB__UART0_REF_CTRL__DIVISOR0 {15} \
   CONFIG.PSU__CRL_APB__UART0_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__UART0_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__UART1_REF_CTRL__ACT_FREQMHZ {100.000000} \
   CONFIG.PSU__CRL_APB__UART1_REF_CTRL__DIVISOR0 {15} \
   CONFIG.PSU__CRL_APB__UART1_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__UART1_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__USB0_BUS_REF_CTRL__ACT_FREQMHZ {250.000000} \
   CONFIG.PSU__CRL_APB__USB0_BUS_REF_CTRL__DIVISOR0 {6} \
   CONFIG.PSU__CRL_APB__USB0_BUS_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__USB0_BUS_REF_CTRL__FREQMHZ {250} \
   CONFIG.PSU__CRL_APB__USB0_BUS_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__USB1_BUS_REF_CTRL__ACT_FREQMHZ {250.000000} \
   CONFIG.PSU__CRL_APB__USB1_BUS_REF_CTRL__DIVISOR0 {6} \
   CONFIG.PSU__CRL_APB__USB1_BUS_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__USB1_BUS_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__USB3_DUAL_REF_CTRL__ACT_FREQMHZ {20.000000} \
   CONFIG.PSU__CRL_APB__USB3_DUAL_REF_CTRL__DIVISOR0 {25} \
   CONFIG.PSU__CRL_APB__USB3_DUAL_REF_CTRL__DIVISOR1 {3} \
   CONFIG.PSU__CRL_APB__USB3_DUAL_REF_CTRL__FREQMHZ {20} \
   CONFIG.PSU__CRL_APB__USB3_DUAL_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__USB3__ENABLE {1} \
   CONFIG.PSU__CSUPMU__PERIPHERAL__VALID {1} \
   CONFIG.PSU__DDRC__ADDR_MIRROR {1} \
   CONFIG.PSU__DDRC__AL {0} \
   CONFIG.PSU__DDRC__BANK_ADDR_COUNT {3} \
   CONFIG.PSU__DDRC__BG_ADDR_COUNT {NA} \
   CONFIG.PSU__DDRC__BRC_MAPPING {ROW_BANK_COL} \
   CONFIG.PSU__DDRC__BUS_WIDTH {32 Bit} \
   CONFIG.PSU__DDRC__CL {NA} \
   CONFIG.PSU__DDRC__CLOCK_STOP_EN {0} \
   CONFIG.PSU__DDRC__COL_ADDR_COUNT {10} \
   CONFIG.PSU__DDRC__COMPONENTS {Components} \
   CONFIG.PSU__DDRC__CWL {NA} \
   CONFIG.PSU__DDRC__DDR3L_T_REF_RANGE {NA} \
   CONFIG.PSU__DDRC__DDR3_T_REF_RANGE {NA} \
   CONFIG.PSU__DDRC__DDR4_ADDR_MAPPING {NA} \
   CONFIG.PSU__DDRC__DDR4_CAL_MODE_ENABLE {NA} \
   CONFIG.PSU__DDRC__DDR4_CRC_CONTROL {NA} \
   CONFIG.PSU__DDRC__DDR4_MAXPWR_SAVING_EN {NA} \
   CONFIG.PSU__DDRC__DDR4_T_REF_MODE {NA} \
   CONFIG.PSU__DDRC__DDR4_T_REF_RANGE {NA} \
   CONFIG.PSU__DDRC__DEEP_PWR_DOWN_EN {0} \
   CONFIG.PSU__DDRC__DEVICE_CAPACITY {8192 MBits} \
   CONFIG.PSU__DDRC__DIMM_ADDR_MIRROR {NA} \
   CONFIG.PSU__DDRC__DM_DBI {DM_NO_DBI} \
   CONFIG.PSU__DDRC__DQMAP_0_3 {0} \
   CONFIG.PSU__DDRC__DQMAP_12_15 {0} \
   CONFIG.PSU__DDRC__DQMAP_16_19 {0} \
   CONFIG.PSU__DDRC__DQMAP_20_23 {0} \
   CONFIG.PSU__DDRC__DQMAP_24_27 {0} \
   CONFIG.PSU__DDRC__DQMAP_28_31 {0} \
   CONFIG.PSU__DDRC__DQMAP_32_35 {0} \
   CONFIG.PSU__DDRC__DQMAP_36_39 {0} \
   CONFIG.PSU__DDRC__DQMAP_40_43 {0} \
   CONFIG.PSU__DDRC__DQMAP_44_47 {0} \
   CONFIG.PSU__DDRC__DQMAP_48_51 {0} \
   CONFIG.PSU__DDRC__DQMAP_4_7 {0} \
   CONFIG.PSU__DDRC__DQMAP_52_55 {0} \
   CONFIG.PSU__DDRC__DQMAP_56_59 {0} \
   CONFIG.PSU__DDRC__DQMAP_60_63 {0} \
   CONFIG.PSU__DDRC__DQMAP_64_67 {0} \
   CONFIG.PSU__DDRC__DQMAP_68_71 {0} \
   CONFIG.PSU__DDRC__DQMAP_8_11 {0} \
   CONFIG.PSU__DDRC__DRAM_WIDTH {32 Bits} \
   CONFIG.PSU__DDRC__ECC {Disabled} \
   CONFIG.PSU__DDRC__ENABLE_2T_TIMING {0} \
   CONFIG.PSU__DDRC__ENABLE_DP_SWITCH {1} \
   CONFIG.PSU__DDRC__ENABLE_LP4_HAS_ECC_COMP {0} \
   CONFIG.PSU__DDRC__ENABLE_LP4_SLOWBOOT {0} \
   CONFIG.PSU__DDRC__FGRM {NA} \
   CONFIG.PSU__DDRC__LPDDR3_T_REF_RANGE {NA} \
   CONFIG.PSU__DDRC__LPDDR4_T_REF_RANGE {Normal (0-85)} \
   CONFIG.PSU__DDRC__LP_ASR {NA} \
   CONFIG.PSU__DDRC__MEMORY_TYPE {LPDDR 4} \
   CONFIG.PSU__DDRC__PARITY_ENABLE {NA} \
   CONFIG.PSU__DDRC__PER_BANK_REFRESH {0} \
   CONFIG.PSU__DDRC__PHY_DBI_MODE {0} \
   CONFIG.PSU__DDRC__RANK_ADDR_COUNT {1} \
   CONFIG.PSU__DDRC__ROW_ADDR_COUNT {15} \
   CONFIG.PSU__DDRC__SB_TARGET {NA} \
   CONFIG.PSU__DDRC__SELF_REF_ABORT {NA} \
   CONFIG.PSU__DDRC__SPEED_BIN {LPDDR4_1066} \
   CONFIG.PSU__DDRC__STATIC_RD_MODE {0} \
   CONFIG.PSU__DDRC__TRAIN_DATA_EYE {1} \
   CONFIG.PSU__DDRC__TRAIN_READ_GATE {1} \
   CONFIG.PSU__DDRC__TRAIN_WRITE_LEVEL {1} \
   CONFIG.PSU__DDRC__T_FAW {40.0} \
   CONFIG.PSU__DDRC__T_RAS_MIN {42} \
   CONFIG.PSU__DDRC__T_RC {63} \
   CONFIG.PSU__DDRC__T_RCD {10} \
   CONFIG.PSU__DDRC__T_RP {12} \
   CONFIG.PSU__DDRC__VENDOR_PART {OTHERS} \
   CONFIG.PSU__DDRC__VREF {0} \
   CONFIG.PSU__DDR_HIGH_ADDRESS_GUI_ENABLE {0} \
   CONFIG.PSU__DDR_QOS_ENABLE {1} \
   CONFIG.PSU__DDR_QOS_HP0_RDQOS {7} \
   CONFIG.PSU__DDR_QOS_HP0_WRQOS {15} \
   CONFIG.PSU__DDR_QOS_HP1_RDQOS {3} \
   CONFIG.PSU__DDR_QOS_HP1_WRQOS {3} \
   CONFIG.PSU__DDR_QOS_HP2_RDQOS {3} \
   CONFIG.PSU__DDR_QOS_HP2_WRQOS {3} \
   CONFIG.PSU__DDR_QOS_HP3_RDQOS {3} \
   CONFIG.PSU__DDR_QOS_HP3_WRQOS {3} \
   CONFIG.PSU__DDR_QOS_PORT0_TYPE {Low Latency} \
   CONFIG.PSU__DDR_QOS_PORT1_VN1_TYPE {Low Latency} \
   CONFIG.PSU__DDR_QOS_PORT1_VN2_TYPE {Best Effort} \
   CONFIG.PSU__DDR_QOS_PORT2_VN1_TYPE {Low Latency} \
   CONFIG.PSU__DDR_QOS_PORT2_VN2_TYPE {Best Effort} \
   CONFIG.PSU__DDR_QOS_PORT3_TYPE {Video Traffic} \
   CONFIG.PSU__DDR_QOS_PORT4_TYPE {Best Effort} \
   CONFIG.PSU__DDR_QOS_PORT5_TYPE {Best Effort} \
   CONFIG.PSU__DDR_QOS_RD_HPR_THRSHLD {0} \
   CONFIG.PSU__DDR_QOS_RD_LPR_THRSHLD {16} \
   CONFIG.PSU__DDR_QOS_WR_THRSHLD {16} \
   CONFIG.PSU__DDR__INTERFACE__FREQMHZ {266.500} \
   CONFIG.PSU__DISPLAYPORT__LANE0__ENABLE {1} \
   CONFIG.PSU__DISPLAYPORT__LANE0__IO {GT Lane1} \
   CONFIG.PSU__DISPLAYPORT__LANE1__ENABLE {1} \
   CONFIG.PSU__DISPLAYPORT__LANE1__IO {GT Lane0} \
   CONFIG.PSU__DISPLAYPORT__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__DLL__ISUSED {1} \
   CONFIG.PSU__DPAUX__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__DPAUX__PERIPHERAL__IO {MIO 27 .. 30} \
   CONFIG.PSU__DP__LANE_SEL {Dual Lower} \
   CONFIG.PSU__DP__REF_CLK_FREQ {27} \
   CONFIG.PSU__DP__REF_CLK_SEL {Ref Clk1} \
   CONFIG.PSU__ENET0__FIFO__ENABLE {0} \
   CONFIG.PSU__ENET0__GRP_MDIO__ENABLE {0} \
   CONFIG.PSU__ENET0__GRP_MDIO__IO {<Select>} \
   CONFIG.PSU__ENET0__PERIPHERAL__ENABLE {0} \
   CONFIG.PSU__ENET0__PERIPHERAL__IO {<Select>} \
   CONFIG.PSU__ENET0__PTP__ENABLE {0} \
   CONFIG.PSU__ENET0__TSU__ENABLE {0} \
   CONFIG.PSU__ENET3__FIFO__ENABLE {0} \
   CONFIG.PSU__ENET3__GRP_MDIO__ENABLE {0} \
   CONFIG.PSU__ENET3__PERIPHERAL__ENABLE {0} \
   CONFIG.PSU__ENET3__PTP__ENABLE {0} \
   CONFIG.PSU__ENET3__TSU__ENABLE {0} \
   CONFIG.PSU__FPD_SLCR__WDT1__ACT_FREQMHZ {100.000000} \
   CONFIG.PSU__FPD_SLCR__WDT1__FREQMHZ {100.000000} \
   CONFIG.PSU__FPD_SLCR__WDT_CLK_SEL__SELECT {APB} \
   CONFIG.PSU__FPGA_PL0_ENABLE {1} \
   CONFIG.PSU__FPGA_PL1_ENABLE {0} \
   CONFIG.PSU__FPGA_PL2_ENABLE {0} \
   CONFIG.PSU__FPGA_PL3_ENABLE {0} \
   CONFIG.PSU__GEM0_COHERENCY {0} \
   CONFIG.PSU__GEM3_COHERENCY {0} \
   CONFIG.PSU__GEM__TSU__ENABLE {0} \
   CONFIG.PSU__GPIO0_MIO__IO {MIO 0 .. 25} \
   CONFIG.PSU__GPIO0_MIO__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__GPIO1_MIO__IO {MIO 26 .. 51} \
   CONFIG.PSU__GPIO1_MIO__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__GPIO2_MIO__IO {MIO 52 .. 77} \
   CONFIG.PSU__GPIO2_MIO__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__GPIO_EMIO__WIDTH {[95:0]} \
   CONFIG.PSU__GT__LINK_SPEED {HBR} \
   CONFIG.PSU__GT__PRE_EMPH_LVL_4 {0} \
   CONFIG.PSU__GT__VLT_SWNG_LVL_4 {0} \
   CONFIG.PSU__HIGH_ADDRESS__ENABLE {0} \
   CONFIG.PSU__I2C0__PERIPHERAL__ENABLE {0} \
   CONFIG.PSU__I2C1__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__I2C1__PERIPHERAL__IO {MIO 4 .. 5} \
   CONFIG.PSU__IOU_SLCR__IOU_TTC_APB_CLK__TTC0_SEL {APB} \
   CONFIG.PSU__IOU_SLCR__IOU_TTC_APB_CLK__TTC1_SEL {APB} \
   CONFIG.PSU__IOU_SLCR__IOU_TTC_APB_CLK__TTC2_SEL {APB} \
   CONFIG.PSU__IOU_SLCR__IOU_TTC_APB_CLK__TTC3_SEL {APB} \
   CONFIG.PSU__IOU_SLCR__TTC0__ACT_FREQMHZ {100.000000} \
   CONFIG.PSU__IOU_SLCR__TTC0__FREQMHZ {100.000000} \
   CONFIG.PSU__IOU_SLCR__TTC1__ACT_FREQMHZ {100.000000} \
   CONFIG.PSU__IOU_SLCR__TTC1__FREQMHZ {100.000000} \
   CONFIG.PSU__IOU_SLCR__TTC2__ACT_FREQMHZ {100.000000} \
   CONFIG.PSU__IOU_SLCR__TTC2__FREQMHZ {100.000000} \
   CONFIG.PSU__IOU_SLCR__TTC3__ACT_FREQMHZ {100.000000} \
   CONFIG.PSU__IOU_SLCR__TTC3__FREQMHZ {100.000000} \
   CONFIG.PSU__IOU_SLCR__WDT0__ACT_FREQMHZ {100.000000} \
   CONFIG.PSU__IOU_SLCR__WDT0__FREQMHZ {100.000000} \
   CONFIG.PSU__IOU_SLCR__WDT_CLK_SEL__SELECT {APB} \
   CONFIG.PSU__LPD_SLCR__CSUPMU__ACT_FREQMHZ {100.000000} \
   CONFIG.PSU__LPD_SLCR__CSUPMU__FREQMHZ {100.000000} \
   CONFIG.PSU__MAXIGP0__DATA_WIDTH {128} \
   CONFIG.PSU__MAXIGP1__DATA_WIDTH {128} \
   CONFIG.PSU__MAXIGP2__DATA_WIDTH {32} \
   CONFIG.PSU__NUM_FABRIC_RESETS {0} \
   CONFIG.PSU__OVERRIDE__BASIC_CLOCK {0} \
   CONFIG.PSU__PL_CLK0_BUF {FALSE} \
   CONFIG.PSU__PL_CLK1_BUF {FALSE} \
   CONFIG.PSU__PL_CLK2_BUF {FALSE} \
   CONFIG.PSU__PL_CLK3_BUF {FALSE} \
   CONFIG.PSU__PMU_COHERENCY {0} \
   CONFIG.PSU__PMU__AIBACK__ENABLE {0} \
   CONFIG.PSU__PMU__EMIO_GPI__ENABLE {0} \
   CONFIG.PSU__PMU__EMIO_GPO__ENABLE {0} \
   CONFIG.PSU__PMU__GPI0__ENABLE {1} \
   CONFIG.PSU__PMU__GPI0__IO {MIO 26} \
   CONFIG.PSU__PMU__GPI1__ENABLE {0} \
   CONFIG.PSU__PMU__GPI2__ENABLE {0} \
   CONFIG.PSU__PMU__GPI3__ENABLE {0} \
   CONFIG.PSU__PMU__GPI4__ENABLE {0} \
   CONFIG.PSU__PMU__GPI5__ENABLE {0} \
   CONFIG.PSU__PMU__GPO0__ENABLE {1} \
   CONFIG.PSU__PMU__GPO0__IO {MIO 32} \
   CONFIG.PSU__PMU__GPO1__ENABLE {1} \
   CONFIG.PSU__PMU__GPO1__IO {MIO 33} \
   CONFIG.PSU__PMU__GPO2__ENABLE {1} \
   CONFIG.PSU__PMU__GPO2__IO {MIO 34} \
   CONFIG.PSU__PMU__GPO2__POLARITY {high} \
   CONFIG.PSU__PMU__GPO3__ENABLE {0} \
   CONFIG.PSU__PMU__GPO4__ENABLE {0} \
   CONFIG.PSU__PMU__GPO5__ENABLE {0} \
   CONFIG.PSU__PMU__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__PMU__PLERROR__ENABLE {0} \
   CONFIG.PSU__PRESET_APPLIED {1} \
   CONFIG.PSU__PROTECTION__MASTERS {USB1:NonSecure;1|USB0:NonSecure;1|S_AXI_LPD:NA;0|S_AXI_HPC1_FPD:NA;0|S_AXI_HPC0_FPD:NA;0|S_AXI_HP3_FPD:NA;0|S_AXI_HP2_FPD:NA;0|S_AXI_HP1_FPD:NA;0|S_AXI_HP0_FPD:NA;0|S_AXI_ACP:NA;1|S_AXI_ACE:NA;0|SD1:NonSecure;1|SD0:NonSecure;1|SATA1:NonSecure;0|SATA0:NonSecure;0|RPU1:Secure;1|RPU0:Secure;1|QSPI:NonSecure;0|PMU:NA;1|PCIe:NonSecure;0|NAND:NonSecure;0|LDMA:NonSecure;1|GPU:NonSecure;1|GEM3:NonSecure;0|GEM2:NonSecure;0|GEM1:NonSecure;0|GEM0:NonSecure;0|FDMA:NonSecure;1|DP:NonSecure;1|DAP:NA;1|Coresight:NA;1|CSU:NA;1|APU:NA;1} \
   CONFIG.PSU__PROTECTION__SLAVES {LPD;USB3_1_XHCI;FE300000;FE3FFFFF;1|LPD;USB3_1;FF9E0000;FF9EFFFF;1|LPD;USB3_0_XHCI;FE200000;FE2FFFFF;1|LPD;USB3_0;FF9D0000;FF9DFFFF;1|LPD;UART1;FF010000;FF01FFFF;1|LPD;UART0;FF000000;FF00FFFF;1|LPD;TTC3;FF140000;FF14FFFF;1|LPD;TTC2;FF130000;FF13FFFF;1|LPD;TTC1;FF120000;FF12FFFF;1|LPD;TTC0;FF110000;FF11FFFF;1|FPD;SWDT1;FD4D0000;FD4DFFFF;1|LPD;SWDT0;FF150000;FF15FFFF;1|LPD;SPI1;FF050000;FF05FFFF;1|LPD;SPI0;FF040000;FF04FFFF;1|FPD;SMMU_REG;FD5F0000;FD5FFFFF;1|FPD;SMMU;FD800000;FDFFFFFF;1|FPD;SIOU;FD3D0000;FD3DFFFF;1|FPD;SERDES;FD400000;FD47FFFF;1|LPD;SD1;FF170000;FF17FFFF;1|LPD;SD0;FF160000;FF16FFFF;1|FPD;SATA;FD0C0000;FD0CFFFF;0|LPD;RTC;FFA60000;FFA6FFFF;1|LPD;RSA_CORE;FFCE0000;FFCEFFFF;1|LPD;RPU;FF9A0000;FF9AFFFF;1|FPD;RCPU_GIC;F9000000;F900FFFF;1|LPD;R5_TCM_RAM_GLOBAL;FFE00000;FFE3FFFF;1|LPD;R5_1_Instruction_Cache;FFEC0000;FFECFFFF;1|LPD;R5_1_Data_Cache;FFED0000;FFEDFFFF;1|LPD;R5_1_BTCM_GLOBAL;FFEB0000;FFEBFFFF;1|LPD;R5_1_ATCM_GLOBAL;FFE90000;FFE9FFFF;1|LPD;R5_0_Instruction_Cache;FFE40000;FFE4FFFF;1|LPD;R5_0_Data_Cache;FFE50000;FFE5FFFF;1|LPD;R5_0_BTCM_GLOBAL;FFE20000;FFE2FFFF;1|LPD;R5_0_ATCM_GLOBAL;FFE00000;FFE0FFFF;1|LPD;QSPI_Linear_Address;C0000000;DFFFFFFF;1|LPD;QSPI;FF0F0000;FF0FFFFF;0|LPD;PMU_RAM;FFDC0000;FFDDFFFF;1|LPD;PMU_GLOBAL;FFD80000;FFDBFFFF;1|FPD;PCIE_MAIN;FD0E0000;FD0EFFFF;0|FPD;PCIE_LOW;E0000000;EFFFFFFF;0|FPD;PCIE_HIGH2;8000000000;BFFFFFFFFF;0|FPD;PCIE_HIGH1;600000000;7FFFFFFFF;0|FPD;PCIE_DMA;FD0F0000;FD0FFFFF;0|FPD;PCIE_ATTRIB;FD480000;FD48FFFF;0|LPD;OCM_XMPU_CFG;FFA70000;FFA7FFFF;1|LPD;OCM_SLCR;FF960000;FF96FFFF;1|OCM;OCM;FFFC0000;FFFFFFFF;1|LPD;NAND;FF100000;FF10FFFF;0|LPD;MBISTJTAG;FFCF0000;FFCFFFFF;1|LPD;LPD_XPPU_SINK;FF9C0000;FF9CFFFF;1|LPD;LPD_XPPU;FF980000;FF98FFFF;1|LPD;LPD_SLCR_SECURE;FF4B0000;FF4DFFFF;1|LPD;LPD_SLCR;FF410000;FF4AFFFF;1|LPD;LPD_GPV;FE100000;FE1FFFFF;1|LPD;LPD_DMA_7;FFAF0000;FFAFFFFF;1|LPD;LPD_DMA_6;FFAE0000;FFAEFFFF;1|LPD;LPD_DMA_5;FFAD0000;FFADFFFF;1|LPD;LPD_DMA_4;FFAC0000;FFACFFFF;1|LPD;LPD_DMA_3;FFAB0000;FFABFFFF;1|LPD;LPD_DMA_2;FFAA0000;FFAAFFFF;1|LPD;LPD_DMA_1;FFA90000;FFA9FFFF;1|LPD;LPD_DMA_0;FFA80000;FFA8FFFF;1|LPD;IPI_CTRL;FF380000;FF3FFFFF;1|LPD;IOU_SLCR;FF180000;FF23FFFF;1|LPD;IOU_SECURE_SLCR;FF240000;FF24FFFF;1|LPD;IOU_SCNTRS;FF260000;FF26FFFF;1|LPD;IOU_SCNTR;FF250000;FF25FFFF;1|LPD;IOU_GPV;FE000000;FE0FFFFF;1|LPD;I2C1;FF030000;FF03FFFF;1|LPD;I2C0;FF020000;FF02FFFF;0|FPD;GPU;FD4B0000;FD4BFFFF;1|LPD;GPIO;FF0A0000;FF0AFFFF;1|LPD;GEM3;FF0E0000;FF0EFFFF;0|LPD;GEM2;FF0D0000;FF0DFFFF;0|LPD;GEM1;FF0C0000;FF0CFFFF;0|LPD;GEM0;FF0B0000;FF0BFFFF;0|FPD;FPD_XMPU_SINK;FD4F0000;FD4FFFFF;1|FPD;FPD_XMPU_CFG;FD5D0000;FD5DFFFF;1|FPD;FPD_SLCR_SECURE;FD690000;FD6CFFFF;1|FPD;FPD_SLCR;FD610000;FD68FFFF;1|FPD;FPD_GPV;FD700000;FD7FFFFF;1|FPD;FPD_DMA_CH7;FD570000;FD57FFFF;1|FPD;FPD_DMA_CH6;FD560000;FD56FFFF;1|FPD;FPD_DMA_CH5;FD550000;FD55FFFF;1|FPD;FPD_DMA_CH4;FD540000;FD54FFFF;1|FPD;FPD_DMA_CH3;FD530000;FD53FFFF;1|FPD;FPD_DMA_CH2;FD520000;FD52FFFF;1|FPD;FPD_DMA_CH1;FD510000;FD51FFFF;1|FPD;FPD_DMA_CH0;FD500000;FD50FFFF;1|LPD;EFUSE;FFCC0000;FFCCFFFF;1|FPD;Display Port;FD4A0000;FD4AFFFF;1|FPD;DPDMA;FD4C0000;FD4CFFFF;1|FPD;DDR_XMPU5_CFG;FD050000;FD05FFFF;1|FPD;DDR_XMPU4_CFG;FD040000;FD04FFFF;1|FPD;DDR_XMPU3_CFG;FD030000;FD03FFFF;1|FPD;DDR_XMPU2_CFG;FD020000;FD02FFFF;1|FPD;DDR_XMPU1_CFG;FD010000;FD01FFFF;1|FPD;DDR_XMPU0_CFG;FD000000;FD00FFFF;1|FPD;DDR_QOS_CTRL;FD090000;FD09FFFF;1|FPD;DDR_PHY;FD080000;FD08FFFF;1|DDR;DDR_LOW;0;7FFFFFFF;1|DDR;DDR_HIGH;800000000;800000000;0|FPD;DDDR_CTRL;FD070000;FD070FFF;1|LPD;Coresight;FE800000;FEFFFFFF;1|LPD;CSU_DMA;FFC80000;FFC9FFFF;1|LPD;CSU;FFCA0000;FFCAFFFF;0|LPD;CRL_APB;FF5E0000;FF85FFFF;1|FPD;CRF_APB;FD1A0000;FD2DFFFF;1|FPD;CCI_REG;FD5E0000;FD5EFFFF;1|FPD;CCI_GPV;FD6E0000;FD6EFFFF;1|LPD;CAN1;FF070000;FF07FFFF;0|LPD;CAN0;FF060000;FF06FFFF;0|FPD;APU;FD5C0000;FD5CFFFF;1|LPD;APM_INTC_IOU;FFA20000;FFA2FFFF;1|LPD;APM_FPD_LPD;FFA30000;FFA3FFFF;1|FPD;APM_5;FD490000;FD49FFFF;1|FPD;APM_0;FD0B0000;FD0BFFFF;1|LPD;APM2;FFA10000;FFA1FFFF;1|LPD;APM1;FFA00000;FFA0FFFF;1|LPD;AMS;FFA50000;FFA5FFFF;1|FPD;AFI_5;FD3B0000;FD3BFFFF;1|FPD;AFI_4;FD3A0000;FD3AFFFF;1|FPD;AFI_3;FD390000;FD39FFFF;1|FPD;AFI_2;FD380000;FD38FFFF;1|FPD;AFI_1;FD370000;FD37FFFF;1|FPD;AFI_0;FD360000;FD36FFFF;1|LPD;AFIFM6;FF9B0000;FF9BFFFF;1|FPD;ACPU_GIC;F9010000;F907FFFF;1} \
   CONFIG.PSU__PSS_REF_CLK__FREQMHZ {33.333333} \
   CONFIG.PSU__QSPI_COHERENCY {0} \
   CONFIG.PSU__QSPI__GRP_FBCLK__ENABLE {0} \
   CONFIG.PSU__QSPI__PERIPHERAL__ENABLE {0} \
   CONFIG.PSU__SATA__LANE0__ENABLE {0} \
   CONFIG.PSU__SATA__LANE1__ENABLE {0} \
   CONFIG.PSU__SATA__PERIPHERAL__ENABLE {0} \
   CONFIG.PSU__SAXIGP0__DATA_WIDTH {128} \
   CONFIG.PSU__SD0_COHERENCY {0} \
   CONFIG.PSU__SD0__DATA_TRANSFER_MODE {4Bit} \
   CONFIG.PSU__SD0__GRP_CD__ENABLE {1} \
   CONFIG.PSU__SD0__GRP_CD__IO {MIO 24} \
   CONFIG.PSU__SD0__GRP_POW__ENABLE {0} \
   CONFIG.PSU__SD0__GRP_WP__ENABLE {0} \
   CONFIG.PSU__SD0__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__SD0__PERIPHERAL__IO {MIO 13 .. 16 21 22} \
   CONFIG.PSU__SD0__RESET__ENABLE {0} \
   CONFIG.PSU__SD0__SLOT_TYPE {SD 2.0} \
   CONFIG.PSU__SD1_COHERENCY {0} \
   CONFIG.PSU__SD1__DATA_TRANSFER_MODE {4Bit} \
   CONFIG.PSU__SD1__GRP_CD__ENABLE {0} \
   CONFIG.PSU__SD1__GRP_POW__ENABLE {0} \
   CONFIG.PSU__SD1__GRP_WP__ENABLE {0} \
   CONFIG.PSU__SD1__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__SD1__PERIPHERAL__IO {MIO 46 .. 51} \
   CONFIG.PSU__SD1__RESET__ENABLE {0} \
   CONFIG.PSU__SD1__SLOT_TYPE {SD 2.0} \
   CONFIG.PSU__SPI0__GRP_SS0__ENABLE {1} \
   CONFIG.PSU__SPI0__GRP_SS0__IO {MIO 41} \
   CONFIG.PSU__SPI0__GRP_SS1__ENABLE {0} \
   CONFIG.PSU__SPI0__GRP_SS2__ENABLE {0} \
   CONFIG.PSU__SPI0__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__SPI0__PERIPHERAL__IO {MIO 38 .. 43} \
   CONFIG.PSU__SPI1__GRP_SS0__ENABLE {1} \
   CONFIG.PSU__SPI1__GRP_SS0__IO {MIO 9} \
   CONFIG.PSU__SPI1__GRP_SS1__ENABLE {0} \
   CONFIG.PSU__SPI1__GRP_SS2__ENABLE {0} \
   CONFIG.PSU__SPI1__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__SPI1__PERIPHERAL__IO {MIO 6 .. 11} \
   CONFIG.PSU__SWDT0__CLOCK__ENABLE {0} \
   CONFIG.PSU__SWDT0__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__SWDT0__RESET__ENABLE {0} \
   CONFIG.PSU__SWDT1__CLOCK__ENABLE {0} \
   CONFIG.PSU__SWDT1__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__SWDT1__RESET__ENABLE {0} \
   CONFIG.PSU__TSU__BUFG_PORT_PAIR {0} \
   CONFIG.PSU__TTC0__CLOCK__ENABLE {0} \
   CONFIG.PSU__TTC0__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__TTC0__WAVEOUT__ENABLE {0} \
   CONFIG.PSU__TTC1__CLOCK__ENABLE {0} \
   CONFIG.PSU__TTC1__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__TTC1__WAVEOUT__ENABLE {0} \
   CONFIG.PSU__TTC2__CLOCK__ENABLE {0} \
   CONFIG.PSU__TTC2__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__TTC2__WAVEOUT__ENABLE {0} \
   CONFIG.PSU__TTC3__CLOCK__ENABLE {0} \
   CONFIG.PSU__TTC3__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__TTC3__WAVEOUT__ENABLE {0} \
   CONFIG.PSU__UART0__BAUD_RATE {115200} \
   CONFIG.PSU__UART0__MODEM__ENABLE {0} \
   CONFIG.PSU__UART0__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__UART0__PERIPHERAL__IO {MIO 2 .. 3} \
   CONFIG.PSU__UART1__BAUD_RATE {115200} \
   CONFIG.PSU__UART1__MODEM__ENABLE {0} \
   CONFIG.PSU__UART1__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__UART1__PERIPHERAL__IO {MIO 0 .. 1} \
   CONFIG.PSU__USB0_COHERENCY {0} \
   CONFIG.PSU__USB0__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__USB0__PERIPHERAL__IO {MIO 52 .. 63} \
   CONFIG.PSU__USB0__REF_CLK_FREQ {26} \
   CONFIG.PSU__USB0__REF_CLK_SEL {Ref Clk0} \
   CONFIG.PSU__USB0__RESET__ENABLE {0} \
   CONFIG.PSU__USB1_COHERENCY {0} \
   CONFIG.PSU__USB1__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__USB1__PERIPHERAL__IO {MIO 64 .. 75} \
   CONFIG.PSU__USB1__REF_CLK_FREQ {26} \
   CONFIG.PSU__USB1__REF_CLK_SEL {Ref Clk0} \
   CONFIG.PSU__USB1__RESET__ENABLE {0} \
   CONFIG.PSU__USB2_0__EMIO__ENABLE {0} \
   CONFIG.PSU__USB2_1__EMIO__ENABLE {0} \
   CONFIG.PSU__USB3_0__EMIO__ENABLE {0} \
   CONFIG.PSU__USB3_0__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__USB3_0__PERIPHERAL__IO {GT Lane2} \
   CONFIG.PSU__USB3_1__EMIO__ENABLE {0} \
   CONFIG.PSU__USB3_1__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__USB3_1__PERIPHERAL__IO {GT Lane3} \
   CONFIG.PSU__USB__RESET__MODE {Boot Pin} \
   CONFIG.PSU__USB__RESET__POLARITY {Active Low} \
   CONFIG.PSU__USE__FABRIC__RST {0} \
   CONFIG.PSU__USE__IRQ0 {1} \
   CONFIG.PSU__USE__M_AXI_GP0 {1} \
   CONFIG.PSU__USE__M_AXI_GP1 {0} \
   CONFIG.PSU__USE__M_AXI_GP2 {0} \
   CONFIG.PSU__USE__S_AXI_ACE {0} \
   CONFIG.PSU__USE__S_AXI_ACP {1} \
   CONFIG.PSU__USE__S_AXI_GP0 {0} \
   CONFIG.SUBPRESET1 {Custom} \
 ] $ps_main

  # Create instance: ps_reset_125M, and set properties
  set ps_reset_125M [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 ps_reset_125M ]

  # Create instance: reset, and set properties
  set reset [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 reset ]

  # Create instance: simple_timer, and set properties
  set simple_timer [ create_bd_cell -type ip -vlnv oscar-rc.dev:zbnt_hw:simple_timer:1.1 simple_timer ]
  set_property -dict [ list \
   CONFIG.axi_width {64} \
 ] $simple_timer

  # Create interface connections
  connect_bd_intf_net -intf_net S00_AXI_1 [get_bd_intf_pins ps_interconnect/S00_AXI] [get_bd_intf_pins ps_main/M_AXI_HPM0_FPD]
  connect_bd_intf_net -intf_net S01_AXIS_1 [get_bd_intf_pins dma/S01_AXIS] [get_bd_intf_pins mitm_a/axis_detector_b]
  connect_bd_intf_net -intf_net S03_AXIS_1 [get_bd_intf_pins dma/S03_AXIS] [get_bd_intf_pins mitm_b/axis_detector_b]
  connect_bd_intf_net -intf_net S05_AXIS_1 [get_bd_intf_pins dma/S05_AXIS] [get_bd_intf_pins mitm_a/axis_stats_b]
  connect_bd_intf_net -intf_net S07_AXIS_1 [get_bd_intf_pins dma/S07_AXIS] [get_bd_intf_pins mitm_b/axis_stats_b]
  connect_bd_intf_net -intf_net dma_M_AXI [get_bd_intf_pins dma/M_AXI] [get_bd_intf_pins ps_main/S_AXI_ACP_FPD]
  connect_bd_intf_net -intf_net eth3_gmii [get_bd_intf_pins gmii_to_sgmii/gmii_3] [get_bd_intf_pins mitm_b/gmii_b]
  connect_bd_intf_net -intf_net gig_ethernet_pcs_pma_0_1_sgmii_0 [get_bd_intf_ports eth96_p0] [get_bd_intf_pins gmii_to_sgmii/sgmii_0]
  connect_bd_intf_net -intf_net gig_ethernet_pcs_pma_0_1_sgmii_1 [get_bd_intf_ports eth96_p1] [get_bd_intf_pins gmii_to_sgmii/sgmii_1]
  connect_bd_intf_net -intf_net gig_ethernet_pcs_pma_2_sgmii_0 [get_bd_intf_ports eth96_p2] [get_bd_intf_pins gmii_to_sgmii/sgmii_2]
  connect_bd_intf_net -intf_net gmii_to_sgmii_M_SGMII_B_0 [get_bd_intf_ports eth96_unused] [get_bd_intf_pins gmii_to_sgmii/sgmii_unused]
  connect_bd_intf_net -intf_net gmii_to_sgmii_sgmii_3 [get_bd_intf_ports eth96_p3] [get_bd_intf_pins gmii_to_sgmii/sgmii_3]
  connect_bd_intf_net -intf_net mitm_a_axis_detector_a [get_bd_intf_pins dma/S00_AXIS] [get_bd_intf_pins mitm_a/axis_detector_a]
  connect_bd_intf_net -intf_net mitm_a_axis_stats_a [get_bd_intf_pins dma/S04_AXIS] [get_bd_intf_pins mitm_a/axis_stats_a]
  connect_bd_intf_net -intf_net mitm_a_gmii_a [get_bd_intf_pins gmii_to_sgmii/gmii_0] [get_bd_intf_pins mitm_a/gmii_a]
  connect_bd_intf_net -intf_net mitm_a_gmii_b [get_bd_intf_pins gmii_to_sgmii/gmii_1] [get_bd_intf_pins mitm_a/gmii_b]
  connect_bd_intf_net -intf_net mitm_b_axis_detector_a [get_bd_intf_pins dma/S02_AXIS] [get_bd_intf_pins mitm_b/axis_detector_a]
  connect_bd_intf_net -intf_net mitm_b_axis_stats_a [get_bd_intf_pins dma/S06_AXIS] [get_bd_intf_pins mitm_b/axis_stats_a]
  connect_bd_intf_net -intf_net mitm_b_gmii_a [get_bd_intf_pins gmii_to_sgmii/gmii_2] [get_bd_intf_pins mitm_b/gmii_a]
  connect_bd_intf_net -intf_net ps_interconnect_M06_AXI [get_bd_intf_pins ps_interconnect/M06_AXI] [get_bd_intf_pins simple_timer/S_AXI]
  connect_bd_intf_net -intf_net ps_interconnect_M07_AXI [get_bd_intf_pins dma/S_AXI_LITE] [get_bd_intf_pins ps_interconnect/M07_AXI]
  connect_bd_intf_net -intf_net ps_interconnect_M08_AXI [get_bd_intf_pins axi_ethlite/S_AXI] [get_bd_intf_pins ps_interconnect/M08_AXI]
  connect_bd_intf_net -intf_net refclk625_in_0_1 [get_bd_intf_ports eth96] [get_bd_intf_pins gmii_to_sgmii/clk_625M]
  connect_bd_intf_net -intf_net s_axi_detector_1 [get_bd_intf_pins mitm_a/s_axi_detector] [get_bd_intf_pins ps_interconnect/M00_AXI]
  connect_bd_intf_net -intf_net s_axi_detector_2 [get_bd_intf_pins mitm_b/s_axi_detector] [get_bd_intf_pins ps_interconnect/M03_AXI]
  connect_bd_intf_net -intf_net s_axi_stats_a_1 [get_bd_intf_pins mitm_a/s_axi_stats_a] [get_bd_intf_pins ps_interconnect/M01_AXI]
  connect_bd_intf_net -intf_net s_axi_stats_a_2 [get_bd_intf_pins mitm_b/s_axi_stats_a] [get_bd_intf_pins ps_interconnect/M04_AXI]
  connect_bd_intf_net -intf_net s_axi_stats_b_1 [get_bd_intf_pins mitm_a/s_axi_stats_b] [get_bd_intf_pins ps_interconnect/M02_AXI]
  connect_bd_intf_net -intf_net s_axi_stats_b_2 [get_bd_intf_pins mitm_b/s_axi_stats_b] [get_bd_intf_pins ps_interconnect/M05_AXI]

  # Create port connections
  connect_bd_net -net M00_ARESETN_1 [get_bd_pins ps_interconnect/M00_ARESETN] [get_bd_pins ps_interconnect/M01_ARESETN] [get_bd_pins ps_interconnect/M02_ARESETN] [get_bd_pins ps_interconnect/M03_ARESETN] [get_bd_pins ps_interconnect/M04_ARESETN] [get_bd_pins ps_interconnect/M05_ARESETN] [get_bd_pins ps_interconnect/M06_ARESETN] [get_bd_pins ps_interconnect/M07_ARESETN] [get_bd_pins reset/interconnect_aresetn]
  connect_bd_net -net Net [get_bd_ports mdio] [get_bd_pins mdio_iobuf/signal_io]
  connect_bd_net -net S00_ARESETN_1 [get_bd_pins axi_ethlite/s_axi_aresetn] [get_bd_pins ps_interconnect/ARESETN] [get_bd_pins ps_interconnect/M08_ARESETN] [get_bd_pins ps_interconnect/S00_ARESETN] [get_bd_pins ps_reset_125M/interconnect_aresetn]
  connect_bd_net -net axi_ethlite_phy_mdc [get_bd_ports mdc] [get_bd_pins axi_ethlite/phy_mdc]
  connect_bd_net -net axi_ethlite_phy_mdio_o [get_bd_pins axi_ethlite/phy_mdio_o] [get_bd_pins mdio_iobuf/signal_o]
  connect_bd_net -net axi_ethlite_phy_mdio_t [get_bd_pins axi_ethlite/phy_mdio_t] [get_bd_pins mdio_iobuf/signal_t]
  connect_bd_net -net constant_1_dout [get_bd_pins dma/rst_n] [get_bd_pins mitm_a/rst_n] [get_bd_pins mitm_b/rst_n] [get_bd_pins reset/peripheral_aresetn] [get_bd_pins simple_timer/rst_n]
  connect_bd_net -net constant_1_dout1 [get_bd_pins axi_ethlite/phy_rx_clk] [get_bd_pins axi_ethlite/phy_tx_clk] [get_bd_pins constant_0/dout]
  connect_bd_net -net constant_1_dout2 [get_bd_pins constant_1/dout] [get_bd_pins ps_reset_125M/ext_reset_in]
  connect_bd_net -net dma_irq [get_bd_pins dma/irq] [get_bd_pins ps_main/pl_ps_irq0]
  connect_bd_net -net ethfmc_clk_buf_IBUF_OUT [get_bd_pins dma/clk] [get_bd_pins gmii_to_sgmii/clk_125M] [get_bd_pins mitm_a/gtx_clk] [get_bd_pins mitm_b/gtx_clk] [get_bd_pins ps_interconnect/M00_ACLK] [get_bd_pins ps_interconnect/M01_ACLK] [get_bd_pins ps_interconnect/M02_ACLK] [get_bd_pins ps_interconnect/M03_ACLK] [get_bd_pins ps_interconnect/M04_ACLK] [get_bd_pins ps_interconnect/M05_ACLK] [get_bd_pins ps_interconnect/M06_ACLK] [get_bd_pins ps_interconnect/M07_ACLK] [get_bd_pins ps_main/saxiacp_fpd_aclk] [get_bd_pins reset/slowest_sync_clk] [get_bd_pins simple_timer/clk]
  connect_bd_net -net gmii_to_sgmii_rst_out [get_bd_pins gmii_to_sgmii/rst_out] [get_bd_pins reset/ext_reset_in]
  connect_bd_net -net mdio_iobuf_signal_i [get_bd_pins axi_ethlite/phy_mdio_i] [get_bd_pins mdio_iobuf/signal_i]
  connect_bd_net -net ps_main_pl_clk0 [get_bd_pins axi_ethlite/s_axi_aclk] [get_bd_pins ps_interconnect/ACLK] [get_bd_pins ps_interconnect/M08_ACLK] [get_bd_pins ps_interconnect/S00_ACLK] [get_bd_pins ps_main/maxihpm0_fpd_aclk] [get_bd_pins ps_main/pl_clk0] [get_bd_pins ps_reset_125M/slowest_sync_clk]
  connect_bd_net -net ps_reset_interconnect_aresetn [get_bd_ports eth96_p0_rst_n] [get_bd_ports eth96_p1_rst_n] [get_bd_ports eth96_p2_rst_n] [get_bd_ports eth96_p3_rst_n] [get_bd_pins ps_reset_125M/peripheral_aresetn]
  connect_bd_net -net simple_timer_current_time [get_bd_pins mitm_a/current_time] [get_bd_pins mitm_b/current_time] [get_bd_pins simple_timer/current_time]
  connect_bd_net -net simple_timer_time_running [get_bd_pins mitm_a/time_running] [get_bd_pins mitm_b/time_running] [get_bd_pins simple_timer/time_running]

  # Create address segments
  create_bd_addr_seg -range 0x00001000 -offset 0xA0000000 [get_bd_addr_spaces ps_main/Data] [get_bd_addr_segs axi_ethlite/S_AXI/Reg] SEG_axi_ethlite_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0xA0080000 [get_bd_addr_spaces ps_main/Data] [get_bd_addr_segs mitm_b/detector/S_AXI/S_AXI_ADDR] SEG_detector_S_AXI_ADDR
  create_bd_addr_seg -range 0x00010000 -offset 0xA0070000 [get_bd_addr_spaces ps_main/Data] [get_bd_addr_segs mitm_a/detector/S_AXI/S_AXI_ADDR] SEG_detector_S_AXI_ADDR1
  create_bd_addr_seg -range 0x00001000 -offset 0xA0010000 [get_bd_addr_spaces ps_main/Data] [get_bd_addr_segs dma/dma/S_AXI/S_AXI_ADDR] SEG_dma_S_AXI_ADDR
  create_bd_addr_seg -range 0x00001000 -offset 0xA0020000 [get_bd_addr_spaces ps_main/Data] [get_bd_addr_segs simple_timer/S_AXI/S_AXI_ADDR] SEG_simple_timer_S_AXI_ADDR
  create_bd_addr_seg -range 0x00001000 -offset 0xA0030000 [get_bd_addr_spaces ps_main/Data] [get_bd_addr_segs mitm_a/eth0/stats/S_AXI/S_AXI_ADDR] SEG_stats_S_AXI_ADDR
  create_bd_addr_seg -range 0x00001000 -offset 0xA0060000 [get_bd_addr_spaces ps_main/Data] [get_bd_addr_segs mitm_b/eth3/stats/S_AXI/S_AXI_ADDR] SEG_stats_S_AXI_ADDR1
  create_bd_addr_seg -range 0x00001000 -offset 0xA0050000 [get_bd_addr_spaces ps_main/Data] [get_bd_addr_segs mitm_b/eth2/stats/S_AXI/S_AXI_ADDR] SEG_stats_S_AXI_ADDR2
  create_bd_addr_seg -range 0x00001000 -offset 0xA0040000 [get_bd_addr_spaces ps_main/Data] [get_bd_addr_segs mitm_a/eth1/stats/S_AXI/S_AXI_ADDR] SEG_stats_S_AXI_ADDR3
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces dma/dma/M_AXI] [get_bd_addr_segs ps_main/SAXIACP/ACP_DDR_LOW] SEG_ps_main_ACP_DDR_LOW
  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces dma/dma/M_AXI] [get_bd_addr_segs ps_main/SAXIACP/ACP_LPS_OCM] SEG_ps_main_ACP_LPS_OCM


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


