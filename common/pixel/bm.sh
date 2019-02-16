#!/system/bin/sh

#BM 3.0

# Disable sysctl.conf to prevent ROM interference
if [ -e /system/etc/sysctl.conf ]; then
  mount -o remount,rw /system;
  mv /system/etc/sysctl.conf /system/etc/sysctl.conf.bak;
  mount -o remount,ro /system;
fi;

# Mounting tweak for better overall partition performance;
busybox mount -o remount,nosuid,nodev,noatime,nodiratime -t auto /;
busybox mount -o remount,nosuid,nodev,noatime,nodiratime -t auto /proc;
busybox mount -o remount,nosuid,nodev,noatime,nodiratime -t auto /sys;
busybox mount -o remount,nosuid,nodev,noatime,nodiratime,barrier=0,noauto_da_alloc,discard -t auto /data;
busybox mount -o remount,nodev,noatime,nodiratime,barrier=0,noauto_da_alloc,discard -t auto /system;

# Enable & include my own customized CPUSet configuration for better overall performance and battery life for daily usage;
echo "3" > /dev/cpuset/background/cpus
echo "1,3" > /dev/cpuset/camera-daemon/cpus
echo "0-1" > /dev/cpuset/foreground/cpus
echo "2" > /dev/cpuset/kernel/cpus
echo "2-3" > /dev/cpuset/restricted/cpus
echo "2-3" > /dev/cpuset/system-background/cpus
echo "0-3" > /dev/cpuset/top-app/cpus

# Enable and set Schedtune foreground boosting value to a strict value for gaining a well-deserved responsivness boost with one extra snap on top of it;
echo "5" > /dev/stune/foreground/schedtune.boost

# Disable exception-trace and reduce some overhead that is caused by a certain amount and percent of kernel logging, in case your kernel of choice have it enabled;
echo "0" > /proc/sys/debug/exception-trace

# FileSystem (FS) optimized tweaks & enhancements for a improved userspace experience;
echo "0" > /proc/sys/fs/dir-notify-enable
echo "20" > /proc/sys/fs/lease-break-time

# A couple of minor kernel entropy tweaks & enhancements for a slight UI responsivness boost;
echo "128" > /proc/sys/kernel/random/read_wakeup_threshold
echo "96" > /proc/sys/kernel/random/urandom_min_reseed_secs
echo "2560" > /proc/sys/kernel/random/write_wakeup_threshold

# Kernel based tweaks that reduces the total amount of wasted CPU cycles and gives back a huge amount of needed performance as well as battery life savings to both the whole system and the user experience itself;
echo "0" > /proc/sys/kernel/compat-log
echo "0" > /proc/sys/kernel/panic
echo "0" > /proc/sys/kernel/panic_on_oops
echo "0" > /proc/sys/kernel/perf_cpu_time_max_percent
echo "15000000" > /proc/sys/kernel/sched_latency_ns
echo "2000000" > /proc/sys/kernel/sched_min_granularity_ns
echo "10000000" > /proc/sys/kernel/sched_wakeup_granularity_ns

# Increase how much CPU bandwidth (CPU time) realtime scheduling processes are given for slightly improved system stability and minimized chance of system freezes & lockups;
echo "980000" > /proc/sys/kernel/sched_rt_runtime_us

# Network tweaks for slightly reduced battery consumption when being "actively" connected to a network connection;
echo "128" > /proc/sys/net/core/netdev_max_backlog
echo "0" > /proc/sys/net/core/netdev_tstamp_prequeue
echo "24" > /proc/sys/net/ipv4/ipfrag_time
echo "westwood" > /proc/sys/net/ipv4/tcp_congestion_control
echo "1" > /proc/sys/net/ipv4/tcp_ecn
echo "0" > /proc/sys/net/ipv4/tcp_fwmark_accept
echo "320" > /proc/sys/net/ipv4/tcp_keepalive_intvl
echo "21600" > /proc/sys/net/ipv4/tcp_keepalive_time
echo "1" > /proc/sys/net/ipv4/tcp_no_metrics_save
echo "0" > /proc/sys/net/ipv4/tcp_slow_start_after_idle
echo "48" > /proc/sys/net/ipv6/ip6frag_time

# Virtual Memory tweaks & enhancements for a massively improved balance between performance and battery life;
echo "3" > /proc/sys/vm/dirty_background_ratio
echo "500" > /proc/sys/vm/dirty_expire_centisecs
echo "30" > /proc/sys/vm/dirty_ratio
echo "3000" > /proc/sys/vm/dirty_writeback_centisecs
echo "0" > /proc/sys/vm/oom_dump_tasks
echo "0" > /proc/sys/vm/oom_kill_allocating_task
echo "1200" > /proc/sys/vm/stat_interval
echo "20" > /proc/sys/vm/swappiness
echo "60" > /proc/sys/vm/vfs_cache_pressure

# Disable in-kernel wake & sleep gestures for battery saving reasons;
echo "0" > /sys/android_touch/doubletap2wake
echo "0" > /sys/android_touch/sweep2sleep
echo "0" > /sys/android_touch/sweep2wake

# Disable gesture based vibration because it is honestly not even worth having enabled at all;
echo "0" > /sys/android_touch/vib_strength

# Enable CFQ group idle mode for improved scheduling effectivness by merging the IO queues in a "unified group" instead of treating them as individual IO based queues;
for i in /sys/block/*/queue/iosched; do
  echo "1" > $i/group_idle;
done;

# Disable CFQ low latency mode for overall increased IO based scheduling throughput and for better overall needed responsivness & performance from the system;
for i in /sys/block/*/queue/iosched; do
  echo "0" > $i/low_latency;
done;

# Wide block based tuning for reduced lag and less possible amount of general IO scheduling based overhead (Thanks to pkgnex @ XDA for the more than pretty much simplified version of this tweak. You really rock, dude!);
for i in /sys/block/*/queue; do
  echo "0" > $i/add_random;
  echo "0" > $i/discard_max_bytes;
  echo "0" > $i/iostats;
  echo "0" > $i/nomerges;
  echo "128" > $i/read_ahead_kb;
  echo "0" > $i/rotational;
  echo "1" > $i/rq_affinity;
done;

# Shift to instead use the simple_ondemand GPU governor for gaining a overall better peak balance between battery life and performance for daily usage;
# echo "simple_ondemand" > /sys/class/devfreq/5000000.qcom,kgsl-3d0/governor

# Revert to and use the stock msm-adreno-tz GPU governor if wished;
echo "msm-adreno-tz" > /sys/class/devfreq/5000000.qcom,kgsl-3d0/governor

# Decrease the ideal target GPU frequency down to 133Mhz for slightly increased power efficiency and less battery drainage;
echo "133000000" > /sys/class/devfreq/5000000.qcom,kgsl-3d0/target_freq

# Optimize the Adreno 530 GPU into delivering better overall graphical rendering performance, but do it with "respect" to battery life as well as power consumption as far as possible with less amount of possible tradeoffs;
echo "0" > /sys/class/kgsl/kgsl-3d0/bus_split
echo "72" > /sys/class/kgsl/kgsl-3d0/deep_nap_timer
echo "1" > /sys/class/kgsl/kgsl-3d0/force_bus_on
echo "1" > /sys/class/kgsl/kgsl-3d0/force_clk_on
echo "1" > /sys/class/kgsl/kgsl-3d0/force_rail_on

# Decrease both battery as well as power consumption that is being caused by the screen by lowering how much light the pixels, the built-in LED switches and the LCD backlight module is releasing & "kicking out" by carefully tuning / adjusting their maximum values a little bit to the balanced overall range of their respective spectrums;
echo "170" > /sys/class/leds/blue/max_brightness
echo "170" > /sys/class/leds/green/max_brightness
echo "170" > /sys/class/leds/lcd-backlight/max_brightness
echo "170" > /sys/class/leds/led:switch_0/max_brightness
echo "170" > /sys/class/leds/led:switch_1/max_brightness
echo "170" > /sys/class/leds/red/max_brightness

# Enable a tuned Boeffla wakelock blocker at boot for both better active & idle battery life;
echo "enable_wlan_ws;enable_wlan_wow_wl_ws;enable_wlan_extscan_wl_ws;enable_timerfd_ws;enable_qcom_rx_wakelock_ws;enable_netmgr_wl_ws;enable_netlink_ws;enable_ipa_ws;" > /sys/class/misc/boeffla_wakelock_blocker/wakelock_blocker

# Tweak and decrease tx_queue_len default stock value(s) for less amount of generated bufferbloat and for gaining slightly faster network speed and performance;
for i in $(find /sys/class/net -type l); do
  echo "128" > $i/tx_queue_len;
done;

# Shift to Schedutil, if possible, and opptimize and lower both the battery drain and overall power consumption that is caused by biasing it to use slightly lower frequency steps, but do this without sacrificing performance or overall UI fluidity. See this as a balanced in-kernel power save mode, but without any notable traces of the "semi-typical" smoothness regressions;

# Little Cluster;
echo "schedutil" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
echo "850" > /sys/devices/system/cpu/cpu0/cpufreq/schedutil/down_rate_limit_us
echo "1275" > /sys/devices/system/cpu/cpu0/cpufreq/schedutil/up_rate_limit_us
echo "schedutil" > /sys/devices/system/cpu/cpu1/cpufreq/scaling_governor
echo "850" > /sys/devices/system/cpu/cpu1/cpufreq/schedutil/down_rate_limit_us
echo "1275" > /sys/devices/system/cpu/cpu1/cpufreq/schedutil/up_rate_limit_us

# BIG Cluster
echo "schedutil" > /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor
echo "850" > /sys/devices/system/cpu/cpu2/cpufreq/schedutil/down_rate_limit_us
echo "1275" > /sys/devices/system/cpu/cpu2/cpufreq/schedutil/up_rate_limit_us
echo "schedutil" > /sys/devices/system/cpu/cpu3/cpufreq/scaling_governor
echo "850" > /sys/devices/system/cpu/cpu3/cpufreq/schedutil/down_rate_limit_us
echo "1275" > /sys/devices/system/cpu/cpu3/cpufreq/schedutil/up_rate_limit_us

# If the Schedutil governor is non existant, then use these following values for the "older" Sched CPU governor for better battery life while keeping performance at bay;

# CPU0;
echo "85000000" > /sys/devices/system/cpu/cpu0/cpufreq/sched/down_throttle_nsec
echo "125000" > /sys/devices/system/cpu/cpu0/cpufreq/sched/up_throttle_nsec

# CPU1;
echo "85000000" > /sys/devices/system/cpu/cpu1/cpufreq/sched/down_throttle_nsec
echo "125000" > /sys/devices/system/cpu/cpu1/cpufreq/sched/up_throttle_nsec

# CPU2;
echo "85000000" > /sys/devices/system/cpu/cpu1/cpufreq/sched/down_throttle_nsec
echo "125000" > /sys/devices/system/cpu/cpu1/cpufreq/sched/up_throttle_nsec

# CPU3;
echo "85000000" > /sys/devices/system/cpu/cpu1/cpufreq/sched/down_throttle_nsec
echo "125000" > /sys/devices/system/cpu/cpu1/cpufreq/sched/up_throttle_nsec

# Tweak the kernel task scheduler for improved overall system performance and user interface responsivness during all kind of possible workload based scenarios;
echo "NO_GENTLE_FAIR_SLEEPERS" > /sys/kernel/debug/sched_features
echo "NO_TTWU_QUEUE" > /sys/kernel/debug/sched_features
echo "NO_RT_RUNTIME_SHARE" > /sys/kernel/debug/sched_features

# Enable Fast Charge for slightly faster battery charging when being connected to a USB 3.1 port, which can be good for the people that is often on the run or have limited access to a wall socket;
echo "1" > /sys/kernel/fast_charge/force_fast_charge

# See my note a few steps higher regarding the change from stock Qualcomm msm-adreno-tz to the simple_ondemand GPU governor;
# echo "simple_ondemand" > /sys/kernel/gpu/gpu_governor

# Turn off a few additional kernel debuggers and what not for gaining a slight boost in both performance and battery life;
echo "Y" > /sys/module/bluetooth/parameters/disable_ertm
echo "Y" > /sys/module/bluetooth/parameters/disable_esco
echo "0" > /sys/module/dwc3/parameters/ep_addr_rxdbg_mask
echo "0" > /sys/module/dwc3/parameters/ep_addr_txdbg_mask
echo "0" > /sys/module/dwc3_msm/parameters/disable_host_mode
echo "0" > /sys/module/hid_apple/parameters/fnmode
echo "0" > /sys/module/hid/parameters/ignore_special_drivers
echo "N" > /sys/module/hid_magicmouse/parameters/emulate_3button
echo "N" > /sys/module/hid_magicmouse/parameters/emulate_scroll_wheel
echo "0" > /sys/module/hid_magicmouse/parameters/scroll_speed
echo "Y" > /sys/module/mdss_fb/parameters/backlight_dimmer
echo "N" > /sys/module/otg_wakelock/parameters/enabled
echo "Y" > /sys/module/workqueue/parameters/power_efficient
# echo "N" > /sys/module/sync/parameters/fsync_enabled
#echo "0" > /sys/module/wakelock/parameters/debug_mask
#echo "0" > /sys/module/userwakelock/parameters/debug_mask
echo "0" > /sys/module/binder/parameters/debug_mask
echo "0" > /sys/module/debug/parameters/enable_event_log
echo "0" > /sys/module/edac_core/parameters/edac_mc_log_ce
echo "0" > /sys/module/edac_core/parameters/edac_mc_log_ue
echo "0" > /sys/module/glink/parameters/debug_mask
echo "N" > /sys/module/ip6_tunnel/parameters/log_ecn_error
echo "0" > /sys/module/lowmemorykiller/parameters/debug_level
echo "0" > /sys/module/msm_show_resume_irq/parameters/debug_mask
echo "0" > /sys/module/msm_smd_pkt/parameters/debug_mask
echo "N" > /sys/module/sit/parameters/log_ecn_errorble
echo "0" > /sys/module/smp2p/parameters/debug_mask
echo "0" > /sys/module/usb_bam/parameters/enable_event_log
echo "Y" > /sys/module/printk/parameters/console_suspend

if [ -e /sys/module/logger/parameters/log_mode ]; then
 echo "2" > /sys/module/logger/parameters/log_mode
fi;
for i in $(find /sys/ -name debug_mask); do
echo "0" > $i;
done
for i in $(find /sys/ -name debug_level); do
echo "0" > $i;
done
for i in $(find /sys/ -name edac_mc_log_ce); do
echo "0" > $i;
done
for i in $(find /sys/ -name edac_mc_log_ue); do
echo "0" > $i;
done
for i in $(find /sys/ -name enable_event_log); do
echo "0" > $i;
done
for i in $(find /sys/ -name log_ecn_error); do
echo "0" > $i;
done
for i in $(find /sys/ -name snapshot_crashdumper); do
echo "0" > $i;
done

# A miscellaneous pm_async tweak that increases the amount of time (in milliseconds) before user processes & kernel threads are being frozen & "put to sleep";
echo "25000" > /sys/power/pm_freeze_timeout

# Push a semi-needed log to the internal storage with a "report" if the script could be executed or not;
# Script log file location
mkdir -p /storage/emulated/0/logs
LOG_FILE=/storage/emulated/0/logs

echo $(date) > /storage/emulated/0/logs/script.log
if [ $? -eq 0 ]
then
  echo "BM was successfully executed. Enjoy!" >> /storage/emulated/0/logs/script.log
  exit 0
else
  echo "BM failed!" >> /storage/emulated/0/logs/script.log
  exit 1
fi
  
# Done!
