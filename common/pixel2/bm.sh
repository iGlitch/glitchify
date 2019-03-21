#!/system/bin/sh

#BM 10.3

# Filesystem tweaks for better system performance;
busybox mount -o remount,nosuid,nodev,noatime,no_block_validity,nodelalloc,barrier=0,data=writeback,nobh,journal_async_commit,noauto_da_alloc,commit=96,discard -t auto /;
busybox mount -o remount,nosuid,nodev,noatime,barrier=0,noauto_da_alloc,commit=96,discard -t auto /data;
busybox mount -o remount,nosuid,nodev,noatime -t auto /proc;
busybox mount -o remount,nosuid,nodev,noatime,no_block_validity,nodelalloc,barrier=0,data=writeback,nobh,journal_async_commit,noauto_da_alloc,commit=96,discard -t auto /sys;
busybox mount -o remount,nodev,noatime,no_block_validity,nodelalloc,barrier=0,data=writeback,nobh,journal_async_commit,noauto_da_alloc,commit=96,discard -t auto /system;

# Disable / stop system logging (logd) daemon;
stop logd

# Enable this custom Doze profile for better battery life savings, and less amount of idle drain, when the screen is turned off and our devices is fully supposed to be sleeping;

# Doze battery life profile;
settings put global device_idle_constants light_after_inactive_to=5000,light_pre_idle_to=10000,light_max_idle_to=86400000,light_idle_to=43200000,light_idle_maintenance_max_budget=20000,light_idle_maintenance_min_budget=5000,min_time_to_alarm=60000,inactive_to=120000,motion_inactive_to=120000,idle_after_inactive_to=5000,locating_to=2000,sensing_to=120000,idle_to=7200000,wait_for_unlock=true

# Disable exception-trace for less debugging overhead;
echo "0" > /proc/sys/debug/exception-trace

# FS tweaks;
echo "0" > /proc/sys/fs/dir-notify-enable
echo "20" > /proc/sys/fs/lease-break-time

# Use & enable Maverick Jester's (@ XDA-Developers) customized random generator entropy configuration;
echo "192" > /proc/sys/kernel/random/read_wakeup_threshold
echo "90" > /proc/sys/kernel/random/urandom_min_reseed_secs
echo "1792" > /proc/sys/kernel/random/write_wakeup_threshold

# Disable kernel compat based logging once and for all;
echo "0" > /proc/sys/kernel/compat-log

# Turn off kernel print writes to the console for less amount of both log spam as well as general overhead;
echo "0 0 0 0" > /proc/sys/kernel/printk

# A few miscellaneous kernel tweaks for better balance between battery life and performance for daily usage;
echo "15000000" > /proc/sys/kernel/sched_latency_ns
echo "1000000" > /proc/sys/kernel/sched_min_granularity_ns
echo "2000000" > /proc/sys/kernel/sched_wakeup_granularity_ns

# A couple network tweaks for achieving slightly reduced amount of battery consumption when being "actively" connected to either a wifi connection or mobile data;
echo "0" > /proc/sys/net/core/netdev_tstamp_prequeue
echo "0" > /proc/sys/net/ipv4/cipso_cache_bucket_size
echo "0" > /proc/sys/net/ipv4/cipso_cache_enable
echo "0" > /proc/sys/net/ipv4/cipso_rbm_strictvalid
echo "westwood" > /proc/sys/net/ipv4/tcp_congestion_control
echo "1" > /proc/sys/net/ipv4/tcp_ecn

# Virtual Memory battery saving tweaks;
echo "500" > /proc/sys/vm/dirty_expire_centisecs
echo "3000" > /proc/sys/vm/dirty_writeback_centisecs
echo "0" > /proc/sys/vm/oom_dump_tasks
echo "1" > /proc/sys/vm/oom_kill_allocating_task
echo "1200" > /proc/sys/vm/stat_interval
echo "0" > /proc/sys/vm/swap_ratio
echo "60" > /proc/sys/vm/swappiness
echo "20" > /proc/sys/vm/vfs_cache_pressure

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

# Either enable (or disable) CFQ group idling with the goal of achieving higher IO throughput by forcing idling at the CFQ group level, instead at the queue level, and thereafter dispatching requests from multiple queues at the same time for generating the higher level of IO throughput;

# Group_idle stock setting;
for i in /sys/block/*/queue/iosched; do
   echo "0" > $i/group_idle;
done;

# Group_idle customized setting;
for i in /sys/block/*/queue/iosched; do
#  echo "8" > $i/group_idle;
done;

# IO block tweaks for better system performance;
for i in /sys/block/*/queue; do
  echo "0" > $i/add_random;
  echo "0" > $i/iostats;
  echo "0" > $i/nomerges;
  echo "32" > $i/nr_requests;
  echo "128" > $i/read_ahead_kb;
  echo "0" > $i/rotational;
  echo "1" > $i/rq_affinity;
  echo "cfq" > $i/scheduler;
done;

# Fully enable Adreno GPU performance profile;
echo "1" > /sys/class/kgsl/kgsl-3d0/force_bus_on
echo "1" > /sys/class/kgsl/kgsl-3d0/force_clk_on
echo "1" > /sys/class/kgsl/kgsl-3d0/force_rail_on

# Enable Adreno POPP power saving mode;
echo "1" > /sys/class/kgsl/kgsl-3d0/popp

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
echo "wlan_pno_wl;wlan_ipa;wcnss_filter_lock;[timerfd];hal_bluetooth_lock;IPA_WS;sensor_ind;wlan;netmgr_wl;qcom_rx_wakelock;SensorService_wakelock;tftp_server_wakelock;wlan_wow_wl;wlan_extscan_wl;" > /sys/class/misc/boeffla_wakelock_blocker/wakelock_blocker

# Tweak and decrease tx_queue_len default stock value(s) for less amount of generated bufferbloat and for gaining slightly faster network speed and performance;
for i in $(find /sys/class/net -type l); do
  echo "128" > $i/tx_queue_len;
done;

# Display Calibration that will be close to D65 (6500K) (Boosted). Thanks to Juzman @ XDA for this contribution;
# echo "256 249 226" > /sys/devices/platform/kcal_ctrl.0/kcal
# echo "5" > /sys/devices/platform/kcal_ctrl.0/kcal_min
# echo "257" > /sys/devices/platform/kcal_ctrl.0/kcal_val

# Adjust and lower both the battery drain and overall power consumption that is caused by the Schedutil governor by biasing it to use slightly lower frequency steps, but do this without sacrificing performance or overall UI fluidity. See this as a balanced in-kernel power save mode, but without any traces of the "semi-typical" smoothness regressions;

# Little Cluster;
echo "18500" > /sys/devices/system/cpu/cpufreq/policy0/schedutil/down_rate_limit_us
echo "775" > /sys/devices/system/cpu/cpufreq/policy0/schedutil/up_rate_limit_us

# BIG Cluster;
echo "18500" > /sys/devices/system/cpu/cpufreq/policy4/schedutil/down_rate_limit_us
echo "775" > /sys/devices/system/cpu/cpufreq/policy4/schedutil/up_rate_limit_us

# In case that you instead want to boost / increase strict raw performance, then enable this fully performance oriented Schedutil profile by removing the hashtags in front of the echo commands and set a # in front of the non-hashtagged syntax commands in the battery life optimized Schedutil profile in the section above;

# Little Cluster;
# echo "22444" > /sys/devices/system/cpu/cpufreq/policy0/schedutil/down_rate_limit_us
# echo "1" > /sys/devices/system/cpu/cpufreq/policy0/schedutil/iowait_boost_enable
# echo "444" > /sys/devices/system/cpu/cpufreq/policy0/schedutil/up_rate_limit_us

# BIG Cluster;
# echo "22444" > /sys/devices/system/cpu/cpufreq/policy4/schedutil/down_rate_limit_us
# echo "1" > /sys/devices/system/cpu/cpufreq/policy4/schedutil/iowait_boost_enable
# echo "444" > /sys/devices/system/cpu/cpufreq/policy4/schedutil/up_rate_limit_us

# Tweak the kernel task scheduler for improved overall system performance and user interface responsivness during all kind of possible workload based scenarios;
echo "NO_GENTLE_FAIR_SLEEPERS" > /sys/kernel/debug/sched_features
echo "NEXT_BUDDY" > /sys/kernel/debug/sched_features
echo "NO_TTWU_QUEUE" > /sys/kernel/debug/sched_features
echo "NO_RT_RUNTIME_SHARE" > /sys/kernel/debug/sched_features

# Enable Fast Charge for slightly faster battery charging when being connected to a USB 3.1 port, which can be good for the people that is often on the run or have limited access to a wall socket;
echo "1" > /sys/kernel/fast_charge/force_fast_charge

# Turn off a few additional kernel debuggers and what not for gaining a slight boost in both performance and battery life;
echo "Y" > /sys/module/bluetooth/parameters/disable_ertm
echo "Y" > /sys/module/bluetooth/parameters/disable_esco

# Slightly tweak Sultans custom CPU input boosting driver into delivering even more UI smoothness as well as overall system responsivness whenever it is possible;
echo "128" > /sys/module/cpu_input_boost/parameters/input_boost_duration
echo "422400" > /sys/module/cpu_input_boost/parameters/input_boost_freq_hp
# echo "748800" > /sys/module/cpu_input_boost/parameters/input_boost_freq_lp
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
echo "Y" > /sys/module/printk/parameters/ignore_loglevel
echo "N" > /sys/module/printk/parameters/pid
echo "N" > /sys/module/printk/parameters/time
echo "0" > /sys/module/service_locator/parameters/enable
echo "1" > /sys/module/subsystem_restart/parameters/disable_restart_work
# echo "N" > /sys/module/sync/parameters/fsync_enabled

# A miscellaneous pm_async tweak that increases the amount of time (in milliseconds) before user processes & kernel threads are being frozen & "put to sleep";
echo "24000" > /sys/power/pm_freeze_timeout

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
