module Drasil.HGHC.Modules (mod_calc, mod_inputp, mod_inputf, 
  mod_outputf, mod_ctrl) where

import Language.Drasil
import Language.Drasil.Code hiding (self)
import Prelude hiding (id)
import Control.Lens ((^.))

import Drasil.HGHC.HeatTransfer --all of it

import Data.Drasil.Modules (mod_hw, mod_ctrl_fun, mod_io_fun, mod_behav,
  mod_calc_fun)
import Data.Drasil.Concepts.Documentation (input_)
import Data.Drasil.Concepts.Software (modInputFormat, mod_outputf_desc_fun, 
  modInputParam, program)
import Data.Drasil.Concepts.Math (parameter)
import Data.Drasil.Concepts.Computation (structure, inDatum, outDatum, 
  algorithm)
import Data.Drasil.SentenceStructures (foldlSent, foldlList, sAnd)

{--}

executable :: NamedChunk
executable = npnc' "HGHC" (compoundPhrase (pn "HGHC") (program ^. term))
  ("HGHC")

-- input param module
mod_inputp :: ModuleChunk
mod_inputp = makeRecord modInputParam 
             (foldlSent [S "The format" `sAnd` (phrase structure), S "of the", 
             (phrase input_), (plural parameter)]) --FIXME: Plural?
             executable
             htVars
             []
             (Just mod_behav)

--input format
--FIXME: All the NP stuff here needs to be tweaked.
meth_input :: MethodChunk
meth_input = makeFileInputMethod
             (nc "read_input" (nounPhraseSP "Reads and stores input from file."))
             (makeVCObj "params" (cn "input parameters") cP (mod_inputp ^. id)) --FIXME: avoid using id
             "input"

mod_inputf :: ModuleChunk
mod_inputf = mod_io_fun executable
  [meth_input]
  [mod_inputp]
  (plural inDatum)
  modInputFormat

-- Calc Module
meth_htTransCladFuel, meth_htTransCladCool :: MethodChunk
meth_htTransCladFuel = fromEC htTransCladFuel allSymbols
meth_htTransCladCool = fromEC htTransCladCool allSymbols

hghc_calcDesc :: Sentence
hghc_calcDesc = S "Calculates heat transfer coefficients"

mod_calc :: ModuleChunk
mod_calc = mod_calc_fun 
  hghc_calcDesc
  (S "The equations used to calculate heat transfer coefficients")
  executable
  [meth_htTransCladFuel, meth_htTransCladCool]
  []

-- Output Format Module
meth_output :: MethodChunk
meth_output = makeFileOutputMethod (nc "write_output" (
  cn "Writes output to file.")) [getVC htTransCladFuel, getVC htTransCladCool] 
  "output"

mod_outputf_desc :: ConceptChunk
mod_outputf_desc = mod_outputf_desc_fun (foldlList [S "input parameters",
  S "temperatures", S "energies", S "times when melting starts" `sAnd` S "stops."])

mod_outputf :: ModuleChunk
mod_outputf = mod_io_fun executable
  [meth_output]
  [mod_hw, mod_inputp]
  (plural outDatum)
  mod_outputf_desc

-- Control Module
main_func :: Body
main_func =
  let labelParams = "params"
      typeParams = obj "input_parameters"
      labelIn = "in"
      typeIn = obj "input_format"
      labelCalc = "cal"
      typeCalc = obj "calc"
      labelOut = "out"
      typeOut = obj "output_format"
      labelCladThick = cladThick ^. id
      labelCoolFilm = coolFilmCond ^. id
      labelGapFilm = gapFilmCond ^. id --FIXME: avoid using id
      labelCladCond = cladCond ^. id
      labelHg = htTransCladFuel ^. id
      labelHc = htTransCladCool ^. id
  in
  [ block
    [ objDecNewVoid' labelParams typeParams,
      objDecNewVoid' labelIn typeIn,
      valStmt $ objMethodCall (var labelIn) (meth_input ^. id) [var labelParams], --FIXME: avoid using id
      objDecNewVoid' labelCalc typeCalc,
      varDecDef labelHg float
        ( objMethodCall (var labelCalc) ("calc_" ++ labelHg)
          [ var labelParams $-> var labelCladCond,
            var labelParams $-> var labelGapFilm,
            var labelParams $-> var labelCladThick ] ),
      varDecDef labelHc float
        ( objMethodCall (var labelCalc) ("calc_" ++ labelHc)
          [ var labelParams $-> var labelCladCond,
            var labelParams $-> var labelCoolFilm,
            var labelParams $-> var labelCladThick ] ),
      objDecNewVoid' labelOut typeOut,
      valStmt $ objMethodCall (var labelOut) (meth_output ^. id) --FIXME: avoid using id
        [ var labelHg,
          var labelHc ]
    ]
  ]

meth_main :: MethodChunk
meth_main = makeMainMethod (nc "main" (cn' "Main method")) main_func

mod_ctrl :: ModuleChunk
mod_ctrl = mod_ctrl_fun (S "The" +:+ (phrase algorithm))
  executable
  [meth_main] 
  [mod_hw, mod_inputp, mod_inputf, mod_calc, mod_outputf]
