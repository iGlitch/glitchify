#!/system/bin/sh

# BM 2.1

# Pause script execution a little for Magisk Boot Service;
sleep 55;

# Manually force all of the kernel tasks to be applied upon the low power cores / cluster for power saving reasons;
echo "0-3" > /dev/cpuset/kernel/cpus

# FS tweaks for slightly better userspace performance;
echo "0" > /proc/sys/fs/dir-notify-enable
echo "20" > /proc/sys/fs/lease-break-time

# A very few minor kernel scheduling tweaks for overall lowered battery consumption while delivering a smooth, snappy and highly responsive system back to the user;
echo "15000000" > /proc/sys/kernel/sched_latency_ns
echo "1000000" > /proc/sys/kernel/sched_min_granularity_ns
echo "2000000" > /proc/sys/kernel/sched_wakeup_granularity_ns

# Disable in-kernel sched statistics for reduced overhead;
echo "0" > /proc/sys/kernel/sched_schedstats

# A couple network tweaks for achieving slightly reduced amount of battery consumption when being "actively" connected to either a wifi connection or mobile data;
echo "0" > /proc/sys/net/core/netdev_tstamp_prequeue
echo "0" > /proc/sys/net/ipv4/cipso_cache_bucket_size
echo "0" > /proc/sys/net/ipv4/cipso_cache_enable
echo "0" > /proc/sys/net/ipv4/cipso_rbm_strictvalid
echo "0" > /proc/sys/net/ipv4/igmp_link_local_mcast_reports
echo "westwood" > /proc/sys/net/ipv4/tcp_congestion_control
echo "1" > /proc/sys/net/ipv4/tcp_ecn
echo "1" > /proc/sys/net/ipv4/tcp_no_metrics_save
echo "0" > /proc/sys/net/ipv4/tcp_slow_start_after_idle
echo "0" > /proc/sys/net/ipv6/calipso_cache_bucket_size
echo "0" > /proc/sys/net/ipv6/calipso_cache_enable

# A few virtual memory tweaks for improved battery life while boosting overall  needed system performance;
echo "500" > /proc/sys/vm/dirty_expire_centisecs
echo "3000" > /proc/sys/vm/dirty_writeback_centisecs
echo "0" > /proc/sys/vm/oom_dump_tasks
echo "1200" > /proc/sys/vm/stat_interval
echo "0" > /proc/sys/vm/swap_ratio

# Turn off all debug_mask based sysfs kernel tunables;
for i in $(find /sys/ -name debug_mask); do
echo "0" > $i;
done

# Turn off all debug_level based sysfs kernel tunables;
for i in $(find /sys/ -name debug_level); do
echo "0" > $i;
done

# Turn off all edac logging kernel based sysfs tunables;
for i in $(find /sys/ -name edac_mc_log_ce); do
echo "0" > $i;
done

# Turn off all edac logging kernel based sysfs tunables;
for i in $(find /sys/ -name edac_mc_log_ue); do
echo "0" > $i;
done

# Turn off a few event logging based sysfs kernel tunables;
for i in $(find /sys/ -name enable_event_log); do
echo "0" > $i;
done

# Turn off a few ECN kernel based sysfs loggers;
for i in $(find /sys/ -name log_ecn_error); do
echo "0" > $i;
done

# Disable the pre-enabled wake-vibrate functionality;
echo "0" > /sys/android_touch/wake_vibrate

# Wide block based tuning for reduced lag and less possible amount of general IO scheduling based overhead (Thanks to pkgnex @ XDA for the more than pretty much simplified version of this tweak. You really rock, dude!);
for i in /sys/block/*/queue; do
  echo "0" > $i/add_random;
  echo "0" > $i/io_poll
  echo "0" > $i/iostats;
  echo "0" > $i/nomerges;
  echo "128" > $i/read_ahead_kb;
  echo "0" > $i/rotational;
  echo "1" > $i/rq_affinity;
  echo "cfq" > $i/scheduler;
  echo "write back" > $i/write_cache;
done;

# Slightly reduce the length of Android PowerHAL boosting duration so it matches the input boost duration on Sultans custom CPU input boosting driver, which should more or less result in, and lead to, overall improved battery life;
echo "64" > /sys/class/drm/card0/device/idle_timeout_ms

# Disable GPU frequency based throttling;
echo "0" > /sys/class/kgsl/kgsl-3d0/throttling

# Tweak and decrease tx_queue_len default stock value(s) for less amount of generated bufferbloat and for gaining slightly faster network speed and performance;
for i in $(find /sys/class/net -type l); do
  echo "128" > $i/tx_queue_len;
done;

# Improve both the scaling responsivness and power efficiency of the Schedutil governor by biasing both clusters to use slightly lower frequency steps as often as possible while delivering system performance that is critically needed for the average users usage patterns;

# Little Cluster;
echo "65" > /sys/devices/system/cpu/cpufreq/policy0/schedutil/hispeed_load
echo "1420800" > /sys/devices/system/cpu/cpufreq/policy0/schedutil/hispeed_freq

# Big Cluster;
echo "85" > /sys/devices/system/cpu/cpufreq/policy4/schedutil/hispeed_load
echo "1996800" > /sys/devices/system/cpu/cpufreq/policy4/schedutil/hispeed_freq

# Use the deepest CPU idle state for a few additional power savings if your kernel of choice now supports it;
echo "1" > /sys/devices/system/cpu/cpuidle/use_deepest_state

# Enable display / screen panel power saving features;
echo "Y" > /sys/kernel/debug/dsi_sw43408_cmd_display/dsi-phy-0_allow_phy_power_off
echo "Y" > /sys/kernel/debug/dsi_sw43408_cmd_display/ulps_enable

# Disable some additional excessive kernel debugging;
echo "N" > /sys/kernel/debug/debug_enabled

# Enable FBT Strict Order for power saving reasons;
echo "FBT_STRICT_ORDER" > /sys/kernel/debug/sched_features

# Use RCU_normal instead of RCU_expedited for improved real-time latency, CPU utilization and energy efficiency;
echo "0" > /sys/kernel/rcu_expedited
echo "1" > /sys/kernel/rcu_normal

# Enable Fast Charge for slightly faster battery charging when being connected to a USB 3.1 port, which can be good for the people that is often on the run or have limited access to a wall socket;
echo "1" > /sys/kernel/fast_charge/force_fast_charge

# Disable a few minor and overall pretty useless modules for slightly better battery life & system wide performance;
echo "Y" > /sys/module/bluetooth/parameters/disable_ertm
echo "Y" > /sys/module/bluetooth/parameters/disable_esco

# Slightly configure Sultans custom CPU input boost driver for better system performance as well as battery life;
echo "15" > /sys/module/cpu_input_boost/parameters/dynamic_stune_boost
echo "1228800" > /sys/module/cpu_input_boost/parameters/input_boost_freq_lp
echo "1420800" > /sys/module/cpu_input_boost/parameters/max_boost_freq_lp

# Turn off even more additional useless kernel debuggers, masks and modules that is not really needed & used at all;
echo "Y" > /sys/module/cryptomgr/parameters/notests
echo "0" > /sys/module/diagchar/parameters/diag_mask_clear_param
echo "N" > /sys/module/drm_kms_helper/parameters/poll
echo "0" > /sys/module/dwc3/parameters/ep_addr_rxdbg_mask
echo "0" > /sys/module/dwc3/parameters/ep_addr_txdbg_mask
echo "1" > /sys/module/hid/parameters/ignore_special_drivers
echo "0" > /sys/module/hid_apple/parameters/fnmode
echo "0" > /sys/module/hid_apple/parameters/iso_layout
echo "0" > /sys/module/hid_magicmouse/parameters/emulate_3button
echo "0" > /sys/module/hid_magicmouse/parameters/emulate_scroll_wheel
echo "0" > /sys/module/icnss/parameters/dynamic_feature_mask
echo "0" > /sys/module/lowmemorykiller/parameters/lmk_fast_run
echo "0" > /sys/module/lowmemorykiller/parameters/oom_reaper
echo "Y" > /sys/module/msm_drm/parameters/backlight_dimmer
# echo "1" > /sys/module/msm_drm/parameters/flickerfree_enabled
echo "0" > /sys/module/msm_poweroff/parameters/download_mode
echo "0" > /sys/module/mt20xx/parameters/tv_antenna
echo "0" > /sys/module/ppp_generic/parameters/mp_protocol_compress
echo "Y" > /sys/module/printk/parameters/console_suspend
echo "0" > /sys/module/rmnet_data/parameters/rmnet_data_log_level
echo "0" > /sys/module/service_locator/parameters/enable
echo "1" > /sys/module/subsystem_restart/parameters/disable_restart_work
echo "Y" > /sys/module/workqueue/parameters/power_efficient

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
