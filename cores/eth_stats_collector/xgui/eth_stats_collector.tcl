source [file join [file dirname [file dirname [info script]]] xgui/eth_stats_collector.gtcl]

proc init_gui { IPINST } {
	ipgui::add_param $IPINST -name "Component_Name"

	set Page_0 [ipgui::add_page $IPINST -name "Page 0"]

	set C_AXI_WIDTH [ipgui::add_param $IPINST -name "C_AXI_WIDTH" -parent ${Page_0} -layout horizontal]
	set_property tooltip {Width of the AXI bus, in bits.} ${C_AXI_WIDTH}

	set Log_options [ipgui::add_group $IPINST -name "Log options" -parent ${Page_0}]

	set C_AXIS_LOG_ENABLE [ipgui::add_param $IPINST -name "C_AXIS_LOG_ENABLE" -parent ${Log_options}]
	set_property tooltip {Enable AXIS interface for saving data to external memory} ${C_AXIS_LOG_ENABLE}

	set C_AXIS_LOG_WIDTH [ipgui::add_param $IPINST -name "C_AXIS_LOG_WIDTH" -parent ${Log_options} -widget comboBox]
	set_property tooltip {Width of the AXIS interface, in bits.} ${C_AXIS_LOG_WIDTH}

	set Other_options [ipgui::add_group $IPINST -name "Other options" -parent ${Page_0}]
	ipgui::add_param $IPINST -name "C_USE_TIMER" -parent ${Other_options}
	ipgui::add_param $IPINST -name "C_SHARED_TX_CLK" -parent ${Other_options}
}

proc update_PARAM_VALUE.C_AXIS_LOG_WIDTH { PARAM_VALUE.C_AXIS_LOG_WIDTH PARAM_VALUE.C_AXIS_LOG_ENABLE } {
	set C_AXIS_LOG_WIDTH ${PARAM_VALUE.C_AXIS_LOG_WIDTH}
	set C_AXIS_LOG_ENABLE ${PARAM_VALUE.C_AXIS_LOG_ENABLE}
	set values(C_AXIS_LOG_ENABLE) [get_property value $C_AXIS_LOG_ENABLE]

	if { [gen_USERPARAMETER_C_AXIS_LOG_WIDTH_ENABLEMENT $values(C_AXIS_LOG_ENABLE)] } {
		set_property enabled true $C_AXIS_LOG_WIDTH
	} else {
		set_property enabled false $C_AXIS_LOG_WIDTH
	}
}

proc update_PARAM_VALUE.C_AXIS_LOG_ENABLE { PARAM_VALUE.C_AXIS_LOG_ENABLE } {}
proc update_PARAM_VALUE.C_AXI_WIDTH { PARAM_VALUE.C_AXI_WIDTH } {}
proc update_PARAM_VALUE.C_SHARED_TX_CLK { PARAM_VALUE.C_SHARED_TX_CLK } {}
proc update_PARAM_VALUE.C_USE_TIMER { PARAM_VALUE.C_USE_TIMER } {}

proc validate_PARAM_VALUE.C_AXIS_LOG_WIDTH { PARAM_VALUE.C_AXIS_LOG_WIDTH } {
	return true
}

proc validate_PARAM_VALUE.C_AXIS_LOG_ENABLE { PARAM_VALUE.C_AXIS_LOG_ENABLE } {
	return true
}

proc validate_PARAM_VALUE.C_AXI_WIDTH { PARAM_VALUE.C_AXI_WIDTH } {
	return true
}

proc validate_PARAM_VALUE.C_SHARED_TX_CLK { PARAM_VALUE.C_SHARED_TX_CLK } {
	return true
}

proc validate_PARAM_VALUE.C_USE_TIMER { PARAM_VALUE.C_USE_TIMER } {
	return true
}

proc update_MODELPARAM_VALUE.C_AXI_WIDTH { MODELPARAM_VALUE.C_AXI_WIDTH PARAM_VALUE.C_AXI_WIDTH } {
	set_property value [get_property value ${PARAM_VALUE.C_AXI_WIDTH}] ${MODELPARAM_VALUE.C_AXI_WIDTH}
}

proc update_MODELPARAM_VALUE.C_USE_TIMER { MODELPARAM_VALUE.C_USE_TIMER PARAM_VALUE.C_USE_TIMER } {
	set_property value [get_property value ${PARAM_VALUE.C_USE_TIMER}] ${MODELPARAM_VALUE.C_USE_TIMER}
}

proc update_MODELPARAM_VALUE.C_SHARED_TX_CLK { MODELPARAM_VALUE.C_SHARED_TX_CLK PARAM_VALUE.C_SHARED_TX_CLK } {
	set_property value [get_property value ${PARAM_VALUE.C_SHARED_TX_CLK}] ${MODELPARAM_VALUE.C_SHARED_TX_CLK}
}

proc update_MODELPARAM_VALUE.C_AXIS_LOG_ENABLE { MODELPARAM_VALUE.C_AXIS_LOG_ENABLE PARAM_VALUE.C_AXIS_LOG_ENABLE } {
	set_property value [get_property value ${PARAM_VALUE.C_AXIS_LOG_ENABLE}] ${MODELPARAM_VALUE.C_AXIS_LOG_ENABLE}
}

proc update_MODELPARAM_VALUE.C_AXIS_LOG_WIDTH { MODELPARAM_VALUE.C_AXIS_LOG_WIDTH PARAM_VALUE.C_AXIS_LOG_WIDTH } {
	set_property value [get_property value ${PARAM_VALUE.C_AXIS_LOG_WIDTH}] ${MODELPARAM_VALUE.C_AXIS_LOG_WIDTH}
}
