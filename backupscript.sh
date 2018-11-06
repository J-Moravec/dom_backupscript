#!/bin/bash

# SET UP VARIABLES:
# absolute path required
DOMINIONS="dom5"
SAVEDIR="${HOME}/.dominions5/savedgames"
BACKUPDIR="${SAVEDIR}/backups"
WATCHED="${SAVEDIR}/watchedgames.txt"

# modify if you want to back up map with every turn file
# otherwise the map will be backed just once
#BACKUPMAP=true
BACKUPMAP=false

echo "Backup script initiated!"

# backup function
_backup () {
    echo "Backing to: ${2}" 
    mkdir -p ${2}
    if [ $BACKUPMAP = true ]; then
        cp -a ${1}/* ${2}/
    else
        cp -a ${1}/*.2h ${2}/
        cp -a ${1}/*.trn ${2}/
    fi
}

_backup_map () {
    echo "Backup up map"
    if [ $BACKUPMAP = false ]; then
        mkdir -p ${2}
        cp -a ${1}/*.map ${2}/
        cp -a ${1}/*.rgb ${2}/
    fi
}

while read GAMENAME
    do
    echo "Trying to backup game: ${GAMENAME}"
    GAMEDIR="${SAVEDIR}/${GAMENAME}"
    BACKUPGAMEDIR="${BACKUPDIR}/${GAMENAME}"
    # verifies GAMENAME
    ${DOMINIONS} --nosteam --verify ${GAMENAME}

    # get nation name from trn file
    NATION=$(ls ${GAMEDIR} | grep ".trn")
    NATION=${NATION%.trn}
    
    # Checks if the chk file exists
    CHKFILE=${GAMEDIR}/${NATION}.chk
    
    if [ -f ${CHKFILE} ]; then
        # get turn number
        TURN=$(grep "turnnbr" ${CHKFILE})
        TURN=${TURN//[!0-9]/}
        rm ${GAMEDIR}/*.chk # clean after
        echo "Found turn: ${TURN}"

        # gamename directory exists:
        if [ -d "${BACKUPGAMEDIR}" ]; then
            # find biggest turn:
            LAST=$(ls ${BACKUPGAMEDIR} | grep "turn_" | sed s/turn_// | sort -g | tail -n 1)
            echo "The last backed turn: ${LAST}"
            
            # if current turn is bigger or equal to the last turn, backup
            if [ "${TURN}" -ge "${LAST}" ]; then
                _backup ${GAMEDIR} "${BACKUPGAMEDIR}/turn_${TURN}"
            fi # else do nothing
        
        else # if not, create it and copy the turn there
            echo "No previous backups found!"
            _backup_map "${GAMEDIR}" "${BACKUPGAMEDIR}"
            _backup "${GAMEDIR}" "${BACKUPGAMEDIR}/turn_${TURN}"
        fi
    else
        echo "Check file ${CHKFILE} for ${GAMENAME} does not exist."
    fi
done < ${WATCHED}
