#!/bin/bash

#These parameters will be substituted by maven.
TEMPLATE_NAME="${configuration.template}"
TEMPLATE="${jboss.home}/server/$TEMPLATE_NAME"
CONF="${jboss.home}/server/${configuration.name}"
OLD="$CONF-`date --rfc-3339=date`"
USER="${file.user}"
GROUP="${file.group}"
PERM="775"

# This will be 1 for a fresh install and 2 for an update.
INST="$1"

if [ "$INST" -eq "1" ]
then
	echo "Fresh install, checking for existing jboss configuration..."
	# Move existing jboss configuration.
	if [ -d "$CONF" ]
	then
		echo "Moving existing configuration to $OLD"
		mv "$CONF" "$OLD"
	fi
	
	# Create new configuration.
	mkdir "$CONF"
	chown "$USER":"$GROUP" "$CONF"
	chmod "$PERM" "$CONF"
	
	# Copy required files from template.
	echo "Copying files from $TEMPLATE_NAME"
	cp -rpd "$TEMPLATE"/lib "$CONF"
	cp -rpd "$TEMPLATE"/conf "$CONF"
	cp -rpd "$TEMPLATE"/deploy "$CONF"
	cp -rpd "$TEMPLATE"/deployers "$CONF"
else
	echo "Upgrading existing rpm..."
fi
