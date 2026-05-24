# Minecraft Server Optimization

ไฟล์ `start.bat` และ `start.sh` สำหรับรันเซิร์ฟเวอร์ Minecraft บน Windows และ Ubuntu โดยใช้ JVM flags ที่ช่วยลดการกระตุกและปรับการจัดการหน่วยความจำให้ดีขึ้น

## วิธีใช้งาน

### Windows
1. วาง `paper.jar` ในโฟลเดอร์เดียวกับ `start.bat`
2. เปิด `start.bat` ด้วยการดับเบิลคลิก
3. หากยังไม่มีไฟล์ `eula.txt` ให้รันครั้งแรกแล้วแก้ค่า `eula=false` เป็น `eula=true`

### Ubuntu / Linux
1. วาง `paper.jar` ในโฟลเดอร์เดียวกับ `start.sh`
2. ให้สิทธิ์รันไฟล์:
   ```bash
   chmod +x start.sh
   ```
3. รัน:
   ```bash
   ./start.sh
   ```
4. หากยังไม่มีไฟล์ `eula.txt` ให้รันครั้งแรกแล้วแก้ค่า `eula=false` เป็น `eula=true`

## ค่าที่ปรับในสคริปต์
- ใช้ค่า default สูงขึ้นสำหรับผู้เล่นเยอะและ modpack หนัก: `XMS=8G`, `XMX=10G` สำหรับ plugin/Paper server และ `XMS=10G`, `XMX=12G` สำหรับ modded server
- ใช้ `G1GC` ซึ่งเป็น garbage collector ที่เหมาะกับเซิร์ฟเวอร์ Minecraft
- ปรับค่า `G1NewSizePercent`, `G1MaxNewSizePercent`, `G1ReservePercent`, `InitiatingHeapOccupancyPercent` เพื่อให้การเก็บขยะทำงานราบรื่น
- เปิด `UseStringDeduplication` เพื่อลดการใช้หน่วยความจำซ้ำซ้อนบน Java 17+
- สามารถปรับ `server_settings.env` เพื่อเพิ่ม JVM flags หรือเปลี่ยน `SERVER_JAR`

## แนะนำ `server.properties`
ปรับค่าเหล่านี้ใน `server.properties`:
- `view-distance=6`
- `simulation-distance=6`
- `max-tick-time=60000`
- `spawn-radius=4`
- `use-native-transport=true`
- `enable-jmx-monitoring=false`
- `max-players=20` (หรือเท่าที่ต้องการตามสเปคเครื่อง)

## การปรับแต่งระบบปฏิบัติการ
### Ubuntu
- ลด `swappiness`
  ```bash
  sudo sysctl vm.swappiness=10
  ```
- เพิ่ม `nofile` limit หากจำเป็น
- ใช้ `screen` หรือ `tmux` เพื่อรันเซิร์ฟเวอร์ใน background

### Windows
- ตั้ง Power Plan เป็น `High Performance`
- ปิดโปรแกรมพื้นหลังที่ไม่จำเป็น
- ตรวจสอบให้ Java อยู่ใน PATH

## ประเภทเซิร์ฟเวอร์และการใช้งาน
- สำหรับ plugin server ให้ใช้ `Paper` หรือ `Purpur` พร้อม `start.bat` / `start.sh`
- สำหรับ modpack server ให้ใช้ `modded_start.bat` / `modded_start.sh`
- หากต้องการ plugin + mod พร้อมกัน ให้ใช้เฉพาะ server jar ที่รองรับ hybrid เช่น `Mohist` หรือ `Thermos` เท่านั้น และต้องใส่ใจ compatibility อย่างมาก
- ข้อแนะนำทั่วไป:
  - อย่าใช้ Forge และ Fabric ในโฟลเดอร์เดียวกัน
  - แยกโฟลเดอร์เซิร์ฟเวอร์สำหรับ plugin server และ modpack server
  - เรียกใช้ `check_modpack` เพื่อไล่ปัญหาก่อนเริ่มเซิร์ฟเวอร์

## Plugin server (Paper/Purpur) สำหรับผู้เล่นเยอะ
- ใช้ `start.bat` หรือ `start.sh` พร้อม `optimized_paper.yml`
- ใส่ plugin ที่เป็น performance oriented เช่น:
  - `Spark`
  - `ClearLag` / `LagAssist`
  - `ServerTools` / `PaperRPG`
  - `WorldBorder` / `Chunky`
- ตั้งค่า `server.properties` และ `paper.yml` ให้ลดการใช้งาน server-side load:
  - `view-distance=6`
  - `simulation-distance=6`
  - `spawn-radius=4`
  - `entity-activation-range` ลดสัตว์และมอนสเตอร์
  - `max-tnt-per-tick=50`
  - `max-block-changes=200`
  - `item-despawn-rate=6000`
- ปรับ `spigot.yml` และ `bukkit.yml` ให้ลดการ spawn และ merge entity

## Modpack server สำหรับ mod หนัก
- ใช้ `modded_start.bat` หรือ `modded_start.sh`
- สำหรับ modpack ใหญ่และผู้เล่นเยอะ:
  - แนะนำ RAM 10-12GB ขึ้นไป
  - ตั้ง `-Xms` เท่ากับ `-Xmx` เช่น `10G`
  - ปรับ `PARALLEL_GC_THREADS` และ `ACTIVE_PROCESSORS` ให้เหมาะสมกับ CPU
- อัปเดต mod performance ที่จำเป็น:
  - `FerriteCore`
  - `Chunky`
  - `Spark`
  - `Entity Culling`
  - `Phosphor` / `Lithium` (ถ้าใช้ Fabric)
- ถ้าเป็น worldgen หนัก ให้ลด `view-distance` และ `simulation-distance` เพิ่มขึ้นตามความจำเป็นของผู้เล่น

## Server Optimization เพิ่มเติม
- ปรับ `server.properties` ให้ลดโหลดระบบ ดังนี้:
  - `view-distance=6`
  - `simulation-distance=6`
  - `spawn-radius=4`
  - `max-tick-time=60000`
  - `use-native-transport=true`
  - `entity-broadcast-range-percentage=100`
  - `network-compression-threshold=256`
  - `max-players=40` หรือปรับตามสเปคจริง
- ปรับ `paper.yml` ด้วย `optimized_paper.yml`
- ปรับ `spigot.yml` ด้วย `optimized_spigot.yml`
- ปรับ `bukkit.yml` ด้วย `optimized_bukkit.yml`
- เปิดใช้ performance mod ของ server เช่น `Spark`, `FerriteCore`, `Chunky`
- ใช้ SSD/NVMe เพื่อโหลด chunk ได้เร็วขึ้น
- CPU ต้องเน้นคอร์เดี่ยวที่แรง และมีคอร์เหลือสำหรับ GC
- รัน `detect_server_specs.bat` หรือ `detect_server_specs.sh` เพื่อให้ระบบตั้งค่า RAM/thread อัตโนมัติ

## ตรวจสอบ modpack ก่อนลงเซิร์ฟเวอร์
- ใช้ `check_modpack.bat mods` บน Windows หรือ `./check_modpack.sh mods` บน Ubuntu/Linux
- สคริปต์จะตรวจสอบ:
  - ไฟล์ `.disabled` และ `.duplicate`
  - mod client-only ที่ไม่ควรใส่ใน server
  - การผสมคำสั่ง Forge และ Fabric
  - mod ชุดหนักที่อาจทำให้ TPS ตก
  - mod performance ที่ควรมี
- หากคุณใช้โฟลเดอร์ม็อดจาก profile ของ Modrinth ให้แน่ใจว่าคุณคัดเลือกเฉพาะ mod server-side
- ดูสรุปการวิเคราะห์ของ mod pack ที่แนบมาได้ใน `MODPACK_ANALYSIS.md`

## เช็คสเปคเครื่องและตั้งค่า Server อัตโนมัติ
- ใช้ `detect_server_specs.bat` บน Windows หรือ `./detect_server_specs.sh` บน Ubuntu/Linux
- สคริปต์จะสร้างไฟล์ `server_settings.env` โดยอัตโนมัติ
- `start.bat` / `start.sh` และ `modded_start.bat` / `modded_start.sh` จะอ่านค่า `server_settings.env` หากมีอยู่
- สามารถตั้งค่า `SERVER_TYPE`, `SERVER_JAR`, `XMS`, `XMX`, `PARALLEL_GC_THREADS`, `CONCURRENT_GC_THREADS`, `ACTIVE_PROCESSORS`, `JAVA_OPTS_EXTRA`
- ถ้าอยากให้สคริปต์เลือกอัตโนมัติ ให้ใช้ `run_server.bat` หรือ `./run_server.sh`
- หากสเปคสูง ระบบจะตั้งค่า RAM และ thread ให้สูงขึ้นอัตโนมัติ
- ถ้าอยากปรับเอง ให้แก้ค่าใน `server_settings.env`
- มีตัวอย่างไฟล์ `server_settings.env.example` ให้ดู format
- บน Linux ให้รัน `chmod +x detect_server_specs.sh modded_start.sh start.sh check_modpack.sh run_server.sh` ก่อนใช้งาน

## Auto-start และ Backup
- Windows:
  - ใช้ `auto_start.bat` เพื่อรันเซิร์ฟเวอร์และ restart อัตโนมัติเมื่อหยุด
  - ใช้ `backup_server.bat` เพื่อสำรองโลก, config, mods, plugins เข้าโฟลเดอร์ `backups`
  - ใช้ `backup_rotate.bat` เพื่อสำรองเป็นไฟล์ `.zip` และเก็บเฉพาะ backup ล่าสุด 5 ชุด
  - ใช้ `install_task_scheduler.bat` เพื่อติดตั้ง Task Scheduler ให้รัน `auto_start.bat` เมื่อบูต
  - ใช้ `monitor_server.bat` เพื่อตรวจสอบพอร์ตเซิร์ฟเวอร์และ restart ถ้ายังไม่ online
  - ใช้ `clean_modpack.bat` เพื่อย้ายไฟล์ `.disabled`, `.duplicate`, และ client-only mods ออกไป
  - ใช้ `optimize_windows.bat` เพื่อสลับเป็น Power Plan แบบ High Performance
- Ubuntu/Linux:
  - ใช้ `auto_start.sh` เพื่อรันเซิร์ฟเวอร์และ restart อัตโนมัติ
  - ใช้ `backup_server.sh` เพื่อสำรองโลก, config, mods, plugins เข้าโฟลเดอร์ `backups`
  - ใช้ `backup_rotate.sh` เพื่อสำรองเป็นไฟล์ `.tar.gz` และเก็บเฉพาะ backup ล่าสุด 5 ชุด
  - ใช้ `monitor_server.sh` เพื่อตรวจสอบพอร์ตเซิร์ฟเวอร์และ restart ถ้ายังไม่ online
  - ใช้ `clean_modpack.sh` เพื่อย้ายไฟล์ `.disabled`, `.duplicate`, และ client-only mods ออกไป
  - ใช้ `optimize_linux.sh` เพื่อตั้งค่า swappiness, fs.file-max, และ ulimit สำหรับ Minecraft
  - หากต้องการ systemd auto-start ให้ใช้ไฟล์ตัวอย่าง `minecraft.service`
    - คัดลอกไฟล์ไปไว้ที่ `/etc/systemd/system/minecraft.service`
    - ปรับ `User` และ `WorkingDirectory` ตามเครื่อง
    - รัน `sudo systemctl daemon-reload && sudo systemctl enable minecraft.service && sudo systemctl start minecraft.service`

## ตัวอย่าง `server.properties` สำหรับ modded server
สร้างไฟล์ชื่อ `server.properties` หรือคัดลอกค่าเหล่านี้:

```properties
enable-jmx-monitoring=false
rcon.port=25575
gamemode=survival
enable-command-block=false
enable-query=false
generator-settings=
sync-chunk-writes=true
force-gamemode=false
enforce-whitelist=false
view-distance=6
simulation-distance=6
spawn-protection=4
max-tick-time=60000
max-players=40
network-compression-threshold=256
function-permission-level=2
server-port=25565
server-ip=
spawn-npcs=true
allow-flight=true
level-name=world
motd=Heavy Modded Server - Optimized
rate-limit=0
hardcore=false
white-list=false
broadcast-console-to-ops=true
spawn-animals=true
pre-generate-chunks=false
online-mode=true
allow-nether=true
use-native-transport=true
enable-status=true
snooper-enabled=false
max-world-size=29999984
```
---

> หากต้องการ ผมสามารถช่วยเพิ่ม `bukkit.yml` / `spigot.yml` / `paper.yml` ตัวอย่าง หรือสคริปต์ backup และ monitoring ให้ด้วยครับ# minecraft-Server-Optimization
