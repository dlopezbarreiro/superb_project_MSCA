# script to calculate the number of water molecules in the hydration layer of a protein in a .dcd trajectory in VMD

set frames [molinfo top get numframes] ; # reads the number of frames in the .dcd trajectory
set outfile [open hydration_shell.dat w] ; # opens files where the data will be output

# iterate over the number of frames in the .dcd trajectory

for {set i 0} {$i < $frames} {incr i} {
      puts "Frame: $i"
      set protein [atomselect top "(water and oxygen within 3.15 of backbone)"] ; # counts the number of water molecules (oxygen atoms) within 3.15 A of the backbone of the protein
      $protein frame $i
      $protein update
      set water_num [$protein num]
      puts $outfile "$i $water_num"
      $protein delete
}
close $outfile
