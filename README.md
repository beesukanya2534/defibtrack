# DefibTrack

เว็บแอปสำหรับบันทึกและสรุปผลการตรวจเช็คเครื่องกระตุกหัวใจไฟฟ้า (Defibrillator) รายเดือน แยกตามหน่วยงาน
พร้อมจัดอันดับ สร้างรายงานสรุปภาษาไทยอัตโนมัติ และส่งออกเป็น `.txt` / `.csv` / PDF

ข้อมูลทั้งหมดถูกจัดเก็บบน **Supabase** (Postgres) และซิงก์แบบเรียลไทม์ให้ทุกคนที่เปิดหน้าเว็บเห็นตรงกัน

## โครงสร้างโปรเจกต์

```
index.html                         แอปทั้งหมดในไฟล์เดียว (HTML + CSS + JS)
supabase/migrations/*.sql          สคีมาฐานข้อมูล (ตาราง + RLS + realtime)
```

## การทำงาน

- แอปเป็นไฟล์ HTML ไฟล์เดียว ไม่ต้อง build ไม่มี dependency ฝั่ง build
- โหลด `@supabase/supabase-js` v2 จาก CDN (jsDelivr) ตอนรันไทม์
- ชั้นเก็บข้อมูลเป็น adapter บาง ๆ ที่ห่อ Supabase ให้มีหน้าตาแบบ document store
  (`collection` / `doc` / `get` / `set` / `onSnapshot`)

### ตารางฐานข้อมูล

| ตาราง    | คอลัมน์                                   | ใช้เก็บ                                                     |
| -------- | ---------------------------------------- | ---------------------------------------------------------- |
| `months` | `key` (เช่น `2569-05`), `data` jsonb     | ข้อมูลการตรวจเช็คของแต่ละเดือน (รายชื่อหน่วยงาน จำนวนเวร ฯลฯ) |
| `config` | `key` (`departments`), `data` jsonb      | รายชื่อหน่วยงานล่าสุดที่ใช้ carry ไปเดือนถัดไป                 |

ทั้งสองตารางเปิด Row Level Security และมี policy อนุญาตให้ผู้ถือ anon key
อ่าน/เขียนได้ (โหมดเปิด ไม่ต้องล็อกอิน) เหมาะกับการใช้งานภายในทีมที่ไม่มีข้อมูลส่วนบุคคล

> anon / publishable key ของ Supabase ถูกฝังไว้ใน `index.html` โดยตั้งใจ —
> เป็นคีย์สาธารณะที่ปลอดภัยเมื่อเปิด RLS ไว้ ไม่ใช่ความลับ

## รันในเครื่อง

เปิด `index.html` ด้วยเบราว์เซอร์ได้เลย หรือเสิร์ฟผ่าน static server:

```bash
python -m http.server 8000
# เปิด http://localhost:8000
```

## เผยแพร่ด้วย GitHub Pages

1. ไปที่ **Settings → Pages** ของ repo
2. เลือก **Source: Deploy from a branch**, branch `main`, folder `/ (root)`
3. เว็บจะออนไลน์ที่ `https://<username>.github.io/defibtrack/`

## ตั้งค่า Supabase ใหม่ (ถ้าต้องการ project ของตัวเอง)

1. สร้าง project ใหม่ที่ [supabase.com](https://supabase.com)
2. รัน SQL ใน `supabase/migrations/` ผ่าน **SQL Editor** หรือ Supabase CLI:
   ```bash
   supabase link --project-ref <your-ref>
   supabase db push
   ```
3. แก้ `SUPABASE_URL` และ `SUPABASE_KEY` ในบล็อก `<script type="module">` ของ `index.html`
   ให้เป็นค่าของ project ใหม่ (Project Settings → API)
