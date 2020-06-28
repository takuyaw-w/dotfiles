#--------------------------------------------------------------#
##          Plugins                                           ##
#--------------------------------------------------------------#

set-option -g @plugin "tmux-plugins/tpm"
set-option -g @plugin "tmux-plugins/tmux-resurrect"
set-option -g @plugin "tmux-plugins/tmux-continuum"
set-option -g @plugin "tmux-plugins/tmux-copycat"
set-option -g @plugin "tmux-plugins/tmux-yank"
set-option -g @plugin "tmux-plugins/vim-tmux-focus-events"
if 'builtin command -v xdg-open > /dev/null 2>&1 ' \
  'set-option -g @plugin "tmux-plugins/tmux-open"'
set-option -g @plugin "jschaf/tmux-newline-detector"
set-option -g @plugin 'tmux-plugins/tmux-prefix-highlight'
set-option -g @plugin 'tmux-plugins/tmux-online-status'
if 'builtin command -v urlview > /dev/null 2>&1 ' \
  'set-option -g @plugin "tmux-plugins/tmux-urlview"'
set -g @plugin 'Morantron/tmux-fingers'
if 'builtin command -v fpp > /dev/null 2>&1 ' \
  'set -g @plugin "jbnicolai/tmux-fpp"'
# set -g @plugin 'ddzero2c/tmux-easymotion' # overwrite C-j. it does not change
set -g @plugin 'samoshkin/tmux-plugin-sysstat'


#--------------------------------------------------------------#
##          Disable Plugins                                   ##
#--------------------------------------------------------------#

## Disabled for customize coloring
#set-option -g @plugin "jooize/tmux-powerline-theme"
## Disabled for include my tmux.conf
#set-option -g @plugin "#tmux-plugins/tmux-sensible"


#--------------------------------------------------------------#
##          Install/Execute tpm                               ##
#--------------------------------------------------------------#

if '[ ! -d ~/.tmux/plugins/tpm ]' \
  'run-shell "git clone --depth 1 https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm"'

if '[ -d ~/.tmux/plugins/tpm ]' \
  'run-shell "~/.tmux/plugins/tpm/tpm"'


#--------------------------------------------------------------#
##          Non tpm plugins                                   ##
#--------------------------------------------------------------#


#--------------------------------------------------------------#
##          Disable Non tpm Plugins                           ##
#--------------------------------------------------------------#

# Management is awkward. Also finger is not so slow
# if '[ -f ~/.tmux/conf/scripts/install-tmux-thumbs.sh ]' \
#   'run-shell "~/.tmux/conf/scripts/install-tmux-thumbs.sh"'
# if '[ -r ~/.tmux/plugins/tmux-thumbs/tmux-thumbs.tmux ]' \
#   'run-shell "~/.tmux/plugins/tmux-thumbs/tmux-thumbs.tmux"'

# Heavy processing
#set -g @plugin 'tmux-plugins/tmux-net-speed'
#set -g @plugin 'samoshkin/tmux-plugin-sysstat'


#--------------------------------------------------------------#
##          Plugins Config                                    ##
#--------------------------------------------------------------#

set -g @continuum-restore 'on'

if '[ -f ~/.tmux/plugins/tmux-newline-detector/scripts/paste.sh ]' \
  'bind -n C-down run-shell "~/.tmux/plugins/tmux-newline-detector/scripts/paste.sh"'

set -g @fingers-key S
set -g @fingers-highlight-format '#[fg=green,bold,dim]%s'
set -g @fingers-hint-format '#[fg=yellow,bold,dim]%s'
bind-key -n M-f  run-shell "~/.tmux/plugins/tmux-fingers/scripts/tmux-fingers.sh"

set -g @fpp-key 'v'

set -g @sysstat_cpu_view_tmpl '#[fg=#{cpu.color}]#{cpu.pused}'
set -g @sysstat_mem_view_tmpl '#[fg=#{mem.color}]#{mem.pused}'
set -g @sysstat_cpu_pused_format '%2.0f%%'
set -g @sysstat_mem_pused_format '%2.0f%%'
set -g @sysstat_mem_pfree_format '%2.0f%%'
set -g @sysstat_cpu_medium_threshold "75"
set -g @sysstat_cpu_stress_threshold "95"
set -g @sysstat_mem_medium_threshold "80"
set -g @sysstat_mem_stress_threshold "90"
set -g @sysstat_swap_medium_threshold "80"
set -g @sysstat_swap_stress_threshold "90"
set -g @sysstat_cpu_color_low "colour231"
set -g @sysstat_cpu_color_medium "colour220"
set -g @sysstat_cpu_color_stress "colour160"
set -g @sysstat_mem_color_low "colour231"
set -g @sysstat_mem_color_medium "blue"
set -g @sysstat_mem_color_stress "colour33"
