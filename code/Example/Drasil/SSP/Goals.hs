module Drasil.SSP.Goals where

import Language.Drasil
import Drasil.SSP.Defs
import Data.Drasil.SentenceStructures

-----------
-- Goals --
-----------

sspGoals :: [Sentence]
sspGoals = [locAndGlFS, lowestFS, displSlope]

locAndGlFS, lowestFS, displSlope :: Sentence

-- 1
locAndGlFS = S "Evaluate local and global" +:+ plural fs_concept +:+
  S "along a given" +:+. phrase slpSrf
  
-- 2
lowestFS   = S "Identify the" +:+ phrase crtSlpSrf +:+ S "for the" +:+
  phrase slope `sC` S "with the lowest" +:+. phrase fs_concept
  
-- 3
displSlope = S "Determine" +:+. (S "displacement" `ofThe` phrase slope)
