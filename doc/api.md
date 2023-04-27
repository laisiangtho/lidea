# API

- `uid`: unique identifier
- `asset`: asset name
- `local`: storage/local name
- `src`: source
- `name`: ?
- `query`: Object

```json
"api": [
  {
    "uid": "word",
    "asset": "<bd.?>",
    "local": "<bd.?>",
    "src": [],
    "name":"list",
    "query":{
      "primary":"ALTER TABLE ?? ADD PRIMARY KEY ('id')",
      "createIndex":"CREATE UNIQUE INDEX IF NOT EXISTS wordIdIndex ON ?? (id, word)"
    }
  },
]
```

```yaml
  assets:
    - assets/env.json
    - assets/word.db
```
