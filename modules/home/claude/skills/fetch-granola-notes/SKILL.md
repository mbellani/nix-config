---
name: fetch-granola-notes
description: Fetch a meeting transcript from Granola (macOS) — first from the local cache, falling back to Granola's backend when the local cache has aged out. Use when the user asks to read, extract, or work with a transcript from a Granola-recorded meeting — whether to save it, summarize it, answer questions about it, or turn it into notes. Returns raw transcript text and basic metadata (title, date, participants). Does NOT prescribe what to do with the transcript afterwards — that's up to the caller or the repo's conventions.
---

# Fetch Granola Notes

Granola is a meeting recorder for macOS that stores transcripts locally in a JSON cache and on a remote backend. This skill pulls a transcript out of any available source, preferring the fastest.

## Three sources, in priority order

1. **Local cache** — fast, offline, no auth required. But **lossy**: Granola prunes older meetings out of this file as new ones come in. Don't assume everything the user sees in the app is present here.
2. **Official public API** (`public-api.granola.ai`) — authoritative and complete. Requires a user-generated API key (one-time setup in the desktop app). Only returns notes that have a generated AI summary + transcript.
3. **Private API** (`api.granola.ai`) — the endpoint the desktop app itself uses. No setup required (reuses the WorkOS token already on disk). Reverse-engineered and unofficial, so it may change without notice, but useful when the user hasn't set up an API key.

Always try the local cache first. If the meeting isn't there, prefer the official public API. Fall back to the private API only when no API key is available.

---

## Source 1 — Local cache

### Location and structure

- **File:** `~/Library/Application Support/Granola/cache-v6.json` (single JSON file, typically ~1 MB)
- **Relevant keys** under `cache.state`:
  - `transcripts` — dict keyed by document ID. Each value is a list of segments, each with `text`, `start_timestamp`, `end_timestamp`, `source`, `is_final`, `document_id`.
  - `documents` — dict keyed by the same document ID. Contains `title`, `created_at`, `notes_markdown`, `people`, `chapters`, `updated_at`, etc.
- Transcript full text is the concatenation of its segments' `text` fields — join with `\n\n`.
- Segmentation varies: some meetings are one big segment; others are split into 10–200 turns.
- The cache refreshes as Granola syncs. Older meetings drop out.

### Workflow

**Step 1 — Find the target meeting.** Search `documents` by `title` (case-insensitive substring). If ambiguous, list recent meetings and ask.

```python
import json, os
with open(os.path.expanduser('~/Library/Application Support/Granola/cache-v6.json')) as f:
    data = json.load(f)
state = data['cache']['state']
for tid, t in state['transcripts'].items():
    doc = state['documents'].get(tid, {})
    print(f"{doc.get('created_at','')[:10]} | {len(t) if isinstance(t, list) else 0:4} segs | {doc.get('title','')}")
```

**Step 2 — Extract the transcript.**

```python
target_id = '...'
segs = state['transcripts'][target_id]
doc = state['documents'][target_id]
text = '\n\n'.join(s.get('text', '') for s in segs)
```

**Step 3 — Return title, created timestamp, participants, full text, document ID.**

---

## Source 2 — Official public API (preferred fallback)

### One-time setup: creating an API key

Tell the user (if they haven't done this already):

1. Open the Granola desktop app.
2. **Settings → API → Create new key**.
3. Select the key type (Personal for own notes; Enterprise for team space) and click **Generate API Key**.
4. Copy the `grn_...` key and store it as `GRANOLA_API_KEY` in their shell env or a local secrets file.

Key-type gate: Personal keys require a Business/Enterprise plan; Enterprise keys require Enterprise. If the user is on the free tier, the public API is not available to them — fall through to Source 3.

### Auth + base URL

- **Base:** `https://public-api.granola.ai/v1`
- **Header:** `Authorization: Bearer grn_YOUR_API_KEY`

### Endpoints

- **List notes:** `GET /notes` with optional query params `created_after` (ISO 8601) and `cursor`. Response: `{ notes: [...], hasMore, cursor }`. Each note has `id`, `title`, `owner`, `summary`.
- **Get note (with transcript):** `GET /notes/{id}?include=transcript`. Response includes the full note object plus a `transcript` array where each segment has a `text` field and a `source` field (`"microphone"` or `"speaker"` on macOS).

### Example

```python
import os, json, urllib.request

def list_notes(created_after=None, cursor=None):
    key = os.environ['GRANOLA_API_KEY']
    qs = []
    if created_after: qs.append(f'created_after={created_after}')
    if cursor:        qs.append(f'cursor={cursor}')
    url = 'https://public-api.granola.ai/v1/notes' + (('?' + '&'.join(qs)) if qs else '')
    req = urllib.request.Request(url, headers={'Authorization': f'Bearer {key}'})
    return json.loads(urllib.request.urlopen(req, timeout=30).read())

def get_note_with_transcript(note_id):
    key = os.environ['GRANOLA_API_KEY']
    url = f'https://public-api.granola.ai/v1/notes/{note_id}?include=transcript'
    req = urllib.request.Request(url, headers={'Authorization': f'Bearer {key}'})
    return json.loads(urllib.request.urlopen(req, timeout=30).read())
```

Reconstruct the full transcript body by joining the `text` fields with `\n\n`, same as for the local cache.

### Rate limits and caveats

- **Burst:** 25 requests per 5 seconds. **Sustained:** 5 requests/second. 429 on overflow — back off.
- **Summary/transcript gate:** the API only returns notes that have a generated AI summary *and* transcript. Notes still processing or never summarised don't appear in `GET /notes` and return 404 on `GET /notes/{id}`. If a note the user expects is missing, it probably hasn't been processed yet — wait, or fall through to Source 3 which returns all notes regardless of processing state.

---

## Source 3 — Private API (no-setup fallback)

Use when the user hasn't created a public API key, or when the public API's summary-gate blocks a note the user actually needs. This is a reverse-engineered endpoint; it isn't officially documented and Granola may change it without notice. Don't make it the default.

### Auth

The desktop app keeps its WorkOS access token in `~/Library/Application Support/Granola/supabase.json` under `workos_tokens` (a stringified JSON):

```python
import json, os
with open(os.path.expanduser('~/Library/Application Support/Granola/supabase.json')) as f:
    token = json.loads(json.load(f)['workos_tokens'])['access_token']
```

- Token lifetime is ~6 hours; the app refreshes it silently while running.
- 401 → the app is logged out or the token has expired; ask the user to open Granola.
- Don't implement the refresh flow yourself — it's tied to the app's WorkOS client.

### Request shape

- **Method:** POST (even for list queries)
- **Headers:**
  - `Authorization: Bearer <access_token>`
  - `Content-Type: application/json`
  - `Accept-Encoding: gzip` (responses are gzipped; decompress before `json.loads`)
  - `User-Agent: Granola/5.x Electron/38.x` (matching the real app is safest)

### Endpoints

- **List documents:** `POST https://api.granola.ai/v2/get-documents` with body `{"limit": 100, "offset": 0}`. Returns `{"docs": [...], "deleted": [...]}`. Each doc mirrors the `documents` shape in the local cache.
- **Get transcript:** `POST https://api.granola.ai/v1/get-document-transcript` with body `{"document_id": "<uuid>"}`. Returns a list of segments, same shape as the local cache.

### Example

```python
import json, os, gzip, urllib.request

def fetch_transcript_private(doc_id):
    with open(os.path.expanduser('~/Library/Application Support/Granola/supabase.json')) as f:
        token = json.loads(json.load(f)['workos_tokens'])['access_token']
    req = urllib.request.Request(
        'https://api.granola.ai/v1/get-document-transcript',
        data=json.dumps({"document_id": doc_id}).encode(),
        headers={
            'Authorization': f'Bearer {token}',
            'Content-Type': 'application/json',
            'Accept-Encoding': 'gzip',
            'User-Agent': 'Granola/5.354.0 Electron/38.2.0',
        },
        method='POST',
    )
    resp = urllib.request.urlopen(req, timeout=60)
    raw = resp.read()
    if resp.headers.get('Content-Encoding') == 'gzip':
        raw = gzip.decompress(raw)
    segs = json.loads(raw.decode())
    return '\n\n'.join(s.get('text', '') for s in segs)
```

---

## What to do with the transcript

**This skill stops at fetching.** What happens next is the caller's job:

- If the project has a `CLAUDE.md` with conventions for transcripts or notes, follow those.
- If not, ask the user what they want — save as-is, summarize, extract action items, write structured notes, etc.
- Don't assume a particular output format.

## When no source has what you need

- Meeting is still live or hasn't synced — suggest stopping the recording or waiting for sync.
- Title doesn't match — list nearby dates (the APIs have the full history) and loosen the search.
- Empty transcript (`len=0` segments) — the meeting was started but nothing was captured.
- Public API 404 on a note you know exists — the AI summary hasn't been generated yet; wait or use Source 3.
- Private API 401 — WorkOS token expired or app is logged out; ask the user to open Granola.

## Notes on fidelity

Granola transcripts are auto-generated and contain typical speech-to-text errors: homonyms, proper nouns mangled, punctuation guessed. If the caller is going to quote from the transcript, warn them to double-check — the raw text isn't verbatim.
