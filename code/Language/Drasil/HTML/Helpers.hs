{-# OPTIONS -Wall #-} 
module Language.Drasil.HTML.Helpers where

import Text.PrettyPrint
import Data.List (intersperse)

import Language.Drasil.Document (Document)
import Language.Drasil.HTML.AST (Expr)

html, head_tag, body, title, paragraph, code, tr, th, td :: Doc -> Doc
html      = wrap "html" []
head_tag  = wrap "head" []
body      = wrap "body" []
title     = wrap "title" []
paragraph = wrap "p" ["paragraph"]
code      = wrap "code" ["code"]
tr        = wrap "tr" []
th        = wrap "th" []
td        = wrap "td" []

h :: Int -> Doc -> Doc
h n       | n < 0 = error "Illegal header (too small)"
          | n > 7 = error "Illegal header (too large)"
          | otherwise = wrap ("h"++show n) []

wrap :: String -> [String] -> Doc -> Doc
wrap s [] = \x -> 
  let tb c = text $ "<" ++ c ++ ">"
  in vcat [tb s, x, tb $ "/"++s]
wrap s ts = \x ->
  let tb c = text $ "<" ++c++ " class=\""++(foldr1 (++) (intersperse " " ts))++"\">"
  in let te c = text $ "</" ++ c ++ ">"
  in vcat [tb s, x, te s]
  
caption :: String -> Doc
caption t = wrap "p" ["caption"] (text t)

refwrap :: String -> Doc -> Doc
refwrap r = \x -> vcat [text ("<a id=\"" ++ r ++ "\">"), x, text "</a>"]

reflink :: String -> String -> String
reflink ref txt = "<a href=#" ++ ref ++ ">" ++ txt ++ "</a>"

image :: String -> String -> Doc
image f c = 
  text $ "<img class=\"figure\" src=\"" ++ f ++ "\" alt=\"" ++ c ++ "\"></img>"

sub,sup :: String -> String  
sub = \x -> "<sub>" ++ x ++ "</sub>"
sup = \x -> "<sup>" ++ x ++ "</sup>"

article_title, author :: Doc -> Doc
article_title t = div_tag ["title"]  (h 1 t)
author a        = div_tag ["author"] (h 2 a)

div_tag :: [String] -> Doc -> Doc
div_tag = wrap "div"
  
span_tag :: [String] -> String -> Doc
span_tag = \t -> wrap "span" t . text

makeCSS :: Document -> Doc  
makeCSS _ = vcat [
-- TODO: Autogenerate necessary css selectors only, make CSS configurable
  text "body {min-width: 400px; max-width: 1400px;}",
  text ".title {text-align:center;}",
  text ".author {text-align:center;}",
  text ".paragraph {text-align:justify;}",
  vcat [
    text ".cases {",
    text "  display: inline-block;",
    text "  vertical-align:middle;}"],
  vcat [
    text ".case {",
    text "float: right;",
    text "padding-left: 1em;}"],
  vcat [
    text ".cases > span {",
    text "  display: block;",
    text "  padding-top: 0.15em;",
    text "  padding-left: 1.5em;}"],
  vcat [
    text ".casebr {",
    text "  display: inline-block;",
    text "  vertical-align: middle;",
    text "  margin: 0 0.2em 0.4ex;",
    text "  text-align: center;",
    text "  font-size:500%;}"],
  vcat [
    text ".caption {",
    text "text-align:center;",
    text "font-weight:bold;",
    text "padding-bottom:1%;",
    text "line-height:0;}"
    ],
  vcat [
    text ".fraction {",
    text "  display: inline-block;",
    text "  vertical-align: middle;",
    text "  margin: 0 0.2em 0.4ex;",
    text "  text-align: center;}"
    ],
  vcat [
    text ".fraction > span {",
    text "  display: block;",
    text "  padding-top: 0.15em;}"
    ],
  text ".fdn {border-top: thin solid black;}",
  text ".table {text-align:left;padding-left:1%;width:90%;margin-bottom:2%;margin-top:2%}",
  text ("table, th, td {border: 1px solid black; border-collapse: collapse;" ++ 
    "margin-left:auto;margin-right:auto;}"),
  text "th, td {padding:1%;}",
  text ".tdefn {width:75%;margin-top:1%;margin-bottom:1%;}",
  text ".tdefn th {width:15%; padding:1%;}",
  text ".ddefn, {width:75%;margin-top:1%;margin-bottom:1%;}",
  text ".section {width:80%; margin:0 auto;text-align:center;}",
  vcat [
    text ".code {",
    text "  display:inline-block;",
    text "  text-align:left;",
    text ("  font-family: Monaco, Consolas, \"Andale Mono\"," ++
      "\"DejaVu Sans Mono\", monospace;"),
    text "  font-size: 95%;",
    text "  line-height: 140%;",
    text "  white-space: pre;",
    text "  white-space: pre-wrap;",
    text "  white-space: -moz-pre-wrap;",
    text "  white-space: -o-pre-wrap;",
    text "  background: #faf8f0;",
    text "}"
    ],
  text ".list {text-align:left;}"
  ]

linkCSS :: String -> Doc  
linkCSS fn = 
  text $ "<link rel=\"stylesheet\" type=\"text/css\" href=\""++fn++".css\">"

fraction :: String -> String -> String  
fraction a b =
  render $ div_tag ["fraction"] (span_tag ["fup"] a $$ span_tag ["fdn"] b)

cases :: [(Expr,Expr)] -> (Expr -> String) -> String
cases ps p_expr = render $ (span_tag ["casebr"] "{" $$ div_tag ["cases"] 
                  (makeCases ps p_expr) $$
                  span_tag ["casebr"] "}")

makeCases :: [(Expr,Expr)] -> (Expr -> String) -> Doc                 
makeCases [] _ = empty
makeCases (p:ps) p_expr = ((span_tag [] (p_expr (fst p) ++ " , " ++
                            (render $ span_tag ["case"] (p_expr (snd p))))) $$
                            makeCases ps p_expr)
