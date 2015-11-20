{-# OPTIONS -Wall #-}
{-# LANGUAGE FlexibleContexts #-} 
module Example1 where
import ASTInternal (Expr(..))
import Spec (Spec(..))
import ExprTools (get_dep)
import Chunk (VarChunk(..))
import SI_Units
import Unicode (Circle(..), Unicode, Tau(..))
import Format (Format)

--------------- --------------- --------------- ---------------
{--------------- Begin tau_c ---------------}
--------------- --------------- --------------- ---------------
tau_c :: VarChunk
tau_c = VC "tau_c" "clad thickness" (U Tau_L :-: S "c")

--------------- --------------- --------------- ---------------
{--------------- Begin h_c ---------------}
--------------- --------------- --------------- ---------------
h_c_eq :: Expr
h_c_eq = ((Int 2):*(C k_c):*(C h_b)) :/ ((Int 2):*(C k_c)
  :+((C tau_c):*(C h_b)))

-- h_c :: (Format mode, Unicode mode Tau) => Chunk mode
-- h_c = newChunk "h_c" $
  -- [(Symbol, S "h" :-: S "c"),
   -- (Equation, E h_c_eq),
   -- (Description, S
    -- "convective heat transfer coefficient between clad and coolant"),
   -- (SIU, S "($\\mathrm{\\frac{kW}{m^2C}}$)"),
   -- (Dependencies, D $ get_dep h_c_eq)
  -- ]

-- --------------- --------------- --------------- ---------------
-- {--------------- Begin h_g ---------------}
-- --------------- --------------- --------------- ---------------
-- h_g_eq :: (Format mode, Unicode mode Tau) => Expr mode
-- h_g_eq = ((Int 2):*(C k_c):*(C h_p)) :/ ((Int 2):*(C k_c):+((C tau_c):*(C h_p)))

-- h_g :: (Format mode, Unicode mode Tau) => Chunk mode
-- h_g = newChunk "h_g" $
  -- [(Symbol, S "h" :-: S "g"),
   -- (Equation, E h_g_eq),
   -- (SIU, S "($\\mathrm{\\frac{kW}{m^2C}}$)"),
   -- (Description, S
    -- "effective heat transfer coefficient between clad and fuel surface"),
   -- (Dependencies, D $ get_dep h_g_eq)
  -- ]

--------------- --------------- --------------- ---------------
{--------------- Begin h_b ---------------}
--------------- --------------- --------------- ---------------

h_b :: VarChunk
h_b = VC "h_b" "initial coolant film conductance" (S "h" :-: S "b")

--------------- --------------- --------------- ---------------
{--------------- Begin h_p ---------------}
--------------- --------------- --------------- ---------------

h_p :: VarChunk
h_p = VC "h_p" "initial gap film conductance" (S "h":-: S "p")

--------------- --------------- --------------- ---------------
{--------------- Begin k_c ---------------}
--------------- --------------- --------------- ---------------

k_c :: VarChunk
k_c = VC "k_c" "clad conductivity" (S "k":-: S "c")
