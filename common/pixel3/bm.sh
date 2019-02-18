#!/system/bin/sh

#
# BM 1.2
#

# Pause script execution a little for Magisk Boot Service;
sleep 25;

# Mounting tweak for better overall partition performance;
busybox mount -o remount,nosuid,nodev,noatime,nodiratime,relatime -t auto /;
busybox mount -o remount,nosuid,nodev,noatime,nodiratime,relatime -t auto /proc;
busybox mount -o remount,nosuid,nodev,noatime,nodiratime,relatime -t auto /sys;
busybox mount -o remount,nosuid,nodev,noatime,nodiratime,relatime,barrier=0,noauto_da_alloc,discard -t auto /data;
busybox mount -o remount,nodev,noatime,nodiratime,relatime,barrier=0,noauto_da_alloc,discard -t auto /system;

# Tweak the various Flag Tuners for achieving slightly improved multitasking as well as overall better system performance and reduced power consumption;

setprop MIN_HIDDEN_APPS false
setprop ACTIVITY_INACTIVE_RESET_TIME false
setprop MIN_RECENT_TASKS false
setprop PROC_START_TIMEOUT false
setprop CPU_MIN_CHECK_DURATION false
setprop GC_TIMEOUT false
setprop SERVICE_TIMEOUT false
setprop MIN_CRASH_INTERVAL false
setprop ENFORCE_PROCESS_LIMIT false

# Modify and enhance the default CPUSet Google set-up / values for a slight critically needed battery life bump;
echo "0-3" > /dev/cpuset/background/cpus
echo "0-3" > /dev/cpuset/kernel/cpus

# Disable exception-trace and reduce some overhead that is caused by a certain amount and percent of kernel logging, in case your kernel of choice have it enabled;
echo "0" > /proc/sys/debug/exception-trace

# FS tweaks for slightly better userspace performance;
echo "0" > /proc/sys/fs/dir-notify-enable
echo "20" > /proc/sys/fs/lease-break-time

# A few kernel tweaks for improved system responsivness;
echo "15000000" > /proc/sys/kernel/sched_latency_ns
echo "2000000" > /proc/sys/kernel/sched_min_granularity_ns
echo "10000000" > /proc/sys/kernel/sched_wakeup_granularity_ns

# Disable in-kernel sched statistics for reduced overhead;
echo "0" > /proc/sys/kernel/sched_schedstats

# Network tweaks for slightly reduced battery consumption when being actively connected to a network;
echo "128" > /proc/sys/net/core/netdev_max_backlog
echo "0" > /proc/sys/net/core/netdev_tstamp_prequeue
echo "0" > /proc/sys/net/ipv4/cipso_cache_bucket_size
echo "0" > /proc/sys/net/ipv4/cipso_cache_enable
echo "0" > /proc/sys/net/ipv4/cipso_rbm_strictvalid
echo "0" > /proc/sys/net/ipv4/igmp_link_local_mcast_reports
echo "24" > /proc/sys/net/ipv4/ipfrag_time
echo "westwood" > /proc/sys/net/ipv4/tcp_congestion_control
echo "1" > /proc/sys/net/ipv4/tcp_ecn
echo "0" > /proc/sys/net/ipv4/tcp_fwmark_accept
echo "320" > /proc/sys/net/ipv4/tcp_keepalive_intvl
echo "21600" > /proc/sys/net/ipv4/tcp_keepalive_time
echo "1" > /proc/sys/net/ipv4/tcp_no_metrics_save
echo "1800" > /proc/sys/net/ipv4/tcp_probe_interval
echo "0" > /proc/sys/net/ipv4/tcp_slow_start_after_idle
echo "0" > /proc/sys/net/ipv6/calipso_cache_bucket_size
echo "0" > /proc/sys/net/ipv6/calipso_cache_enable
echo "48" > /proc/sys/net/ipv6/ip6frag_time

# Virtual Memory tweaks & enhancements for a massively improved balance between performance and battery life;
echo "0" > /proc/sys/vm/compact_unevictable_allowed
echo "3" > /proc/sys/vm/dirty_background_ratio
echo "500" > /proc/sys/vm/dirty_expire_centisecs
echo "30" > /proc/sys/vm/dirty_ratio
echo "3000" > /proc/sys/vm/dirty_writeback_centisecs
echo "0" > /proc/sys/vm/oom_dump_tasks
echo "0" > /proc/sys/vm/oom_kill_allocating_task
echo "1200" > /proc/sys/vm/stat_interval
echo "0" > /proc/sys/vm/swap_ratio
echo "20" > /proc/sys/vm/swappiness
echo "60" > /proc/sys/vm/vfs_cache_pressure

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

# Enable CFQ group idle mode for improved scheduling effectivness by merging the IO queues in a "unified group" instead of treating them as individual IO based queues;
for i in /sys/block/*/queue/iosched; do
  echo "1" > $i/group_idle;
done;

# Wide block based tuning for reduced lag and less possible amount of general IO scheduling based overhead (Thanks to pkgnex @ XDA for the more than pretty much simplified version of this tweak. You really rock, dude!);
for i in /sys/block/*/queue; do
  echo "0" > $i/add_random;
  echo "0" > $i/io_poll;
  echo "0" > $i/iostats;
  echo "0" > $i/nomerges;
  echo "32" > $i/nr_requests;
  echo "128" > $i/read_ahead_kb;
  echo "0" > $i/rotational;
  echo "1" > $i/rq_affinity;
  echo "write through" > $i/write_cache;
done;

# Disable GPU throttling because it's more or less useless;
echo "0" > /sys/class/kgsl/kgsl-3d0/throttling

# Enable a fully tuned and customized Boeffla kernel wakelock blocker for slightly better battery life during idle;
echo "wlan;qcom_rx_wakelock;netmgr_wl;IPA_WS;fts_tp;sthal_transit_wake_lock;IPA_RM12;hal_bluetooth_lock;IPA_RM14;" > /sys/class/misc/boeffla_wakelock_blocker/wakelock_blocker

# Tweak and decrease tx_queue_len default stock value(s) for less amount of generated bufferbloat and for gaining slightly faster network speed and performance;
for i in $(find /sys/class/net -type l); do
  echo "128" > $i/tx_queue_len;
done;

# Disable Gentle Fair Sleepers for better UI smoothness;
echo "NO_GENTLE_FAIR_SLEEPERS" > /sys/kernel/debug/sched_features

# Enable Fast Charge for slightly faster battery charging when being connected to a USB 3.1 port, which can be good for the people that is often on the run or have limited access to a wall socket;
echo "1" > /sys/kernel/fast_charge/force_fast_charge

# Disable a few minor and overall pretty useless modules for slightly better battery life & system wide performance;
echo "Y" > /sys/module/bluetooth/parameters/disable_ertm
echo "Y" > /sys/module/bluetooth/parameters/disable_esco

# Tweak the custom boosting drivers and give everyone the choice enable & apply what they might prefer to use;
# echo "15" > /sys/module/cpu_input_boost/parameters/dynamic_stune_boost # Dynamic Stune
# echo "825600" > /sys/module/cpu_input_boost/parameters/general_boost_freq_hp # Dynamic Stune
# echo "979200" > /sys/module/cpu_input_boost/parameters/general_boost_freq_lp # Dynamic Stune
# echo "15" > /sys/module/cpu_input_boost/parameters/general_stune_boost # Dynamic Stune
# echo "825600" > /sys/module/cpu_input_boost/parameters/input_boost_awake_return_freq_hp # CPU Input Boost
# echo "576000" > /sys/module/cpu_input_boost/parameters/input_boost_awake_return_freq_lp # CPU Input Boost
# echo "1555" > /sys/module/cpu_input_boost/parameters/input_boost_duration # Dynamic Stune
# echo "64" > /sys/module/cpu_input_boost/parameters/input_boost_duration # CPU Input Boost
# echo "825600" > /sys/module/cpu_input_boost/parameters/input_boost_freq_hp # CPU Input Boost
# echo "1228800" > /sys/module/cpu_input_boost/parameters/input_boost_freq_lp # CPU Input Boost
# echo "0" > /sys/module/cpu_input_boost/parameters/remove_input_boost_freq_lp # CPU Input Boost
# echo "0" > /sys/module/cpu_input_boost/parameters/remove_input_boost_freq_perf # CPU Input Boost

# Turn off even more additional useless kernel debuggers, masks and modules that is not really needed & used at all;
echo "Y" > /sys/module/cryptomgr/parameters/notests
echo "0" > /sys/module/diagchar/parameters/diag_mask_clear_param
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
echo "0" > /sys/module/mt20xx/parameters/tv_antenna
echo "0" > /sys/module/ppp_generic/parameters/mp_protocol_compress
echo "0" > /sys/module/rmnet_data/parameters/rmnet_data_log_level
echo "0" > /sys/module/service_locator/parameters/enable
# echo "N" > /sys/module/sync/parameters/fsync_enabled
echo "Y" > /sys/module/workqueue/parameters/power_efficient

# Enable deep in-memory sleep when suspending for less idle battery drain when the system decides to suspend;
echo "deep" > /sys/power/mem_sleep

# Trim selected partitions at boot for a more than well-deserved and nice speed boost;
# fstrim /data;
# fstrim /cache;
# fstrim /system;

# Push a semi-needed log to the internal storage with a "report" if the script could be executed or not;

# Script log file location;
LOG_FILE=/storage/emulated/0/logs
echo $(date) > /storage/emulated/0/logs/glitchify.log
if [ $? -eq 0 ]
then
  echo "Glitchify was successfully executed!" >> /storage/emulated/0/logs/glitchify.log
  exit 0
else
  echo "Glitchify was unsuccessful... try again!" >> /storage/emulated/0/logs/glitchify.log
  exit 1
fi
  
# Wait..
# Done!
#
