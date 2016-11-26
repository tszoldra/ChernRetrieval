(* Mathematica Package *)
(* Created by Mathematica Plugin for IntelliJ IDEA *)

(* :Title: space *)
(* :Context: space` *)
(* :Author: c8888 *)
(* :Date: 2016-11-20 *)

(* :Package Version: 0.1 *)
(* :Mathematica Version: *)
(* :Copyright: (c) 2016 c8888 *)
(* :Keywords: *)
(* :Discussion: *)

BeginPackage["space`"]
(* Exported symbols added here with SymbolName::usage *)

latticeProbingPoints::usage =
    "latticeProbingPoints[xmin, xmax, ymin, ymax, \[Delta]x, \[Delta]y] generates a list of points {{x_i, y_i}} at which one measures physical variables of BEC in a trap"

rectLatticeSites::usage =
    "rectLatticeSites[ax, ay, RTF, latticeProbingPoints, rangeNeighbour] generates two lists {l1,l2}:
    l1={{x_i,y_i},type_i} are the rectangular lattice sites, where type_i is the i-th lattice site type (-1 - type A or 1 - type B)
    l2={{x_i_j,y_i_j}} is the list of 1..j..k points from latticeProbingPoints which are in the distance of rangeNeighbour from i_th lattice node corresponding to l1
    "
rectLatticeBrillouinZonePoints::usage =
    "rectLatticeBrillouinZonePoints[q, ax, ay, \[Delta]x, \[Delta]y] generates a (flattened) 1D list of the points {x_i,y_i} in the first Brillouin zone for the rectangular lattice, with spacing \[Delta]x, \[Delta]y"

(*)honeycombLatticeSites[a, RTF, latticeProbingPoints]::usage =
    "rectLatticeSites[a RTF, latticeProbingPoints] generates two lists {l1,l2}:
    l1={{x_i,y_i},type_i} are the honeycomb lattice sites, where type_i is the i-th lattice site type (0 - type A or 1 - type B)
    l2={{x_i_j,y_i_j}} is the list of 1..j..k points from latticeProbingPoints which are in the distance of rangeNeighbour from i_th lattice node corresponding to l1
    "
honeycombLatticeBrillouinZonePoints[a, \[Delta]x, \[Delta]y]::usage =
    "honeycombLatticeBrillouinZonePoints[a, \[Delta]x, \[Delta]y] generates a (flattened) 1D list of the points {x_i,y_i} in the first Brillouin zone for the honeycomb lattice, with spacing \[Delta]x, \[Delta]y"

mirror2DSpace[latticeProbingPointsValue]::usage =
    "mirrorSpace[latticeProbingPointsValue] mirrors the 2Dtable with respect to x and y axes"
*)

Begin["`Private`"]



latticeProbingPoints[xmin_, xmax_, ymin_, ymax_, \[Delta]x_, \[Delta]y_]:=
    Flatten[Table[{x,y}, {x,xmin,xmax,\[Delta]x}, {y,ymin,ymax,\[Delta]y}],1]

rectLatticeSites[ax_, ay_, RTF_, latticeProbingPoints_, rangeNeighbour_]:=
    Module[ {
      sitesij = {},
      neighbourij = {},
      xmin = latticeProbingPoints[[1,1]],
      xmax = Last[latticeProbingPoints][[1]],
      ymin = latticeProbingPoints[[1,2]],
      ymax = Last[latticeProbingPoints][[2]]

    },

      For[i = -Floor[RTF/ax], i <= Floor[RTF/ax], i++,
        For[j = -Floor[RTF/ay], j <= Floor[RTF/ay], j++,
          If[
            Norm@N[{i*ax, j*ay}] <= RTF && i*ax >= xmin &&  i*ax <= xmax && j*ay >= ymin && j*ay <=ymax,
              AppendTo[sitesij, {{N[i*ax], N[j*ay]}, (-1)^(i+j)}]
          ]
          ]
      ];
      neighbourij = Table[{},Length[sitesij]];

      For[i = 1, i <= Length[sitesij], i++,
        Map[
          If[Norm[#-sitesij[[i, 1]] ] <= rangeNeighbour, AppendTo[neighbourij[[i]], #]]&,
          latticeProbingPoints
        ]
      ];

      Return[
        {
          N@sitesij,
          N@neighbourij
        }
      ]
      ]
End[] (* `Private` *)

EndPackage[]