# asrd_tk_counter

Серверный счётчик тимкиллов с рангами, сохранением на диск и таблицей лидеров в чате.

**Версия:** `tk_counter/version.nut` (сейчас **1.2.5**), также в баннере `mapspawn` и в `!tkc_help`. История — в [`CHANGELOG.md`](CHANGELOG.md).

Работает **при любом выбранном челлендже** через `mapspawn.nut` (нужен `sv_mapspawn_nut_exec 1`). Клиентские файлы не требуются: объявления идут через `ClientPrint`.

## Возможности

- Учёт убийств морпех → морпех (жертва-бот тоже считается)
- Ключ игрока: SteamID вида `STEAM_1:0:…`; в записи также хранится ник
- Сохранение между сессиями в `save/vscripts/tk_counter/`
- Ранги от 0 до 1000+ — отдельно `ru` и `en` (по умолчанию русский)
- Язык и показ объявлений хранятся на игрока; `!tkc_lang ru|en`, `!tkc_on` / `!tkc_off`
- Формат объявления: `ник: 2 — Случайный выстрел`
- Текст чуть выше центра экрана (`y = 0.38`)
- Подсказка в чат: `team kill counter help - !tkc_help` (через ~3 с после захода / при смене карты)
- Команды с префиксом `!tkc`
- Сброс по `STEAM_X:Y:Z` только для ID из `::g_TkAdmins`

## Установка на dedicated server

Скопируй содержимое `reactivedrop/` в папку игры сервера:

```
...\Alien Swarm Reactive Drop\reactivedrop\
```

Попадут:

| Файл | Назначение |
|------|------------|
| `scripts/vscripts/tk_counter/tk_counter.nut` | логика |
| `scripts/vscripts/tk_counter/ranks.nut` | пороги и названия рангов |
| `scripts/vscripts/tk_counter/admins.nut` | whitelist для `!tkc_reset` |
| `scripts/vscripts/tk_counter/announce.nut` | шаблон красного текста + цвет/позиция |
| `scripts/vscripts/mapspawn.nut` | загрузчик на каждой карте |
| `scripts/vscripts/mapspawn.merge-snippet.nut` | фрагмент для слияния с уже существующим mapspawn |
| `cfg/autoexec.cfg` | `sv_mapspawn_nut_exec 1` |
| `resource/challenges/tk_counter.txt` | опциональная запись челленджа |
| `scripts/vscripts/challenge_tk_counter.nut` | опциональный вход через челлендж |

Если `cfg/autoexec.cfg` уже есть — допиши в конец:

```
sv_mapspawn_nut_exec 1
```

### Если mapspawn.nut уже есть

1. **Не перезаписывай** существующий `mapspawn.nut`.
2. Скопируй только `tk_counter.nut`.
3. В конец текущего `mapspawn.nut` вставь содержимое `mapspawn.merge-snippet.nut`.

Сниппет цепляет предыдущие обработчики `player_say` / `player_activate` / `entity_killed`, если они уже были.

## Команды

Префикс: `!tkc` (чтобы не пересекаться с другими модами).

| Команда | Кто | Что делает |
|---------|-----|------------|
| `!tkc` | любой | свой счёт и ранг |
| `!tkc_top` | любой | топ‑10 только себе в чат |
| `!tkc_next` | любой | следующий ранг и сколько ТК осталось |
| `!tkc_ranks` | любой | список порогов и рангов (себе) |
| `!tkc_lang` | любой | показать язык |
| `!tkc_lang ru` / `!tkc_lang en` | любой | сменить язык рангов |
| `!tkc_on` | любой | включить объявления тимкиллов (чат + центр) |
| `!tkc_off` | любой | выключить объявления тимкиллов |
| `!tkc_reset STEAM_1:0:12345` | только whitelist | сброс счёта игрока в 0 |
| `!tkc_help` | любой | справка |

`!tkc_off` скрывает только авто-объявления (тимкилл / ранг / tip). Команды `!tkc`, `!tkc_top`, `!tkc_next` по запросу работают как раньше. Счётчик продолжает копиться.

### Права на сброс

VScript **не видит** админов SourceMod. Список доверенных ID задаётся прямо в скрипте в **привычном виде** (как в `status` и `admins_simple.ini`):

```squirrel
::g_TkAdmins <- [
    "STEAM_1:0:12345678",
]
```

Узнать ID: команда `status` в консоли сервера, либо `!tkc` (ник и SteamID печатаются в чат).

Пример сброса:

```
!tkc_reset STEAM_1:0:12345678
```

Также принимается форма `[U:1:24791356]`. `STEAM_0` и `STEAM_1` считаются одним и тем же аккаунтом.

## Файлы данных

Путь на сервере:

```
reactivedrop/save/vscripts/tk_counter/
  index.txt        — список account id (число из SteamID)
  <accountId>.txt  — одна строка: count|nickname
```

Снаружи везде используется привычный `STEAM_1:0:…`; в имени файла — числовой account id (на Windows в имени файла нельзя `:`)

Пример записи игрока (`count|name|lang|notify`):

```
42|Vasya|ru|1
```

`notify`: `1` = показывать объявления, `0` = скрыть (`!tkc_off`).

Бэкапь папку `save/vscripts/tk_counter/` вместе с сервером.

## Ранги, админы, уведомление

- Пороги/названия: `tk_counter/ranks.nut`
- Whitelist `!tkc_reset`: `tk_counter/admins.nut`
- Красный текст: `tk_counter/announce.nut`

Шаблон, например:

```squirrel
template = {
    ru = "${nickname} - ${killcount} - ${rank}",
    en = "${nickname} - ${killcount} - ${rank}",
}
```

Плейсхолдеры: `${nickname}`, `${killcount}`, `${rank}` (синонимы: `${name}`, `${count}`, `${title}`). Там же `color`, `y`, `holdtime`.

## Важно

- Это **не** замена выбранного челленджа: логика живёт в `mapspawn`, игровой челлендж в лобби может быть любым.
- Самоубийство не считается; жук → морпех не считается; бот → бот не даёт очков игроку.
- Челлендж `tk_counter` в меню — запасной путь. Для «всегда включено» используй mapspawn.
- `FileToString` ограничен ~16 КБ на файл; поэтому на игрока отдельный файл + индекс.

## Структура репозитория

```
asrd_tk_counter/
  README.md
  CHANGELOG.md
  nut/reactivedrop/
    cfg/autoexec.cfg
    resource/challenges/tk_counter.txt
    scripts/vscripts/
      mapspawn.nut
      mapspawn.merge-snippet.nut
      challenge_tk_counter.nut
      tk_counter/
        tk_counter.nut   — ядро
        ranks.nut        — ранги
        admins.nut       — админы
        announce.nut     — шаблон уведомления
```

На живом сервере удали старый одиночный `scripts/vscripts/tk_counter.nut`, если он остался после обновления с 1.1.x.
