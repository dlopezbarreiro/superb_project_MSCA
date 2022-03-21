# script to calculate SASA (hydrophobic and hydrophilic) and radius of gyration from a .dcd trajectory in VMD

set outfile [open sasa_rgyr.dat w] ; # opens files where the data will be output
set frames [molinfo top get numframes] ; # reads the number of frames in the .dcd trajectory

set protein [atomselect top all] ; # Selects all amino acids
set hydrophobic [atomselect top hydrophobic] ; # Selects hydrophobic amino acids
set hydrophilic [atomselect top "not hydrophobic"] ; # Selects hydrophilic amino acids

# iterate over the number of frames to calculate SASA (hydrophobic and hydrophilic) and radius of gyration

for {set i 0} {$i<$frames} {incr i} {

      $protein frame $i
      $protein update
      $hydrophobic frame $i
      $hydrophobic update
      $hydrophilic frame $i
      $hydrophilic update

      set sasa [measure sasa 1.4 $protein]
      set sasa_hydrophobic [measure sasa 1.4 $protein -restrict $hydrophobic] ; # returns SASA of atoms in the selection $hydrophobic using a radius of 1.4 for each atom
      set sasa_hydrophilic [measure sasa 1.4 $protein -restrict $hydrophilic] ; # returns SASA of atoms in the selection $hydrophilic using a radius of 1.4 for each atom
      set rgyr [measure rgyr $protein] ; # returns the radius of gyration of the whole protein

      puts $outfile "$i $sasa $sasa_hydrophobic $sasa_hydrophilic $rgyr" ; # writes the data (SASA+radius of gyration) in the output file
}
close $outfile
