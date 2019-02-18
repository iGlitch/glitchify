#!/system/bin/sh

#
# BM 9.6
#

# Pause script execution a little for Magisk Boot Service;
sleep 15;

# Mounting tweak for better overall partition performance;
busybox mount -o remount,nosuid,nodev,commit=90,noatime,data=writeback,nodiratime,noauto_da_alloc,relatime -t auto /;
busybox mount -o remount,nosuid,nodev,noatime,nodiratime,relatime -t auto /proc;
busybox mount -o remount,nosuid,nodev,commit=90,noatime,data=writeback,nodiratime,barrier=0,noauto_da_alloc,relatime -t auto /sys;
busybox mount -o remount,nosuid,nodev,noatime,nodiratime,relatime,barrier=0,noauto_da_alloc,discard -t auto /data;
busybox mount -o remount,nosuid,nodev,commit=90,noatime,data=writeback,nodiratime,relatime,barrier=0,noauto_da_alloc,discard -t auto /system;

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
echo "0" > /dev/stune/foreground/schedtune.prefer_idle
echo "0" > /dev/stune/top-app/schedtune.prefer_idle

# Disable exception-trace and reduce some overhead that is caused by a certain amount and percent of kernel logging, in case your kernel of choice have it enabled;
echo "0" > /proc/sys/debug/exception-trace

# FileSystem (FS) optimized tweaks & enhancements for a improved userspace experience;
echo "0" > /proc/sys/fs/dir-notify-enable
echo "20" > /proc/sys/fs/lease-break-time

# Use my own semi-customized kernel entropy hook config so the urandom generator is fully kept at bay;
echo "128" > /proc/sys/kernel/random/read_wakeup_threshold
echo "96" > /proc/sys/kernel/random/urandom_min_reseed_secs
echo "2560" > /proc/sys/kernel/random/write_wakeup_threshold

# Disable kernel compat based logging once and for all;
echo "0" > /proc/sys/kernel/compat-log

# Fully disable kernel printk console log spamming directly for less amount of useless wakeups (reduces overhead);
echo "0 0 0 0" > /proc/sys/kernel/printk

# A few sched tweaks for improved system responsivness;
echo "15000000" > /proc/sys/kernel/sched_latency_ns
echo "2000000" > /proc/sys/kernel/sched_min_granularity_ns
echo "10000000" > /proc/sys/kernel/sched_wakeup_granularity_ns

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

# Turn off all snapshot crashdumper modules;
for i in $(find /sys/ -name snapshot_crashdumper); do
echo "0" > $i;
done

# Disable gesture based vibration because it is honestly not even worth having enabled at all;
echo "0" > /sys/android_touch/vib_strength

# Enable CFQ group idle mode for improved scheduling effectivness by merging the IO queues in a "unified group" instead of treating them as individual IO based queues;
for i in /sys/block/*/queue/iosched; do
  echo "1" > $i/group_idle;
done;

# Wide block based tuning for reduced lag and less possible amount of general IO scheduling based overhead (Thanks to pkgnex @ XDA for the more than pretty much simplified version of this tweak. You really rock, dude!);
for i in /sys/block/*/queue; do
  echo "0" > $i/add_random;
  echo "0" > $i/iostats;
  echo "0" > $i/nomerges;
  echo "32" > $i/nr_requests;
  echo "128" > $i/read_ahead_kb;
  echo "0" > $i/rotational;
  echo "1" > $i/rq_affinity;
done;

# Shift to and instead use the originally Samsung forked simple_ondemand GPU governor for gaining a better peak balance between battery life and performance for daily usage;
# echo "simple_ondemand" > /sys/class/devfreq/5000000.qcom,kgsl-3d0/governor

# Revert to and use the stock msm-adreno-tz GPU governor if wished;
# echo "msm-adreno-tz" > /sys/class/devfreq/5000000.qcom,kgsl-3d0/governor

# Underclock and strictly cap the maximum allowed GPU frequency just a little with a few steps for overall power consumption and thermal pressure based reasons;
# echo "515000000" > /sys/class/devfreq/5000000.qcom,kgsl-3d0/max_freq

# See my note above regarding the max GPU freq cap;
# echo "515000000" > /sys/class/devfreq/soc:qcom,kgsl-busmon/max_freq

# Boost GPU rendering by tuning the Adreno 540 GPU into delivering better graphical rendering, with respect to power consumption, by using this performance oriented mode;
echo "0" > /sys/class/kgsl/kgsl-3d0/bus_split
echo "1" > /sys/class/kgsl/kgsl-3d0/force_bus_on
echo "1" > /sys/class/kgsl/kgsl-3d0/force_clk_on
echo "1" > /sys/class/kgsl/kgsl-3d0/force_rail_on

# See my previous notes regarding the limitation & capping of the maximal allowed GPU frequency;
# echo "515" > /sys/class/kgsl/kgsl-3d0/max_clock_mhz
# echo "515000000" > /sys/class/kgsl/kgsl-3d0/max_gpuclk

# Disable GPU frequency based throttling;
echo "0" > /sys/class/kgsl/kgsl-3d0/throttling

# Decrease both battery as well as power consumption that is being caused by the screen by lowering how much light the pixels, the built-in LED switches and the LCD backlight module is releasing & "kicking out" by carefully tuning / adjusting their maximum values a little bit to the balanced overall range of their respective spectrums;
echo "170" > /sys/class/leds/blue/max_brightness
echo "170" > /sys/class/leds/green/max_brightness
echo "170" > /sys/class/leds/lcd-backlight/max_brightness
echo "170" > /sys/class/leds/led:switch_0/max_brightness
echo "170" > /sys/class/leds/led:switch_1/max_brightness
echo "170" > /sys/class/leds/red/max_brightness

# Enable a tuned Boeffla wakelock blocker at boot for both better active & idle battery life;
echo "wlan_pno_wl;wlan_ipa;wcnss_filter_lock;[timerfd];hal_bluetooth_lock;IPA_WS;sensor_ind;wlan;netmgr_wl;qcom_rx_wakelock;wlan_wow_wl;wlan_extscan_wl;" > /sys/class/misc/boeffla_wakelock_blocker/wakelock_blocker

# Tweak and decrease tx_queue_len default stock value(s) for less amount of generated bufferbloat and for gaining slightly faster network speed and performance;
for i in $(find /sys/class/net -type l); do
  echo "128" > $i/tx_queue_len;
done;

# Display Calibration that will be close to D65 (6500K) (Boosted). Thanks to Juzman @ XDA for this contribution;
# echo "256 249 226" > /sys/devices/platform/kcal_ctrl.0/kcal
# echo "5" > /sys/devices/platform/kcal_ctrl.0/kcal_min
# echo "257" > /sys/devices/platform/kcal_ctrl.0/kcal_val

# Optimize and lower both the battery drain and overall power consumption that is caused by the Schedutil governor by biasing it to use slightly lower frequency steps, but do this without sacrificing performance or overall UI fluidity. See this as a balanced in-kernel power save mode, but without any notable traces of the "semi-typical" smoothness regressions;

# Little Cluster;
echo "18500" > /sys/devices/system/cpu/cpufreq/policy0/schedutil/down_rate_limit_us
# echo "1" > /sys/devices/system/cpu/cpufreq/policy0/schedutil/iowait_boost_enable
echo "775" > /sys/devices/system/cpu/cpufreq/policy0/schedutil/up_rate_limit_us

# BIG Cluster;
echo "18500" > /sys/devices/system/cpu/cpufreq/policy4/schedutil/down_rate_limit_us
# echo "1" > /sys/devices/system/cpu/cpufreq/policy4/schedutil/iowait_boost_enable
echo "775" > /sys/devices/system/cpu/cpufreq/policy4/schedutil/up_rate_limit_us

# Tweak the kernel task scheduler for improved overall system performance and user interface responsivness during all kind of possible workload based scenarios;
echo "NO_GENTLE_FAIR_SLEEPERS" > /sys/kernel/debug/sched_features
echo "NO_TTWU_QUEUE" > /sys/kernel/debug/sched_features
echo "NO_RT_RUNTIME_SHARE" > /sys/kernel/debug/sched_features

# Enable Fast Charge for slightly faster battery charging when being connected to a USB 3.1 port, which can be good for the people that is often on the run or have limited access to a wall socket;
echo "1" > /sys/kernel/fast_charge/force_fast_charge

# See my note a few steps higher regarding the change from stock to the simple_ondemand GPU governor;
# echo "simple_ondemand" > /sys/kernel/gpu/gpu_governor

# See my short, but explained, note a very few steps up regarding the usage of stock msm-adreno-tz GPU governor;
# echo "msm-adreno-tz" > /sys/kernel/gpu/gpu_governor

# See my previous notes (again) regarding the limitation & capping of the maximal allowed GPU frequency;
# echo "515" > /sys/kernel/gpu/gpu_max_clock

# Turn off a few additional kernel debuggers and what not for gaining a slight boost in both performance and battery life;
echo "Y" > /sys/module/bluetooth/parameters/disable_ertm
echo "Y" > /sys/module/bluetooth/parameters/disable_esco

# Slightly tweak Sultans custom CPU input boosting driver into delivering even more UI smoothness as well as overall system responsivness whenever it is possible;
echo "128" > /sys/module/cpu_input_boost/parameters/input_boost_duration
echo "422400" > /sys/module/cpu_input_boost/parameters/input_boost_freq_hp
echo "825600" > /sys/module/cpu_input_boost/parameters/input_boost_freq_lp

# Turn off even more additional useless kernel debuggers, masks and modules that is not really needed & used at all;
# echo "Y" > /sys/module/cpufreq/parameters/enable_underclock
echo "0" > /sys/module/dwc3/parameters/ep_addr_rxdbg_mask
echo "0" > /sys/module/dwc3/parameters/ep_addr_txdbg_mask
echo "0" > /sys/module/diagchar/parameters/diag_mask_clear_param
echo "0" > /sys/module/hid_apple/parameters/fnmode
echo "N" > /sys/module/hid_logitech_hidpp/parameters/disable_raw_mode
echo "N" > /sys/module/hid_logitech_hidpp/parameters/disable_tap_to_click
echo "N" > /sys/module/hid_magicmouse/parameters/emulate_3button
echo "0" > /sys/module/hid_magicmouse/parameters/scroll_speed
echo "N" > /sys/module/hid_magicmouse/parameters/emulate_scroll_wheel
echo "Y" > /sys/module/mdss_fb/parameters/backlight_dimmer
echo "170" > /sys/module/mdss_fb/parameters/backlight_max
echo "N" > /sys/module/otg_wakelock/parameters/enabled
echo "N" > /sys/module/printk/parameters/always_kmsg_dump
echo "Y" > /sys/module/printk/parameters/console_suspend
echo "N" > /sys/module/printk/parameters/cpu
echo "N" > /sys/module/printk/parameters/pid
echo "0" > /sys/module/service_locator/parameters/enable
echo "1" > /sys/module/subsystem_restart/parameters/disable_restart_work

# A miscellaneous pm_async tweak that increases the amount of time (in milliseconds) before user processes & kernel threads are being frozen & "put to sleep";
echo "25000" > /sys/power/pm_freeze_timeout

# Trim selected partitions at boot for a more than well-deserved and nice speed boost;
#fstrim /data;
#fstrim /cache;
#fstrim /system;

# Push a semi-needed log to the internal storage with a "report" if the script could be executed or not;

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
  
# Wait..
# Done!
#
