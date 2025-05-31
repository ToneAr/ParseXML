BeginPackage["ToneAr`ParseXML`Parse`", {
	"ToneAr`ParseXML`PackageScope`",
	"ToneAr`ParseXML`",
	"GeneralUtilities`"
}];

Begin["`Private`"];


(* -------------------------------------------------------------------------- *)
(* ::Section:: *)(* ParseXML *)
(* Description:  Parse XML to Association
 * Return:       _Association
 *)
ParseXML // Clear;
ParseXML[___] := $Failed;
ParseXML[
	xmlFile:(_File | _URL),
	props___
] := Enclose[
	ParseXML[
		Confirm[
			Import[xmlFile, "XML"],
			"Failed to import XML file as XMLObject."
		],
		props
	]
];
ParseXML[
	xmlStr_String,
	props___
] := Enclose[
	ParseXML[
		Confirm[
			ImportString[xmlStr, "XML"],
			"Failed to import XML string as XMLObject."
		],
		props
	]
];
ParseXML[
	xmlObj: (XMLObject[_String][___] | XMLElement[___]),
	elems: {__String} | _String | All : All
] := Module[{
		parsingRules, formatRules, elements,documentParsingRules
	},
	Enclose[
		elements = Confirm[
			Replace[
				elems,
				{
					All -> {
						"Children", "Properties", "URN",
						"Metadata", "Options"
					},
					Except[{__String} | _String] -> $Failed
				}
			],
			"Elements specification must be a string, list of strings or All."
		];

		parsingRules = Dispatch @ {
			XMLObject[string:Except["Document",_String]][props___] :> (
				string -> {props}
			),
			XMLElement[
				name: (_String | _List),
				{props___},
				{children___}
			] :> (
				If[ListQ[name],
					Last @ name,
					name
				] -> With[{
						chld = Replace[{children}, Missing[] -> Nothing],
						prps = Replace[{props}, Missing[] -> Nothing],
						(* URN is the first element of the name list *)
						urn = If[ListQ[name],
							First @ name,
							Missing[]
						]
					},
					Switch[elements,
					"Children",
						chld,
					"Properties",
						prps,
					"URN",
						urn,
					{__String},
						{} // If[MemberQ[elements, "Children"],
							Append["Children" -> chld], Identity
						] // If[MemberQ[elements, "Properties"],
							Append["Properties" -> prps], Identity
						] // If[MemberQ[elements, "URN"],
							Append["URN" -> urn], Identity
						]
					]
				]
			)
		};
		documentParsingRules =  {
			XMLObject["Document"][props_, children_, meta_, opts: OptionsPattern[]] :> {
				"Document" -> Switch[elements,
					"Children", {children},
					"Properties", {props},
					"Metadata", {meta},
					{__String},
						{} // If[MemberQ[elements, "Children"],
							Append["Children" -> {children}], Identity
						] // If[MemberQ[elements, "Properties"],
							Append["Properties" -> {props}], Identity
						] // If[MemberQ[elements, "Metadata"],
							Append["Metadata" -> {meta}], Identity
						] // If[MemberQ[elements, "Options"],
							Append["Options" -> {opts}], Identity
						]
				]
			}
		};
		formatRules = Dispatch @ {
			{{a___}} :> {a},
			{a_String} :> a,
			(* Group duplicate attributes *)
			({pre___, a_ -> x_, b_ -> y_, post___} /; a === b) :>
				{pre, a -> Flatten[ToAssociations @ {x, y}], post}
		};

		ToAssociations @ Fold[
			ReplaceRepeated,
			xmlObj,
			{
				parsingRules,
				documentParsingRules,
				formatRules
			}
		]
	]
];


End[];
EndPackage[];
