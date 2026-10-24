# 🗡️ Diablo: Hellfire (1997) для портативної консолі M17

[![Platform](https://img.shields.io/badge/Platform-M17%20Handheld-blue.svg)](https://github.com/MCDShema/Hellfire_M17)
[![Engine](https://img.shields.io/badge/Engine-DevilutionX%20ARM-red.svg)](https://github.com/diasurgical/devilutionX)
[![Language](https://img.shields.io/badge/Language-Українська%20%2F%20English-yellow.svg)](https://github.com/MCDShema/Hellfire_M17)
[![Status](https://img.shields.io/badge/Status-Fully%20Playable%2060FPS-brightgreen.svg)](https://github.com/MCDShema/Hellfire_M17)

Повний автономний порт офіційного розширення **Diablo: Hellfire (1997)** від Synergistic Software / Sierra On-Line на оновленому нативному рушії **DevilutionX** для ретро-консолі **M17**.

---

### 📥 Швидке завантаження
👉 **[Завантажити готовий архів гри (ZIP)](https://github.com/MCDShema/Hellfire_M17/archive/refs/heads/main.zip)**

---

## ✨ Що нового у доповненні Hellfire

- 🥋 **Нові класи героїв**:
  - **Монах (Monk)** — майстер рукопашного бою та палиць із круговою атакою кількох ворогів одночасно.
  - Приховані класи: **Бард (Bard)** та **Варвар (Barbarian)**.
- 🪱 **Нові локації та підземелля**:
  - **Вулик (The Hive)** — гніздо комах-демонів під фермою Трістрама.
  - **Склеп (The Crypt)** — стародавня усипальниця На-Крула (Na-Krul) на церковному кладовищі.
- ⚔️ **Нові предмети та закляття**: Магічні олії для поліпшення зброї та броні, руни-пастки, нові сувої та зілля.
- ⚡ **Якість життя (Quality of Life від DevilutionX)**:
  - Біг у місті за замовчуванням.
  - Автоматичний підбір золота.
  - Смужки здоров'я монстрів.
  - Повна оптимізація під роздільну здатність екрана M17 (480x272).
  - Спеціальний апаратний маппер кнопок `m17_diablo_mapper`.
  - Повна українська локалізація.

---

## 🕹️ Керування на M17

| Кнопка | Дія у грі |
|---|---|
| **Лівий стік / D-Pad** | Пряме переміщення героя |
| **Кнопка A** | Основна атака / Взаємодія / Розмова |
| **Кнопка B** | Скасування / Закрити вікно |
| **Кнопка X** | Випити зілля здоров'я (Health Potion) |
| **Кнопка Y** | Випити зілля мани (Mana Potion) |
| **L1 (Лівий бампер)** | Відкрити інвентар (Inventory) |
| **R1 (Правий бампер)** | Характеристики персонажа (Character Sheet) |
| **L2 / R2 (Тригери)** | Книга заклинань / Карта підземелля |
| **Start** | Головне меню / Пауза |
| **Select** | Підсвічування луту на землі |

---

## 📦 Інструкція зі встановлення

1. **Завантажте файли**:
   - Натисніть кнопку **Code ➔ Download ZIP** або [скористайтеся прямим посиланням](https://github.com/MCDShema/Hellfire_M17/archive/refs/heads/main.zip).
2. **Розпакуйте архів**:
   - Розархівуйте ZIP-файл на комп'ютері.
3. **Скопіюйте на карту пам'яті (microSD)**:
   - Підключіть карту пам'яті M17 до ПК.
   - Скопіюйте папку `roms` із архіву в корінь картки пам'яті.
   *(Якщо у вас уже встановлено Diablo 1, файли доповнення Hellfire коректно доповнять спільну папку `roms/ports/diablo/`)*.
4. **Запустіть гру**:
   - Вставте картку назад у консоль M17, увімкніть її.
   - У розділі **PORTS** (Порти) виберіть **Diablo: Hellfire** та натисніть **A**!

---

## 📁 Структура файлів на картці пам'яті

```text
/roms/ports/
├── Hellfire.sh                       # Стартовий скрипт Hellfire
├── images/
│   ├── system-hellfire.png           # Обкладинка для EmulationStation
│   └── system-hellfire-thumb.png     # Мініатюра
└── diablo/                           # Каталог рушія та контенту
    ├── devilutionx                   # Бінарний ARM-файл
    ├── devilutionx.mpq               # Ресурси рушія
    ├── diabdat.mpq.part*             # Базовий архів Diablo 1
    ├── hellfire.mpq                  # Головний архів Hellfire
    ├── hfmonk.mpq                    # Ресурси Монаха
    ├── hfmusic.mpq                   # Музичний супровід Hellfire
    ├── hfvoice.mpq                   # Озвучка та діалоги
    ├── m17_diablo_mapper             # Фоновий маппер кнопок M17
    ├── diablo.ini                    # Конфігурація
    └── translations/                 # Український переклад
```

---

### Здолайте На-Крула та врятуйте Трістрам від нової загрози! 🛡️⚡🔥
