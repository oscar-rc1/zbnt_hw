proc init_gui { IPINST } {
	ipgui::add_param $IPINST -name "Component_Name"

	set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
	ipgui::add_param $IPINST -name "C_WIDTH" -parent ${Page_0}
}

proc update_PARAM_VALUE.C_WIDTH { PARAM_VALUE.C_WIDTH } { }

proc validate_PARAM_VALUE.C_WIDTH { PARAM_VALUE.C_WIDTH } {
	return true
}

proc update_MODELPARAM_VALUE.C_WIDTH { MODELPARAM_VALUE.C_WIDTH PARAM_VALUE.C_WIDTH } {
	set_property value [get_property value ${PARAM_VALUE.C_WIDTH}] ${MODELPARAM_VALUE.C_WIDTH}
}

