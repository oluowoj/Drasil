module Drasil.SSP.Defs where

import Drasil.SSP.Units

import Language.Drasil
import Data.Drasil.SI_Units
import Data.Drasil.Concepts.Documentation

import Control.Lens ((^.))

--FIXME: Remove unitless
sspSymbols :: [UnitalChunk]
sspSymbols = [fricAngle, cohesion, dryWeight, satWeight, waterWeight, elastMod, poisson, coords, hWT, hUS, hSlip, xi, critCoords, fs, fsloc, si, pi_f, ti, ri, wi, kc, hi, dHi, ei, xi_2, ubi, uti, ni, ni_prime, ni_star, qi, alpha_i, beta_i, omega_i, lambda, fi, bi, lbi, lsi, hi_2, n, f, m, upsilon, delta, k, k_sti, k_bti, k_sni, k_bni, k_tr, k_no, du_i, dv_i, dx_i, dy_i]

fricAngle, cohesion, dryWeight, satWeight, waterWeight, elastMod, poisson, coords, hWT, hUS, hSlip, xi, critCoords, fs, fsloc, si, pi_f, ti, ri, wi, kc, hi, dHi, ei, xi_2, ubi, uti, ni, ni_prime, ni_star, qi, alpha_i, beta_i, omega_i, lambda, fi, bi, lbi, lsi, hi_2, n, f, m, upsilon, delta, k, k_sti, k_bti, k_sni, k_bni, k_tr, k_no, du_i, dv_i, dx_i, dy_i, s, p :: UnitalChunk

fricAngle   = makeUC "varphi'" "effective angle of friction" 
  "FIXME: Define this or remove the need for definitions"
  (Concat [Greek Phi_V, Atomic "'"]) degree

cohesion    = makeUC "c'" "effective cohesion" 
  "FIXME: Define this or remove the need for definitions"
  (Atomic "c'") pascal

dryWeight   = makeUC "gamma" "unit weight of dry soil/ground layer" 
  "FIXME: Define this or remove the need for definitions"
  (Greek Gamma_L) specific_weight

satWeight   = makeUC "gamma_sat" "unit weight of saturated soil/ground layer" 
  "FIXME: Define this or remove the need for definitions"
  (sub (Greek Gamma_L) (Atomic "Sat")) specific_weight

waterWeight = makeUC "gamma_w" "unit weight of water" 
  "FIXME: Define this or remove the need for definitions"
  (sub (Greek Gamma_L) lW) specific_weight

elastMod    = makeUC "E" "elastic modulus" 
  "FIXME: Define this or remove the need for definitions"
  cE pascal

poisson     = makeUC "nu" "Poisson's ratio"
  "FIXME: Define this or remove the need for definitions"
  (Greek Nu_L) unitless

coords      = makeUC "(x,y)" 
  ("cartesian position coordinates; y is considered parallel to the " ++ 
  "direction of the force of gravity and x is considered perpendicular to y")
  "FIXME: Define this or remove the need for definitions"
  (Atomic "(x,y)") metre

hWT         = makeUC "y_wt,i" 
  ("the y ordinate, or height of the water table at i; refers to either " ++
  "slice i midpoint, or slice interface i")
  "FIXME: Define this or remove the need for definitions"
  (sub lY (Atomic "wt,i")) metre

hUS         = makeUC "y_us,i" ("the y ordinate, or height of the top of the " ++
  "slope at i; refers to either slice i midpoint, or slice interface i")
  "FIXME: Define this or remove the need for definitions"
  (sub lY (Atomic "us,i")) metre

hSlip       = makeUC "y_slip,i" ("the y ordinate, or height of the slip " ++
  "surface at i; refers to either slice i midpoint, or slice interface i") 
  "FIXME: Define this or remove the need for definitions"
  (sub lY (Atomic "slip,i")) metre

xi          = makeUC "x_i" 
  "the x ordinate; refers to either slice i midpoint, or slice interface i" 
  "FIXME: Define this or remove the need for definitions"
  (sub lX lI) metre

critCoords  = makeUC "(xcs,ycs)" ("the set of x and y coordinates that " ++
  "describe the vertices of the critical slip surface")
  "FIXME: Define this or remove the need for definitions"
  (Concat [sub (Atomic "({x") (Atomic "cs"), sub (Atomic "},{y") (Atomic "cs"), 
  Atomic "})"]) metre

fs          = makeUC "FS" ("global factor of safety describing the " ++
  "stability of a surface in a slope")
  "FIXME: Define this or remove the need for definitions"
  (Atomic "FS") unitless

fsloc       = makeUC "FS_loci" "local factor of safety specific to a slice i" 
  "FIXME: Define this or remove the need for definitions"
  (sub (Atomic "FS") (Atomic "Loc,i")) unitless

si          = makeUC "S_i" "mobilized shear force for slice i" 
  "FIXME: Define this or remove the need for definitions"
  (sub cS lI) newton

s           = makeUC "S" "mobilized shear force" 
  "FIXME: Define this or remove the need for definitions"
  cS newton

pi_f        = makeUC "P_i" ("shear resistance; Mohr Coulomb frictional " ++
  "force that describes the limit of mobilized shear force the slice i " ++
  "can withstand before failure")
  "FIXME: Define this or remove the need for definitions"
  (sub cP lI) newton

p           = makeUC "P" "shear resistance" 
  "FIXME: Define this or remove the need for definitions"
  (cP) newton

ti          = makeUC "T_i" 
  "mobilized shear force without the influence of interslice forces for slice i"
  "FIXME: Define this or remove the need for definitions"
  (sub cT lI) newton

ri          = makeUC "R_i" 
  "shear resistance without the influence of interslice forces for slice i" 
  "FIXME: Define this or remove the need for definitions"
  (sub cR lI) newton

wi          = makeUC "W_i" "weight; downward force caused by gravity on slice i"
  "FIXME: Define this or remove the need for definitions"
  (sub cW lI) newton

kc          = makeUC "K_c" ("earthquake load factor; proportionality factor " ++
  "of force that weight pushes outwards; caused by seismic earth movements")
  "FIXME: Define this or remove the need for definitions"
  (sub cK lC) unitless

hi          = makeUC "H_i" ("interslice water force exerted in the " ++
  "x-ordinate direction between adjacent slices (for interslice index i)")
  "FIXME: Define this or remove the need for definitions"
  (sub cH lI) newton

dHi         = makeUC "dH_i" "difference between interslice forces on acting in the x-ordinate direction of the slice on each side (for interslice index i)"
  "FIXME: Define this or remove the need for definitions"
  (sub (Concat [Greek Delta, cH]) lI) newton

ei          = makeUC "E_i" "interslice normal force being exerted between adjacent slices (for interslice index i)"
  "FIXME: Define this or remove the need for definitions"
  (sub cE lI) newton

xi_2        = makeUC "X_i" "interslice shear force being exerted between adjacent slices (for interslice index i)" 
  "FIXME: Define this or remove the need for definitions"
  (sub cX lI) newton

ubi         = makeUC "U_b,i" "base hydrostatic force arising from water pressure within the slice (for slice index i)" 
  "FIXME: Define this or remove the need for definitions"
  (sub cU (Atomic "b,i")) newton

uti         = makeUC "U_t,i" "surface hydrostatic force arising from water pressure acting into the slice from standing water on the slope surface (for slice index i)" 
  "FIXME: Define this or remove the need for definitions"
  (sub cU (Atomic "t,i")) newton

ni          = makeUC "N_i" "total reactive force for a soil surface subject to a body resting on it" 
  "FIXME: Define this or remove the need for definitions"
  (sub cN lI) newton

ni_prime    = makeUC "N'_i" "effective normal force of a soil surface, subtracting pore water reactive force from total reactive force" 
  "FIXME: Define this or remove the need for definitions"
  (sub (Atomic "N'") lI) newton

ni_star     = makeUC "N*_i" "effective normal force of a soil surface, neglecting the influence of interslice forces" 
  "FIXME: Define this or remove the need for definitions"
  (sub (Atomic "N*") lI) newton

qi          = makeUC "Q_i" "imposed surface load; a downward force acting into the surface from midpoint of slice i" 
  "FIXME: Define this or remove the need for definitions"
  (sub cQ lI) newton

alpha_i     = makeUC "alpha_i" "angle of the base of the mass relative to the horizontal (for slice index i)" 
  "FIXME: Define this or remove the need for definitions"
  (sub (Greek Alpha_L) lI) degree

beta_i      = makeUC "beta_i" "angle of the surface of the mass relative to the horizontal (for slice index i)" 
  "FIXME: Define this or remove the need for definitions"
  (sub (Greek Beta_L) lI) degree

omega_i     = makeUC "omega_i" "angle of imposed surface load acting into the surface relative to the vertical (for slice index i)" 
  "FIXME: Define this or remove the need for definitions"
  (sub (Greek Omega_L) lI) degree

lambda      = makeUC "lambda" "ratio between interslice normal and shear forces (applied to all interslices)" 
  "FIXME: Define this or remove the need for definitions"
  (Greek Lambda_L) unitless

fi          = makeUC "f_i" "scaling function for magnitude of interslice forces as a function of the x coordinate (at interslice index i); can be constant or a half-sine" 
  "FIXME: Define this or remove the need for definitions"
  (sub lF lI) unitless

bi          = makeUC "b_i" "base width of the slice in the x-ordinate direction only (for slice index i)" 
  "FIXME: Define this or remove the need for definitions"
  (sub lB lI) metre

lbi         = makeUC "l_b,i" "total length of the base of a slice (for slice index i)" 
  "FIXME: Define this or remove the need for definitions"
  (sub (Greek Ell) (Atomic "b,i")) metre

lsi         = makeUC "l_s,i" "length of an interslice surface, from slip base to slope surface in a vertical line from an interslice vertex (for interslice index i)" 
  "FIXME: Define this or remove the need for definitions"
  (sub (Greek Ell) (Atomic "s,i")) metre

hi_2        = makeUC "h_i" "midpoint height; distance from the slip base to the slope surface in a vertical line from the midpoint of the slice (for slice i)" 
  "FIXME: Define this or remove the need for definitions"
  (sub lH lI) metre

n           = makeUC "n" "number of slices the slip mass has been divided into" 
  "FIXME: Define this or remove the need for definitions"
  lN unitless

f           = makeUC "F" "generic force; assumed 1D allowing a scalar" 
  "FIXME: Define this or remove the need for definitions"
  cF metre

m           = makeUC "M" "moment of a body; assumed 2D allowing a scalar" 
  "FIXME: Define this or remove the need for definitions"
  cM momentOfForceU

upsilon     = makeUC "Upsilon" "generic minimization function or algorithm" 
  "FIXME: Define this or remove the need for definitions"
  (Greek Upsilon) unitless

delta       = makeUC "delta" "generic displacement of a body" 
  "FIXME: Define this or remove the need for definitions"
  (Greek Delta_L) metre

k           = makeUC "K" "stiffness (how much a body resists displacement when subject to a force)" 
  "FIXME: Define this or remove the need for definitions"
  (cK) stiffnessU

k_sti       = makeUC "K_st,i" "shear stiffness of an interslice surface, without length adjustment (for interslice index i)" 
  "FIXME: Define this or remove the need for definitions"
  (sub cK (Atomic "st,i")) pascal

k_bti       = makeUC "K_bt,i" "shear stiffness of a slice base surface, without length adjustment (for slice index i)" 
  "FIXME: Define this or remove the need for definitions"
  (sub cK (Atomic "bt,i")) pascal

k_sni       = makeUC "K_sn,i" "normal stiffness of an interslice surface, without length adjustment (for interslice index i)" 
  "FIXME: Define this or remove the need for definitions"
  (sub cK (Atomic "sn,i")) pascal

k_bni       = makeUC "K_bn,i" "normal stiffness of a slice base surface, without length adjustment (for slice index i)" 
  "FIXME: Define this or remove the need for definitions"
  (sub cK (Atomic "bn,i")) pascal

k_tr        = makeUC "K_tr" "residual shear stiffness" 
  "FIXME: Define this or remove the need for definitions"
  (sub cK (Atomic "tr")) pascal

k_no        = makeUC "K_no" "residual normal stiffness" 
  "FIXME: Define this or remove the need for definitions"
  (sub cK (Atomic "no")) pascal

du_i        = makeUC "du_i" "shear displacement of a slice (for slice index i)" 
  "FIXME: Define this or remove the need for definitions"
  (sub (Concat [Greek Delta_L, Atomic "u"]) lI) metre

dv_i        = makeUC "dv_i" "normal displacement of a slice (for slice index i)" 
  "FIXME: Define this or remove the need for definitions"
  (sub (Concat [Greek Delta_L, Atomic "v"]) lI) metre

dx_i        = makeUC "dx_i" "displacement of a slice in the x-ordinate direction (for slice index i)" 
  "FIXME: Define this or remove the need for definitions"
  (sub (Concat [Greek Delta_L, Atomic "x"]) lI) metre

dy_i        = makeUC "dy_i" "displacement of a slice in the y-ordinate direction (for slice index i)" 
  "FIXME: Define this or remove the need for definitions"
  (sub (Concat [Greek Delta_L, Atomic "y"]) lI) metre


----Acronyms-----
-- FIXME: Use acronyms
acronyms :: [ConceptChunk]
acronyms = [assumption,dataDefn,genDefn,goalStmt,inModel,likelyChg,
  physSyst,requirement,srs,sSA,thModel]
  
--FIXME: Use an acronym and move "Slope Stability Analysis" to term.
sSA :: ConceptChunk
sSA = dcc "sSA" "SSA" "Slope Stability Analysis"


----Theoretical Models----
fs_rc :: RelationConcept
fs_rc = makeRC "fs_rc" "Factor of Safety" fs_desc fs_rel

fs_rel :: Relation
fs_rel = (C fs) := (C p) / (C s)

fs_desc :: Sentence
fs_desc = 
  (S "The stability metric of the slope, known as the factor of safety (" :+: 
  P (fs ^. symbol) :+: S "), is determined by the ratio of the shear force at the base of the slope (" :+: P (s ^. symbol) :+: S "), and the resistive shear (" :+: P (p ^. symbol) :+: S ").")
