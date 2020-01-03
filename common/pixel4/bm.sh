#!/system/bin/sh

# BM 2.9

# Pause script execution a little for Magisk Boot Service;
sleep 120;

# A few strictly, and carefully, selected filesystem mounting tweaks and enhancements for better system performance;
busybox mount -o remount,nosuid,nodev,noatime,nodiratime,noauto_da_alloc,barrier=0 -t auto /;
busybox mount -o remount,nosuid,nodev,noatime,nodiratime -t auto /proc;
busybox mount -o remount,nosuid,nodev,noatime,nodiratime,noauto_da_alloc,barrier=0 -t auto /sys;

# Disable exception-trace kernel debugging;
echo "0" > /proc/sys/debug/exception-trace

# Disable SCSI logging;
echo "0" > /proc/sys/dev/scsi/logging_level

# Disable / prevent the possibility of autoloading ldiscs;
echo "0" > /proc/sys/dev/tty/ldisc_autoload

# FS tweaks for slightly better userspace performance;
echo "0" > /proc/sys/fs/dir-notify-enable
echo "20" > /proc/sys/fs/lease-break-time

# Disable scheduling stats for overall reduced overhead;
echo "0" > /proc/sys/kernel/sched_schedstats

# Set Westwood as the default TCP congestion algorithm;
echo "westwood" > /proc/sys/net/ipv4/tcp_congestion_control

# A few virtual memory tweaks for improved battery life;
echo "500" > /proc/sys/vm/dirty_expire_centisecs
echo "3000" > /proc/sys/vm/dirty_writeback_centisecs
echo "5" > /proc/sys/vm/laptop_mode
echo "0" > /proc/sys/vm/oom_dump_tasks
echo "1" > /proc/sys/vm/oom_kill_allocating_task
echo "0" > /proc/sys/vm/reap_mem_on_sigkill
echo "1200" > /proc/sys/vm/stat_interval

# Flash storages doesn't comes with any back seeking problems, so set this as low as possible for performance;
for i in /sys/block/sd*/queue/iosched; do
  echo "1" > $i/back_seek_penalty;
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

# Set the default PowerHAL CPU boosting to a ideal value;
echo "128" > /sys/class/drm/card0/device/idle_timeout_ms

# Disable GPU frequency based throttling;
echo "0" > /sys/class/kgsl/kgsl-3d0/throttling

# Block a few safe wakelocks for improved battery life;
echo "wlan_wow_wl;wlan_extscan_wl;wlan;qcom_rx_wakelock;netmgr_wl;" > /sys/class/misc/boeffla_wakelock_blocker/wakelock_blocker

# Tweak and decrease tx_queue_len default stock value(s) for less amount of generated bufferbloat and for gaining slightly faster network speed and performance;
for i in $(find /sys/class/net -type l); do
  echo "128" > $i/tx_queue_len;
done;

# Enable the screen panel ULPS power saving features;

# For Google Pixel 4 XL;
echo "Y" > /sys/kernel/debug/dsi_s6e3hc2_cmd_display/dsi-phy-0_allow_phy_power_off
echo "Y" > /sys/kernel/debug/dsi_s6e3hc2_cmd_display/ulps_feature_enable

# Disable some additional excessive kernel debugging;
echo "N" > /sys/kernel/debug/debug_enabled

# Disable some excessive sched biased debugging;
echo "N" > /sys/kernel/debug/sched_debug

# Configure sched_features for potentially reduced power consumption with a non-existing performance impact and short of obviously the completely opposite case if possible;
echo "NO_GENTLE_FAIR_SLEEPERS" > /sys/kernel/debug/sched_features
echo "NO_TTWU_QUEUE" > /sys/kernel/debug/sched_features
echo "NO_RT_RUNTIME_SHARE" > /sys/kernel/debug/sched_features
echo "NO_EAS_PREFER_IDLE" > /sys/kernel/debug/sched_features

# Use RCU_normal instead of RCU_expedited for improved real-time latency, CPU utilization and energy efficiency;
echo "0" > /sys/kernel/rcu_expedited
echo "1" > /sys/kernel/rcu_normal

# Enable Fast Charge for slightly faster battery charging through a USB 3.1 port which can be good for the people that is often on the run or have limited access to a wall socket;
echo "1" > /sys/kernel/fast_charge/force_fast_charge

# Disable a few minor and overall pretty useless modules for slightly better battery life & system wide performance;
echo "0" > /sys/module/battery/parameters/debug_mask
echo "0" > /sys/module/binder/parameters/debug_mask
echo "0" > /sys/module/binder_alloc/parameters/debug_mask
echo "Y" > /sys/module/bluetooth/parameters/disable_ertm
echo "Y" > /sys/module/bluetooth/parameters/disable_esco
echo "0" > /sys/module/cam_debug_util/parameters/debug_mdl
echo "N" > /sys/module/cam_ois_core/parameters/ois_debug
echo "Y" > /sys/module/cryptomgr/parameters/notests
echo "0" > /sys/module/diagchar/parameters/diag_mask_clear_param
echo "0" > /sys/module/dns_resolver/parameters/debug
echo "0" > /sys/module/drm/parameters/debug
echo "N" > /sys/module/drm_kms_helper/parameters/poll
echo "0" > /sys/module/dwc3/parameters/ep_addr_rxdbg_mask
echo "0" > /sys/module/dwc3/parameters/ep_addr_txdbg_mask
echo "0" > /sys/module/event_timer/parameters/debug_mask
echo "0" > /sys/module/glink_pkt/parameters/debug_mask
echo "0" > /sys/module/hid/parameters/debug
echo "0" > /sys/module/hid/parameters/ignore_special_drivers
echo "0" > /sys/module/hid_apple/parameters/fnmode
echo "0" > /sys/module/hid_apple/parameters/iso_layout
echo "N" > /sys/module/hid_magicmouse/parameters/emulate_3button
echo "N" > /sys/module/hid_magicmouse/parameters/emulate_scroll_wheel
echo "0" > /sys/module/hid_magicmouse/parameters/scroll_speed
echo "0" > /sys/module/icnss/parameters/dynamic_feature_mask
echo "N" > /sys/module/ip6_tunnel/parameters/log_ecn_error
echo "Y" > /sys/module/libcomposite/parameters/disable_l1_for_hs
echo "0" > /sys/module/mhi_qcom/parameters/debug_mode
echo "Y" > /sys/module/msm_drm/parameters/backlight_dimmer
echo "0" > /sys/module/msm_poweroff/parameters/download_mode
echo "0" > /sys/module/msm_show_resume_irq/parameters/debug_mask
echo "N" > /sys/module/msm_vidc_ar50_dyn_gov/parameters/debug
echo "N" > /sys/module/msm_vidc_dyn_gov/parameters/debug
echo "0" > /sys/module/pci_msm/parameters/debug_mask
echo "N" > /sys/module/ppp_generic/parameters/mp_protocol_compress
echo "Y" > /sys/module/printk/parameters/console_suspend
echo "0" > /sys/module/ramoops/parameters/dump_oops
echo "0" > /sys/module/scsi_mod/parameters/scsi_logging_level
echo "0" > /sys/module/service_locator/parameters/enable
echo "N" > /sys/module/sit/parameters/log_ecn_error
echo "1" > /sys/module/subsystem_restart/parameters/disable_restart_work
# echo "N" > /sys/module/sync/parameters/fsync_enabled
echo "0" > /sys/module/usb_bam/parameters/enable_event_log
echo "Y" > /sys/module/workqueue/parameters/power_efficient

# Set mem_sleep state to the more conservative s2idle;
echo "deep" > /sys/power/mem_sleep

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

