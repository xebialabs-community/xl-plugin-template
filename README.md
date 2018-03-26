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
* examples of the MIT License format for various file types (.ftl, .html, .java, .js, .py, .sh, .xml, etc.)

The WikiPageBody.txt file can be pasted into the New Page Text field of the [xlr-confluence plugin](https://github.com/xebialabs-community/xlr-confluence-plugin) to generate an empty POC summary page.

## References

Note:  The required XL Deploy or XL Release version should not be lower than the lowest supported.  See https://support.xebialabs.com/hc/en-us/articles/115003299946-Supported-XebiaLabs-product-versions

#### Image link format:

![screenshot of <image description>](images/macdown-logo-160.png)

#### Supported types for license text:

<http://code.mycila.com/license-maven-plugin/#supported-comment-types>

#### Travis configuration

* After creating git repository, sync Travis with GitHub (https://travis-ci.org/profile/xebialabs-community) and enable the project by setting switch to on.

* travis encrypt TRAVIS-HIPCHAT-PASSWORD --add  notifications.hipchat.rooms

* travis setup releases

* Replace last several lines with  

```
  file_glob: true
  file: build/libs/*
  or
  file: build/distributions/*
  skip_cleanup: true
  on:
    all_branches: true
    tags: true
    repo: xebialabs-community/LCPLUGINNAME
```
* See https://xebialabs-community.github.io for additional details on enabling Continuous Integration with Gradle, Nebula, and Travis.