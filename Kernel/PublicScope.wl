BeginPackage["ToneAr`ParseXML`", {
	"GeneralUtilities`"
}];

ParseXML::usage =
	"ParseXML[xml] converts an XML to a DocumentObject.\n"<>
	"ParseXML[xml, elements] converts XML to a DocumentObject containing only the specified component elements.";
ExportXML::usage = "ExportXML[xml] converts a DocumentObject to symbolic XML.";

EndPackage[];
