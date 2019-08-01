#!/system/bin/sh

# BM 1.7

# Pause script execution a little for Magisk Boot Service;
sleep 120;

# A few strictly, and carefully, selected filesystem mounting tweaks and enhancements for better system performance;
busybox mount -o remount,nosuid,nodev,noatime,nodiratime,noblock_validity,barrier=0 -t auto /;
busybox mount -o remount,nosuid,nodev,noatime,nodiratime -t auto /proc;
busybox mount -o remount,nosuid,nodev,noatime,nodiratime,noblock_validity,barrier=0 -t auto /sys;
busybox mount -o remount,nodev,noatime,nodiratime,noblock_validity,barrier=0,noauto_da_alloc,discard -t auto /system;

# FS tweaks for slightly better userspace performance;
echo "0" > /proc/sys/fs/dir-notify-enable
echo "20" > /proc/sys/fs/lease-break-time

# Disable printk log spamming to the console;
echo "0 0 0 0" > /proc/sys/kernel/printk

# Disable sched_stats for a minor overhead reduction;
echo "0" > /proc/sys/kernel/sched_schedstats

# For reducing overall power consumption, adjust the kernel task scheduler into lower the total 'allowed' amount of task swapping;
echo "15000000" > /proc/sys/kernel/sched_latency_ns
echo "2000000" > /proc/sys/kernel/sched_min_granularity_ns
echo "10000000" > /proc/sys/kernel/sched_wakeup_granularity_ns

# Use the Westwood TCP congestion control algorithm instead;
echo "westwood" > /proc/sys/net/ipv4/tcp_congestion_control

# A few minor virtual memory enhancing tweaks for improved battery life while boosting overall needed system performance;
echo "500" > /proc/sys/vm/dirty_expire_centisecs
echo "3000" > /proc/sys/vm/dirty_writeback_centisecs
echo "0" > /proc/sys/vm/oom_dump_tasks
echo "1" > /proc/sys/vm/oom_kill_allocating_task
echo "1200" > /proc/sys/vm/stat_interval
echo "0" > /proc/sys/vm/swap_ratio

# Disable a few useless screen wakeup methods / alternatives:
echo "0" > /sys/android_touch/vib_strength
echo "0" > /sys/android_touch/wake_vibrate

# Wide block based tuning for reduced lag as well as jank and less possible amount of general IO scheduling based system overhead (A lot of thanks to pkgnex @ XDA for the more than pretty much simplified version of this tweak. You rock, dude!);
for i in /sys/block/*/queue; do
  echo "0" > $i/add_random;
  echo "0" > $i/io_poll;
  echo "0" > $i/iostats;
  echo "0" > $i/nomerges;
  echo "128" > $i/read_ahead_kb;
  echo "0" > $i/rotational;
  echo "1" > $i/rq_affinity;
  echo "cfq" > $i/scheduler;
  echo "write back" > $i/write_cache;
done;

# Disable frequency scaling throttling of the Adreno GPU circuits;
echo "0" > /sys/class/kgsl/kgsl-3d0/throttling

# Silence the qcom_rx_wakelock kernel wakelock because it's completely worthless and isn't even doing anything useful at all;
echo "qcom_rx_wakelock;" > /sys/class/misc/boeffla_wakelock_blocker/wakelock_blocker

# Decrease tx_queue_len default stock value(s) for less amount of  bufferbloat and for slightly faster network speed in the long run;
for i in $(find /sys/class/net -type l); do
  echo "128" > $i/tx_queue_len;
done;

# Allow the performance cluster to rapidly increase it's frequency to a freq step that is between the lowest and highest end of the frequency spectrum for strictly raw performance reasons. But do this by carefully selecting a middle frequency that is conservative high enough for keeping the phone both smooth as well as snappy, but without by any possible means increasing overall power consumption or affecting battery life in a notable way;

# Big cluster;
echo "1363200" > /sys/devices/system/cpu/cpufreq/policy6/schedutil/hispeed_freq
echo "70" > /sys/devices/system/cpu/cpufreq/policy6/schedutil/hispeed_load

# Now when the "allowed" maximum and minimum freqs have been changed all the way to the bone, then increase the Schedutil up_rate limit for both clusters to 1000us for a slightly reduced amount of "rapid noisy" frequency scaling across the board;

# LITTLE Cluster;
echo "1000" > /sys/devices/system/cpu/cpufreq/policy0/schedutil/up_rate_limit_us

# LITTLE Cluster;
echo "1000" > /sys/devices/system/cpu/cpufreq/policy6/schedutil/up_rate_limit_us

# Increase the minimum LITTLE cluster freq as a completely needed compensation, from a performance based point of view, for the altered big cluster maximum and minimum frequencies;
echo "998400" > /sys/devices/system/cpu/cpufreq/policy0/scaling_min_freq

# Reduce both the minimum as well as the maximum allowed frequencies on the big cluster for overall power saving reasons;
echo "1747200" > /sys/devices/system/cpu/cpufreq/policy6/scaling_max_freq
echo "300000" > /sys/devices/system/cpu/cpufreq/policy6/scaling_min_freq

# Enable all of the "built-in" display panel power saving props;
echo "Y" > /sys/kernel/debug/dsi_sofef00_sdc_1080p_cmd_display/dsi-phy-0_allow_phy_power_off
echo "Y" > /sys/kernel/debug/dsi_sofef00_sdc_1080p_cmd_display/ulps_enable

# Turn off some pretty useless kernel debugging;
echo "N" > /sys/kernel/debug/debug_enabled

# Disable Gentle_Fair_Sleepers for a UI responsivness boost;
echo "NO_GENTLE_FAIR_SLEEPERS" > /sys/kernel/debug/sched_features

# Disable RT_Runtime_Share because the performance penalty that is being caused by the risk of the CPU (cores) being unable to service non-realtime based tasks, which is being strictly scheduled on a specific CPU core, is not even worth it at all;
echo "NO_RT_RUNTIME_SHARE" > /sys/kernel/debug/sched_features

# Use RCU_normal instead of RCU_expedited for improved real-time latency, CPU utilization and energy efficiency;
echo "0" > /sys/kernel/rcu_expedited
echo "1" > /sys/kernel/rcu_normal

# Fully disable a lot of various miscellaneous kernel based modules for hopefully overall reduced system overhead;
echo "0" > /sys/module/binder/parameters/debug_mask
echo "Y" > /sys/module/bluetooth/parameters/disable_ertm
echo "Y" > /sys/module/bluetooth/parameters/disable_esco
echo "Y" > /sys/module/cryptomgr/parameters/notests
echo "0" > /sys/module/diagchar/parameters/diag_mask_clear_param
echo "0" > /sys/module/dwc3/parameters/ep_addr_rxdbg_mask
echo "0" > /sys/module/dwc3/parameters/ep_addr_txdbg_mask
echo "0" > /sys/module/glink/parameters/debug_mask
echo "0" > /sys/module/glink_smem_native_xprt/parameters/debug_mask
echo "1" > /sys/module/hid/parameters/ignore_special_drivers
echo "0" > /sys/module/hid_apple/parameters/fnmode
echo "0" > /sys/module/hid_apple/parameters/iso_layout
echo "N" > /sys/module/hid_magicmouse/parameters/emulate_3button
echo "N" > /sys/module/hid_magicmouse/parameters/emulate_scroll_wheel
echo "0" > /sys/module/hid_magicmouse/parameters/scroll_speed
echo "0" > /sys/module/icnss/parameters/dynamic_feature_mask
echo "N" > /sys/module/ip6_tunnel/parameters/log_ecn_error
echo "Y" > /sys/module/libcomposite/parameters/disable_l1_for_hs
echo "Y" > /sys/module/msm_drm/parameters/backlight_dimmer
echo "0" > /sys/module/msm_poweroff/parameters/download_mode
echo "0" > /sys/module/msm_show_resume_irq/parameters/debug_mask
echo "0" > /sys/module/msm_smem/parameters/debug_mask
echo "0" > /sys/module/msm_smp2p/parameters/debug_mask
echo "0" > /sys/module/mt20xx/parameters/tv_antenna
echo "Y" > /sys/module/printk/parameters/console_suspend
echo "0" > /sys/module/rmnet_data/parameters/rmnet_data_log_level
echo "0" > /sys/module/service_locator/parameters/enable
echo "N" > /sys/module/sit/parameters/log_ecn_error
echo "1" > /sys/module/subsystem_restart/parameters/disable_restart_work
# echo "N" > /sys/module/sync/parameters/fsync_enabled
echo "0" > /sys/module/usb_bam/parameters/enable_event_log
echo "N" > /sys/module/workqueue/parameters/power_efficient

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
