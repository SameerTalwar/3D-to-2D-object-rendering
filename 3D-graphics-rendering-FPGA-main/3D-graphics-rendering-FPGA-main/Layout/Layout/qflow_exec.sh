#!/bin/tcsh -f
#-------------------------------------------
# qflow exec script for project /home/osboxes/Qflow_2
#-------------------------------------------

# /usr/local/share/qflow/scripts/synthesize.sh /home/osboxes/Qflow_2 CompBlock /home/osboxes/Qflow_2/source/CompBlock.v || exit 1
# /usr/local/share/qflow/scripts/placement.sh -d /home/osboxes/Qflow_2 CompBlock || exit 1
# /usr/local/share/qflow/scripts/vesta.sh  /home/osboxes/Qflow_2 CompBlock || exit 1
# /usr/local/share/qflow/scripts/router.sh /home/osboxes/Qflow_2 CompBlock || exit 1
# /usr/local/share/qflow/scripts/vesta.sh  -d /home/osboxes/Qflow_2 CompBlock || exit 1
# /usr/local/share/qflow/scripts/migrate.sh /home/osboxes/Qflow_2 CompBlock || exit 1
# /usr/local/share/qflow/scripts/drc.sh /home/osboxes/Qflow_2 CompBlock || exit 1
# /usr/local/share/qflow/scripts/lvs.sh /home/osboxes/Qflow_2 CompBlock || exit 1
/usr/local/share/qflow/scripts/gdsii.sh /home/osboxes/Qflow_2 CompBlock || exit 1
# /usr/local/share/qflow/scripts/cleanup.sh /home/osboxes/Qflow_2 CompBlock || exit 1
# /usr/local/share/qflow/scripts/display.sh /home/osboxes/Qflow_2 CompBlock || exit 1
