#!/bin/sh
# TODO: write proper hooks
# HOOKS
#        Executables  (e.g.  scripts)  placed in folder ~/.config/gammastep/hooks will be run when a certain event happens. The first parameter to the script indicates the
#        event and further parameters may indicate more details about the event. The event period-changed is indicated when the period  changes  (night,  daytime,  transi‐
#        tion).  The  second  parameter is the old period and the third is the new period. The event is also signaled at startup with the old period set to none.  Any dot‐
#        files in the folder are skipped.
#
#        A simple script to handle these events can be written like this:
#
#               #!/bin/sh
#               case $1 in
#                   period-changed)
#                       exec notify-send "Gammastep" "Period changed to $3"
#               esac
case $1 in
period-changed)
  exec notify-send "Gammastep" "Period changed to $3"
  ;;
esac
