# Modpack Analysis

## สรุปจากโฟลเดอร์ม็อดที่แนบมา
- มีไฟล์ม็อดทั้งหมดหลายสิบไฟล์ พร้อมไฟล์ `.disabled` และไฟล์ `.duplicate`
- มีทั้ง mod ที่เขียนสำหรับ Forge และ Fabric อยู่พร้อมกัน
- มี mod client-only หรือ renderer/ตัวช่วย UI ที่ไม่ควรใส่ใน server เช่น `sodiumdynamiclights`, `fabric-api` (ถ้าใช้งาน Forge), `cloth-config`, `Camerapture`
- มี mod หนักหลายตัว เช่น `CustomNPCs`, `Immersive Vehicles`, `Epic Fight`, `Waystones`, `Blood N' Particles`
- มี mod performance ที่ดีอยู่ด้วย เช่น `ferritecore`, `spark`, `Chunky`, `entityculling`

## ปัญหาหลัก
1. **Mix Forge + Fabric**
   - หากใช้ server แบบ Forge ต้องไม่ใส่ Fabric mods และต้องใช้ Forge server jar เท่านั้น
   - หากใช้ Fabric server ต้องใช้ Fabric server jar และไม่ใส่ Forge-only mods
2. **ไฟล์ `.disabled` และ `.duplicate`**
   - ต้องลบหรือย้ายออกก่อนใช้จริง เพราะจะไม่ช่วยให้ server ทำงานดีขึ้น
3. **ม็อด client-only**
   - บางไฟล์เป็น client-side เท่านั้นและจะทำให้ server ล้มเหลวหากติดตั้งผิดวิธี
4. **mod pack หนักเกินไป**
   - mod อย่าง `CustomNPCs`, `Immersive Vehicles`, `Epic Fight` เป็น mod ที่ใช้ทรัพยากรสูง
   - ผู้เล่นเยอะ + mod หนัก จะทำให้ TPS ตกได้ถ้าไม่มีการปรับแต่งดีพอ

## สิ่งที่ควรทำก่อนลง server
- แยก mod ที่ใช้บน server ออกมาในโฟลเดอร์ `mods` ของ server เท่านั้น
- เลือก loader ให้ชัดเจน: Forge หรือ Fabric
- เอาออกทุกไฟล์ที่ชื่อมี `.disabled` หรือ `.duplicate`
- ลบ mod client-only ออกก่อน เช่น `sodiumdynamiclights` และ mod ที่เกี่ยวกับ client rendering
- ตรวจสอบว่า mod แต่ละตัวใช้กับ Minecraft 1.20.1 และ Forge server แล้ว

## คำแนะนำเพิ่มเติม
- ใช้ `check_modpack.bat mods` หรือ `./check_modpack.sh mods` เพื่อตรวจสอบปัญหาเบื้องต้น
- หากต้องการเซิร์ฟเวอร์ modpack หนักให้เน้น mod performance และลด mod decoration/visual-heavy
- หากต้องการ ผมช่วยแยก mod ที่ server-side เหมาะกับ server จากโฟลเดอร์ของคุณได้อีกครั้ง
