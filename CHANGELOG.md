# История версий TK Counter

Версия печатается при загрузке карты в `nut/reactivedrop/scripts/vscripts/mapspawn.nut`
(строка вида `TK Counter  vX.Y.Z`).

Формат: newest first.

---

## 1.2.1

- Шаблон и вид красного уведомления вынесены в `tk_counter/announce.nut`.
- Плейсхолдеры: `${nickname}`, `${killcount}`, `${rank}` (также `{name}`, `{count}`, `{title}`).

## 1.2.0

- Скрипты перенесены в `scripts/vscripts/tk_counter/`.
- Ранги вынесены в `tk_counter/ranks.nut`, админы — в `tk_counter/admins.nut`.
- `mapspawn` грузит `tk_counter/tk_counter` (старый одиночный `tk_counter.nut` в корне `vscripts` больше не используется).

## 1.1.5

- Ответы на чат-команды (`!tkc_top`, `!tkc_reset` и др.) видны **только** запросившему — без спама в общий чат.
- Авто-объявления тимкиллов по-прежнему только у игроков с `!tkc_on`.

## 1.1.x (накопительно до 1.1.5)

- `!tkc_on` / `!tkc_off` — личное включение/выключение отображения объявлений; флаг в файле игрока (`count|name|lang|notify`).
- Двуязычные ранги (`ru` / `en`), `!tkc_lang`; строки UI через словарь `g_TkStrings` + id сообщений.
- Тролль-ранги (пороги 0…1001); `1` и `1001` зафиксированы отдельно в коде.
- SteamID в привычном виде `STEAM_X:Y:Z` для админов и `!tkc_reset`.
- Объявления: `game_text` (красный, выше центра), формат `ник: N — ранг`.
- Подсказка `team kill counter … !tkc_help` с задержкой после захода / смены карты.
- Счёт и настройки в `save/vscripts/tk_counter/`.

## 1.0.0

- Первая always-on сборка через `mapspawn` + `tk_counter.nut`.
- Подсчёт marine→marine (бот-жертва считается), persist, ранги, `!tkc` / `!tkc_top` / `!tkc_next` / `!tkc_help` / `!tkc_reset`.
