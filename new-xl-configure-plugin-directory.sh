#!/bin/bash

#
# XebiaLabs Configure Plugin Directory:  xl-configure-plugin-directory.sh
# XebiaLabs, Dave Roberts, September 23 2017
#

echo
echo "Command format is ../xl-configure-plugin-directory.sh XLPRODUCT LCPLUGINNAME SCRIPTDIRNAME WEBSCRIPTDIRNAME"
echo
echo "XLPRODUCT should be lowercase xld or xlr"
echo "LCPLUGINNAME should be hyphenated lowercase, e.g., xl-my-demo-plugin"
echo "SCRIPTDIRNAME should be camelcase, e.g., MyDemo"
echo "WEBSCRIPTDIRNAME should be hyphenated lowercase, e.g., my-demo"
echo "PYTHONCLIENTNAME should be snake case, e.g., My_Demo_Client"
echo
echo "Or, execute without arguments and enter responses at the prompts"
echo
echo "Execute from your local github/xebialabs, github/xebialabs-community, or xebialabs-external directory"
echo

#
# Organize parameters
#

get-arguments-and-responses() {
    if [ $1 -gt 0 ]
    then
        eval RESPONSE$2=$3
    else
        read -p "${PROMPTS[$2 - 1]}: " RESPONSE$2
    fi
}

PROMPTS=("Enter lowercase product abbreviation, xl, xld, or xlr (XLPRODUCT)"
         "Enter lowercase plugin name (LCPLUGINNAME)"
         "Enter script directory name (SCRIPTDIRNAME)"
         "Enter web script directory name (WEBSCRIPTDIRNAME)"
         "Enter Python client name (PYTHONCLIENTNAME)")

if [ $# -gt 5 ]
then
  echo "Too many arguments were supplied"
  echo "Ignoring extra arguments and continuing"
  echo
fi

for INDEX in 1 2 3 4 5
do
  get-arguments-and-responses $# $INDEX $1
  shift
done

XLPRODUCT=$RESPONSE1
LCPLUGINNAME=$RESPONSE2
SCRIPTDIRNAME=$RESPONSE3
WEBSCRIPTDIRNAME=$RESPONSE4
PYTHONCLIENTNAME=$RESPONSE5

XLPLUGINTEMPLATE="$(dirname $0)"

echo "Product:               $XLPRODUCT"
echo "Plugin name:           $LCPLUGINNAME"
echo "Script directory:      $SCRIPTDIRNAME"
echo "Web script directory:  $WEBSCRIPTDIRNAME"
echo "Python client name     $PYTHONCLIENTNAME"
echo

#
# Make the LCPLUGINNAME and images directories
#

mkdir -p $LCPLUGINNAME/images

#
# Copy the mostly static root components
#

cp -R $XLPLUGINTEMPLATE/gradle $LCPLUGINNAME
cp $XLPLUGINTEMPLATE/.gitignore $XLPLUGINTEMPLATE/.travis.yml $XLPLUGINTEMPLATE/build.gradle $XLPLUGINTEMPLATE/gradlew $XLPLUGINTEMPLATE/gradlew.bat $XLPLUGINTEMPLATE/License.md $LCPLUGINNAME

#
# Sed the files that need LCPLUGINNAME replaced
#

sed "s/LCPLUGINNAME/$LCPLUGINNAME/g" $XLPLUGINTEMPLATE/README-TEMPLATE.md > $LCPLUGINNAME/README.md
sed "s/LCPLUGINNAME/$LCPLUGINNAME/g" $XLPLUGINTEMPLATE/settings.gradle > $LCPLUGINNAME/settings.gradle

#
# Make the remaining directories and copy the rest of the files
#

# Java
mkdir -p $LCPLUGINNAME/src/main/java
cp $XLPLUGINTEMPLATE/src/main/java/template.java $LCPLUGINNAME/src/main/java

# Resources
mkdir -p $LCPLUGINNAME/src/main/resources
cp $XLPLUGINTEMPLATE/src/main/resources/plugin-version.properties $LCPLUGINNAME/src/main/resources

# synthetic.xml, xl-rest-endpoints.xml, xl-rules.xml, xl-ui-plugin.xml
cp $XLPLUGINTEMPLATE/src/main/resources/*.xml $LCPLUGINNAME/src/main/resources

# template.py, template.sh.ftl, template.xml
if [ -z "$SCRIPTDIRNAME" ]
then
    echo "Omitting script directory"
else
    mkdir -p $LCPLUGINNAME/src/main/resources/$SCRIPTDIRNAME
    cp $XLPLUGINTEMPLATE/src/main/resources/template/template.* $LCPLUGINNAME/src/main/resources/$SCRIPTDIRNAME
fi

# Web for XL Deploy UI extension
if [ "$XLPRODUCT" = "xld" ]
then
    if [ -z "$WEBSCRIPTDIRNAME" ]
    then
        echo "Omitting xld web script directory"
    else
        mkdir -p $LCPLUGINNAME/src/main/resources/web/$WEBSCRIPTDIRNAME/css
        mkdir -p $LCPLUGINNAME/src/main/resources/web/$WEBSCRIPTDIRNAME/js
        cp $XLPLUGINTEMPLATE/src/main/resources/web/template-for-xld-ui-extension/index.html $LCPLUGINNAME/src/main/resources/web/$WEBSCRIPTDIRNAME/index.html
        cp $XLPLUGINTEMPLATE/src/main/resources/web/template-for-xld-ui-extension/css/cc-fonts.css $LCPLUGINNAME/src/main/resources/web/$WEBSCRIPTDIRNAME/css/cc-fonts.css
        cp $XLPLUGINTEMPLATE/src/main/resources/web/template-for-xld-ui-extension/css/template.css $LCPLUGINNAME/src/main/resources/web/$WEBSCRIPTDIRNAME/css/$WEBSCRIPTDIRNAME.css
        cp $XLPLUGINTEMPLATE/src/main/resources/web/template-for-xld-ui-extension/js/template.js $LCPLUGINNAME/src/main/resources/web/$WEBSCRIPTDIRNAME/js/$WEBSCRIPTDIRNAME.js
    fi
fi

# Web for XL Release tile
if [ "$XLPRODUCT" = "xlr" ]
then
    if [ -z "$WEBSCRIPTDIRNAME" ]
    then
        echo "Omitting xlr web script directory"
    else
        mkdir -p $LCPLUGINNAME/src/main/resources/web/include/$WEBSCRIPTDIRNAME/css
        mkdir -p $LCPLUGINNAME/src/main/resources/web/include/$WEBSCRIPTDIRNAME/js
        cp $XLPLUGINTEMPLATE/src/main/resources/web/include/template-for-xlr-tile/index.html $LCPLUGINNAME/src/main/resources/web/include/$WEBSCRIPTDIRNAME/index.html
        cp $XLPLUGINTEMPLATE/src/main/resources/web/include/template-for-xlr-tile/css/cc-fonts.css $LCPLUGINNAME/src/main/resources/web/include/$WEBSCRIPTDIRNAME/css/cc-fonts.css
        cp $XLPLUGINTEMPLATE/src/main/resources/web/include/template-for-xlr-tile/css/template.css $LCPLUGINNAME/src/main/resources/web/include/$WEBSCRIPTDIRNAME/css/$WEBSCRIPTDIRNAME.css
        cp $XLPLUGINTEMPLATE/src/main/resources/web/include/template-for-xlr-tile/js/template.js $LCPLUGINNAME/src/main/resources/web/include/$WEBSCRIPTDIRNAME/js/$WEBSCRIPTDIRNAME.js
    fi
fi

# Python client for XL Release
if [ "$XLPRODUCT" = "xlr" ]
then
    if [ -z "$PYTHONCLIENTNAME" ]
    then
        echo "Omitting xlr Python client -- client name not supplied"
    else
        if [ -z $SCRIPTDIRNAME ]
        then
            echo "Omitting xlr Python client -- script dir name not supplied"
        else
            PYTHONCLIENTUTILNAME=${PYTHONCLIENTNAME}_Util
            CLIENTFILENAME=$(echo ${PYTHONCLIENTNAME} | sed 's/_//g')
            CLIENTUTILFILENAME=$(echo ${PYTHONCLIENTUTILNAME} | sed 's/_//g')
            sed "s/Template_Client/$PYTHONCLIENTNAME/g" $XLPLUGINTEMPLATE/src/main/resources/template/templateclient.py > $LCPLUGINNAME/src/main/resources/$SCRIPTDIRNAME/${CLIENTFILENAME}-1.py
            sed "s/TemplateClient/$CLIENTFILENAME/g" $LCPLUGINNAME/src/main/resources/$SCRIPTDIRNAME/${CLIENTFILENAME}-1.py > $LCPLUGINNAME/src/main/resources/$SCRIPTDIRNAME/${CLIENTFILENAME}.py
            sed "s/Template_Client/$PYTHONCLIENTNAME/g" $XLPLUGINTEMPLATE/src/main/resources/template/templateclientutil.py > $LCPLUGINNAME/src/main/resources/$SCRIPTDIRNAME/${CLIENTUTILFILENAME}-1.py
            sed "s/Template_Client_Util/$$PYTHONCLIENTUTILNAME/g" $LCPLUGINNAME/src/main/resources/$SCRIPTDIRNAME/${CLIENTUTILFILENAME}-1.py > $LCPLUGINNAME/src/main/resources/$SCRIPTDIRNAME/${CLIENTUTILFILENAME}-2.py
            sed "s/template\.TemplateClient/$SCRIPTDIRNAME\.$CLIENTFILENAME/g" $LCPLUGINNAME/src/main/resources/$SCRIPTDIRNAME/${CLIENTUTILFILENAME}-2.py > $LCPLUGINNAME/src/main/resources/$SCRIPTDIRNAME/${CLIENTUTILFILENAME}-3.py
            sed "s/TemplateClientUtil/$CLIENTUTILFILENAME/g" $LCPLUGINNAME/src/main/resources/$SCRIPTDIRNAME/${CLIENTUTILFILENAME}-3.py > $LCPLUGINNAME/src/main/resources/$SCRIPTDIRNAME/${CLIENTUTILFILENAME}.py
            cp "$LCPLUGINNAME/src/main/resources/$SCRIPTDIRNAME/template.py" "$LCPLUGINNAME/src/main/resources/$SCRIPTDIRNAME/__init__.py"
            cp "$LCPLUGINNAME/src/main/resources/$SCRIPTDIRNAME/template.py" "$LCPLUGINNAME/src/main/resources/$SCRIPTDIRNAME/Task.py"
            echo "import $SCRIPTDIRNAME.$CLIENTUTILFILENAME" >> "$LCPLUGINNAME/src/main/resources/$SCRIPTDIRNAME/Task.py"
            echo "reload($SCRIPTDIRNAME.$CLIENTUTILFILENAME)" >> "$LCPLUGINNAME/src/main/resources/$SCRIPTDIRNAME/Task.py"
            echo "from $SCRIPTDIRNAME.$CLIENTUTILFILENAME import $PYTHONCLIENTUTILNAME" >> "$LCPLUGINNAME/src/main/resources/$SCRIPTDIRNAME/Task.py"
            echo "" >> "$LCPLUGINNAME/src/main/resources/$SCRIPTDIRNAME/Task.py"
            echo "client = $PYTHONCLIENTUTILNAME.create_client()" >> "$LCPLUGINNAME/src/main/resources/$SCRIPTDIRNAME/Task.py"
            rm $LCPLUGINNAME/src/main/resources/$SCRIPTDIRNAME/*-[123]\.py
       fi
    fi
fi


if [ "$XLPRODUCT" == "xld" ]
then
    XLPRODUCTLONG1="xldeploy"
    XLPRODUCTLONG2="XL Deploy"
fi

if [ "$XLPRODUCT" == "xlr" ]
then
    XLPRODUCTLONG1="xlrelease"
    XLPRODUCTLONG2="XL Release"
fi

sed "s/LCPLUGINNAME/$LCPLUGINNAME/g" $XLPLUGINTEMPLATE/manifest-template.json > $LCPLUGINNAME/manifest-1.json
sed "s/XLPRODUCTLONG1/$XLPRODUCTLONG1/g" $LCPLUGINNAME/manifest-1.json > $LCPLUGINNAME/manifest-2.json
sed "s/XLPRODUCTLONG2/$XLPRODUCTLONG2/g" $LCPLUGINNAME/manifest-2.json > $LCPLUGINNAME/manifest.json
rm $LCPLUGINNAME/manifest-1.json $LCPLUGINNAME/manifest-2.json

echo "Complete"
echo
