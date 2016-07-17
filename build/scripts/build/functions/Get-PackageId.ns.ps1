Function Get-PackageId ($nuspecFile) {
    $node = Select-Xml -Path $nuspecFile -XPath "//*[local-name()='id']/text()"
    $node.Node.Value
}