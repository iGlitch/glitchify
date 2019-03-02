#!/system/bin/sh

#
# BM 1.5
#

sleep 25;

# Filesystem tweaks for better system performance;
busybox mount -o remount,nosuid,nodev,commit=96,noblock_validity,noatime,data=writeback,nodiratime,noauto_da_alloc,relatime -t auto /;
busybox mount -o remount,nosuid,nodev,noatime,nodiratime,relatime -t auto /proc;
busybox mount -o remount,nosuid,nodev,noblock_validity,commit=96,noatime,data=writeback,nodiratime,barrier=0,noauto_da_alloc,relatime -t auto /sys;
busybox mount -o remount,nosuid,nodev,noblock_validity,commit=96,noatime,data=writeback,nodiratime,relatime,barrier=0,noauto_da_alloc,discard -t auto /system;

# Remove Find My Device for enabling GMS Doze;
pm disable com.google.android.gms/com.google.android.gms.mdm.receivers.MdmDeviceAdminReceiver;

# Enable this custom Doze profile for better battery life savings, and less amount of idle drain, when the screen is turned off and our devices is fully supposed to be sleeping;

# Doze battery life profile;
settings put global device_idle_constants light_after_inactive_to=5000,light_pre_idle_to=10000,light_max_idle_to=86400000,light_idle_to=43200000,light_idle_maintenance_max_budget=20000,light_idle_maintenance_min_budget=5000,min_time_to_alarm=60000,inactive_to=120000,motion_inactive_to=120000,idle_after_inactive_to=5000,locating_to=2000,sensing_to=120000,idle_to=7200000,wait_for_unlock=true

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

# Modify and enhance the default CPUSet Google set-up / values for a slight and critically needed battery life bump;
echo "0-3" > /dev/cpuset/background/cpus
echo "0-3" > /dev/cpuset/foreground/cpus
echo "0-3" > /dev/cpuset/kernel/cpus

# Disable that Stune prefers idling cores for saving some extra potential battery percents at the expense of the UX;
# echo "0" > /dev/stune/foreground/schedtune.prefer_idle
# echo "0" > /dev/stune/top-app/schedtune.prefer_idle

# Disable exception-trace and reduce some overhead that is caused by a certain amount and percent of kernel logging, in case your kernel of choice have it enabled;
echo "0" > /proc/sys/debug/exception-trace

# FS tweaks for slightly better userspace performance;
echo "0" > /proc/sys/fs/dir-notify-enable
echo "20" > /proc/sys/fs/lease-break-time

# Fully disable kernel printk console log spamming directly for less amount of useless wakeups (reduces overhead);
echo "0 0 0 0" > /proc/sys/kernel/printk

# A few sched tweaks for improved system responsivness;
echo "15000000" > /proc/sys/kernel/sched_latency_ns
echo "2000000" > /proc/sys/kernel/sched_min_granularity_ns
echo "10000000" > /proc/sys/kernel/sched_wakeup_granularity_ns

# Disable in-kernel sched statistics for reduced overhead;
echo "0" > /proc/sys/kernel/sched_schedstats

# A couple network tweaks for achieving slightly reduced amount of battery consumption when being "actively" connected to either a wifi connection or mobile data;
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
echo "1" > /proc/sys/vm/compact_unevictable_allowed
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

# Turn off all snapshot crashdumper modules;
for i in $(find /sys/ -name snapshot_crashdumper); do
echo "0" > $i;
done

# Disable the pre-enabled wake-vibrate functionality;
echo "0" > /sys/android_touch/wake_vibrate

# Either enable (or disable) CFQ group idle mode for improved scheduling effectivness by merging all of the single IO queues in a "unified group" instead of treating them as fully individual, and standalone, IO based queues;

# Group_idle stock setting;
for i in /sys/block/*/queue/iosched; do
#  echo "0" > $i/group_idle;
done;

# Group_idle customized setting;
for i in /sys/block/*/queue/iosched; do
   echo "8" > $i/group_idle;
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

# Increase PowerHAL interaction boosting just a little bit for reduced stuttering and improved system performance; 
echo "128" > /sys/class/drm/card0/device/idle_timeout_ms

# Turn off the power feeding to the ActiveEdge sensor;
# echo "0" > /sys/class/gpio/gpio1262/value

# Boost GPU rendering by tuning the Adreno 630 GPU into delivering better graphical rendering, with respect to power consumption, by using this performance oriented mode;
echo "0" > /sys/class/kgsl/kgsl-3d0/bus_split
echo "1" > /sys/class/kgsl/kgsl-3d0/force_bus_on
echo "1" > /sys/class/kgsl/kgsl-3d0/force_clk_on
echo "1" > /sys/class/kgsl/kgsl-3d0/force_rail_on

# Disable GPU frequency based throttling;
echo "0" > /sys/class/kgsl/kgsl-3d0/throttling

# Enable a fully tuned and customized Boeffla kernel wakelock blocker for slightly better battery life during idle;
echo "wlan;wlan_pno_wl;wlan_ipa;qcom_rx_wakelock;wlan_wow_wl;netmgr_wl;wlan_extscan_wl;SensorService_wakelock;sensor_ssc_cq;sensor_ssc_worker;IPA_WS;IPA_RM12;hal_bluetooth_lock;" > /sys/class/misc/boeffla_wakelock_blocker/wakelock_blocker

# Tweak and decrease tx_queue_len default stock value(s) for less amount of generated bufferbloat and for gaining slightly faster network speed and performance;
for i in $(find /sys/class/net -type l); do
  echo "128" > $i/tx_queue_len;
done;

# Adjust and optimize Schedutil into delivering even better system peak performance and user interface snappiness while attempting to reduce power consumption and maximizing battery life as far as possible with the less amounts of notable tradeoffs for everyone and nobody;

# Little Cluster;
echo "1516800" > /sys/devices/system/cpu/cpufreq/policy0/schedutil/hispeed_freq
echo "82" > /sys/devices/system/cpu/cpufreq/policy0/schedutil/hispeed_load
echo "444" > /sys/devices/system/cpu/cpufreq/policy0/schedutil/up_rate_limit_us

# Big Cluster;
echo "1286400" > /sys/devices/system/cpu/cpufreq/policy4/schedutil/hispeed_freq
echo "82" > /sys/devices/system/cpu/cpufreq/policy4/schedutil/hispeed_load
echo "444" > /sys/devices/system/cpu/cpufreq/policy4/schedutil/up_rate_limit_us

# Disable a lot of kernel debugging for more than just only massively reduced overhead and better performance;
echo "N" > /sys/kernel/debug/debug_enabled

# Tweak the kernel task scheduler for improved overall system performance and user interface responsivness during all kind of possible workload based scenarios;
echo "NO_GENTLE_FAIR_SLEEPERS" > /sys/kernel/debug/sched_features
echo "NEXT_BUDDY" > /sys/kernel/debug/sched_features
echo "NO_TTWU_QUEUE" > /sys/kernel/debug/sched_features
echo "NO_RT_RUNTIME_SHARE" > /sys/kernel/debug/sched_features

# Enable Fast Charge for slightly faster battery charging when being connected to a USB 3.1 port, which can be good for the people that is often on the run or have limited access to a wall socket;
echo "1" > /sys/kernel/fast_charge/force_fast_charge

# Disable a few minor and overall pretty useless modules for slightly better battery life & system wide performance;
echo "Y" > /sys/module/bluetooth/parameters/disable_ertm
echo "Y" > /sys/module/bluetooth/parameters/disable_esco

# Adjust Sultans CPU Boost driver for better battery life;
echo "25" > /sys/module/cpu_input_boost/parameters/dynamic_stune_boost
echo "50" > /sys/module/cpu_input_boost/parameters/max_stune_boost

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
# echo "1" > /sys/module/msm_drm/parameters/flickerfree_enabled
echo "0" > /sys/module/msm_poweroff/parameters/download_mode
echo "Y" > /sys/module/msm_poweroff/parameters/warm_reset
echo "0" > /sys/module/mt20xx/parameters/tv_antenna
echo "0" > /sys/module/ppp_generic/parameters/mp_protocol_compress
echo "Y" > /sys/module/printk/parameters/console_suspend
echo "0" > /sys/module/rmnet_data/parameters/rmnet_data_log_level
echo "0" > /sys/module/service_locator/parameters/enable
echo "1" > /sys/module/subsystem_restart/parameters/disable_restart_work
echo "Y" > /sys/module/workqueue/parameters/power_efficient

# Enable deep in-memory sleep when suspending for less idle battery drain when the system decides to suspend;
echo "deep" > /sys/power/mem_sleep

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
