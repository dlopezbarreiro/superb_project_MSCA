# script to calculate the secondary structure of a .dcd trajectory from a protein in VMD

start_sscache top ; # the sscache package calculates and stores the secondary structure for	each timestep

puts "Getting secondary structure information"

set outfile [open "sec_struct.dat" w ] ; # opens files where the data will be output
set n [molinfo top get numframes] ; # reads the number of frames in the .dcd trajectory

set prot_sec_struct [atomselect top all] ; # select the protein for which the secundary structure will be determined

set numRes [llength [$prot_sec_struct get resid]] ; # returns the number of residues in the protein

for {set i 0 } { $i <= $n } { incr i } {
      animate goto $i
      display update ui
      mol ssrecalc 0
      $prot_sec_struct frame $i
      $prot_sec_struct update
      set sscache_data($i) [$prot_sec_struct get structure]
      set extended [llength [lsearch -all $sscache_data($i) E ]] ; # returns the number of residues in extended conformation
      set turn [llength [lsearch -all $sscache_data($i) T ]] ; # returns the number of residues in turn conformation
      set helix [llength [lsearch -all $sscache_data($i) H ]] ; # returns the number of residues in helix conformation
      set coil [llength [lsearch -all $sscache_data($i) C ]] ; # returns the number of residues in random coil conformation
      puts "This is number of extended, turn and coil: $extended $turn $helix $coil"
      set extendedPercent [expr { [llength [lsearch -all $sscache_data($i) E ]] / double($numRes)}]
      set turnPercent [expr { [llength [lsearch -all $sscache_data($i) T ]] / double($numRes)}]
      set helixPercent [expr { [llength [lsearch -all $sscache_data($i) H ]] / double($numRes)}]
      set coilPercent [expr { [llength [lsearch -all $sscache_data($i) C ]] / double($numRes)}]
      puts "Extended_percent $extendedPercent"
      puts "Turn_percent $turnPercent"
      puts "Helix_percent $helixPercent"
      puts "Coil_percent $coilPercent"
      puts $outfile "$i $extendedPercent $turnPercent $helixPercent $coilPercent"
      lappend extendedPercent $extendedPercent
      lappend turnPercent $turnPercent
      lappend helixPercent $helixPercent
      lappend coilPercent $coilPercent
      puts "Structure: $i"
}
close $outfile

$prot_sec_struct delete
