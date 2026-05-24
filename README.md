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
- `-Xms2G -Xmx4G` ตั้งค่าขนาด heap เริ่มต้นและขนาดสูงสุด
- ใช้ `G1GC` ซึ่งเป็น garbage collector ที่เหมาะกับเซิร์ฟเวอร์ Minecraft
- ปรับค่า `G1NewSizePercent`, `G1MaxNewSizePercent`, `G1ReservePercent`, `InitiatingHeapOccupancyPercent` เพื่อให้การเก็บขยะทำงานราบรื่น
- เปิด `UseStringDeduplication` เพื่อลดการใช้หน่วยความจำซ้ำซ้อนบน Java 17+

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

## Modded Server / Modpack หนัก
- ใช้ `modded_start.bat` หรือ `modded_start.sh` แทนถ้าเป็นเซิร์ฟเวอร์ modpack
- เปลี่ยน `modded.jar` เป็นชื่อไฟล์ server jar ของคุณ เช่น `forge-1.20.1-45.0.0.jar`, `fabric-server-launch.jar`, หรือ `server.jar`
- สำหรับ modpack ที่กินสเปคมากและผู้เล่นเยอะ:
  - แนะนำ 8-10GB RAM สำหรับ modpack ขนาดกลาง
  - แนะนำ 10-12GB หรือมากกว่า สำหรับ modpack ใหญ่ + ผู้เล่น 20-40 คน
  - ตั้ง `-Xms` เท่ากับ `-Xmx` เพื่อป้องกัน GC ชั่วคราว
- ควรใช้ Java 17 หรือ Java 21 64-bit จาก Adoptium / BellSoft / Liberica
- ถ้าใช้ Fabric modpack ให้ใส่ Performance mods:
  - `Lithium`
  - `Phosphor`
  - `Starlight`
  - `FerriteCore`
  - `Chunky` / `Carpet` สำหรับ tuning
- ถ้าใช้ Forge modpack ให้ใส่ Performance mods:
  - `FoamFix`
  - `Phosphor` (Forge version)
  - `BetterFPS`
  - `FastWorkbench`
  - `FastFurnace`
- ถ้า modpack ต้องการ worldgen หนัก ให้:
  - ลด `view-distance` / `simulation-distance`
  - ลด `spawn-radius`
  - ปิด `doMobSpawning` หรือลด mob farm หากมี plugin/mod support
- หลีกเลี่ยง mod ที่หนักเกินไปพร้อมกัน เช่น biome/worldgen generator จำนวนมาก, ม็อด entity เยอะเกิน
- หากใช้ modpack + plugin พร้อมกัน ให้เลือก server jar ที่มั่นคงและรองรับทั้งคู่ เช่น Mohist/Thermos เท่านั้น

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
- เปิดใช้ performance mod ของ server เช่น `Sodium`/`Starlight` on client side แต่ server side ต้องมี `Phosphor`/`Lithium`
- ใช้ SSD/NVMe เพื่อโหลด chunk ได้เร็วขึ้น
- CPU ต้องเน้นคอร์เดี่ยวที่แรง และมีคอร์เหลือสำหรับ GC
- ถ้าอยากปล่อยผู้เล่นเยอะ ให้เพิ่ม RAM และตั้งค่า `-Xmx` มากกว่า 12GB ขึ้นไป เพื่อไม่ให้ GC รันบ่อยเกินไป

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
- `modded_start.bat` และ `modded_start.sh` จะอ่านค่า `server_settings.env` หากมีอยู่
- หากสเปคสูง ระบบจะตั้งค่า RAM และ thread ให้สูงขึ้นอัตโนมัติ
- ถ้าอยากปรับเอง ให้แก้ค่าใน `server_settings.env`
- มีตัวอย่างไฟล์ `server_settings.env.example` ให้ดู format
- บน Linux ให้รัน `chmod +x detect_server_specs.sh modded_start.sh start.sh check_modpack.sh` ก่อนใช้งาน

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
