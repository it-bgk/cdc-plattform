#!/bin/sh
#
#
#
echo ""
echo "Start $0"
echo ""

[ "$1" = "--enable-debug" ] && DEBUG=True && echo "Activate Debug Mode." && echo ""
{ [ "$1" = "--display-all" ] || [ "$2" = "--display-all" ] } && DISPLAY_ALL=True && echo "Disable diff mode and show all"

FILE_ENV="$PWD/.env"
FILE_ENV_SAMPLE="$PWD/.env.sample"
ENV="$(cat $FILE_ENV)"

while IFS= read -r line; 
do
    [ $DEBUG ] && echo "DEBUG | '$line'"
    case "$line" in
        \#\#\#*\#\#\#) 
            ### Sections ###
            echo ""
            echo "$line"
            continue 
            ;;
        \#\#*) 
            ## Comments
            #echo "Comment Line"
            continue 
            ;;
        \#\ *) 
            ## Comments
            #echo "Comment Line"
            continue 
            ;;
        "") 
            # Skip emtpy lines
            continue 
            ;;
        \#) 
            # Skip emtpy lines
            continue 
            ;;
        \#*) 
            #
            #   This section is for commented variables
            #
            NAME="$(echo "$line"| cut -d = -f 1)"
            VALUE="$(echo "$line"| cut -d = -f 2)"
            COMMENTED_OUT_VAR=""

            # Check if env var is set:
            GREP_VAR_FROM_ENV="$(grep "^$NAME=" "$FILE_ENV")"

            if [ -z "$GREP_VAR_FROM_ENV" ]
            then
                # If GREP_VAR_FROM_ENV is empty perhaps it was commented :
                NAME="$(echo "$NAME"| cut -d '#' -f 2)"
                GREP_VAR_FROM_ENV="$(grep "^$NAME=" "$FILE_ENV")"
                COMMENTED_OUT_VAR=True
            fi

            # Check value of .env var:
            VALUE_SET="$(echo "$GREP_VAR_FROM_ENV"|cut -d = -f 2)"

            if [ -z "$GREP_VAR_FROM_ENV" ] 
            then
                # Is variable added to .env file?
                echo "Not implemented optional (commented) variable: $line"
            elif [ "$VALUE_SET" != "$VALUE" ] && [ $DISPLAY_ALL ]
            then
                # Is added variable modified from default?
                if [ $COMMENTED_OUT_VAR ]
                then
                    # Optional variable was activated and changed
                    echo "Variable '$NAME' different from default. Default: '$NAME=$VALUE' | Your: '$NAME=$VALUE_SET'"
                else
                    echo "Optional (commented) variable '$NAME' different from default. Default: '$NAME=$VALUE' | Your: '$NAME=$VALUE_SET'"
                fi
            elif [ "$VALUE_SET" = "$VALUE" ] && [ $DISPLAY_ALL ]
            then
                # Is variable unchanged but added?
                if [ $COMMENTED_OUT_VAR ]
                then
                    # Optional variable was activated
                    echo "Variable: '$NAME=$VALUE_SET'"
                else
                    echo "Optional (commented) variable: '$NAME=$VALUE_SET'"
                fi
            fi
            set +xv
            ;;
        *)         
            ## Divide variable
            NAME="$(echo "$line"| cut -d = -f 1)"
            VALUE="$(echo "$line"| cut -d = -f 2)"
            
            # Check if env var is set in .env:
            GREP_VAR_FROM_ENV="$(grep "^$NAME" "$FILE_ENV")"
            VALUE_SET="$(echo "$GREP_VAR_FROM_ENV"|cut -d = -f 2)"

            if [ -z "$GREP_VAR_FROM_ENV" ] 
            then
                # Is variable added to .env file?
                echo "Not implemented variable: $line"
            elif [ "$VALUE_SET" != "$VALUE" ] && [ -n "$VALUE" ]
            then
                # Is added variable modified from default?
                echo "Variable '$NAME' different from default. Default: '$NAME=$VALUE' | Your: '$NAME=$VALUE_SET'"
            elif [ "$VALUE_SET" = "$VALUE" ] && [ $DISPLAY_ALL ]
            then
                # Is variable unchanged but added?
                echo "Variable: '$NAME=$VALUE_SET'"
            fi
            ;;
    esac
done < "$FILE_ENV_SAMPLE"
echo ""
echo "$0 | finished."