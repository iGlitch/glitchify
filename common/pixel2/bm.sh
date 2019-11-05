#!/system/bin/sh

# BM 11.2

# Pause script execution a little for Magisk Boot Service;
sleep 120;

# A few strictly, and carefully, selected filesystem mounting tweaks and enhancements for better system performance;
busybox mount -o remount,nosuid,nodev,noatime,nodiratime,noauto_da_alloc,barrier=0 -t auto /;
busybox mount -o remount,nosuid,nodev,noatime,nodiratime -t auto /proc;
busybox mount -o remount,nosuid,nodev,noatime,nodiratime,noauto_da_alloc,barrier=0 -t auto /sys;

# Disable the exception-trace kernel debugger;
echo "0" > /proc/sys/debug/exception-trace

# Disable SCSI logging;
echo "0" > /proc/sys/dev/scsi/logging_level

# FS tweaks for slightly better userspace performance;
echo "0" > /proc/sys/fs/dir-notify-enable
echo "20" > /proc/sys/fs/lease-break-time

# Kernel tweaks for overall improved performance;
echo "0" > /proc/sys/kernel/compat-log

# Tweaks for overall improved network performance;
# echo "0" > /proc/sys/net/core/netdev_tstamp_prequeue
echo "westwood" > /proc/sys/net/ipv4/tcp_congestion_control
# echo "1" > /proc/sys/net/ipv4/tcp_ecn
# echo "0" > /proc/sys/net/ipv4/tcp_slow_start_after_idle

# A few virtual memory tweaks for improved battery life;
echo "500" > /proc/sys/vm/dirty_expire_centisecs
echo "3000" > /proc/sys/vm/dirty_writeback_centisecs
echo "5" > /proc/sys/vm/laptop_mode
echo "0" > /proc/sys/vm/oom_dump_tasks
echo "1" > /proc/sys/vm/oom_kill_allocating_task
echo "1200" > /proc/sys/vm/stat_interval
echo "0" > /proc/sys/vm/swap_ratio

# Disable all this useless wakeup based bloat;
echo "0" > /sys/android_touch/vib_strength

# Flash storages doesn't comes with any back seeking problems, so set this as low as possible for performance;
for i in /sys/block/sd*/queue/iosched; do
  echo "1" > $i/back_seek_penalty;
done;

# Set all of the 'fifo_expire_sync' IO scheduling block tunables to half of the value that 'fifo_expire_async' tunables is using;
for i in /sys/block/sd*/queue/iosched; do
  echo "125" > $i/fifo_expire_sync;
done;

# Disable CFQ group_idle for all of the sdx queue levels;
for i in /sys/block/sd*/queue/iosched; do
  echo "0" > $i/group_idle;
done;

# Wide block based tuning for reduced lag and less possible amount of general IO scheduling based overhead (Thanks to pkgnex @ XDA for the more than pretty much simplified version of this tweak. You really rock, dude!);
for i in /sys/block/*/queue; do
  echo "0" > $i/add_random;
  echo "128" > $i/read_ahead_kb;
  echo "0" > $i/rotational;
  echo "1" > $i/rq_affinity;
done;

# Disable GPU frequency based throttling;
echo "0" > /sys/class/kgsl/kgsl-3d0/throttling

# Decrease both battery as well as power consumption that is being caused by the screen by lowering how much light the pixels, the built-in LED switches and the LCD backlight module is releasing & "kicking out" by carefully tuning / adjusting their maximum values a little bit to the balanced overall range of their respective spectrums;
echo "175" > /sys/class/leds/blue/max_brightness
echo "175" > /sys/class/leds/green/max_brightness
echo "175" > /sys/class/leds/lcd-backlight/max_brightness
echo "175" > /sys/class/leds/led:switch_0/max_brightness
echo "175" > /sys/class/leds/led:switch_1/max_brightness
echo "175" > /sys/class/leds/red/max_brightness

# Block a few safe wakelocks for improved battery life;
echo "wlan_wow_wl;wlan_extscan_wl;wlan;qcom_rx_wakelock;netmgr_wl;" > /sys/class/misc/boeffla_wakelock_blocker/wakelock_blocker

# Tweak and decrease tx_queue_len default stock value(s) for less amount of generated bufferbloat and for gaining slightly faster network speed and performance;
for i in $(find /sys/class/net -type l); do
  echo "128" > $i/tx_queue_len;
done;

# Display Calibration that will be close to D65 (6500K) (Boosted). Thanks to Juzman @ XDA for this contribution;
# echo "256 249 226" > /sys/devices/platform/kcal_ctrl.0/kcal
# echo "5" > /sys/devices/platform/kcal_ctrl.0/kcal_min
# echo "257" > /sys/devices/platform/kcal_ctrl.0/kcal_val

# Adjust a few display props for improved performance as well as overall reduced stuttering and power consumption;
echo "0" > /sys/kernel/debug/mdss_panel_fb0/intf0/mipi/hw_vsync_mode
echo "0" > /sys/kernel/debug/mdss_panel_fb0/intf0/mipi/vsync_enable
echo "175" > /sys/kernel/debug/mdss_panel_fb0/intf0/bl_max
echo "175" > /sys/kernel/debug/mdss_panel_fb0/intf0/brightness_max
echo "Y" > /sys/kernel/debug/mdss_panel_fb0/intf0/panel_ack_disabled
echo "1" > /sys/kernel/debug/mdss_panel_fb0/intf0/partial_update_enabled

# Disable some additional excessive kernel debugging;
echo "N" > /sys/kernel/debug/debug_enabled

# Fully configure the sched_features values for potentially reduced power consumption with a non-existing performance impact and short of obviously the completely opposite case;
echo "NO_GENTLE_FAIR_SLEEPERS" > /sys/kernel/debug/sched_features
echo "NO_TTWU_QUEUE" > /sys/kernel/debug/sched_features
echo "NO_RT_RUNTIME_SHARE" > /sys/kernel/debug/sched_features

# Disable RCU_expedited directly after each boot;
echo "0" > /sys/kernel/rcu_expedited

# Enable Fast Charge for slightly faster battery charging when being connected to a USB 3.1 port, which can be good for the people that is often on the run or have limited access to a wall socket;
echo "1" > /sys/kernel/fast_charge/force_fast_charge

# Disable a few minor and overall pretty useless modules for slightly better battery life & system wide performance;
echo "0" > /sys/module/battery/parameters/debug_mask
echo "0" > /sys/module/binder/parameters/debug_mask
echo "0" > /sys/module/binder_alloc/parameters/debug_mask
echo "Y" > /sys/module/bluetooth/parameters/disable_ertm
echo "Y" > /sys/module/bluetooth/parameters/disable_esco
echo "0" > /sys/module/debug/parameters/enable_event_log
echo "0" > /sys/module/diagchar/parameters/diag_mask_clear_param
echo "0" > /sys/module/dwc3/parameters/ep_addr_rxdbg_mask
echo "0" > /sys/module/dwc3/parameters/ep_addr_txdbg_mask
echo "0" > /sys/module/event_timer/parameters/debug_mask
echo "0" > /sys/module/glink/parameters/debug_mask
echo "0" > /sys/module/hid/parameters/debug
echo "0" > /sys/module/hid/parameters/ignore_special_drivers
echo "0" > /sys/module/hid_apple/parameters/fnmode
echo "0" > /sys/module/hid_apple/parameters/iso_layout
echo "Y" > /sys/module/hid_logitech_hidpp/parameters/disable_raw_mode
echo "Y" > /sys/module/hid_logitech_hidpp/parameters/disable_tap_to_click
echo "N" > /sys/module/hid_magicmouse/parameters/emulate_3button
echo "N" > /sys/module/hid_magicmouse/parameters/emulate_scroll_wheel
echo "0" > /sys/module/hid_magicmouse/parameters/scroll_speed
echo "0" > /sys/module/icnss/parameters/dynamic_feature_mask
echo "N" > /sys/module/ip6_tunnel/parameters/log_ecn_error
echo "0" > /sys/module/ipc_router_core/parameters/debug_mask
echo "0" > /sys/module/ipc_router_glink_xprt/parameters/debug_mask
echo "0" > /sys/module/ipc_router_smd_xprt/parameters/debug_mask
echo "Y" > /sys/module/libcomposite/parameters/disable_l1_for_hs
echo "0" > /sys/module/lowmemorykiller/parameters/debug_level
echo "Y" > /sys/module/mdss_fb/parameters/backlight_dimmer
echo "0" > /sys/module/msm_glink_pkt/parameters/debug_mask
echo "0" > /sys/module/msm_poweroff/parameters/download_mode
echo "0" > /sys/module/msm_show_resume_irq/parameters/debug_mask
echo "0" > /sys/module/msm_smd/parameters/debug_mask
echo "0" > /sys/module/msm_smem/parameters/debug_mask
echo "0" > /sys/module/msm_spm/parameters/debug_mask
echo "N" > /sys/module/msm_vidc_dyn_gov/parameters/debug
echo "N" > /sys/module/otg_wakelock/parameters/enabled
echo "0" > /sys/module/pci_msm/parameters/debug_mask
echo "0" > /sys/module/pnp/parameters/debug
echo "N" > /sys/module/ppp_generic/parameters/mp_protocol_compress
echo "Y" > /sys/module/printk/parameters/console_suspend
echo "0" > /sys/module/qpnp_fg_gen3/parameters/debug_mask
echo "0" > /sys/module/qpnp_regulator/parameters/debug_mask
echo "0" > /sys/module/qpnp_smb2/parameters/debug_mask
echo "0" > /sys/module/ramoops/parameters/dump_oops
echo "0" > /sys/module/rmnet_data/parameters/rmnet_data_log_level
echo "0" > /sys/module/rmnet_data/parameters/rmnet_data_log_module_mask
echo "0" > /sys/module/rpm_smd/parameters/debug_mask
echo "0" > /sys/module/rpm_smd_regulator/parameters/debug_mask
echo "0" > /sys/module/service_locator/parameters/enable
echo "N" > /sys/module/sit/parameters/log_ecn_error
echo "0" > /sys/module/smb138x_charger/parameters/debug_mask
echo "N" > /sys/module/smb_lib/parameters/enable_ovh
echo "0" > /sys/module/smem_log/parameters/debug_mask
echo "0" > /sys/module/smem_log/parameters/log_enable
echo "0" > /sys/module/smp2p/parameters/debug_mask
echo "Y" > /sys/module/spurious/parameters/noirqdebug
echo "1" > /sys/module/subsystem_restart/parameters/disable_restart_work
# echo "N" > /sys/module/sync/parameters/fsync_enabled
echo "0" > /sys/module/touch_core_base/parameters/debug_mask
echo "0" > /sys/module/usb_bam/parameters/enable_event_log
echo "N" > /sys/module/v4l2_mem2mem/parameters/debug
echo "0" > /sys/module/videobuf2_core/parameters/debug
echo "0" > /sys/module/wlan/parameters/qdf_dbg_mask
echo "0" > /sys/module/xt_qtaguid/parameters/debug_mask

# A miscellaneous pm_async tweak that increases the amount of time (in milliseconds) before user processes & kernel threads are being frozen & "put to sleep";
echo "24000" > /sys/power/pm_freeze_timeout

fstrim /data;
fstrim /cache;
fstrim /system;
sleep 5;

# Script log file location
LOG_FILE=/storage/emulated/0/logs
echo $(date) > /storage/emulated/0/logs/glitchify.log
if [ $? -eq 0 ]
then
  echo "Glitchify was successfuly executed!" >> /storage/emulated/0/logs/glitchify.log
  exit 0
else
  echo "Glitchify was unsuccessful... try again!" >> /storage/emulated/0/logs/glitchify.log
  exit 1
fi
#done

