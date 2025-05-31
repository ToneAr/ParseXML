BeginPackage["ToneAr`ParseXML`Export`", {
	"ToneAr`ParseXML`PackageScope`",
	"ToneAr`ParseXML`",
	"GeneralUtilities`"
}];

Begin["`Private`"];

ExportXML // Clear;
ExportXML[doc_Association] := Module[{
		normalizationRules, elementParsingRules, groupParsingRules,
		nameInjectionRules, documentParsingRules, formattingRules
	},

	normalizationRules = {
		Association -> List
	};
	elementParsingRules = {
		Except[{},{OrderlessPatternSequence[
			Repeated["Properties" -> p_, {0,1}],
			Repeated["Children" -> c_, {0,1}],
			Repeated["URN" -> u_, {0,1}]
		]}] :> XMLElement[
			If[{u} =!= {},
				If[!MissingQ[u], {u, ""}, ""],
				""
			],
			Flatten[{p}],
			Flatten[{c}]
		]
	};
	groupParsingRules = {
		(name_ -> {elems__XMLElement}) :> Flatten[
			(name -> #) & /@ {elems}
		]
	};
	nameInjectionRules = Dispatch @ {
		Rule[name_String, XMLElement["", props_, child_]] :> (
			XMLElement[
				name,
				props,
				If[ListQ[child], Flatten[child], child]
			]
		),
		Rule[name_, XMLElement[{urn_, ""}, props_, child_]] :> (
			XMLElement[
				{urn, name},
				props,
				If[ListQ[child], Flatten[child], child]
			]
		)
	};
	documentParsingRules = {
		{"Document" -> {OrderlessPatternSequence[
			Repeated["Children" -> child_, {0,1}],
			Repeated["Properties" -> props_, {0,1}],
			Repeated["Metadata" -> meta_, {0,1}],
			Repeated["Options" -> {opts___}, {0,1}]
		]}} :> XMLObject["Document"][
			Map[
				If[MatchQ[#, _Rule],
					XMLObject[#[[1]]][Sequence @@ #[[2]]],
					#
				]&,
				Flatten[{props}]
			],
			If[Length[child] > 1, child, Identity @@ child],
			Flatten[{meta}],
			opts
		]
	};
	formattingRules = {
		{OrderlessPatternSequence[r___, Missing[]]} :> {r}
	};

	Fold[
		ReplaceRepeated,
		doc,
		{
			normalizationRules,
			documentParsingRules,
			elementParsingRules,
			groupParsingRules,
			nameInjectionRules
		}
	]
];


End[];
EndPackage[];
