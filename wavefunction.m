(* Mathematica Package *)
(* Created by Mathematica Plugin for IntelliJ IDEA *)

(* :Title: wavefunction *)
(* :Context: wavefunction` *)
(* :Author: c8888 *)
(* :Date: 2016-11-20 *)

(* :Package Version: 0.1 *)
(* :Mathematica Version: *)
(* :Copyright: (c) 2016 c8888 *)
(* :Keywords: *)
(* :Discussion: *)

BeginPackage["wavefunction`"]
(* Exported symbols added here with SymbolName::usage *)
waveFunctionHarperK::usage =
    "waveFunctionHarperK[{kx,ky}, \[Phi]k, \[Theta]k, n] returns a value of Harper wave function of n-th energy band in momentum space at {kx,ky} in the
    Harper Pi-flux model (q=2)."
waveFunctionHarper::usage =
    "waveFunctionHarper[{x, y}, rectLatticeSites, RTF, \[Sigma]w, \[Phi]k, \[Theta]k] returns a value of wave function in real space at {x,y} in the
    Harper Pi-flux model (q=2) for initial state \[Phi]k, \[Theta]k. Uses knowledge of neighbor positions to spped up calculations."
hamiltonianHarperK::usage =
    "hamiltonianHarperK[{kx, ky}, J, J1] returns hamiltonian matrix in momentum space at {x,y} in the
    Harper Pi-flux model (q=2). J and J1 are the tunneling factors."
wannier::usage =
    "wannier[{x,y}, {xi, yi}, \[Sigma]w, \[Beta]] returns value of wannier function localized at {xj, yj}. \[Sigma]w is the Gauss peak width and \[Beta] is the normalisation factor."
wannierNormalisationFactor::usage =
    "wannierNormalisationFactor[\[Sigma]w_, \[Delta]x_, \[Delta]y_, latticeProbingPoints_] returns a normalisation factor for Wannier function localized at {0,0}"
blochSphereAnglesHarper[{kx,ky}]::usage =
    "blochSphereAnglesHarper[{kx,ky}] calculates the angles {\[Theta]k, \[Phi]k} in Bloch sphere representation from a Harper Hamiltonian"

Begin["`Private`"]

wannierNormalisationFactor[\[Sigma]w_, \[Delta]x_, \[Delta]y_, latticeProbingPoints_] := 1/Sqrt[
        Total[
          Chop@Map[wannier[#, {0, 0}, \[Sigma]w, 1] &, latticeProbingPoints]^2
        ] * \[Delta]x * \[Delta]y
    ]

wannier[r_,ri_,\[Sigma]w_, wannierNormalisationFactor_]:= wannierNormalisationFactor*Exp[-Norm[N[r]-N[ri]]^2/2/\[Sigma]w^2]

hamiltonianHarperK[k_, J_, J1_] := Module[
      {
        h = {-J - J1 Cos[2 k[[1]]], J1 Sin[2 k[[1]]], -2 J Cos[k[[2]]] }
      },
      h[[1]]*PauliMatrix[1] + h[[2]]*PauliMatrix[2] + h[[3]]*PauliMatrix[3]
    ] (*no h0*Id factor, which means that we assume on-site energies equal to zero *)

myES[hamiltonian_] :=
    Transpose@
        Sort[Transpose[Eigensystem[hamiltonian]], #1[[1]] < #2[[1]] &];

blochSphereAnglesHarper[k_, J_, J1_] := Module[{
  h = {-J - J1 Cos[2 k[[1]] ], J1 Sin[2 k[[1]] ], -2 J Cos[ k[[2]] ] }
},
  {
    ArcTan[ h[[2]] / h[[1]] ],
    ArcSin[ h[[3]] / Norm[h] ]
  }
]

waveFunctionHarperK[k_, \[Phi]k, \[Theta]k, n] :=



End[] (* `Private` *)

EndPackage[]