#!/bin/bash

TODAY=$(date +%Y%m%d)

# Path to changelog file
CHANGE_FILE=$STORAGE/$VER/$TODAY-"changelog-"$BRANCH.html
# Path to root of the ROM project directory
PROJECT_DIR=$SAUCE
PROJECT_LIST=$SAUCE/.repo/project.list

NOW=$(date -u)
SINCE=$(date -u --date "-30 days")

generatechangelog() {
	if [ -f "$CHANGE_FILE" ]; then
	  echo "Changelog exist alrady, regenerating"
	  rm "$CHANGE_FILE"
	fi
	echo "<!DOCTYPE html><html><body><h2><b><u>$BRANCH: From $SINCE to $NOW</u></b></h2><br>" > "$CHANGE_FILE"

	for REPOPATH in $REPOS ; do
	    if [ ! "$REPOPATH" == "" ]; then
	      if [ -d "$PROJECT_DIR"/"$REPOPATH" ]; then
        cd "$PROJECT_DIR"/"$REPOPATH"
	        GITOUT=$(git log HEAD --pretty="<li>%h %s (%an)</li>" --since="30 days ago")
	        if [ ! "$GITOUT" == "" ]; then
	          echo "<font size="4"><b>$REPOPATH</b></font>" >> "$CHANGE_FILE"
	          echo '<ul style="list-style-type:square">' >> "$CHANGE_FILE"
	          echo "$GITOUT" >> "$CHANGE_FILE"
	          echo "</ul>" >> "$CHANGE_FILE"
	        fi
	      fi
	    fi
	done

	echo "</body></html>" >> "$CHANGE_FILE"

	echo ""
	echo "Most recent changes:"
	echo ""
	cat "$CHANGE_FILE" | grep -E '<li>' | sed 's/<br>//g' | sed 's/<\/li>//g' | sed 's/<li>//g'
	echo ""
}

if [ -e "$PROJECT_LIST" ]; then
  REPOS=$(cat "$PROJECT_LIST" | tr " " "\n")
  REPOS=$(echo -e "$REPOS" | sort)
  generatechangelog
else
  echo "Project list not found."
  echo "Run repo_sync command first to generate needed project list!"
fi

echo "Moving back to source directory."
cd $SAUCE
