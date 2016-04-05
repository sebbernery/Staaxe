#!/bin/sh

haxe doc.hxml
haxelib run dox -i doc.xml -o doc -in "staaxe"
