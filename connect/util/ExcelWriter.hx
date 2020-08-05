/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/
package connect.util;

@:dox(hide)
typedef ExcelRow = Array<String>;

@:dox(hide)
typedef ExcelSheet = Array<ExcelRow>;

@:dox(hide)
class ExcelWriter {
    private static final APP = '<Properties xmlns="http://schemas.openxmlformats.org/officeDocument/2006/extended-properties"><Application>Microsoft Excel</Application><AppVersion>2.5</AppVersion></Properties>';
    private static final CORE = '<cp:coreProperties xmlns:cp="http://schemas.openxmlformats.org/package/2006/metadata/core-properties" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:dcterms="http://purl.org/dc/terms/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><dc:creator>connect</dc:creator><dcterms:created xsi:type="dcterms:W3CDTF">%DATE%</dcterms:created><dcterms:modified xsi:type="dcterms:W3CDTF">%DATE%</dcterms:modified></cp:coreProperties>';
    private static final RELS1 = '<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships"><Relationship Id="rId1" Target="xl/workbook.xml" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument" /><Relationship Id="rId2" Target="docProps/core.xml" Type="http://schemas.openxmlformats.org/package/2006/relationships/metadata/core-properties" /><Relationship Id="rId3" Target="docProps/app.xml" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/extended-properties" /></Relationships>';
    private static final THEME = '<?xml version="1.0"?><a:theme xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main" name="Office Theme"><a:themeElements><a:clrScheme name="Office"><a:dk1><a:sysClr val="windowText" lastClr="000000"/></a:dk1><a:lt1><a:sysClr val="window" lastClr="FFFFFF"/></a:lt1><a:dk2><a:srgbClr val="1F497D"/></a:dk2><a:lt2><a:srgbClr val="EEECE1"/></a:lt2><a:accent1><a:srgbClr val="4F81BD"/></a:accent1><a:accent2><a:srgbClr val="C0504D"/></a:accent2><a:accent3><a:srgbClr val="9BBB59"/></a:accent3><a:accent4><a:srgbClr val="8064A2"/></a:accent4><a:accent5><a:srgbClr val="4BACC6"/></a:accent5><a:accent6><a:srgbClr val="F79646"/></a:accent6><a:hlink><a:srgbClr val="0000FF"/></a:hlink><a:folHlink><a:srgbClr val="800080"/></a:folHlink></a:clrScheme><a:fontScheme name="Office"><a:majorFont><a:latin typeface="Cambria"/><a:ea typeface=""/><a:cs typeface=""/><a:font script="Jpan" typeface="&#xFF2D;&#xFF33; &#xFF30;&#x30B4;&#x30B7;&#x30C3;&#x30AF;"/><a:font script="Hang" typeface="&#xB9D1;&#xC740; &#xACE0;&#xB515;"/><a:font script="Hans" typeface="&#x5B8B;&#x4F53;"/><a:font script="Hant" typeface="&#x65B0;&#x7D30;&#x660E;&#x9AD4;"/><a:font script="Arab" typeface="Times New Roman"/><a:font script="Hebr" typeface="Times New Roman"/><a:font script="Thai" typeface="Tahoma"/><a:font script="Ethi" typeface="Nyala"/><a:font script="Beng" typeface="Vrinda"/><a:font script="Gujr" typeface="Shruti"/><a:font script="Khmr" typeface="MoolBoran"/><a:font script="Knda" typeface="Tunga"/><a:font script="Guru" typeface="Raavi"/><a:font script="Cans" typeface="Euphemia"/><a:font script="Cher" typeface="Plantagenet Cherokee"/><a:font script="Yiii" typeface="Microsoft Yi Baiti"/><a:font script="Tibt" typeface="Microsoft Himalaya"/><a:font script="Thaa" typeface="MV Boli"/><a:font script="Deva" typeface="Mangal"/><a:font script="Telu" typeface="Gautami"/><a:font script="Taml" typeface="Latha"/><a:font script="Syrc" typeface="Estrangelo Edessa"/><a:font script="Orya" typeface="Kalinga"/><a:font script="Mlym" typeface="Kartika"/><a:font script="Laoo" typeface="DokChampa"/><a:font script="Sinh" typeface="Iskoola Pota"/><a:font script="Mong" typeface="Mongolian Baiti"/><a:font script="Viet" typeface="Times New Roman"/><a:font script="Uigh" typeface="Microsoft Uighur"/></a:majorFont><a:minorFont><a:latin typeface="Calibri"/><a:ea typeface=""/><a:cs typeface=""/><a:font script="Jpan" typeface="&#xFF2D;&#xFF33; &#xFF30;&#x30B4;&#x30B7;&#x30C3;&#x30AF;"/><a:font script="Hang" typeface="&#xB9D1;&#xC740; &#xACE0;&#xB515;"/><a:font script="Hans" typeface="&#x5B8B;&#x4F53;"/><a:font script="Hant" typeface="&#x65B0;&#x7D30;&#x660E;&#x9AD4;"/><a:font script="Arab" typeface="Arial"/><a:font script="Hebr" typeface="Arial"/><a:font script="Thai" typeface="Tahoma"/><a:font script="Ethi" typeface="Nyala"/><a:font script="Beng" typeface="Vrinda"/><a:font script="Gujr" typeface="Shruti"/><a:font script="Khmr" typeface="DaunPenh"/><a:font script="Knda" typeface="Tunga"/><a:font script="Guru" typeface="Raavi"/><a:font script="Cans" typeface="Euphemia"/><a:font script="Cher" typeface="Plantagenet Cherokee"/><a:font script="Yiii" typeface="Microsoft Yi Baiti"/><a:font script="Tibt" typeface="Microsoft Himalaya"/><a:font script="Thaa" typeface="MV Boli"/><a:font script="Deva" typeface="Mangal"/><a:font script="Telu" typeface="Gautami"/><a:font script="Taml" typeface="Latha"/><a:font script="Syrc" typeface="Estrangelo Edessa"/><a:font script="Orya" typeface="Kalinga"/><a:font script="Mlym" typeface="Kartika"/><a:font script="Laoo" typeface="DokChampa"/><a:font script="Sinh" typeface="Iskoola Pota"/><a:font script="Mong" typeface="Mongolian Baiti"/><a:font script="Viet" typeface="Arial"/><a:font script="Uigh" typeface="Microsoft Uighur"/></a:minorFont></a:fontScheme><a:fmtScheme name="Office"><a:fillStyleLst><a:solidFill><a:schemeClr val="phClr"/></a:solidFill><a:gradFill rotWithShape="1"><a:gsLst><a:gs pos="0"><a:schemeClr val="phClr"><a:tint val="50000"/><a:satMod val="300000"/></a:schemeClr></a:gs><a:gs pos="35000"><a:schemeClr val="phClr"><a:tint val="37000"/><a:satMod val="300000"/></a:schemeClr></a:gs><a:gs pos="100000"><a:schemeClr val="phClr"><a:tint val="15000"/><a:satMod val="350000"/></a:schemeClr></a:gs></a:gsLst><a:lin ang="16200000" scaled="1"/></a:gradFill><a:gradFill rotWithShape="1"><a:gsLst><a:gs pos="0"><a:schemeClr val="phClr"><a:shade val="51000"/><a:satMod val="130000"/></a:schemeClr></a:gs><a:gs pos="80000"><a:schemeClr val="phClr"><a:shade val="93000"/><a:satMod val="130000"/></a:schemeClr></a:gs><a:gs pos="100000"><a:schemeClr val="phClr"><a:shade val="94000"/><a:satMod val="135000"/></a:schemeClr></a:gs></a:gsLst><a:lin ang="16200000" scaled="0"/></a:gradFill></a:fillStyleLst><a:lnStyleLst><a:ln w="9525" cap="flat" cmpd="sng" algn="ctr"><a:solidFill><a:schemeClr val="phClr"><a:shade val="95000"/><a:satMod val="105000"/></a:schemeClr></a:solidFill><a:prstDash val="solid"/></a:ln><a:ln w="25400" cap="flat" cmpd="sng" algn="ctr"><a:solidFill><a:schemeClr val="phClr"/></a:solidFill><a:prstDash val="solid"/></a:ln><a:ln w="38100" cap="flat" cmpd="sng" algn="ctr"><a:solidFill><a:schemeClr val="phClr"/></a:solidFill><a:prstDash val="solid"/></a:ln></a:lnStyleLst><a:effectStyleLst><a:effectStyle><a:effectLst><a:outerShdw blurRad="40000" dist="20000" dir="5400000" rotWithShape="0"><a:srgbClr val="000000"><a:alpha val="38000"/></a:srgbClr></a:outerShdw></a:effectLst></a:effectStyle><a:effectStyle><a:effectLst><a:outerShdw blurRad="40000" dist="23000" dir="5400000" rotWithShape="0"><a:srgbClr val="000000"><a:alpha val="35000"/></a:srgbClr></a:outerShdw></a:effectLst></a:effectStyle><a:effectStyle><a:effectLst><a:outerShdw blurRad="40000" dist="23000" dir="5400000" rotWithShape="0"><a:srgbClr val="000000"><a:alpha val="35000"/></a:srgbClr></a:outerShdw></a:effectLst><a:scene3d><a:camera prst="orthographicFront"><a:rot lat="0" lon="0" rev="0"/></a:camera><a:lightRig rig="threePt" dir="t"><a:rot lat="0" lon="0" rev="1200000"/></a:lightRig></a:scene3d><a:sp3d><a:bevelT w="63500" h="25400"/></a:sp3d></a:effectStyle></a:effectStyleLst><a:bgFillStyleLst><a:solidFill><a:schemeClr val="phClr"/></a:solidFill><a:gradFill rotWithShape="1"><a:gsLst><a:gs pos="0"><a:schemeClr val="phClr"><a:tint val="40000"/><a:satMod val="350000"/></a:schemeClr></a:gs><a:gs pos="40000"><a:schemeClr val="phClr"><a:tint val="45000"/><a:shade val="99000"/><a:satMod val="350000"/></a:schemeClr></a:gs><a:gs pos="100000"><a:schemeClr val="phClr"><a:shade val="20000"/><a:satMod val="255000"/></a:schemeClr></a:gs></a:gsLst><a:path path="circle"><a:fillToRect l="50000" t="-80000" r="50000" b="180000"/></a:path></a:gradFill><a:gradFill rotWithShape="1"><a:gsLst><a:gs pos="0"><a:schemeClr val="phClr"><a:tint val="80000"/><a:satMod val="300000"/></a:schemeClr></a:gs><a:gs pos="100000"><a:schemeClr val="phClr"><a:shade val="30000"/><a:satMod val="200000"/></a:schemeClr></a:gs></a:gsLst><a:path path="circle"><a:fillToRect l="50000" t="50000" r="50000" b="50000"/></a:path></a:gradFill></a:bgFillStyleLst></a:fmtScheme></a:themeElements><a:objectDefaults/><a:extraClrSchemeLst/></a:theme>';
    private static final STYLES = '<styleSheet xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main"><numFmts count="0" /><fonts count="1"><font><name val="Calibri" /><family val="2" /><color theme="1" /><sz val="11" /><scheme val="minor" /></font></fonts><fills count="2"><fill><patternFill /></fill><fill><patternFill patternType="gray125" /></fill></fills><borders count="1"><border><left /><right /><top /><bottom /><diagonal /></border></borders><cellStyleXfs count="1"><xf borderId="0" fillId="0" fontId="0" numFmtId="0" /></cellStyleXfs><cellXfs count="1"><xf borderId="0" fillId="0" fontId="0" numFmtId="0" pivotButton="0" quotePrefix="0" xfId="0" /></cellXfs><cellStyles count="1"><cellStyle builtinId="0" hidden="0" name="Normal" xfId="0" /></cellStyles><tableStyles count="0" defaultPivotStyle="PivotStyleLight16" defaultTableStyle="TableStyleMedium9" /></styleSheet>';

    private final sheets: Map<String, ExcelSheet>;

    public function new() {
        this.sheets = new Map<String, ExcelSheet>();
    }

    public function addSheet(name: String, sheet: ExcelSheet): ExcelWriter {
        if (!this.sheetExists(name)) {
            this.sheets.set(name, sheet);
        }
        return this;
    }

    public function sheetExists(name: String): Bool {
        return this.sheets.exists(name);
    }

    public function compress(): haxe.io.Bytes {
        final strings = getStrings();
        final sheetNames = getSheetNames();
        final entries = new List<haxe.zip.Entry>();
        entries.add(zipEntry('_rels/.rels', RELS1));
        entries.add(zipEntry('docProps/app.xml', APP));
        entries.add(zipEntry('docProps/core.xml', StringTools.replace(CORE, '%DATE%',
            DateTime.now().toString())));
        entries.add(zipEntry('xl/theme/theme1.xml', THEME));
        entries.add(zipEntry('xl/sharedStrings.xml', parseSheetsStrings()));
        entries.add(zipEntry('xl/styles.xml', STYLES));
        entries.add(zipEntry('xl/workbook.xml', getWorkbook()));
        for (i in 0...sheetNames.length) {
            entries.add(zipEntry('xl/worksheets/sheet${i+1}.xml', parseSheet(sheets[sheetNames[i]], strings)));
        }
        entries.add(zipEntry('xl/_rels/workbook.xml.rels', getRels2()));
        entries.add(zipEntry('[Content_Types].xml', getContentTypes()));

        final output = new haxe.io.BytesOutput();
        new haxe.zip.Writer(output).write(entries);
        return output.getBytes();
    }

    private function getStrings(): Array<String> {
        final stringsIncludingDuplicates = [
            for (sheet in this.sheets)
                for (row in sheet)
                    for (col in row)
                        if (col.split(':')[0] == 's')
                            col.split(':').slice(1).join(':')
        ];
        final fixedStrings: Array<String> = [];
        Lambda.iter(stringsIncludingDuplicates, (s) -> if (fixedStrings.indexOf(s) == -1) fixedStrings.push(s));
        return fixedStrings;
    }


    private function getSheetNames(): Array<String> {
        final names = [for (k in this.sheets.keys()) k];
        haxe.ds.ArraySort.sort(names, (a, b) -> Util.boolToInt(a > b) - Util.boolToInt(b > a));
        return names;
    }

    private static function zipEntry(name: String, content: String): haxe.zip.Entry {
        final bytes = haxe.io.Bytes.ofString(content);
        final entry = {
            compressed: false,
            crc32: haxe.crypto.Crc32.make(bytes),
            data: bytes,
            dataSize: 0,
            fileName: name,
            fileSize: bytes.length,
            fileTime: Date.now()
        };
    #if cs
        final contentBytes = cs.system.text.Encoding.UTF8.GetBytes(content);
        final outputStream = new cs.system.io.MemoryStream();
        final compressionStream = new connect.native.CsDeflateStream(outputStream,
            connect.native.CsCompressionMode.Compress);
        compressionStream.Write(contentBytes, 0, contentBytes.Length);
        compressionStream.Dispose();
        outputStream.Dispose();

        final compressed = haxe.io.Bytes.ofData(outputStream.GetBuffer());
        entry.compressed = true;
        entry.data = compressed;
        entry.dataSize = entry.data.length;
    #elseif python
        final compressed = connect.native.PythonZlib.compress(bytes, 9);
        entry.compressed = true;
        entry.data = compressed.sub(2, compressed.length - 6);
        entry.dataSize = entry.data.length;
    #else
        haxe.zip.Tools.compress(entry, 9);
    #end
        return entry;
    }

    private static function parseSheet(sheet: ExcelSheet, strings: Array<String>): String {
        final firstRowNames = getRowNames(sheet[0], 1);
        final lastRowNames = getRowNames(sheet[sheet.length - 1], sheet.length);
        final buf = new StringBuf();
        buf.add('<worksheet xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main">');
        buf.add('<sheetPr><outlinePr summaryBelow="1" summaryRight="1" /><pageSetUpPr /></sheetPr>');
        buf.add('<dimension ref="${firstRowNames[0]}:${lastRowNames[lastRowNames.length-1]}" />');
        buf.add('<sheetViews><sheetView workbookViewId="0"><selection activeCell="A1" sqref="A1" /></sheetView></sheetViews>');
        buf.add('<sheetFormatPr baseColWidth="8" defaultRowHeight="15" />');
        buf.add('<sheetData>');
        for (r in 0...sheet.length) {
            final rowNames = getRowNames(sheet[r], r+1);
            buf.add('<row r="${r+1}" spans="1:${sheet[r].length}">');
            for (c in 0...rowNames.length) {
                final elem = sheet[r][c];
                if (elem != null) {
                    final split = elem.split(':');
                    final type = split[0];
                    final value = split.slice(1).join(':');
                    final fixedValue = Std.string(type == 's' ? strings.indexOf(value) : value);
                    buf.add('<c r="${rowNames[c]}" t="$type">');
                    buf.add('<v>$fixedValue</v>');
                    buf.add('</c>');
                }
            }
            buf.add('</row>');
        }
        buf.add('</sheetData>');
        buf.add('<pageMargins bottom="1" footer="0.5" header="0.5" left="0.75" right="0.75" top="1" />');
        buf.add('</worksheet>');
        return buf.toString();
    }

    private static function getRowNames(row: ExcelRow, rowNumber: Int): Array<String> {
        return [for(c in 0...row.length) '${String.fromCharCode('A'.code + c)}$rowNumber'];
    }

    private function parseSheetsStrings(): String {
        final strings = getStrings();
        final buf = new StringBuf();
        buf.add('<sst uniqueCount="${strings.length}" xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main">');
        for (string in strings) {
            buf.add('<si><t>$string</t></si>');
        }
        buf.add('</sst>');
        return buf.toString();
    }

    private function getWorkbook(): String {
        final sheet = '<sheet name="%NAME%" sheetId="%ID%" state="visible" r:id="rId%ID%" />';
        final sheetNames = getSheetNames();
        final buffer = new StringBuf();
        buffer.add('<workbook xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main">');
        buffer.add('<workbookPr />');
        buffer.add('<workbookProtection />');
        buffer.add('<bookViews><workbookView activeTab="0" autoFilterDateGrouping="1" firstSheet="0" minimized="0" showHorizontalScroll="1" showSheetTabs="1" showVerticalScroll="1" tabRatio="600" visibility="visible" /></bookViews>');
        buffer.add('<sheets>');
        for (i in 0...sheetNames.length) {
            final replacedId = StringTools.replace(sheet, '%ID%', Std.string(i + 1));
            final replacedName = StringTools.replace(replacedId, '%NAME%', sheetNames[i]);
            buffer.add(replacedName);
        }
        buffer.add('</sheets>');
        buffer.add('<definedNames />');
        buffer.add('<calcPr calcId="124519" fullCalcOnLoad="1" />');
        buffer.add('</workbook>');
        return buffer.toString();
    }

    private function getRels2(): String {
        final sheetRel = '<Relationship Id="rId%ID%" Target="/xl/worksheets/sheet%ID%.xml" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/worksheet" />';
        final stringsRel = '<Relationship Id="rId%ID%" Target="sharedStrings.xml" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/sharedStrings" />';
        final stylesRel = '<Relationship Id="rId%ID%" Target="styles.xml" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/styles" />';
        final themeRel = '<Relationship Id="rId%ID%" Target="theme/theme1.xml" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/theme" />';
        final numSheets = Lambda.fold(this.sheets, (_, n) -> n+1, 0);
        final buffer = new StringBuf();
        buffer.add('<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">');
        for (i in 0...numSheets) {
            buffer.add(StringTools.replace(sheetRel, '%ID%', Std.string(i + 1)));
        }
        buffer.add(StringTools.replace(stringsRel, '%ID%', Std.string(numSheets + 1)));
        buffer.add(StringTools.replace(stylesRel, '%ID%', Std.string(numSheets + 2)));
        buffer.add(StringTools.replace(themeRel, '%ID%', Std.string(numSheets + 3)));
        buffer.add('</Relationships>');
        return buffer.toString();
    }

    private function getContentTypes(): String {
        final sheet = '<Override ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.worksheet+xml" PartName="/xl/worksheets/sheet%ID%.xml" />';
        final numSheets = Lambda.fold(this.sheets, (_, n) -> n+1, 0);
        final buffer = new StringBuf();
        buffer.add('<Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types">');
        buffer.add('<Default ContentType="application/vnd.openxmlformats-package.relationships+xml" Extension="rels" />');
        buffer.add('<Default ContentType="application/xml" Extension="xml" />');
        buffer.add('<Override ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.sharedStrings+xml" PartName="/xl/sharedStrings.xml" />');
        buffer.add('<Override ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.styles+xml" PartName="/xl/styles.xml" />');
        buffer.add('<Override ContentType="application/vnd.openxmlformats-officedocument.theme+xml" PartName="/xl/theme/theme1.xml" />');
        buffer.add('<Override ContentType="application/vnd.openxmlformats-package.core-properties+xml" PartName="/docProps/core.xml" />');
        buffer.add('<Override ContentType="application/vnd.openxmlformats-officedocument.extended-properties+xml" PartName="/docProps/app.xml" />');
        for (i in 0...numSheets) {
            buffer.add(StringTools.replace(sheet, '%ID%', Std.string(i + 1)));
        }
        buffer.add('<Override ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet.main+xml" PartName="/xl/workbook.xml" />');
        buffer.add('</Types>');
        return buffer.toString();
    }
}
