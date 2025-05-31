# ParseXML Paclet

## Overview
The ParseXML paclet provides a robust two-way conversion system between XML documents and Wolfram Language associations. It allows users to easily parse XML into structured association data for manipulation and then convert that data back to XML. This paclet is designed to simplify XML data handling within the Wolfram Language environment.

## Features
- **XML Parsing**: Convert XML documents into nested Wolfram Language associations for easy manipulation.
- **XML Exporting**: Convert Wolfram Language associations back into XML documents.
- **Customizable Parsing Rules**: Define specific rules for parsing and exporting XML elements.
- **Support for Namespaces**: Handle XML namespaces.

## Installation
To install the ParseXML paclet, use the following command in your Wolfram Language session:

```wolfram
PacletInstall["ToneAr/ParseXML"]
```

## Usage
### Parsing XML
To parse an XML document into a Wolfram Language association:

```wolfram
parsedData = ParseXML[symbolicXML]
parsedData = ParseXML["xmlString"]
parsedData = ParseXML[File @ "path/to/your/file.xml"]
parsedData = ParseXML[URL @ "https://remote.xml"]
```

### Exporting XML
To convert a Wolfram Language association back into symbolic XML:

```wolfram
ExportXML[parsedData]
```

### Examples
```xml
<!-- Example.xml -->
<note>
	<to>Tove</to>
	<from>Jani</from>
	<heading>Reminder</heading>
	<body>Don't forget me this weekend!</body>
</note>
```

```wl
In[1]:= ParseXML[ File["Example.xml"] ]

Out[1]:= <|
	"Document" -> <|
		"Children" -> <|
			"note" -> <|
				"Children" -> <|
					"to" -> <|
						"Children" -> "Tove",
						"Properties" -> {},
						"URN" -> Missing[]
					|>,
					"from" -> <|
						"Children" -> "Jani",
						"Properties" -> {},
						"URN" -> Missing[]
					|>,
					"heading" -> <|
						"Children" -> "Reminder",
						"Properties" -> {},
						"URN" -> Missing[]
					|>,
					"body" -> <|
						"Children" -> "Don't forget me this weekend!",
						"Properties" -> {},
						"URN" -> Missing[]
					|>
				|>,
				"Properties" -> {},
				"URN" -> Missing[]
			|>
		|>,
		"Properties" -> {},
		"Metadata" -> {},
		"Options" -> {}
	|>
|>
```
```wl
In[2]:= ParseXML[ File["Example.xml"], "Children"]

Out[2]:= <|
	"Document" -> <|
		"note" -> <|
			"to" -> "Tove",
			"from" -> "Jani",
			"heading" -> "Reminder",
			"body" -> "Don't forget me this weekend!"
		|>
	|>
|>
```

## Documentation
Comprehensive documentation is available in the Wolfram Language Documentation Center. You can also access the documentation directly from the paclet:

1. Navigate to the `Documentation/English/` folder.
2. Open the `Guides` or `ReferencePages/Symbols` notebooks for detailed information.
