# XL Plugin Template

## Overview

This is a template that contains the directory structure, common files, and sample formats for XebiaLabs community plugins.

## Usage

Run the xl-configure-plugin-directory.sh script from whatever directory you want as the parent of your plugin directory.  This is typically your local github/xebialabs, github/xebialabs-community, or github/xebialabs-external directory.

The command format is `<path>/configure-plugin-directory.sh LCPLUGINNAME SCRIPTDIRNAME WEBSCRIPTDIRNAME`  
where  
`LCPLUGINNAME` is your plugin name.  It should be hyphenated lowercase, e.g., xl-my-demo-plugin.  
`SCRIPTDIRNAME` is the resource namespace directory.  It should be camelcase, e.g., MyDemo.  
`WEBSCRIPTDIRNAME` is the web namespace directory for custom UI panels or XL Release tiles.  It should be hyphenated lowercase, e.g., my-demo.

The result is

* a new directory with your plugin name
* a README.md file formatted with badge links and major headings of Preface, Overview, Requirements, Installation, and Usage/Features/Tasks/Types.
* Gradle scripts and supporting files
* a directory structure that Gradle can use to build a typical XL plugin
* examples of the MIT License format for various file type (.ftl, .html, .java, .js, .py, .sh, .xml, etc.)

The WikiPageBody.txt file can be pasted into the New Page Text field of the [xlr-confluence plugin](https://github.com/xebialabs-community/xlr-confluence-plugin) to generate an empty POC summary page.


