module Language.Drasil.Expr.Precedence where

import Language.Drasil.Expr (BinOp(..),Oper(..),UFunc(..),Expr(..),EOperator(..))

-- These precedences are inspired from Haskell/F# 
-- as documented at http://kevincantu.org/code/operators.html
-- They are all multiplied by 10, to leave room to weave things in between

-- | prec2 - precendence for binary operators
prec2 :: BinOp -> Int
prec2 Frac = 190
prec2 Pow = 200
prec2 Subt = 180
prec2 Eq = 130
prec2 NEq  = 130
prec2 Lt  = 130
prec2 Gt  = 130
prec2 LEq  = 130
prec2 GEq  = 130
prec2 Impl = 130
prec2 Iff = 130
prec2 Index = 250
prec2 Dot = 190
prec2 Cross = 190

-- | prec - precedence for Binary-Associative (Commutative) operators
prec :: Oper -> Int
prec Mul = 190
prec Add = 180
prec And = 120
prec Or = 110


-- | prec1 - precedence of unary operators
prec1 :: UFunc -> Int
prec1 Neg = 230
prec1 Exp = 200
prec1 Not = 230
prec1 _ = 250

-- | eprec - "Expression" precedence
eprec :: Expr -> Int
eprec (Dbl _)           = 500
eprec (Int _)           = 500
eprec (Str _)           = 500
eprec (Assoc op _)      = prec op
eprec (C _)             = 500
eprec (Deriv _ _ _)     = prec2 Frac
eprec (FCall _ _)       = 210
eprec (Case _)          = 200
eprec (Matrix _)        = 220
eprec (UnaryOp fn _)    = prec1 fn
eprec (EOp (Summation _ _)) = prec Add
eprec (EOp (Product _ _))   = prec Mul
eprec (EOp (Integral _ _))  = prec Add
eprec (BinaryOp bo _ _) = prec2 bo
eprec (IsIn  _ _)       = 170
eprec (RealI _ _)       = 170
