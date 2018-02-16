{-# Language Rank2Types #-}
module Drasil.DocumentLanguage.Chunk.InstanceModel 
  ( InstanceModel
  , inCons, outCons, outputs, inputs, im, imQD
  )where

import Language.Drasil

import Control.Lens (Simple, Lens, (^.), set)

import Prelude hiding (id)

type Inputs = [QuantityDict]
type Outputs = [QuantityDict]

type InputConstraints  = [TheoryConstraint]
type OutputConstraints = [TheoryConstraint]

-- | An Instance Model is a RelationConcept that may have specific input/output
-- constraints. It also has attributes (like Derivation, source, etc.)
data InstanceModel = IM { _rc :: RelationConcept
                        , inputs :: Inputs
                        , inCons :: InputConstraints
                        , outputs :: Outputs
                        , outCons :: OutputConstraints
                        , _attribs :: Attributes 
                        }
  
instance Chunk InstanceModel where
  id = rcl id
instance NamedIdea InstanceModel where
  term = rcl term
instance Idea InstanceModel where
  getA (IM a _ _ _ _ _) = getA a
instance Definition InstanceModel where
  defn = rcl defn
instance ConceptDomain InstanceModel where
  cdom = rcl cdom
instance Concept InstanceModel where
instance ExprRelat InstanceModel where
  relat = rcl relat
instance HasAttributes InstanceModel where
  attributes f (IM rc ins inc outs outc attribs) = fmap (\x -> IM rc ins inc outs outc x) (f attribs)

-- | Smart constructor for instance models
im :: RelationConcept -> Inputs -> InputConstraints -> Outputs -> 
  OutputConstraints -> Attributes -> InstanceModel
im = IM

-- | Smart constructor for instance model from qdefinition 
-- (Sentence is the "concept" definition for the relation concept)
imQD :: HasSymbolTable ctx => ctx -> QDefinition -> Sentence -> InputConstraints -> OutputConstraints -> Attributes -> InstanceModel
imQD ctx qd dfn incon ocon att = IM (makeRC (qd ^. id) (qd ^. term) dfn (C qd $= (equat qd))) (vars (equat qd) ctx) incon [qw qd] ocon att

-- DO NOT EXPORT BELOW THIS LINE --
  
rcl :: Simple Lens RelationConcept a -> Simple Lens InstanceModel a
rcl l f (IM rc ins inc outs outc attribs) = fmap (\x -> IM (set l x rc) ins inc outs outc attribs) (f (rc ^. l))
