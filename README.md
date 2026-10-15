# asrd_tk_counter

Серверный счётчик тимкиллов с рангами, сохранением на диск и таблицей лидеров в чате.

**Версия:** `tk_counter/version.nut` (сейчас **1.2.5**), также в баннере `mapspawn` и в `!tkc_help`. История — в [`CHANGELOG.md`](CHANGELOG.md).

Клиентские файлы не требуются: объявления идут через `ClientPrint` / `game_text`.

## Возможности

- Работа без челленджа или с любым челленджем (сценарий mapspawn)
- Либо только пока выбран челлендж «TK Counter» (сценарий challenge)
- Сохранение между игровыми сессиями в `save/vscripts/tk_counter/`
- Настраиваемая система ачивментов/рангов (от 0 до 1001 убийств по умолчанию)
- Настраиваемый перечень админов
- Система i18n (2 языка встроено — RU/EN)
- Настраиваемый формат вывода сообщения (цвет, позиция, шаблон; по умолчанию `${nickname}: ${killcount} — ${rank}`)
- Сброс статистики админом
- Возможность каждому игроку на сервере отключить для себя индивидуально показ уведмлений о тимкилле

## Какой сценарий выбрать

| Сценарий | Когда использовать | Работает при смене челленджа? |
|----------|--------------------|-------------------------------|
| **A. Always-on (mapspawn)** | Нужен счётчик постоянно на сервере | Да |
| **B. Только челлендж** | Включать вручную из лобби, как обычный challenge | Нет — только пока выбран TK Counter |

Рекомендуется **A**, если челленджи на сервере часто меняют.

Общий шаг для обоих сценариев: файлы лежат в репозитории под `nut/reactivedrop/`. Их нужно положить в каталог игры сервера:

```
...\Alien Swarm Reactive Drop\reactivedrop\
```

---

## Сценарий A — всегда включено (mapspawn)

Счётчик стартует на каждой карте (включая лобби), независимо от выбранного челленджа.

### 1. Скопируй ядро

Из `nut/reactivedrop/` в `reactivedrop/` сервера:

```
scripts/vscripts/tk_counter/     — вся папка (tk_counter.nut, ranks, admins, announce, version)
```

### 2. Включи mapspawn

В `reactivedrop/cfg/autoexec.cfg` (создай файл, если нет) добавь:

```
sv_mapspawn_nut_exec 1
```

### 3. Поставь загрузчик mapspawn

**Если на сервере ещё нет** `scripts/vscripts/mapspawn.nut`:

- скопируй `scripts/vscripts/mapspawn.nut` из репозитория как есть.

**Если `mapspawn.nut` уже есть** (другой always-on мод):

1. **Не перезаписывай** существующий файл.
2. В **конец** текущего `mapspawn.nut` вставь содержимое `scripts/vscripts/mapspawn.merge-snippet.nut`.

Сниппет подключает TK Counter и цепляет уже существующие обработчики `player_say` / `player_activate` / `entity_killed`.

### 4. Перезапуск

Смени карту или перезапусти сервер. В консоли должен появиться баннер `TK Counter  v…`.

Челлендж из меню для этого сценария **не нужен**. Файлы `resource/challenges/tk_counter.txt` и `challenge_tk_counter.nut` можно не копировать.

---

## Сценарий B — только как челлендж

Счётчик работает, только пока в лобби выбран challenge **TK Counter**. Сменили челлендж — модуль останавливается.

### 1. Скопируй ядро и челлендж

```
scripts/vscripts/tk_counter/              — вся папка
scripts/vscripts/challenge_tk_counter.nut
resource/challenges/tk_counter.txt
```

### 2. mapspawn и autoexec

**Не обязательны.** `sv_mapspawn_nut_exec` и `mapspawn.nut` для этого сценария не нужны.

### 3. Включение в игре

В лобби выбери челлендж **TK Counter (optional)** и начни миссию.

---

## После установки — настройка

Править можно без лезания в ядро:

| Файл | Что настраивать |
|------|-----------------|
| `scripts/vscripts/tk_counter/ranks.nut` | пороги и названия рангов |
| `scripts/vscripts/tk_counter/admins.nut` | whitelist для `!tkc_reset` |
| `scripts/vscripts/tk_counter/announce.nut` | шаблон красного текста, цвет, позиция, стек |
| `scripts/vscripts/tk_counter/version.nut` | номер версии (баннер + `!tkc_help`) |

### Админы для сброса

VScript **не видит** админов SourceMod. SteamID в привычном виде (как в `status` / `admins_simple.ini`):

```squirrel
::g_TkAdmins <- [
    "STEAM_1:0:12345678",
]
```

Узнать ID: `status` в консоли сервера или `!tkc` (ник и SteamID в чат).  
Пример: `!tkc_reset STEAM_1:0:12345678`  
Также принимается `[U:1:…]`. `STEAM_0` и `STEAM_1` с теми же цифрами — один аккаунт.

### Шаблон объявления

В `announce.nut`:

```squirrel
template = {
    ru = "${nickname}: ${killcount} — ${rank}",
    en = "${nickname}: ${killcount} — ${rank}",
}
```

Плейсхолдеры: `${nickname}`, `${killcount}`, `${rank}` (синонимы: `${name}`, `${count}`, `${title}`). Там же `color`, `y`, `holdtime`, `stack_slots`.

## Команды

Префикс: `!tkc`.

| Команда | Кто | Что делает |
|---------|-----|------------|
| `!tkc` | любой | свой счёт и ранг |
| `!tkc_top` | любой | топ‑10 |
| `!tkc_next` | любой | следующий ранг |
| `!tkc_ranks` | любой | список порогов и рангов |
| `!tkc_lang` | любой | показать язык |
| `!tkc_lang ru` / `!tkc_lang en` | любой | сменить язык рангов |
| `!tkc_on` | любой | включить объявления тимкиллов |
| `!tkc_off` | любой | выключить объявления тимкиллов |
| `!tkc_reset STEAM_1:0:12345` | whitelist | сброс счёта игрока в 0 |
| `!tkc_help` | любой | справка (версия + автор) |

`!tkc_off` скрывает только авто-объявления. Команды по запросу и подсчёт ТК продолжают работать.

Ответы на команды видны **только** запросившему. Авто-объявления — игрокам с `!tkc_on`.

## Файлы данных

На сервере скрипт пишет статистику сюда:

```
reactivedrop/save/vscripts/tk_counter/
  index.txt        — список account id всех учтённых игроков
  <accountId>.txt  — данные одного игрока
```

В каждом `<accountId>.txt` одна строка из четырёх полей через `|`:

```
count|name|lang|notify
```

Пример:

```
42|Vasya|ru|1
```

| Поле | Пример | Смысл |
|------|--------|--------|
| `count` | `42` | число тимкиллов |
| `name` | `Vasya` | последний известный ник |
| `lang` | `ru` / `en` | язык рангов (`!tkc_lang`) |
| `notify` | `1` / `0` | показывать ли авто-объявления о тимкиллах: `1` — да (`!tkc_on`), `0` — нет (`!tkc_off`) |

Обычно файл трогать не нужно: его обновляет сам счётчик. Бэкапь папку `save/vscripts/tk_counter/` вместе с сервером.

## Важно

- Самоубийство не считается; жук → морпех не считается; бот-жертва считается, если убийца — игрок.
- `FileToString` ограничен ~16 КБ на файл — поэтому файл на игрока + индекс.
- После обновления с 1.1.x удали старый одиночный `scripts/vscripts/tk_counter.nut`, если он ещё лежит в корне `vscripts`.

## Структура репозитория

```
asrd_tk_counter/
  README.md
  CHANGELOG.md
  nut/reactivedrop/
    cfg/autoexec.cfg
    resource/challenges/tk_counter.txt
    scripts/vscripts/
      mapspawn.nut                 — сценарий A
      mapspawn.merge-snippet.nut   — сценарий A, если mapspawn уже был
      challenge_tk_counter.nut     — сценарий B
      tk_counter/
        tk_counter.nut
        ranks.nut
        admins.nut
        announce.nut
        version.nut
```
