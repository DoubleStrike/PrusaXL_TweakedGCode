M17 ; enable steppers
M862.3 P "XL" ; printer model check
M862.5 P2 ; g-code level check
M862.6 P"Input shaper" ; FW feature check
M115 U6.2.6+8948
G90 ; use absolute coordinates
M83 ; extruder relative mode
; set print area
M555 X{first_layer_print_min[0]} Y{first_layer_print_min[1]} W{(first_layer_print_max[0]) - (first_layer_print_min[0])} H{(first_layer_print_max[1]) - (first_layer_print_min[1])}
; inform about nozzle diameter
{if (is_extruder_used[0])}M862.1 T0 P{nozzle_diameter[0]} A{(filament_abrasive[0] ? 1 : 0)} F{(nozzle_high_flow[0] ? 1 : 0)}{endif}
{if (is_extruder_used[1])}M862.1 T1 P{nozzle_diameter[1]} A{(filament_abrasive[1] ? 1 : 0)} F{(nozzle_high_flow[1] ? 1 : 0)}{endif}
{if (is_extruder_used[2])}M862.1 T2 P{nozzle_diameter[2]} A{(filament_abrasive[2] ? 1 : 0)} F{(nozzle_high_flow[2] ? 1 : 0)}{endif}
{if (is_extruder_used[3])}M862.1 T3 P{nozzle_diameter[3]} A{(filament_abrasive[3] ? 1 : 0)} F{(nozzle_high_flow[3] ? 1 : 0)}{endif}
{if (is_extruder_used[4])}M862.1 T4 P{nozzle_diameter[4]} A{(filament_abrasive[4] ? 1 : 0)} F{(nozzle_high_flow[4] ? 1 : 0)}{endif}

; turn off unused heaters
{if ! is_extruder_used[0]}M104 T0 S0{endif}
{if num_extruders > 1 and ! is_extruder_used[1]}M104 T1 S0{endif}
{if num_extruders > 2 and ! is_extruder_used[2]}M104 T2 S0{endif}
{if num_extruders > 3 and ! is_extruder_used[3]}M104 T3 S0{endif}
{if num_extruders > 4 and ! is_extruder_used[4]}M104 T4 S0{endif}

M217 Z{max(zhop, 2.0)} ; set toolchange z hop to 2mm, or zhop variable from slicer if higher
; set bed and extruder temp for MBL
M140 S[first_layer_bed_temperature] ; set bed temp
G0 Z5 ; add Z clearance
M109 T{initial_tool} S{((filament_notes[initial_tool]=~/.*MBL160.*/) ? 160 : (filament_notes[initial_tool]=~/.*HT_MBL10.*/) ? (first_layer_temperature[initial_tool] - 10) : (filament_type[initial_tool] == "PC" or filament_type[initial_tool] == "PA") ? (first_layer_temperature[initial_tool] - 25) : (filament_type[initial_tool] == "FLEX") ? 180 : (filament_type[initial_tool]=~/.*PET.*/) ? 175 : 170)} ; wait for temp

; Home XY
G28 XY
; try picking tools used in print
G1 F{travel_speed * 60}
{if (is_extruder_used[0]) and (initial_tool != 0)}T0 S1 L0 D0{endif}
{if (is_extruder_used[1]) and (initial_tool != 1)}T1 S1 L0 D0{endif}
{if (is_extruder_used[2]) and (initial_tool != 2)}T2 S1 L0 D0{endif}
{if (is_extruder_used[3]) and (initial_tool != 3)}T3 S1 L0 D0{endif}
{if (is_extruder_used[4]) and (initial_tool != 4)}T4 S1 L0 D0{endif}
; select tool that will be used to home & MBL
T{initial_tool} S1 L0 D0
; home Z with MBL tool
M84 E ; turn off E motor
G28 Z
G0 Z5 ; add Z clearance

; (EARLY_NOZZLE_PREHEAT) Preheats any active nozzles to idle temp before other operations happen
{if num_extruders > 0 and (is_extruder_used[0])}M104 T0 S{if is_nil(idle_temperature[0])}70{else}{idle_temperature[0]}{endif}{endif}
{if num_extruders > 1 and (is_extruder_used[1])}M104 T1 S{if is_nil(idle_temperature[1])}70{else}{idle_temperature[1]}{endif}{endif}
{if num_extruders > 2 and (is_extruder_used[2])}M104 T2 S{if is_nil(idle_temperature[2])}70{else}{idle_temperature[2]}{endif}{endif}
{if num_extruders > 3 and (is_extruder_used[3])}M104 T3 S{if is_nil(idle_temperature[3])}70{else}{idle_temperature[3]}{endif}{endif}
{if num_extruders > 4 and (is_extruder_used[4])}M104 T4 S{if is_nil(idle_temperature[4])}70{else}{idle_temperature[4]}{endif}{endif}

;M104 T{initial_tool} S{if is_nil(idle_temperature[initial_tool])}70{else}{idle_temperature[initial_tool]}{endif} ; set idle temp
M190 S[first_layer_bed_temperature] ; wait for bed temp

;G29 G ; absorb heat

M109 T{initial_tool} S{((filament_notes[initial_tool]=~/.*MBL160.*/) ? 160 : (filament_notes[initial_tool]=~/.*HT_MBL10.*/) ? (first_layer_temperature[initial_tool] - 10) : (filament_type[initial_tool] == "PC" or filament_type[initial_tool] == "PA") ? (first_layer_temperature[initial_tool] - 25) : (filament_type[initial_tool] == "FLEX") ? 180 : (filament_type[initial_tool]=~/.*PET.*/) ? 175 : 170)} ; wait for temp

; move to the nozzle cleanup area
G1 X{(min(((((first_layer_print_min[0] + first_layer_print_max[0]) / 2) < ((print_bed_min[0] + print_bed_max[0]) / 2)) ? (((first_layer_print_min[1] - 7) < -2) ? 70 : (min(print_bed_max[0], first_layer_print_min[0] + 32) - 32)) : (((first_layer_print_min[1] - 7) < -2) ? 260 : (min(print_bed_max[0], first_layer_print_min[0] + 32) - 32))), first_layer_print_min[0])) + 32} Y{(min((first_layer_print_min[1] - 7), first_layer_print_min[1]))} Z{5} F{(travel_speed * 60)}
M302 S155 ; lower cold extrusion limit to 155C
G1 E{-(filament_type[0] == "FLEX" ? 4 : 2)} F2400 ; retraction for nozzle cleanup

; nozzle cleanup
M84 E ; turn off E motor
G29 P9 X{((((first_layer_print_min[0] + first_layer_print_max[0]) / 2) < ((print_bed_min[0] + print_bed_max[0]) / 2)) ? (((first_layer_print_min[1] - 7) < -2) ? 70 : (min(print_bed_max[0], first_layer_print_min[0] + 32) - 32)) : (((first_layer_print_min[1] - 7) < -2) ? 260 : (min(print_bed_max[0], first_layer_print_min[0] + 32) - 32)))} Y{(first_layer_print_min[1] - 7)} W{32} H{7}
G0 Z5 F480 ; move away in Z
M107 ; turn off the fan
; MBL
M84 E ; turn off E motor
G29 P1 ; invalidate mbl & probe print area
G29 P1 X30 Y0 W{(((is_extruder_used[4]) or ((is_extruder_used[3]) or (is_extruder_used[2]))) ? "300" : ((is_extruder_used[1]) ? "130" : "50"))} H20 C ; probe near purge place
G29 P3.2 ; interpolate mbl probes
G29 P3.13 ; extrapolate mbl outside probe area
G29 A ; activate mbl
G1 Z10 F720 ; move away in Z
G1 F{travel_speed * 60}
P0 S1 L1 D0; park the tool
; set extruder temp
{if first_layer_temperature[0] > 0 and (is_extruder_used[0])}M104 T0 S{first_layer_temperature[0]}{endif}
{if first_layer_temperature[1] > 0 and (is_extruder_used[1])}M104 T1 S{first_layer_temperature[1]}{endif}
{if first_layer_temperature[2] > 0 and (is_extruder_used[2])}M104 T2 S{first_layer_temperature[2]}{endif}
{if first_layer_temperature[3] > 0 and (is_extruder_used[3])}M104 T3 S{first_layer_temperature[3]}{endif}
{if first_layer_temperature[4] > 0 and (is_extruder_used[4])}M104 T4 S{first_layer_temperature[4]}{endif}
{if (is_extruder_used[0]) and initial_tool != 0}

; (STUCK_FILAMENT_ERRORS) If stuck detection is causing false positives, uncomment this line and the corresponding one at the end
M591 S0 ; disable stuck detection

;
; purge first tool
;
G1 F{travel_speed * 60}
P0 S1 L2 D0; park the tool
M109 T0 S{first_layer_temperature[0]}
T0 S1 L0 D0; pick the tool
G92 E0 ; reset extruder position

G0 X30 Y-7 Z10 F{(travel_speed * 60)} ; move close to the sheet's edge
G0 E{if is_nil(filament_multitool_ramming[0])}10{else}30{endif} X40 Z0.2 F{if is_nil(filament_multitool_ramming[0])}500{else}170{endif} ; purge while moving towards the sheet
G0 X70 E9 F800 ; continue purging and wipe the nozzle
G0 X73 Z0.05 F8000 ; wipe, move close to the bed
G0 X76 Z0.2 F8000 ; wipe, move quickly away from the bed
G1 E{-retract_length_toolchange[0]} F2400 ; retract
{e_retracted[0] = retract_length_toolchange[0]}
G92 E0 ; reset extruder position

M104 S{(is_nil(idle_temperature[0]) ? (first_layer_temperature[0] + standby_temperature_delta) : (idle_temperature[0]))} T0
{endif}
{if (is_extruder_used[1]) and initial_tool != 1}
;
; purge second tool
;
G1 F{travel_speed * 60}
P0 S1 L2 D0; park the tool
M109 T1 S{first_layer_temperature[1]}
T1 S1 L0 D0; pick the tool
G92 E0 ; reset extruder position

G0 X150 Y-7 Z10 F{(travel_speed * 60)} ; move close to the sheet's edge
G0 E{if is_nil(filament_multitool_ramming[1])}10{else}30{endif} X140 Z0.2 F{if is_nil(filament_multitool_ramming[1])}500{else}170{endif} ; purge while moving towards the sheet
G0 X110 E9 F800 ; continue purging and wipe the nozzle
G0 X107 Z0.05 F8000 ; wipe, move close to the bed
G0 X104 Z0.2 F8000 ; wipe, move quickly away from the bed
G1 E{-retract_length_toolchange[1]} F2400 ; retract
{e_retracted[1] = retract_length_toolchange[1]}
G92 E0 ; reset extruder position

M104 S{(is_nil(idle_temperature[1]) ? (first_layer_temperature[1] + standby_temperature_delta) : (idle_temperature[1]))} T1
{endif}
{if (is_extruder_used[2]) and initial_tool != 2}
;
; purge third tool
;
G1 F{travel_speed * 60}
P0 S1 L2 D0; park the tool
M109 T2 S{first_layer_temperature[2]}
T2 S1 L0 D0; pick the tool
G92 E0 ; reset extruder position

G0 X210 Y-7 Z10 F{(travel_speed * 60)} ; move close to the sheet's edge
G0 E{if is_nil(filament_multitool_ramming[2])}10{else}30{endif} X220 Z0.2 F{if is_nil(filament_multitool_ramming[2])}500{else}170{endif} ; purge while moving towards the sheet
G0 X250 E9 F800 ; continue purging and wipe the nozzle
G0 X253 Z0.05 F8000 ; wipe, move close to the bed
G0 X256 Z0.2 F8000 ; wipe, move quickly away from the bed
G1 E{-retract_length_toolchange[2]} F2400 ; retract
{e_retracted[2] = retract_length_toolchange[2]}
G92 E0 ; reset extruder position

M104 S{(is_nil(idle_temperature[2]) ? (first_layer_temperature[2] + standby_temperature_delta) : (idle_temperature[2]))} T2
{endif}
{if (is_extruder_used[3]) and initial_tool != 3}
;
; purge fourth tool
;
G1 F{travel_speed * 60}
P0 S1 L2 D0; park the tool
M109 T3 S{first_layer_temperature[3]}
T3 S1 L0 D0; pick the tool
G92 E0 ; reset extruder position

G0 X330 Y-7 Z10 F{(travel_speed * 60)} ; move close to the sheet's edge
G0 E{if is_nil(filament_multitool_ramming[3])}10{else}30{endif} X320 Z0.2 F{if is_nil(filament_multitool_ramming[3])}500{else}170{endif} ; purge while moving towards the sheet
G0 X290 E9 F800 ; continue purging and wipe the nozzle
G0 X287 Z0.05 F8000 ; wipe, move close to the bed
G0 X284 Z0.2 F8000 ; wipe, move quickly away from the bed
G1 E{-retract_length_toolchange[3]} F2400 ; retract
{e_retracted[3] = retract_length_toolchange[3]}
G92 E0 ; reset extruder position

M104 S{(is_nil(idle_temperature[3]) ? (first_layer_temperature[3] + standby_temperature_delta) : (idle_temperature[3]))} T3
{endif}
{if (is_extruder_used[4]) and initial_tool != 4}
;
; purge fifth tool
;
G1 F{travel_speed * 60}
P0 S1 L2 D0; park the tool
M109 T4 S{first_layer_temperature[4]}
T4 S1 L0 D0; pick the tool
G92 E0 ; reset extruder position

G0 X330 Y-4.5 Z10 F{(travel_speed * 60)} ; move close to the sheet's edge
G0 E{if is_nil(filament_multitool_ramming[4])}10{else}30{endif} X320 Z0.2 F{if is_nil(filament_multitool_ramming[4])}500{else}170{endif} ; purge while moving towards the sheet
G0 X290 E9 F800 ; continue purging and wipe the nozzle
G0 X287 Z0.05 F8000 ; wipe, move close to the bed
G0 X284 Z0.2 F8000 ; wipe, move quickly away from the bed
G1 E{-retract_length_toolchange[4]} F2400 ; retract
{e_retracted[4] = retract_length_toolchange[4]}
G92 E0 ; reset extruder position

M104 S{(is_nil(idle_temperature[4]) ? (first_layer_temperature[4] + standby_temperature_delta) : (idle_temperature[4]))} T4
{endif}
;
; purge initial tool
;
G1 F{travel_speed * 60}
P0 S1 L2 D0; park the tool
M109 T{initial_tool} S{first_layer_temperature[initial_tool]}
T{initial_tool} S1 L0 D0; pick the tool
G92 E0 ; reset extruder position

G0 X{(initial_tool == 0 ? 30 : (initial_tool == 1 ? 150 : (initial_tool == 2 ? 210 : 330)))} Y{(initial_tool < 4 ? -7 : -4.5)} Z10 F{(travel_speed * 60)} ; move close to the sheet's edge
G0 E{if is_nil(filament_multitool_ramming[initial_tool])}10{else}30{endif} X{(initial_tool == 0 ? 30 : (initial_tool == 1 ? 150 : (initial_tool == 2 ? 210 : 330))) + ((initial_tool == 0 or initial_tool == 2 ? 1 : -1) * 10)} Z0.2 F{if is_nil(filament_multitool_ramming[initial_tool])}500{else}170{endif} ; purge while moving towards the sheet
G0 X{(initial_tool == 0 ? 30 : (initial_tool == 1 ? 150 : (initial_tool == 2 ? 210 : 330))) + ((initial_tool == 0 or initial_tool == 2 ? 1 : -1) * 40)} E9 F800 ; continue purging and wipe the nozzle
G0 X{(initial_tool == 0 ? 30 : (initial_tool == 1 ? 150 : (initial_tool == 2 ? 210 : 330))) + ((initial_tool == 0 or initial_tool == 2 ? 1 : -1) * 40) + ((initial_tool == 0 or initial_tool == 2 ? 1 : -1) * 3)} Z{0.05} F{8000} ; wipe, move close to the bed
G0 X{(initial_tool == 0 ? 30 : (initial_tool == 1 ? 150 : (initial_tool == 2 ? 210 : 330))) + ((initial_tool == 0 or initial_tool == 2 ? 1 : -1) * 40) + ((initial_tool == 0 or initial_tool == 2 ? 1 : -1) * 3 * 2)} Z0.2 F{8000} ; wipe, move quickly away from the bed
G1 E-{retract_length[initial_tool]} F2400 ; retract
{e_retracted[initial_tool] = retract_length[initial_tool]}

; (STUCK_FILAMENT_ERRORS) If stuck detection was disabled, uncomment the next line also
;M591 R ; restore stuck detection
G92 E0 ; reset extruder position
