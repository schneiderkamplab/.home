#!/bin/bash
INIT_VAR=$(jq -r '.request.parameters.x_var.value' /work/JobParameters.json)
if [[ "$INIT_VAR" == "null" ]]
then
    INIT_HOME="null"
else
    INIT_HOME=$(jq -r '.request.parameters.x_var.value | fromjson | .home' /work/JobParameters.json)
fi
if [[ "$INIT_HOME" == "null" ]]
then
    for i in /work/*/.home
    do
        if [[ -d "$i" ]]
        then
            INIT_HOME="$i"
            break
        fi
    done
fi
if [[ "$INIT_HOME" != "null" ]]
then
    if [[ -d "$INIT_HOME" ]]
    then
        cd "$INIT_HOME"
        for i in * .[!.] .??*
        do
           if [[ -e "$i" ]]
           then
               echo "INFO -- found persistent file: $INIT_HOME/$i"
               if [[ -e ~/"$i" ]]
               then
                   echo "INFO -- found ephemeral file: ~/$i"
                   echo "INFO -- $(mv -v ~/"$i" ~/"$i.backup" 2>&1)"
               fi
               cd ~
               ln -s "$INIT_HOME/$i" .
               echo "INFO -- created symbolic link: "$(ls -l $i | awk '{print $9" "$10" "$11;}')
               cd - > /dev/null
           fi
        done
    else
        echo "WARNING -- directory not found: $INIT_HOME"
    fi
else
    echo 'INFO -- no home directory given - use {"home": "/work/XYZ/home"} to use /work/XYZ/home as your home directory.'
fi

