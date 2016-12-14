module Data.Drasil.Concepts.Thermodynamics where

import Language.Drasil

boiling,law_cons_energy, law_conv_cooling, latent_heat, melting, phase_change,
  sens_heat, thermal_analysis, thermal_conduction, thermal_energy,
  thermal_conductor :: DefinedTerm

heat_trans, heat_cap_spec :: ConceptChunk

boiling = makeDCC "boiling" "Boiling" 
  "Phase change from liquid to vapour"
heat_trans = makeCC "Heat transfer" 
  "heat transfer"
heat_cap_spec = makeCC "C" "specific heat capacity"
latent_heat = makeDCC "latent_heat" "Latent heat" 
  "Latent heating"
law_cons_energy = makeDCC "law_cons_energy" "Law of conservation of energy" 
  "Energy is conserved"
law_conv_cooling = makeDCC "law_conv_cooling" "Newton's law of cooling" 
  "Newton's law of convective cooling"
melting = makeDCC "melting" "Melting" 
  "Phase change from solid to liquid"
phase_change = makeDCC "phase_change" "Phase change" "Change of state"
--FIXME: sens_heat's definition is useless.
sens_heat = makeDCC "sens_heat" "Sensible heat" "Sensible heating"
thermal_analysis = makeDCC "thermal_analysis" "Thermal analysis" 
  "The study of material properties as they change with temperature"
thermal_conduction = makeDCC "thermal_conduction" "Thermal conduction" 
  "The transfer of heat energy through a substance."
thermal_conductor = makeDCC "thermal_conductor" "Thermal conductor" 
  ("An object through which thermal energy can be transferred")
thermal_energy = makeDCC "thermal_energy" "Thermal energy"
  "The energy that comes from heat."