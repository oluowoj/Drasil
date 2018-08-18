module Drasil.GlassBR.Requirements (funcReqsList, funcReqsListOfReqs) where

import Control.Lens ((^.))
import Data.Function (on)
import Data.List (sortBy)

import Language.Drasil
import Drasil.DocLang (mkRequirement)
import Drasil.DocLang.SRS (datConLabel)

import Data.Drasil.Concepts.Computation (inParam, inQty, inValue)
import Data.Drasil.Concepts.Documentation (characteristic, condition, 
  datumConstraint, description, failure, input_, message, output_, quantity, 
  symbol_, system, value)
import Data.Drasil.Concepts.Math (calculation, probability)
import Data.Drasil.Concepts.PhysicalProperties (dimension)
import Data.Drasil.Concepts.Software (errMsg)

import Data.Drasil.SentenceStructures (FoldType(List), SepType(Comma), andThe, 
  foldlList, foldlSent, foldlSent_, followA, ofThe, sAnd, sOf)
import Data.Drasil.SI_Units (metre, millimetre)
import Data.Drasil.Utils (noRefs)

import Drasil.GlassBR.Assumptions (standardValues, glassLite, assumptionConstants)
import Drasil.GlassBR.Concepts (glass, lShareFac)
import Drasil.GlassBR.DataDefs (aspRat, dimLL, glaTyFac, hFromt, loadDF, nonFL, 
  risk, standOffDis, strDisFac, tolPre, tolStrDisFac)
import Drasil.GlassBR.IMods (gbrIMods)
import Drasil.GlassBR.TMods (lrIsSafe, pbIsSafe)
import Drasil.GlassBR.Unitals (blast, char_weight, glassTy, glass_type, 
  is_safeLR, is_safePb, nom_thick, notSafe, pb_tol, plate_len, plate_width, 
  safeMessage, sdx, sdy, sdz, tNT)

{--Functional Requirements--}

funcReqsList :: [Contents]
funcReqsList = funcReqsListOfReqsCon ++ [LlC inputGlassPropsTable]

funcReqsListOfReqsCon :: [Contents]
funcReqsListOfReqsCon = map LlC $ funcReqsListOfReqs

funcReqsListOfReqs :: [LabelledContent]
funcReqsListOfReqs = [inputGlassProps, sysSetValsFollowingAssumps, checkInputWithDataCons, outputValsAndKnownQuants, checkGlassSafety, outputQuants]
inputGlassProps, sysSetValsFollowingAssumps, checkInputWithDataCons, outputValsAndKnownQuants, checkGlassSafety, outputQuants :: LabelledContent

inputGlassProps          = mkRequirement "inputGlassProps"          inputGlassPropsDesc              "Input-Glass-Props"
checkInputWithDataCons   = mkRequirement "checkInputWithDataCons"   checkInputWithDataConsDesc       "Check-Input-with-Data_Constraints"
outputValsAndKnownQuants = mkRequirement "outputValsAndKnownQuants" outputValsAndKnownQuantsDesc     "Output-Values-and-Known-Quantities"
checkGlassSafety         = mkRequirement "checkGlassSafety"         (checkGlassSafetyDesc (output_)) "Check-Glass-Safety"

inputGlassPropsDesc, checkInputWithDataConsDesc, outputValsAndKnownQuantsDesc :: Sentence
checkGlassSafetyDesc :: NamedChunk -> Sentence

inputGlassPropsDesc = foldlSent [at_start input_, S "the", plural quantity, S "from",
  makeRef inputGlassPropsTable `sC` S "which define the" +:+. foldlList Comma List
  [phrase glass +:+ plural dimension, (glassTy ^. defn), S "tolerable" +:+
  phrase probability `sOf` phrase failure, (plural characteristic `ofThe` 
  phrase blast)] +: S "Note", ch plate_len `sAnd` ch plate_width,
  S "will be input in terms of", plural millimetre `sAnd`
  S "will be converted to the equivalent value in", plural metre]

inputGlassPropsTable :: LabelledContent
inputGlassPropsTable = llcc (mkLabelSame "InputGlassPropsReqInputs" Tab) $ 
  Table
  [at_start symbol_, at_start description, S "Units"]
  (mkTable
  [ch,
   at_start, unitToSentence] requiredInputs)
  (S "Required Inputs following" +:+ makeRef inputGlassProps) True
  where
    requiredInputs :: [QuantityDict]
    requiredInputs = (map qw [plate_len, plate_width, char_weight])
      ++ (map qw [pb_tol, tNT]) ++ (map qw [sdx, sdy, sdz])
      ++ (map qw [glass_type, nom_thick])

sysSetValsFollowingAssumps = llcc sysSetValsFollowingAssumpsLabel $
  Enumeration $ Simple $ 
  [(S "System-Set-Values-Following-Assumptions"
   , Nested (foldlSent_ [S "The", phrase system, S "shall set the known", 
    plural value +: S "as follows"])
     $ Bullet $ noRefs $
     map (Flat $) (sysSetValsFollowingAssumpsList)
   , Just $ (getAdd (sysSetValsFollowingAssumpsLabel ^. getRefAdd)))]

sysSetValsFollowingAssumpsList :: [Sentence]
sysSetValsFollowingAssumpsList = [foldlList Comma List (map ch (take 4 assumptionConstants)) `followA` standardValues,
  ch loadDF +:+ S "from" +:+ makeRef loadDF, 
  short lShareFac `followA` glassLite,
  ch hFromt +:+ S "from" +:+ makeRef hFromt,
  ch glaTyFac +:+ S "from" +:+ makeRef glaTyFac,
  ch standOffDis +:+ S "from" +:+ makeRef standOffDis,
  ch aspRat +:+ S "from" +:+ makeRef aspRat]

--FIXME:should constants, LDF, and LSF have some sort of field that holds
-- the assumption(s) that're being followed? (Issue #349)

checkInputWithDataConsDesc = foldlSent [S "The", phrase system, S "shall check the entered",
  plural inValue, S "to ensure that they do not exceed the",
  plural datumConstraint, S "mentioned in" +:+. makeRef datConLabel, 
  S "If any" `sOf` S "the", plural inParam, S "are out" `sOf` S "bounds" `sC`
  S "an", phrase errMsg, S "is displayed" `andThe` plural calculation, S "stop"]

outputValsAndKnownQuantsDesc = foldlSent [titleize output_, S "the", plural inQty,
  S "from", makeRef inputGlassProps `andThe` S "known", plural quantity,
  S "from", makeRef sysSetValsFollowingAssumps]

checkGlassSafetyDesc cmd = foldlSent_ [S "If", (ch is_safePb), S "∧", (ch is_safeLR),
  sParen (S "from" +:+ (makeRef pbIsSafe)
  `sAnd` (makeRef lrIsSafe)), S "are true" `sC`
  phrase cmd, S "the", phrase message, Quote (safeMessage ^. defn),
  S "If the", phrase condition, S "is false, then", phrase cmd,
  S "the", phrase message, Quote (notSafe ^. defn)]

outputQuants = llcc outputQuantsLabel $
  Enumeration $ Simple $ 
  [(S "Output-Quantities"
   , Nested (titleize output_ +:+ S "the following" +: plural quantity)
     $ Bullet $ noRefs $ chunksToItemTypes outputQuantsList
   , Just $ (getAdd (outputQuantsLabel ^. getRefAdd)))]

chunksToItemTypes :: [(Sentence, Symbol, Sentence)] -> [ItemType]
chunksToItemTypes = map (\(a, b, c) -> Flat $ a +:+ sParen (P b) +:+ c)

outputQuantsList :: [(Sentence, Symbol, Sentence)]
outputQuantsList = sortBy (compsy `on` get2) $ (mkReqList gbrIMods) ++ (mkReqList r6DDs)
  where
    r6DDs :: [DataDefinition]
    r6DDs = [risk, strDisFac, nonFL, glaTyFac, dimLL, tolPre, tolStrDisFac, hFromt, aspRat]
    get2 (_, b, _) = b

mkReqList :: (NamedIdea c, HasSymbol c, HasShortName c, HasUID c, Referable c) => [c] -> [(Sentence, Symbol, Sentence)]
mkReqList = map (\c -> (at_start c, symbol c Implementation, sParen (makeRef c)))

sysSetValsFollowingAssumpsLabel, outputQuantsLabel :: Label
sysSetValsFollowingAssumpsLabel = mkLabelSame "System-Set-Values-Following-Assumptions" (Req FR)
outputQuantsLabel               = mkLabelSame "Output-Quantities"                       (Req FR)