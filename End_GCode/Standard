G4 ; wait

{if layer_z < max_print_height}G1 Z{z_offset+min(max_layer_z+5, max_print_height)}{endif} ; Move bed down

P0 S1 ; park tool

{if layer_z < max_print_height}G1 Z{z_offset+min(max_layer_z+97, max_print_height)} F300{endif} ; Move bed further down

; turn off extruder heaters
{if is_extruder_used[0]}M104 T0 S0{endif}
{if is_extruder_used[1]}M104 T1 S0{endif}
{if is_extruder_used[2]}M104 T2 S0{endif}
{if is_extruder_used[3]}M104 T3 S0{endif}
{if is_extruder_used[4]}M104 T4 S0{endif}

M140 S0 ; turn off heatbed
M107 ; turn off fan
M221 S100 ; reset flow percentage
M84 ; disable motors
M77 ; stop print timer
; max_layer_z = [max_layer_z]
